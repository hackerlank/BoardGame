-----------------------------------------------------------------------------
--LuaGameModeBase:: 
-- lua game mode base. Communicate with GameMode class of CSharp version. this
-- is the only way. Forbid use GameModeBase.Instance directly in lua script.
-- all game mode class must inherits from it. 

-- @constructor
-- If your subclass does define a constructor, be sure to call "super" like so
--  function LuaGameModeBase:ctor()
--    {
--        self.super.ctor(self);
--    };

-- @Update FixedUpdate OnDestroy 
-- you can override Update FixedUpdate OnDestroy functions. if you have
-- override, must call function in spuer class. like::
-- function LuaGameModeBase:Update()
--		self.super.Update(self)
-- end

-- @Init
--  generally subclass always override self. current game mode will be bind with 
--	GameModeBase class of csharp. so this funciton must be invoked if subclass
--  override it. like:: self.super.Init(self). do not use self.super:Init().

--@Fade in or out. currently only support fade in.
--@DEFINED_FADE_IN whether need to fade in when switch level
--@DEFINED_FADE_OUT whether need to fade out when switch level? 
--if we want to disbale this function. please set false as its value
-----------------------------------------------------------------------------
local LuaGameModeBase = class('LuaGameModeBase')

LuaGameModeBase.Name = LUA_GAME_MODE_BASE
LuaGameModeBase.MAX_PLAYERS = 4
LuaGameModeBase.BACKGROUND_MUSIC = EGameSound.EGS_MAX

--Log functions
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

local DEFINED_FADE_IN = true
local DEFINED_FADE_OUT = true

local m_SceneFade = nil 

-- constructor
function LuaGameModeBase:ctor()
	self.components = {}	
end

-- Game mode main entrance
function LuaGameModeBase:Init(iName, iSound)
	if m_SceneFade == nil then 
		local obj = UnityEngine.GameObject.Find("SceneFade")
		if obj then 
			m_SceneFade = obj:GetComponent("ScreenFade")
		end 	
	end 
	self.super.Name = iName
	self.super.BACKGROUND_MUSIC = iSound
	--bind with CSharp GameModeBase class
	local defaultGameMode = GameModeBase.GameMode
	defaultGameMode:BindLuaGameMode(self,self.Name)
end

function LuaGameModeBase:GetBGMusic()
	return self.BACKGROUND_MUSIC
end 

--Update is called once per frame
function LuaGameModeBase._Update(inTable)
	if inTable ~= nil and inTable.Update then 
		inTable:Update()
	end 
end 

-- override this function in your subclass.
function LuaGameModeBase:Update()
	--@TODO use another way to cache this, so we can improve execution speed  
	if self ~= nil and self.components ~= nil then 
		for k,v in pairs(self.components) do 
			local comp = self.components[k] 
			if comp ~= nil and comp.Update ~= nil then 
				comp:Update()
			end
		end 
	end 
end 

function LuaGameModeBase._FixedUpdate(inTable)
	if inTable ~= nil and inTable.FixedUpdate then 
		inTable:FixedUpdate()
	end 
end 

-- override this function in your subclass.
function LuaGameModeBase:FixedUpdate()
	if self ~= nil and self.components ~= nil then 
		for k,v in pairs(self.components) do 
			local comp = self.components[k] 
			if comp ~= nil and comp.FixedUpdate ~= nil then 
				comp:FixedUpdate()
			end
		end 
	end 
end 


function LuaGameModeBase._OnDestroy(inTable)
	if inTable ~= nil and inTable.OnDestroy then
		inTable:OnDestroy() 
	end 
end 

-- override this function in your subclass.
-- @todo should us directly call RemoveAllComponent. 
-- not notification all components? because, if this
-- funciton has been called, generally indicates application
-- has been killed. 
function LuaGameModeBase:OnDestroy()
	--release all components. maybe this need to be executed in advance
	if self ~= nil and self.components ~= nil then 
		for k,v in pairs(self.components) do 
			local comp = self.components[k] 
			if comp ~= nil and comp.SafeRelease ~= nil then 
				comp.SafeRelease(comp)
			end		
		end 
	end 

	self:RemoveAllComponent()

	-- release static game mode base object instance in csharp
	self.ReleaseGameModeObj();
end 

-- release static instance object of GameModeBase class.
-- this operation must be executed in LuaGameModeBase's 
-- OnDestroy. 
function LuaGameModeBase:ReleaseGameModeObj()
	local defaultGameMode = GameModeBase.GameMode
	if defaultGameMode then 
		defaultGameMode:FreeGameMode()
	end 
end 

-- register one component, which wants to do something in update or OnDestroy
-- inTable means lua script component
-- compName means any character, the lua file name is the best choice
function LuaGameModeBase:RegisterComponent(inTable, compName)
	if inTable == nil or compName == nil or compName == "" then 
		LogError("Failed to register component:: " ..compName)
		return
	end 
	

	if self.components[compName]  then 
		LogWarning("[LuaGameModeBase]:: Component:: " .. compName .. " has been registered.")
		return
	end 
	self.components[compName] = inTable	
