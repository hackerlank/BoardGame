local LoginProxy = class('LoginProxy', pm.Notifier)
local login_msg_id = depends("network.msg_id.login_msgid")
local gate_msg_id = depends("network.msg_id.gate_msgid")
local agent_msg_id = depends("network.msg_id.agent_msgid")
local hall_msg_id = depends("network.msg_id.hall_msgid")

local protocols = depends('Common.ProtocolManager')
local login_sproto =  protocols.GetLoginSproto()
local gate_sproto = protocols.GetGateSproto()
local hall_sproto = protocols.GetHallSproto()
local agent_sproto = protocols.GetAgentSproto()
local common_sproto = protocols.GetCommonSproto()
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local HEART_PACKAGE_CONTENT = 123
local HEART_EXPIRED_IN = 10 --心跳包有效时间
local m_HeartOutOfDate = 0 --接受心跳包最迟时间
local m_bSentHeart = false
local UTime = UnityEngine.Time
local m_HeartCor = nil 
local m_bReceivedHeart = false

local m_bIsOnline = false

local self_record_list = {}
LoginProxy.proxyName = Common.LOGIN_PROXY

local SERVICE_ID_LOGIN = 0

--server notificaitons:: login game, create account .. etc
local login_pack = {}

--server notifications:: login gate, loginout gate .. etc
local gate_pack = {}

--server notifications:: game hall callbacks
local agent_pack = {}

local hall_pack = {}

--user info
local userInfo = {}

--gate service id
local gate_service_id = nil

--plaza service id
local agent_service_id = nil

local tb_halllist = nil 

--save gate server address
local gate_server_address = nil

--shuihu service 

local shuihu_service = nil

--cache current built account
local createAccountParam = nil

--player joined game
local m_PlayerJoinedGame = nil 

local m_RenderWelcomeMsg = true

function LoginProxy:getProxyName()
    return self.proxyName
end 
local m_bLogout = false 

function LoginProxy:StartHeart()
    m_bSentHeart = false
    local m_SendHeartTime = 0
    if m_HeartCor == nil then 
        m_HeartCor = coroutine.create(function()
            while true do 
                if m_bLogout == true  or m_bIsOnline == false then 
                    break
                end 
                if m_bSentHeart == false then 
                    m_bReceivedHeart = false     
                    m_SendHeartTime = UTime.realtimeSinceStartup 
                    m_HeartOutOfDate = m_SendHeartTime + HEART_EXPIRED_IN
                    m_bSentHeart = true 
                    LoginProxy:Heart()
                else
                    if UTime.realtimeSinceStartup <= m_HeartOutOfDate and m_bReceivedHeart == true then 
                        --wait 3 seconds
                        UnityEngine.Yield(UnityEngine.WaitForSeconds(HEART_EXPIRED_IN))
                        m_bSentHeart = false 
                    elseif UTime.realtimeSinceStartup > m_HeartOutOfDate and m_bReceivedHeart == false then 
                        m_HeartCor = nil 
                        m_bIsOnline = false
                        LogError("heart out of date")
                        facade:sendNotification(Common.DISCONNECT)
                        break
                    end 
                end 
                UnityEngine.Yield(UnityEngine.WaitForSeconds(0.03))
            end 
        end)
        coroutine.resume(m_HeartCor)
    end 
end 

function LoginProxy:Disconnect()
    -- body
    m_bIsOnline = false
end

function LoginProxy:onRegister()
    tb_halllist = {}
    ClientConn.RegisterRspPack(SERVICE_ID_LOGIN, login_pack)
    m_PlayerJoinedGame = nil 
end

function LoginProxy:onRemove()
    Log("Login proxy:: onRemove")
    m_PlayerJoinedGame = nil 
end

---Login game
function LoginProxy:LoginGame(logintype, _params)
    if logintype == nil or _params == nil then 
        return
    end 
    local param={login_type = logintype,
                    params = _params }
    ClientConn.SendMessage(
	            SERVICE_ID_LOGIN,
	            login_msg_id.user_login,
                login_sproto:encode("user_login",param)
    )

end 

function LoginProxy:Logout()
    ClientConn.SendMessage(
	            gate_service_id,
	            gate_msg_id.user_logout,
                gate_sproto:encode("user_logout",{user_id = userInfo.user_id})
    )
end 

function LoginProxy:ReqPay(userid, paytype, param)
    
    local t = {user_id = userid, pay_type = paytype, params = param}
    ClientConn.SendMessage(
        agent_service_id,
        agent_msg_id.req_pay,
        agent_sproto:encode("req_pay",t)
    )
