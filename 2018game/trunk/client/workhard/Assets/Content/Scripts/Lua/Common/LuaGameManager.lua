-----------------------------------------------------------------------------
--LuaGameManager:: 
--  The unique class, that offers all interface for user can manage their 
--	game. DONt call GameManager of C#. 
--
--  LuaGameManager will automatic cache the defaultGameType from CSharp game 
--  manager, and update all game scripts path when init function was invoked.

-- Note:: if the value of gameType macro is equals EGameType.MAX, we must 
-- update game type by call SetGameType() function before real launch game.
-- because if we cant ensure valid game type, all scripts root path will keep 
-- invalid state, so we cant successfully launch the game that we want to play.
-- otherwise, do not manually update game type. 
-----------------------------------------------------------------------------

LuaGameManager = LuaGameManager or {}
depends("Puremvc.init")

--Cache c game manager
LuaGameManager.GInstance = GameManager.Instance

--save current game mode
LuaGameManager.currentGameMode = nil

--saved all managers 
LuaGameManager.managers = nil

--whether game manager has been initial
LuaGameManager.bInited = false

local m_bNeedSendCopyTip = false
local m_RoomIdInFromClipboard = nil 

--current playing game
local gameName = ""

local currentGame = EGameType.EGT_MAX

local targetLevelInfo = nil

--save bundles of each game
local gameBundleConfig = nil

--log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

local m_currentScene = nil 

local bWithSystemManager = false 

--facade
local facade = nil

local param_ui_notis = nil 

--custom event
local function onLoadingLevel(fProgress)
	--update loading level menu
	facade:sendNotification(Common.ON_LOADING_LEVEL, fProgress)
end 

--init Game Manager. this function will be invoked when launch game.
--we will init game client in here.
--NOTE:: we need cache the game type, even if we had defined game type when cook games.
--if we not cache the game type, game content path will keep invalid states; launch game 
--client must failure.
function LuaGameManager:Init()
	Log("Init lua game manager...")
	LuaGameManager.bInited = false
	LuaGameManager.managers = {}
	LuaGameManager.bInited = true

	--load game bundle configuration file
	GBC.Reload()

	--initial puremvc
	pm.InitPuremvc()
	
	--UnityEngine.Debug.Log("Init lua pure mvc...")
	--register all common command. all of them was saved into lua_common.u files
	--local commonExtraCommand = depends('Common.Controller.RegisterUpdatesCommand')
	--local executeCmd = commonExtraCommand.new()
	--executeCmd:execute(nil)	

	--initial download manager
	GetDownloadManager().Init()

	--initial game setting
	--GameSetting.getInstance()

	--initial the lua input manager
	LuaInputManager.getInstance()

	--initial the ui manager
	UIManager.getInstance()

	--initial audio manager
	AudioManager.getInstance()

	--initial system manager
	if bWithSystemManager == true then 
		SystemEventManager.getInstance()
	end 

	--initial update manager
	GetUpdateManager().Init()
	
	--initial head icon manager
	GetHeadIconManager().Init()

	GetLuaPing().Init()

	facade = pm.Facade.getInstance(GAME_FACADE_NAME)

	--initial client net connection manager
	LuaGameManager:InitClient()

	--register listener
	LuaGameManager.GInstance.onAsyncLoadLevel:RemoveAllListeners()
	LuaGameManager.GInstance.onAsyncLoadLevel:AddListener(onLoadingLevel)

	if GameHelper.isWithBundle then 
		--check installed game
		LogWarning("check installed game begin. ignore this log")
		for k,v in pairs(EGameType) do 
			if v ~= EGameType.EGT_MAX then 
				Log("Installed " .. tostring(GameNames[tostring(v)]) .. "=" .. tostring(GBC.IsInstalledGame(v)))
			end 
		end 
		LogWarning("check installed game end. ignore this log")
	end
	m_currentScene = LuaGameManager.GInstance.currentScene
	LuaGameManager:StartGameMode()
