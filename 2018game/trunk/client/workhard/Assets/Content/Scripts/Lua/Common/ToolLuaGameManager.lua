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

local login_msg_id = depends("network.msg_id.login_msgid")
local gate_msg_id = depends("network.msg_id.gate_msgid")
local plaza_msg_id = depends("network.msg_id.plaza_msgid")
local hall_msg_id = depends("network.msg_id.hall_msgid")
local LoginType = depends("network.msg_id.logintype")

local protocols = depends('Common.ProtocolManager')
local login_sproto =  protocols.GetLoginSproto()
local gate_sproto = protocols.GetGateSproto()
local plaza_sproto = protocols.GetAgentSproto()
local hall_sproto = protocols.GetGameHallSproto()

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

--current playing game
local gameName = ""

local currentGameType = EGameType.EGT_MAX

local targetLevelInfo = nil

--save bundles of each game
local gameBundleConfig = nil

--log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

--facade
local facade = nil

local param_ui_notis = nil 


    local password = "123456"
    local loginType = LoginType.user_name
    local user_name

local self_user_id_cache

local self_authcode_cache	

local self_gate_service_id_cache

local self_gate_server_address_cache

local self_plaza_service_id_cache
	
local  tb_halllist 	= {}

local self_hall_service_cache

local self_table_id_cache
	
local  login_pack = {}
local  gate_pack = {}
local game_plaza_pack = {}
local hall_pack = {}


local self_btn_createroom
local self_btn_exitroom
local self_btn_returnroom
local self_btn_dismissroom

local self_txt_room_info

local  create_room
local  req_enter_own_table
local  dismiss_table

local function on_create()
	create_room()
end

local function on_exit()
	
end

local function on_return()
	
end
local function on_dismiss()

	dismiss_table()
end


--local function LoadGameBundleConfig()
	--local asset = UnityEngine.Resources.Load("GameBundle", GameHelper.GetAssetType(GameHelper.EAssetType.EAT_TextAsset))
	--if asset ~= nil then 
		--local content = asset.text
		--gameBundleConfig = JsonTool.Decode(content)
	--end 
--end 

--custom event
--local function onLoadingLevel(fProgress)
	--update loading level menu
	--facade:sendNotification(Common.ON_LOADING_LEVEL, fProgress)
--end 
-- successfully create account


--help bind 
local  findfunc = UnityEngine.GameObject.Find
 
local function find_ui_in_scene(ui_object,ui_path)
	ui_object = findfunc(ui_path):GetComponent('Button')
end

dismiss_table = function()
		local tmp = {table_id = self_table_id_cache}

 		ClientConn.SendMessage(
			self_hall_service_cache,
			hall_msg_id.req_dismiss_room,
			hall_sproto:encode("req_dismiss_room",tmp)
		)	
end

 req_enter_own_table = function()
 		ClientConn.SendMessage(
			self_hall_service_cache,
			hall_msg_id.req_enter_own_table,
			nil
		)
 end

  create_room = function()
		--self_hall_service_cache =tb_halllist[1].hall_service
		--ClientConn.RegisterRspPack(self_hall_service_cache, hall_pack)
		ClientConn.SendMessage(
			self_hall_service_cache,
			hall_msg_id.req_create_private_table,
			nil
		)

end

--register account
local function RegisterAccount(loginType, name, password)
   



    Log("registering " .. tostring(name) .. " " .. tostring(password))
    if name == nil or password == nil or loginType == nil then 
        return
    end 

    if name == "" or password == "" or loginType <= 0 then 
        return
    end 

     local tmp = { login_type = logintype,  
                    user_name = name,
                    user_pass = password
                }
    
    
    --send create user request
    ClientConn.SendMessage(
	            SERVICE_ID_LOGIN, 
	            login_msg_id.create_user,
                login_sproto:encode("create_user",tmp)
    )
end 


---Login game
local function LoginGame(logintype, name ,password)
    if logintype == nil or name == nil or password == nil then 
        return
    end 

    if name == "" or password == "" then 
        return
    end 

    local param={ login_type = logintype,     --登录类型，帐号，qq，邮箱等，现在只有帐号，随便填
                    user_name = name, --帐号
                    user_pass = password
                }
    --userInfo.username = name
    --userInfo.password = password
    --userInfo.loginType = logintype
    ClientConn.SendMessage(
	            SERVICE_ID_LOGIN,
	            login_msg_id.user_login,
                login_sproto:encode("user_login",param)
    )

end 


--login gate
local function  LoginGate()
	
    local param = { user_id = self_user_id_cache, auth_code = self_authcode_cache }
    ClientConn.SendMessage(
        self_gate_service_id_cache,
        gate_msg_id.user_login,
        gate_sproto:encode("user_login", param)
    )
end 

--get game hall list
local function QueryHallList()
    local param = { user_id = self_user_id_cache, auth_code = self_authcode_cache}
    ClientConn.SendMessage(
        self_plaza_service_id_cache,
        plaza_msg_id.get_hall_list,
        nil
    )