end 

function LoginProxy:QueryGameHall(roomId)
    ClientConn.SendMessage(
        agent_service_id,
        agent_msg_id.req_query_private_table,
        agent_sproto:encode("req_query_private_table", {private_key = roomId})
    )
end 

function LoginProxy:UploadGPS(x, y)
    userInfo.latitude = tonumber(x)
    userInfo.longitude = tonumber(y)
    ClientConn.SendMessage(
        agent_service_id,
        agent_msg_id.req_update_gps,
        agent_sproto:encode("req_update_gps",{gps_x=x, gps_y=y})
    )
end 

--register account
function LoginProxy:RegisterAccount(param)
   
    if param == nil then 
        return
    end 

    local loginType = param:GetLoginType()
    local name = param:GetUserName()
    local password = param:GetPassword()

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
    
    createAccountParam = param
 
    --send create user request
    ClientConn.SendMessage(
	            SERVICE_ID_LOGIN, 
	            login_msg_id.create_user,
                login_sproto:encode("create_user",tmp)
    )
end 

--login gate
function  LoginProxy:LoginGate()

    local param = { user_id = userInfo.playerId, auth_code = userInfo.auth_code }
    ClientConn.SendMessage(
        gate_service_id,
        gate_msg_id.user_login,
        gate_sproto:encode("user_login", param)
    )
end 

function LoginProxy:QueryHallInfo(service_id)
    local param = { hall_service = tonumber(service_id)}
    ClientConn.SendMessage(
        agent_service_id,
        agent_msg_id.get_hall_info,
        agent_sproto:encode("get_hall_info", param)
    )
end

--get game hall list
function LoginProxy:QueryHallList()
    local param = { user_id = userInfo.playerId, auth_code = userInfo.auth_code }
    ClientConn.SendMessage(
        agent_service_id,
        agent_msg_id.get_hall_list,
        nil
    )
end 

function LoginProxy:QueryUserInfo()
    ClientConn.SendMessage(
        agent_service_id,
        agent_msg_id.get_user_info,
        nil
    )
end 

--heart package 
function LoginProxy:Heart()
    ClientConn.SendMessage(
        gate_service_id,
        gate_msg_id.ping,
        gate_sproto:encode("ping", {data=HEART_PACKAGE_CONTENT})
    )
end 

--whether has logined game
function LoginProxy:HasLogin()
    if userInfo.playerId  == nil then 
        return false
    end 

    return true
end 

--return the playerId
function LoginProxy:GetPlayerId()
    if userInfo ~= nil then 
        return userInfo.user_id 
    end 

    return 0
end 

--get gate server address
function LoginProxy:GetGateAddress()
    return gate_server_address
end 

--return user name
function LoginProxy:GetUserName()
     if userInfo ~= nil then 
        return userInfo.user_name 
    end 

    return ""
end 

function LoginProxy:GetHeadImageUrl()
    if userInfo == nil then 
        return  ""
    end 

    return userInfo.head_img
end 

--is self 
function LoginProxy:IsSelf(id)
    if userInfo ~= nil then 
        return userInfo.user_id == id 
    end 
    return false
end

--################### login game server callbacks begin #################
-- successfully login game
login_pack[login_msg_id.user_login_ok] = function(buf)
	local body = login_sproto:decode("user_login_ok",buf)
	gate_service_id = body.gate_service
	userInfo.playerId = body.user_id
	userInfo.auth_code = body.auth_code
    gate_server_address = body.gate_address
    m_bLogout = false
	-- register callbacks of login_gate
    ClientConn.RegisterRspPack(gate_service_id, gate_pack)
    facade:sendNotification(Common.LOGIN_GAME_SERVER_RSP, {errorcode=EGameErrorCode.EGE_Success, param=body})
end

-- failed to login game.clear cached username section
login_pack[login_msg_id.user_login_fail] = function(buf)
	local body = login_sproto:decode("user_login_fail",buf)
    userInfo.username = nil
    facade:sendNotification(Common.LOGIN_GAME_SERVER_RSP, {errorcode = body.code, desc = body.desc})
end

-- successfully create account
login_pack[login_msg_id.create_user_ok] = function(buf)
    --now directly call LoginGame function to login game with register account parameter
    Log("create user ok")
    facade:sendNotification(Common.LOGIN_GAME_SERVER, createAccountParam)
    createAccountParam = nil
end 