end 

function  LuaGameManager:InitClient()
	ClientConn.Init()
end

function LuaGameManager:StartGameMode()
	LuaGameManager.SetGameType(LuaGameManager.GInstance.defaultGameType)
	LuaGameManager:CreateGameMode(DEFAULT_LUA_GAME_MODE)
end

--return ture if game has ended. otherwise false
function LuaGameManager:IsGameEnd()
	return LuaGameManager.GInstance.gameState == EGameState.EGS_Ended
end 

local function TestNotification()
	LuaGameManager.cor = coroutine.create(function() 
		while true do 
			facade:sendNotification(Common.RENDER_NOTIFICAITON, {msg=" hello everyone" .. luaTool:GetGuid(), weight=ENotiWeight.ENW_System})
			UnityEngine.Yield(UnityEngine.WaitForSeconds(3.0))
		end 
	end)
	coroutine.resume(LuaGameManager.cor)
end 

local function _PostLoadedLevel(gameModeClass)
	LuaGameManager:CreateGameMode(gameModeClass)
	
	if m_currentScene ~= "update" then 
		--[[if param_ui_notis == nil then 
			param_ui_notis = ci.GetUiParameterBase().new(Common.MENU_NOTIFICATION, EMenuType.EMT_Common, nil)
		end 
		facade:sendNotification(Common.OPEN_UI_COMMAND, param_ui_notis)]]
	end
	--if LuaGameManager.cor == nil then 
	--	TestNotification()
	--end 
end 

--level loaded. we need load lua game mode file and then bind it with source game mode.
function LuaGameManager.OnLevelLoaded(loadedScene)
	--@TODO we need spawn game mode of level.
	if loadedScene ~= nil then 
		LogWarning("Loaded scene is:: " .. loadedScene)
	end 

	if targetLevelInfo == nil then 
		LogError("invalid target level info.....will return")
		return
	end 

	--LuaGameManager.GInstance:UnloadLevel(m_currentScene)
	m_currentScene = loadedScene

	local gameModeClass = targetLevelInfo:getGameMode()

	targetLevelInfo = nil
	if gameModeClass == nil or gameModeClass == "" then 	
		UnityEngine.Debug.LogError("[OnLevelLoaded]:: invalid game mode class")
	end 
	
	LuaGameManager:CreateGameMode(gameModeClass)

	
end 

--Update is called once per frame
function LuaGameManager.Update()
	if LuaGameManager.bInited == false then 
		return
	end 
	
	if LuaGameManager.managers ~= nil then 
		for k,v in pairs(LuaGameManager.managers) do 
			local tmpManager = LuaGameManager.managers[k] 
	
			if tmpManager ~= nil and tmpManager.Update ~= nil then 
				tmpManager.Update()	
			end
		end 
	end
end 

--this will be called when application lost focus or focused again
function LuaGameManager.OnApplicationFocus(bFocus)
	if LuaGameManager.managers ~= nil then 
		for k,v in pairs(LuaGameManager.managers) do 
			local tmpManager = LuaGameManager.managers[k] 
			if tmpManager ~= nil and tmpManager.OnApplicationFocus ~= nil then 
				tmpManager.OnApplicationFocus(bFocus)
			end
		end 
		
		local platform = GameHelper.runtimePlatform
		if bFocus == true then 
			--try to read clipboard 
			if platform == BuildPlatform.IOS or platform == BuildPlatform.Android then 
				local str = ClipboardHelper.GetClipboardMsg()
				if str ~= "" and str ~= nil then 

					local roomId = nil 
					for k,v in  string.gmatch(str, "口令：%d+") do 
						roomId = k 
					end 
					if roomId and type(roomId) == "string" then 
						for _,v in string.gmatch(roomId, "%d+") do 
							roomId = _
						end 
					end 

					if roomId ~= nil and  string.len(roomId) == MAX_ROOM_ID_LEN then 
						m_RoomIdInFromClipboard = tonumber(roomId)
						Log("Parsed roomdid " .. roomId)
						m_bNeedSendCopyTip = true
						LuaGameManager.ShowDuplicateRoomIdTip()
					end 
				end 
			end 
		end 
	end