end 

local function ConnectGateServer()
    ClientConn.Disconnect()
	 local tmp_strs = luaTool:Split(self_gate_server_address_cache, ":")
	
    ClientConn.Connect(tmp_strs[1], tonumber(tmp_strs[2]), false, ENetConnOperation.ENCO_GateServer)	
end

---------------------------------------------
----------------call backs --------------------------------
---------------------------

login_pack[login_msg_id.create_user_ok] = function(buf)
    --now directly call LoginGame function to login game with register account parameter
    Log("create user ok")
    --facade:sendNotification(Common.LOGIN_GAME_SERVER, createAccountParam)
    --createAccountParam = nil
	LoginGame(loginType,user_name,password )
end 

-- successfully login game
login_pack[login_msg_id.user_login_ok] = function(buf)
	
	local body = login_sproto:decode("user_login_ok",buf)
	print("login ok ,gate service addr is ..".. body.gate_address)
	self_gate_service_id_cache =  body.login_service
	self_user_id_cache = body.user_id
	self_authcode_cache = body.auth_code
	self_gate_server_address_cache = body.gate_address

    --SaveAccountInfo()
	-- register callbacks of login_gate
    ClientConn.RegisterRspPack(self_gate_service_id_cache, gate_pack)
	
	ConnectGateServer()
   
end

-- failed to login game.clear cached username section
login_pack[login_msg_id.user_login_fail] = function(buf)
	
	local body = login_sproto:decode("user_login_fail",buf)
     print("login server login failed ,reason is : "..body.desc)
end


--################### login gate callbacks begin #################
--login gate ok
gate_pack[gate_msg_id.user_login_ok] = function(buf)
    local body = gate_sproto:decode("user_login_ok",buf)
	self_plaza_service_id_cache = body.plaza_service

	-- register response of gamehall
    ClientConn.RegisterRspPack(self_plaza_service_id_cache, game_plaza_pack)

	Log("user login gate ok " .. self_plaza_service_id_cache)

	--query game hall list
    --facade:sendNotification(Common.LOGIN_GATE_SERVER_RSP, 0)
	QueryHallList()
end 

--failed to login gate
gate_pack[gate_msg_id.user_login_fail] = function(buf)
    local body = gate_sproto:decode("user_login_fail",buf)
   print("gate user_login_fail")
end 

--login out gate ok
gate_pack[gate_msg_id.user_logout_ok] = function(buf)
	print("user logout ok ")
end 

game_plaza_pack[plaza_msg_id.hall_list] = function(buf)
    Log("on_hall_list")
	local body = plaza_sproto:decode("hall_list",buf)

	--local hall_service = nil
	if body.hall == nil  then 
		LogError("no game hall exitst")
	    return
	else
		
        local tmp_hall = nil 
		for k,v in pairs(body.hall) do 
            tmp_hall = {}
            
            tmp_hall.hall_name = v.hall_name
            tmp_hall.game_type = tonumber(v.hall_type)
            tmp_hall.hall_desc = v.hall_desc       
            tmp_hall.hall_version = v.hall_version
            tmp_hall.hall_service = v.hall_service
            tmp_hall.client_version = v.client_version
            tmp_hall.is_expired = v.is_expired
            tmp_hall.user_num = v.user_num
            table.insert(tb_halllist, tmp_hall)	 

            
		end
       -- luaTool:Dump(tb_halllist)
		--facade:sendNotification(Common.LOGIN_GATE_SERVER_RSP, 0)
	end
	if #tb_halllist >0 then 
		print("there is a hall") 
		self_hall_service_cache =tb_halllist[1].hall_service
		ClientConn.RegisterRspPack(self_hall_service_cache, hall_pack)
		ClientConn.SendMessage(
			self_hall_service_cache,
			hall_msg_id.req_enter_hall,
			nil
		)		
	end
	
end 

hall_pack[hall_msg_id.req_enter_hall_ok] = function(buf)
	--local body = hall_sproto:decode("you_enter_table",buf)
		print("enter hall success")
end

hall_pack[hall_msg_id.enter_table_completed] = function(buf)
	--local body = hall_sproto:decode("you_enter_table",buf)
		print("enter table success")
end

hall_pack[hall_msg_id.req_create_private_table_ok] = function(buf)
	local body = hall_sproto:decode("req_create_private_table_ok",buf)
		print("create table ok ,room id is :"..body.room_id)
		self_table_id_cache = body.room_id
		req_enter_own_table()
end

hall_pack[hall_msg_id.req_create_private_table_fail] = function(buf)
	local body = hall_sproto:decode("req_create_private_table_fail",buf)
		print("create table fail ,reason is :"..body.desc )
end

hall_pack[hall_msg_id.req_join_private_table_ok] = function(buf)
	
	local body = hall_sproto:decode("join_private_table_ok",buf)
		print("enter private table ok")
		print(body)
		for k,v in pairs(body) do
			print("k is :"..k .." and v is:"..v)
		end