-- failed to create account. need to bt re-created
login_pack[login_msg_id.create_user_fail] = function(buf)
    --@todo should us show the message???
    local body = login_sproto:decode("create_user_fail",buf)
	LogError("user login fail:: " .. body.desc)
    createAccountParam = nil
    facade:sendNotification(Common.REGISTER_ACCOUNT)
end 

--user has been kicked.
login_pack[login_msg_id.user_kick] = function(buf)
     facade:sendNotification(Common.LOGIN_GAME_SERVER_RSP, body.desc)
end 
--################### login game server callbacks end #################


--################### login gate callbacks begin #################
--login gate ok
gate_pack[gate_msg_id.user_login_ok] = function(buf)
    local body = gate_sproto:decode("user_login_ok",buf)
	agent_service_id = body.agent_service

	-- register response of gamehall
    ClientConn.RegisterRspPack(agent_service_id, agent_pack)
    m_bIsOnline = true 
    m_PlayerJoinedGame = body.hall_service
    LoginProxy:StartHeart()
	Log("user login gate ok " .. agent_service_id .. " game_hall_service" .. tostring(body.hall_service))
    m_bNeedSendHeart = true 
    userInfo.ip_address = body.ipaddr or ""
	LoginProxy:QueryHallList()
end 

--failed to login gate
gate_pack[gate_msg_id.user_login_fail] = function(buf)
    local body = gate_sproto:decode("user_login_fail",buf)
    facade:sendNotification(Common.LOGIN_GATE_SERVER_RSP, {errorcode = EGameErrorCode.EGE_LoginFailed, desc = body.desc})
end 

--login out gate ok
gate_pack[gate_msg_id.user_logout_ok] = function(buf)
    m_bIsOnline = false
    facade:sendNotification(Common.LOGOUT_RSP, {errorcode = EGameErrorCode.EGE_Success, desc = ""})
end 

--loginout gate faliure
gate_pack[gate_msg_id.user_logout_fail] = function(buf)
    local body = gate_sproto:decode("user_logout_fail",buf)
    facade:sendNotification(Common.LOGOUT_RSP, {errorcode = EGameErrorCode.EGE_LogoutFail, desc = body.desc})
end 

--user was kicked 
gate_pack[gate_msg_id.user_kick] = function(buf)
    local body = gate_sproto:decode("user_kick", buf)
    m_bIsOnline = false 
    facade:sendNotification(Common.PLAYER_WAS_KICKED, body.desc)
end 

gate_pack[gate_msg_id.ping] = function(buf)
    local body = gate_sproto:decode("ping", buf)
    m_bReceivedHeart = true
end 

agent_pack[agent_msg_id.ack_update_gps] = function(buf)
    local body = common_sproto:decode("error", buf)
    if body.code ~= EGameErrorCode.EGE_Success then 
        userInfo.latitude = 0
        userInfo.longitude = 0 
    end 
    facade:sendNotification(Common.UPLOAD_GPS_LOCATION_RSP, {errorcode=body.code, desc=body.desc})
end 
--################## login gate callbacks end ##############

--################## hall callbacks begin ##############
 
local m_HallCallBacks = {}
local m_GameRecords = {}