end 

-- remove one component
-- compName means any character, the lua file name is the best choice
function LuaGameModeBase:RemoveComponent(compName)

	if compName == nil or compName == "" then 
		LogError("Invalid component name. will return ")
		return
	end 

	if not self.components[compName] then 
		LogError("[LuaGameModeBase]:: Component " .. compName .. " has not been registered, check this now")
		return
	end 
	
	--remove component from table
	self.components[compName] = nil
end 

-- remove all components that has been registered into self.
-- this will be invoked when play exit one real game. not application
function LuaGameModeBase:RemoveAllComponent()
	if self.components ~= nil then 
		for k, v in pairs(self.components) do 
			self.components[k] = nil;
		end
		self.components = nil;
	end 
end

-- override this funtion in subclass. must invoke it  first
function LuaGameModeBase:EndGame(endReason)
	if GameModeBase.GameMode then 
		GameModeBase.GameMode:EndGame(endReason)
	end 
end 

local CLOSE_LOADING_MENU = nil 
-- override this funtion in subclass. must invoke it  first
function LuaGameModeBase:PlayGame()
	if GameModeBase.GameMode then 
		GameModeBase.GameMode:PlayGame()
	end 
	if CLOSE_LOADING_MENU == nil then 
		CLOSE_LOADING_MENU = ci.GetUICloseParam().new(true, Common.MENU_LOADING)
	end 
	if UIManager.getInstance():HasOpened(Common.MENU_LOADING) then 
		local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_LOADING_MENU)
	end
end 

-- override this funtion in subclass. must invoke it  first
function LuaGameModeBase:PauseGame()
	if GameModeBase.GameMode then 
		GameModeBase.GameMode:PauseGame()
	end 
end 

-- override this funtion in subclass. must invoke it  first
function LuaGameModeBase:ResumeGame()
	if GameModeBase.GameMode then 
		GameModeBase.GameMode:ResumeGame()
	end 
end 

--do not override it
function LuaGameModeBase:GetGameState()
	if GameModeBase.GameMode then 
		return GameModeBase.GameMode.gameState
	end 
end 

function LuaGameModeBase:IsPaused()
	if GameModeBase.GameMode then 
		return GameModeBase.GameMode.gameState == EGameState.EGS_Paused
	end 
	return false		
end 

function LuaGameModeBase:IsGameEnd()
	if GameModeBase.GameMode then 
		return GameModeBase.GameMode.gameState == EGameState.EGS_Ended
	end 
	return false	
end

function LuaGameModeBase:IsPlaying()
	if GameModeBase.GameMode then 
		return GameModeBase.GameMode.gameState == EGameState.EGS_Playing
	end 
	return false	
end 

function LuaGameModeBase:IsWait()
	if GameModeBase.GameMode then 
		return GameModeBase.GameMode.gameState == EGameState.EGS_WaitStart or GameModeBase.GameMode.gameState == EGameState.EGS_Start
	end 
	return false	
end 

function LuaGameModeBase:OnLeaveLevel()
	if GameModeBase.GameMode then 
		GameModeBase.GameMode:RemoveLuaGameMode()
	end 
	--m_SceneFade = nil 
	-- release memory when switch level
	if self ~= nil and self.components ~= nil then 
		for k,v in pairs(self.components) do 
			local comp = self.components[k] 
			if comp ~= nil and comp.SafeRelease ~= nil then 
				comp:SafeRelease()
			end		
		end 
	end 
	self:RemoveAllComponent()
end 

function LuaGameModeBase:JoinGame(id)
	if #self.players < self.MAX_PLAYERS and self.SpawnPlayer then 
		local newPlayer = self:SpawnPlayer(id) 
		self.players[#self.players+1] = tmpPlayer
	end 
end 

function LuaGameModeBase:LeaveGame(id)
	if id == nil or (id ~= nil and type(id) ~= "number") then 
		return
	end 

	for k,v in ipairs(self.players) do 
		if v.GetPlayerId() == id then 
			if v.SafeRelease then 
				v:SafeRelease()
			end 
			self.players[k] = nil
			break
		end 
	end 
end 

--fade in when switch level
--@param delayTime  
function LuaGameModeBase:FadeIn(delayTime)
	delayTime = delayTime or 0--or 0.1
	if DEFINED_FADE_IN == true then 
		if m_SceneFade then 
			m_SceneFade:EnableFade(delayTime)
		end 
	end 
end

function LuaGameModeBase:FadeOut()
	if DEFINED_FADE_OUT == true then
	end 
end

function LuaGameModeBase:GetAllPlayers()
	return self.players
end 

function LuaGameModeBase:GetPlayer(id)
	if id < 0 or id > #self.players then 
		return nil
	end 
	
	return self.players[id]
end 

--override this in sub class
function LuaGameModeBase:SpawnPlayer(id)
	return nil
end 

return LuaGameModeBase