end

hall_pack[hall_msg_id.req_join_private_table_fail] = function(buf)
	local body = hall_sproto:decode("req_join_private_table_fail",buf)
	print("join private table fail")
			for k,v in pairs(body) do
			print("k is :"..k .." and v is:"..v)
		end
end


hall_pack[hall_msg_id.dismiss_room_completed] = function(buf)
	--local body = hall_sproto:decode("req_join_private_table_fail",buf)
	print(" dismiss ok")
end


hall_pack[hall_msg_id.dismiss_room_failed] = function(buf)
	local body = hall_sproto:decode("dismiss_room_failed",buf)
	print("dismiss failed")
			for k,v in pairs(body) do
			print("k is :"..k .." and v is:"..v)
		end
end

hall_pack[hall_msg_id.room_dismissed] = function(buf)
	
	print("room dismissed by master")

end
--init Game Manager. this function will be invoked when launch game.
--we will init game client in here.
--NOTE:: we need cache the game type, even if we had defined game type when cook games.
--if we not cache the game type, game content path will keep invalid states; launch game 
--client must failure.
function LuaGameManager:Init()
	Log("Init lua game manager...")
	self_btn_createroom = UnityEngine.GameObject.Find("/Canvas/createroom"):GetComponent('Button')
	self_btn_exitroom = UnityEngine.GameObject.Find("/Canvas/exitroom"):GetComponent('Button')
	self_btn_returnroom = UnityEngine.GameObject.Find("/Canvas/returnroom"):GetComponent('Button')
	self_btn_dismissroom =  UnityEngine.GameObject.Find("/Canvas/dismissroom"):GetComponent('Button')
	self_txt_room_info =  UnityEngine.GameObject.Find("/Canvas/roominfo"):GetComponent('Text')
	
	self_btn_createroom.onClick:AddListener(on_create)
	self_btn_exitroom.onClick:AddListener(on_exit)
	self_btn_returnroom.onClick:AddListener(on_return)
	self_btn_dismissroom.onClick:AddListener(on_dismiss)
	
	LuaGameManager.bInited = false
	LuaGameManager.managers = {}
	LuaGameManager.bInited = true

	--load game bundle configuration file

	--initial puremvc
	pm.InitPuremvc()
	
	UnityEngine.Debug.Log("Init lua pure mvc...")
	--register all common command. all of them was saved into lua_common.u files
	--local commonExtraCommand = depends('Common.Controller.RegisterUpdatesCommand')
	--local executeCmd = commonExtraCommand.new()
	--executeCmd:execute(nil)	

	--initial download manager
	--GetDownloadManager().Init()

	--initial game setting
	--GameSetting.getInstance()

	--initial the lua input manager
	--LuaInputManager.getInstance()

	--initial the ui manager
	--UIManager.getInstance()

	--initial audio manager
	--AudioManager.getInstance()

	--initial update manager
	--GetUpdateManager().Init()

	facade = pm.Facade.getInstance(GAME_FACADE_NAME)

	--initial client net connection manager
	LuaGameManager:InitClient()

	--register listener
	LuaGameManager.GInstance.onAsyncLoadLevel:RemoveAllListeners()
	--LuaGameManager.GInstance.onAsyncLoadLevel:AddListener(onLoadingLevel)

	if GameHelper.isWithBundle then 
		--check installed game
		LogWarning("check installed game begin. ignore this log")
		for k,v in pairs(EGameType) do 
			Log("Installed " .. tostring(GameNames[tostring(v)]) .. "=" .. tostring(LuaGameManager.IsInstallGame(v)))
		end 
		LogWarning("check installed game end. ignore this log")
	end

	--LuaGameManager:StartGameMode()
	--do something 
    ClientConn.Disconnect()

    ClientConn.Connect("192.168.0.109", 2701, false, ENetConnOperation.ENCO_LoginServer)	
	
end 

function  LuaGameManager:InitClient()
		ClientConn.Init()
		
		 ClientConn.RegisterRspPack(0, login_pack)
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
	end
end 

--this will be invoked when game has been killed
function LuaGameManager.OnDestroy()
	LuaGameManager.bInited = false
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	if nil ~= facade then 
		--facade:sendNotification(Common.UNREGISTER_EXTRA_COMMAND)
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



function LuaGameManager:pre_login_game_server(connOperation)
	print(" connect to login server ..........")
	
    --local password = "123456"
    --local loginType = LoginType.user_name
     user_name = string.format("%s%s%s%s%s%s%s", "user",os.date("%y"), os.date("%m"), os.date("%d"),os.date("%H"),os.date("%M"), os.date("%S") )

	RegisterAccount(loginType,user_name,password)
end


 function LuaGameManager:login_gate_server(connOperation)
   print(" connect to gate server ..........")
   LoginGate()
 end



return LuaGameManager