function LoginProxy:QueryGameRecords(hall_service)
    --facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
    if m_HallCallBacks[hall_service] == nil then 
        local t = {}
        m_HallCallBacks[hall_service] = t 
        m_GameRecords[hall_service] = {}
        t.pack = {}
        t.pack[hall_msg_id.your_play_records] = function(buf)
            local body = hall_sproto:decode("your_play_records", buf)
            if body.play_records ~= nil then 
                if m_GameRecords[hall_service] ~= nil then 
                    for _,sv in ipairs(m_GameRecords[hall_service]) do 
                        m_GameRecords[hall_service][_] = nil 
                    end 
                    m_GameRecords[hall_service] = {}
                end 
                local record = nil 
                for k,v in pairs(body.play_records) do 
                    if v then 
						--decode brief 
						local tmp_brief_info 
                        if v.brief then 
							tmp_brief_info = hall_sproto:decode("game_brief",v.brief)
                        end
                        local m_GameType = nil 
                        local hall_type = LoginProxy:GetHallType(hall_service)
                        local games = luaTool:GetAllGamesInfos()
                        if games ~= nil then 
                            for k,v in ipairs(games) do 
                                if v then 
                                    if v:GetHallType() == hall_type then 
                                        m_GameType = v:GetGameType()
                                        break
                                    end 
                                end 
                            end 
                        end 

                        --covert its time str to number
                        local tmp_time = {} 
                        local time_num = 0
                        for _k,_v in string.gmatch(v.record_time, "%d+") do
                            table.insert( tmp_time, tonumber(_k))
                        end
                        if tmp_time then 
                            time_num = os.time({year=tmp_time[1], month=tmp_time[2], day=tmp_time[3],hour=tmp_time[4],min=tmp_time[5], sec=tmp_time[6]})
                        end 
                        record={
                                record_id = v.record_id,
                                record_time = v.record_time,
                                owner = v.owner,
                                roomId = v.private_key,
                                version = v.version,
                                game_score_infos = tmp_brief_info.game_score_infos,
                                roundInfos = {roomId = v.private_key, round_score_infos = tmp_brief_info.round_score_infos, game_type = m_GameType, record_id = v.record_id, service_id = hall_service, rules = tmp_brief_info.game_rules},
                                service_id = hall_service,
                                game_type = m_GameType,
                                record_time_num = time_num
                                
                              }
                        table.insert(m_GameRecords[hall_service], record)
                    end 

                    --now sort the table 
                    table.sort( m_GameRecords[hall_service], function(left, right)
                        return left.record_time_num >= right.record_time_num
                    end)
                end 
            end 
            facade:sendNotification(Common.GET_RECORDS_OF_GAMES_RSP)
            --facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        end --end for 	t.pack[hall_msg_id.your_play_records	
		
		t.pack[hall_msg_id.your_play_record_list] = function(buf)
			  local body = hall_sproto:decode("your_play_record_list", buf)
			  if body.record_list then 
					local tmp_record_id_list = {}
					for i,v in ipairs(body.record_list) do 
						table.insert(tmp_record_id_list,v)
					end	
						
					self_record_list[hall_service]	=tmp_record_id_list 
					
                    local tmp_req_body =  hall_sproto:encode("req_get_play_records", {record_list = tmp_record_id_list})
                    --luaTool:Dump(tmp_record_id_list)
					ClientConn.SendMessage(
						hall_service,
						hall_msg_id.req_get_play_records,
						tmp_req_body
                    )	
                   -- facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)					
			  end
		end--end for func t.pack[hall_msg_id.your_play_record_list]
           

        m_HallCallBacks[hall_service] = t 
    end 
	
	

    ClientConn.RegisterRspPack(hall_service, m_HallCallBacks[hall_service].pack)

    ClientConn.SendMessage(
        hall_service,
        hall_msg_id.req_get_play_record_list,
        nil
    )
end 

function LoginProxy:RemoveRecordCallBacks()
    if m_HallCallBacks then 
        for k,v in pairs(m_HallCallBacks) do 
            ClientConn.RemoveRspPack(k)
        end 
    end 
end

--################## hall callbacks end ##############


--################# game hall response begin ##############
agent_pack[agent_msg_id.user_info] = function(buf)
    local body = agent_sproto:decode("user_info", buf)
    if body ~= nil then 
        userInfo.user_name = body.user_name 
        userInfo.user_id=body.user_id
        userInfo.room_card=body.room_card
        userInfo.game_money=body.money
        if body.head_img ~= nil and body.head_img ~= "" then 
            userInfo.head_img =  body.head_img
        else 
            userInfo.head_img = "" 
        end
    end 
    facade:sendNotification(Common.LOGIN_GATE_SERVER_RSP, {errorcode = EGameErrorCode.EGE_Success, desc = ""})
end 

--s2c:: get hall list rsp
agent_pack[agent_msg_id.hall_list] = function(buf)
	local body = agent_sproto:decode("hall_list",buf)
    local tmp_hall = nil 
    if body.hall ~= nil then 
        for k,v in pairs(body.hall) do 
            tmp_hall = {}
            
            tmp_hall.hall_name = v.hall_name
            tmp_hall.hall_type = v.hall_type
            tmp_hall.hall_desc = v.hall_desc       
            tmp_hall.hall_version = v.hall_version
            tmp_hall.hall_service = v.hall_service
            tmp_hall.client_version = v.client_version
            tmp_hall.is_expired = v.is_expired
            tmp_hall.user_num = v.user_num

            Log("hall_name " .. v.hall_name .. " hall_service=" .. v.hall_service .. " type=" .. v.hall_type)
            table.insert(tb_halllist, tmp_hall)	   
        end
    end 
    LoginProxy:QueryUserInfo()
    
end 