end 

--this will be invoked when game has been killed
function LuaGameManager.OnDestroy()
	LuaGameManager.bInited = false
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	if nil ~= facade then 
		facade:sendNotification(Common.UNREGISTER_EXTRA_COMMAND)
	end 
	
	if LuaGameManager.managers ~= nil then 
		for k,v in pairs(LuaGameManager.managers) do 
			local tmpManager = LuaGameManager.managers[k] 
			if tmpManager ~= nil and tmpManager.OnDestroy ~= nil then 
				tmpManager.OnDestroy()
			end
			
			LuaGameManager.managers[k] = nil
		end 
	end
	
	LuaInputManager.Clear()
	LuaGameManager.managers = nil 
	LuaGameManager.GInstance.onAsyncLoadLevel:RemoveAllListeners()
	LuaGameManager.GInstance = nil
end 

function LuaGameManager.FixedUpdate()
	if LuaGameManager.bInited == false then 
		return 
	end 
	if LuaGameManager.managers ~= nil then 
		for k,v in pairs(LuaGameManager.managers) do 
			local tmpManager = LuaGameManager.managers[k] 
			if tmpManager ~= nil and tmpManager.FixedUpdate ~= nil then 
				tmpManager.FixedUpdate()
			end
		end 
	end
end 

--get current game mode
function LuaGameManager.GetGameMode()
	return LuaGameManager.currentGameMode
end 

--end game 
function LuaGameManager.GameEnded()
	--LuaGameManager.currentGameMode = nil
end

--spawn game mode
function LuaGameManager:CreateGameMode(inGameModeClass)
	if inGameModeClass == nil or inGameModeClass == "" then 
		LogError("Invalid game mode class. check it" )
	else 
		local gameMode = depends(inGameModeClass)
		if gameMode ~= nil then 
			LuaGameManager.currentGameMode = gameMode.new()
			LuaGameManager.currentGameMode:Init()
		else
			LogError("Failed to build " .. inGameModeClass)
		end
	end 
end 

--register managers
function LuaGameManager.RegisterManager(inTable,managerName)
	if inTable == nil or managerName == nil or managerName == "" then 
		LogError("Failed to register manager " .. tostring(managerName))
		return
	end 
	
	if LuaGameManager.managers[managerName] ~= nil then 
		LogWarning("Manager:: " .. managerName .. "has been registered. are you sure replace?")
		return
	end 
	
	LuaGameManager.managers[managerName] = inTable
end 

--return game name
function LuaGameManager.GetGameName()
	return gameName
end 

--Set Game Type.
--Note:: if one game contains is application, not real game.we must update game type
--before real launch game.
function LuaGameManager.SetGameType(inGameType)
	if inGameType == EGameType.EGT_MAX then 
		LogWarning("Invalid game type, please check it now....")
	end 
	local oldGame = currentGame
	currentGame = inGameType;
	LuaGameManager:UpdateGamePaths(currentGame)
	if oldGame ~= currentGame then 
		--try to instance classInstance and GameConfig 
		gameName = GameNames[tostring(inGameType)]
		if gameName == nil or gameName == "Invalid" then 
			LogWarning("Missed Game name of game type:: " .. inGameType)	
		else 
			local root = "Games." .. gameName .. ".Tools." 
			local path = root .. "GameConfig"
			local tmp = depends(path)
 
			SetGameConfig(tmp)

			path = root .. "ClassInstance"
			tmp = depends(path)
			SetGameCI(tmp)
		end 
	end
end 

function LuaGameManager.GetGameType()
	if currentGame == EGameType.EGT_MAX then 
		return 0
	else 
		return currentGame
	end 
end 