agent_pack[agent_msg_id.ack_query_private_table] = function(buf)
    local body = agent_sproto:decode("ack_query_private_table", buf)
    facade:sendNotification(Common.PRE_JOIN_GAME_RSP, {roomId = body.private_key, hall_service_id = body.hall_service})
end 

--s2c:: query hall info
agent_pack[agent_msg_id.hall_info] = function(buf)
    local body = agent_sproto:decode("hall_info", buf)
    --[[ hall_service 0 : integer

    # 大厅名称
    hall_name 1 : string
    # 大厅类型
    hall_type 2 : string
    # 大厅说明
    hall_desc 3 : string
    # 大厅版本
    hall_version 4 : integer
    # 客户端最低版本
    client_version 5 : integer
    # 过期，即将关闭
    is_expired 6 : boolean
    # 在线人数
    user_num 7 : integer]]
end

--s2c:: pay result
agent_pack[agent_msg_id.ack_pay] = function ( )
    -- body
    --[[#玩家支付结果
.ack_pay {
    code        0  : boolean     #结果 0成功，其他失败
    desc        1  : string      #错误说明
    pay_type    2  : integer     #支付类型
    params      11 : integer     #支付参数
}]]
    local body = agent_sproto:decode("ack_pay", buf)
end
--################# game hall response end ################

--whether this game has been enabled
function LoginProxy:IsGameEnabled(game_type)
    if tb_halllist == nil then 
        return false
    end 

    if game_type == nil then 
        return false
    end 

    if type(game_type) ~= "number" then 
        return false
    end 

    
    for k,v in ipairs(tb_halllist) do 
        if v then 
            if v.game_type == game_type  and v.is_expired == false then 
                return true
            end 
        end 
    end 

    if game_type == EGameType.EGT_CDMaJiang then 
        return true
    end 

    return false
end 

--Get service id of game
function LoginProxy:GetHallServiceId(hall_type)
    local service_id = nil 
    if tb_halllist == nil then 
        return service_id
    end 

    if hall_type == nil then 
        return service_id
    end 

    for k,v in ipairs(tb_halllist) do 
        if v then 
            if v.hall_type == hall_type then       
                service_id = v.hall_service
                break
            end 
        end 
    end 

    return service_id
end 

function LoginProxy:GetHallType(hall_service)
    if hall_service == nil then 
        return nil 
    end 

    local type = nil 
    for k,v in ipairs(tb_halllist) do 
        if v then 
            if v.hall_service == hall_service then            
                type = v.hall_type
                break
            end 
        end 
    end 
    return type
end 

function LoginProxy:GetHallList()
	print ("get hall list  ,list length is :"..#tb_halllist)
	
    return tb_halllist
end 

function LoginProxy:HasJoinedGame()
    if m_PlayerJoinedGame == nil then 
        return false
    end 

    for k,v in ipairs(tb_halllist) do 
        if v.hall_service == m_PlayerJoinedGame then 
            return true 
        end 
    end
    return false 
end 

function LoginProxy:GetJoinedHall()
    return m_PlayerJoinedGame
end 

function LoginProxy:GetSelfInfo()
    return userInfo
end 

function LoginProxy:GetUserId()
    return userInfo.user_id
end 

function LoginProxy:GetUserName()
    return userInfo.user_name 
end 

function LoginProxy:GetUserIp()
    return userInfo.ip_address
end
function LoginProxy:GetHeadImage()
    return userInfo.head_img
end 

function LoginProxy:GetRoomCard()
    return userInfo.room_card
end 

function LoginProxy:IsOnline()
    return m_bIsOnline
end 

function LoginProxy:IsLoginGame()
    if userInfo == nil then 
        return false 
    end 

    if userInfo.user_id == nil then 
        return false 
    end 
    return true 
end 

function LoginProxy:GetGameRecords()
    local tb = {} 
    if m_GameRecords ~= nil then 
        for k,v in pairs(m_GameRecords) do 
            for _,sv in ipairs(v) do 
                table.insert(tb, sv)
            end 
        end 
    end 
    return tb 
end 

function LoginProxy:IsRenderWelcomeMsg()
    return m_RenderWelcomeMsg
end

function LoginProxy:DontRenderWelcome()
    m_RenderWelcomeMsg = false
end

function LoginProxy:ServiceName(service)
    if service == nil then 
        return ""
    end 

    if service == gate_service_id then 
        return "gate_service" 
    elseif service == agent_service_id then 
        return "agent_service"
    elseif service == SERVICE_ID_LOGIN then 
        return "login_service"
    end
    return "it should be game_service"
end
return LoginProxy