--Update Game Path with game type
--this function must be called when the default game type equals EGameType.MAX.
--because game scripts will be normally load only when path is valid
function LuaGameManager:UpdateGamePaths(inGameType)
	gameName = GameNames[tostring(inGameType)]
	if gameName == nil then 
			
	else 
		local root = "Games." .. gameName
		
		root_path.GAME_MVC_CONTROLLER_PATH =  root .. ".Controller."
		root_path.GAME_MVC_PROXY_PATH = root .. ".Proxy."
		root_path.GAME_MVC_MEDIATOR_PATH = root  .. ".Mediator."
		root_path.GAME_MVC_VIEW_PATH = root .. ".View."
		
		--game mode path
		root_path.GAME_MODE_PATH =  root .. ".GameMode."

		--game player path
		root_path.GAME_PLAYER_PATH = root .. ".Player."
	end 
end

--whether has set default game type
function LuaGameManager.HasSetDefaultGameType()
	if LuaGameManager.GInstance ~= nil and LuaGameManager.GInstance.defaultGameType == EGameType.EGT_MAX then 
		return false 
	end 
	return true
end 

local function PreLeaveLevel()
	if LuaGameManager.currentGameMode ~= nil then 
		LuaGameManager.currentGameMode:OnLeaveLevel()
		LuaGameManager.currentGameMode = nil
	end
end 

function LuaGameManager.SwitchLevel(info)
	if targetLevelInfo ~= nil then 
		LogError("Can not switch level. because last operation has not done.. currently switching " .. targetLevelInfo.levelName)
		return
	end 

	if info == nil then 
		LogError("Please set valid level info")
		return
	end 
	
	PreLeaveLevel();
	local onAudioFade = function()
		onAudioFade = nil
		GameHelper.GC()
		collectgarbage()
		
		targetLevelInfo = info	
		LuaGameManager.GInstance:SwitchLevel(targetLevelInfo:getLevelName(), false, UnityEngine.SceneManagement.LoadSceneMode.Single)		
	end 
	AudioManager.getInstance():SafeRelease(onAudioFade)
end 

function LuaGameManager:PostBindServer(state, connOperation, desc)
	desc = desc or "unknown problem"
	--facade:sendNotification(Common.PRE_LOGIN_GAME_SERVER)
	if connOperation == ENetConnOperation.ENCO_LoginServer then 
		facade:sendNotification(Common.BIND_GAME_SERVER_RSP, {state = state, desc = desc})
	elseif connOperation == ENetConnOperation.ENCO_GateServer then 
		facade:sendNotification(Common.BIND_GATE_SERVER_RSP, {state = state , desc = desc})
	else 
		facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
	end 
	
end 

function LuaGameManager.GetClipboardRoomId()
	return m_RoomIdInFromClipboard
end 

function LuaGameManager.ClearClipboardRoomId()
	m_RoomIdInFromClipboard = nil 
end 

function LuaGameManager.IsLoginScene()
	return m_currentScene == "Login"
end

function LuaGameManager.IsMainScene()
	-- body
	return m_currentScene == "Main"
end

function LuaGameManager.IsUpdateScene()
	-- body
	return m_currentScene == "Update"
end

function LuaGameManager.IsInGame()
	local bIsInGame = true 
	if LuaGameManager.IsLoginScene() == true or LuaGameManager.IsUpdateScene() == true  or LuaGameManager.IsMainScene() == true then 
		bIsInGame = false
	end 
	return bIsInGame
end

function LuaGameManager.ShowDuplicateRoomIdTip()
	if m_bNeedSendCopyTip == true then 
		if UIManager.getInstance():HasOpened(Common.MENU_MSGBOX) == true then 
			local s = string.format(luaTool:GetLocalize("had_copy_room_id"), tostring(m_RoomIdInFromClipboard))
			facade:sendNotification(Common.RENDER_MESSAGE_VALUE, s)
			m_bNeedSendCopyTip = false 
		end 
	end 
end 


return LuaGameManager