--[[
* GameProxy class of ....Game
*
* *GameProxy.proxyName
*   proxy name format: xxx.GAME_PROXY_NAME. MUST REPLACE IT.such as
*   GameProxy.proxyName = nn.GAME_PROXY_NAME
]]
local GameProxy = class('GameProxy', pm.Notifier)

GameProxy.proxyName = nn.GAME_PROXY_NAME

--log function reference
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

--load sproto ... etc
local sproto = depends("sproto.sproto")
local spx = depends("Common.lualib.spx")

local hall_msg_id = depends("network.msg_id.hall_msgid")
local game_msg_id = depends("network.msg_id.nn_tb_game_msgid")
local base_msg_id = depends("network.msg_id.table_base_msgid")

local hall_service_id = nil 
local game_service_id = nil

local protocolmanager = depends('Common.ProtocolManager')
local hall_sproto = protocolmanager.GetHallSproto()
local game_sproto = protocolmanager.GetGameSproto_NNTb()
local base_sproto = protocolmanager.GetBaseSproto()
local common_sproto = protocolmanager.GetCommonSproto()

local CONST_MAX_PLAYER = 6 
local CONST_MIN_PLAYER = 2 

local default_url_head = ""

--floor function
local floor = math.floor
--random function
local random = math.random
 
--mvc
local facade = nil

local GameType = 0

--hall callbacks
local hall_pack = {}

local bReqLeft = false 

--game callbacks
local game_pack = {} 

local m_bHasEnterHall = false

local m_privatekey = nil 
local m_GameRule = nil 
local self_seat_id = 1

local m_GameOverInfo = nil 

--whether play game record 
local m_bPlayGameRecord = false 

--当前播放录像的roundid
local m_RecordRoundId = 0

--constant value.
local self_real_seat_id = 1 

local m_currentOperation = EOperation.EO_Max
local m_RequestGameParam = nil 

--whether game is playing
local m_bGamePlaying = false

--save table info
local m_tableInfo = nil 

local m_GameMode = nil 

--save user cards ..  etc
local m_userGameInfo = nil 

--save player data. such as head_img_url .... coin ... etc
local m_PlayerInfo = nil 

local m_roundOverData = nil 

--cache current action info of user. not only self. 
local m_currentActionInfo = nil 

local m_chatMsg = nil 

local real_play_step = 1
local m_RecordStep = 1
local m_record_data_cache = {}

local play_record_delay_step =  0.5 * 1000 
local yield_delay = UnityEngine.Yield
local play_record_coroutine

--录像播放状态
local m_PlayRecordState = EPlayRecordState.ERS_Max
--播放录像流程
local m_RecordGameStep =  nn.ERecordGameStep.EGS_Idle

--record detail 
local m_RecordDetail = nil 
local m_bIsShuffle = false 
local m_tbGlobalNtf = nil 
local m_logicCor = nil 
local m_ExecutingCmd = nil 


local m_play_record_step_timer 

local bPopuping = false 
local counter = 0

local function GetSeatId(real_seat_id)
    for k,v in ipairs(m_PlayerInfo) do 
        if v and v.real_seat_id == real_seat_id then 
            return v.seat_id
        end 
    end 
    return nil
end

--real popup a command to execute
local function _PopupCmd()
    if m_GameMode == nil then 
        return 
    end 

    if m_GameMode:IsPlaying() == false then 
        return 
    end 
    if m_ExecutingCmd ~= nil or bPopuping == true then 
        --LogWarning("has command is executing " .. tostring(m_ExecutingCmd) .. "  " .. tostring(bPopuping))
        return 
    end 

    bPopuping = true 
    if m_tbGlobalNtf ~= nil and #m_tbGlobalNtf > 0 then 
        local param = m_tbGlobalNtf[1].param
        m_ExecutingCmd = m_tbGlobalNtf[1].command 
        if m_ExecutingCmd == nil then 
            LogError("popup a nil command")
            return 
        end 

       
        table.remove( m_tbGlobalNtf, 1)
        bPopuping = false 
        --[[if #m_tbGlobalNtf > 0 then 
            Log("send " ..m_ExecutingCmd  .." remain=" .. #m_tbGlobalNtf)
        end]]
        facade:sendNotification(m_ExecutingCmd, param)
    else 
        bPopuping = false 
        --LogError("there is not any command needs to be executed")
    end 
   
end

local function PushCmd(cmd, param)
    if cmd == nil or cmd == "" then 
        LogError("Failed to register command")
    end 
    local _cmd = {}
    _cmd.command = cmd 
    _cmd.param = param 
    table.insert(m_tbGlobalNtf, _cmd)
    _PopupCmd()
end 

local function ParseGameRule(rule)
    if rule == nil then 
        LogError("missing rule")
        return 
    end 

    local default_game_mode = GetGameConfig():GetDefaultGameRule()

    m_GameRule = m_GameRule or {}
    local param_type = ""
    local key = nil 
    for k,v in pairs(rule) do 
        if v then 
            key = v.name 
            if default_game_mode[key] ~= nil then 
                param_type = type(default_game_mode[key])
                if param_type == "number" then 
                    m_GameRule[key] = tonumber(v.value)  
                elseif param_type == "boolean" then 
                    local s = string.lower(v.value)
                    if s == "true" then 
                        m_GameRule[key] = true 
                    elseif s == "false" then 
                        m_GameRule[key] = false
                    end 
                else 
                    m_GameRule[key] = v.value
                end 
            end 
           
        end 
    end 
end 

function GameProxy:SetGameMode(gameMode)
    m_GameMode = gameMode
end
--public interface 
function GameProxy:PopupCmd()
    -- body
   
    m_ExecutingCmd = nil 
   -- counter = counter + 1
    _PopupCmd()
  
end

--get the proxy name
function GameProxy:getProxyName()
    return self.proxyName
end 

--set hall service id 
function GameProxy:SetHallServiceId(inHallServiceId)
    if inHallServiceId == nil or type(inHallServiceId) ~= "number" then 
        return 
    end 
    hall_service_id = inHallServiceId
end 

--called by mvc. Init the proxy in here.
function GameProxy:onRegister()
    --inital all data structer
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    m_PlayerInfo = {}
    m_GameMode = nil
    ClientConn.RegisterRspPack(hall_service_id, hall_pack)
    m_bHasEnterHall = false
    m_bGamePlaying = false
    m_tbGlobalNtf = {}
    m_tableInfo = {}
    m_chatMsg = ListObject()
    m_bPlayGameRecord = false 
end


--called by mvc. please free reference in here if needed
function GameProxy:onRemove()
    m_tableInfo = nil 
    facade = nil
    m_GameMode = nil 
    for k,v in pairs(m_PlayerInfo) do 
        m_PlayerInfo[k] = nil
    end 
    m_PlayerInfo = nil
    if game_service_id ~= nil then 
        ClientConn.RemoveRspPack(game_service_id)
    end 
 
    if hall_service_id ~= nil then 
        ClientConn.RemoveRspPack(hall_service_id)
    end 
    self_table_service_id = nil
    hall_service_id = nil
    m_bHasEnterHall = false
    m_bGamePlaying = false
    m_RecordDetail = nil 
    m_chatMsg = nil
    m_GameOverInfo = nil 
    m_roundOverData = nil 
    m_bPlayGameRecord = false 
    m_tbGlobalNtf = nil 
    m_ExecutingCmd = nil 
	
	if m_play_record_step_timer then 
		LuaTimer.Delete(m_play_record_step_timer)
	end
end

function GameProxy:IsEnterHall()
    return m_bHasEnterHall
end 

function GameProxy:ClearCacheParam()
    m_currentOperation = EOperation.EO_Max
    m_RequestGameParam = nil
end 

function GameProxy:IsJoinedGame()
    return game_service_id ~= nil 
end 

--============== private interface =======================
--c2s::enter hall
function GameProxy:EnterHall(param)
    m_currentOperation = param.operation
    m_RequestGameParam = param.param
    ClientConn.SendMessage(
	            hall_service_id, 
	            hall_msg_id.req_enter_hall,
                nil
    )
end 

--============== private interface end ====================

--===================== public interface ====================
--create game
--@param game settings
function GameProxy:CreateGame(param)
    if param == nil or type(param) ~= "table" then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY,"errorcode.invalidparam")
        return 
    end 

    local _arg = {}
    for k,v in pairs(param) do 
        _arg[#_arg + 1] = {name=tostring(k), value=tostring(v)}
    end 
    
    ClientConn.SendMessage(
                hall_service_id, 
                hall_msg_id.req_create_private_table,
                hall_sproto:encode("req_create_private_table", {rules=_arg})
    )
end 

--join game 
--@param order the password of room
function GameProxy:JoinGame(param)
    if param == nil then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY,"errorcode.invalidparam")
        return 
    end 

    local t = { private_key = tostring(param) }

    ClientConn.SendMessage(
                hall_service_id, 
                hall_msg_id.req_join_private_table,
                hall_sproto:encode("req_join_private_table", t)
    )
end 


function GameProxy:GetRecordDetail(recordId, roundId, rules)
    m_RecordRoundId = roundId
    if rules then 
        ParseGameRule(rules)
    end 

    --try to load from disk
    local string_record = luaTool:GetGameRecord(hall_service_id, recordId)
    if string_record == nil then 
		print("req play record data")
        ClientConn.SendMessage(
            hall_service_id,
            hall_msg_id.req_get_play_record_data,
            hall_sproto:encode("req_get_play_record_data", {record_id = recordId})
        )
    else 
		print("get cache data")
        hall_pack[hall_msg_id.your_play_record_data](string_record)
    end 
end 

--c2s::req online
function GameProxy:PlayerReqOnline()
    m_currentOperation = EOperation.EO_ReqOnline
    ClientConn.SendMessage(
                game_service_id, 
                base_msg_id.req_online,
                nil
    )

end 

--c2s::pull table info
function GameProxy:PullTableInfo(param)
    m_currentOperation = param
    ClientConn.SendMessage(
	            hall_service_id, 
	            hall_msg_id.get_table_info,
                nil
    )
end 

function GameProxy:LeaveHall()
    bReqLeft = true
    ClientConn.SendMessage(
                hall_service_id, 
                hall_msg_id.req_left_hall,
                nil
    )
end 

--c2s:: request dismiss game game 
function GameProxy:LeaveGame()
    --send left game req
    bReqLeft = true 
    ClientConn.SendMessage(
                game_service_id, 
                base_msg_id.req_left_table,
                nil
    )
end 

--c2s:: req dismiss table
function GameProxy:PlayerReqDismiss()
    print("player req dismiss")
    --send dismiss room req 
    ClientConn.SendMessage(
                game_service_id, 
                base_msg_id.req_dismiss_table,
                nil
    )
end 

--c2s:: agree dismiss table?
function GameProxy:VoteDismiss(param)
    ClientConn.SendMessage(
        game_service_id,
        base_msg_id.req_vote_dismiss_table,
        base_sproto:encode("req_vote_dismiss_table", {agree = param})
    )
end 
 
--c2s::player has ready for playing game
function GameProxy:PlayerReqReady()
    ClientConn.SendMessage(
                    game_service_id, 
                    game_msg_id.req_ready,
                    nil
    )
end 

--c2s::send chat msg
function  GameProxy:SendChat(chatType, msg)
-- bod
    local t = {chat_type = chatType, preset_text = tostring(self_seat_id), preset_image = "", user_text = msg}
    ClientConn.SendMessage(
        game_service_id, 
        base_msg_id.req_chat,
        base_sproto:encode("req_chat", t)
    )
end

--c2s:: player wants to start a new round
function GameProxy:PlayerReqStartRound()
    ClientConn.SendMessage(
	            game_service_id, 
	            game_msg_id.req_start_round,
                nil
    )
end 

--c2s:: player wants to start game
function GameProxy:PlayerReqStartGame()
    ClientConn.SendMessage(
	            game_service_id, 
	            game_msg_id.req_start_game,
                nil
    )
end 

local current_req_act = nil 
function GameProxy:PlayerReqAct(act, chip, target)
    local t = {act_type = act, act_chip = chip, target_seat_id = GetSeatId(target)}
    current_req_act = act 
    ClientConn.SendMessage(
        game_service_id,
        game_msg_id.req_user_act,
        game_sproto:encode("req_user_act", t)
    )
end 

--calculate relative seat
local function _CalculateRealSeatId(seat_id)
    --self is always in the first index
    local real_seat_id = nil 
    if self_seat_id == 1 then 
        real_seat_id =  seat_id
    elseif self_seat_id == seat_id then 
        real_seat_id = self_real_seat_id
    else 
        local final  = CONST_MAX_PLAYER - self_seat_id + 1 + seat_id 
        if final > CONST_MAX_PLAYER then 
            real_seat_id = final % CONST_MAX_PLAYER
        else 
            real_seat_id = final
        end 
    end 
    return real_seat_id
end 

local function CalculateRealSeatId()
    if m_PlayerInfo == nil then 
        return 
    end 

    for k,v in pairs(m_PlayerInfo) do 
        if v then 
           v.real_seat_id = _CalculateRealSeatId(v.seat_id)
        end 
    end 
end 

local function ParseUserInfo(users)
    m_userGameInfo = m_userGameInfo or {} 
    local over_result = {} 
    local t = nil 
    local player = nil 

    local tmp = nil 
    if users ~= nil  then 
        for k,v in pairs(users) do 
            if v then   
                player = m_PlayerInfo[v.seat_id] or {}
                player.seat_id = v.seat_id
                player.user_name = v.user_name 
                player.user_id = v.user_id 
                player.money = v.money
                player.room_card = v.room_card  
                player.ip_address = v.ipaddr
                player.gps_state = v.gps_state
                if v.gps_x == nil then 
                    if player.latitude == nil then 
                        player.latitude = 30.57265663147  +  math.random( 100000 , 10000000  ) * 0.00000001
                    end 
                else 
                    v.latitude = tonumber(v.gps_x)
                end 

                if v.gps_y == nil then 
                    if player.longitude == nil  then 
                        player.longitude = 104.06225585938  + math.random( 100000, 10000000 ) * 0.00000001
                    end 
                else 
                    player.longitude = tonumber(v.gps_y)
                end 
                
                player.head_img = v.head_img

                m_PlayerInfo[v.seat_id] = player

                t = m_userGameInfo[v.seat_id] 
                if t == nil then 
                    t = {}
                end 
                
                t.hand_cards = {}  
                if v.hand_cards ~= nil then  
                    for sk, sv in ipairs(v.hand_cards) do 
                        table.insert(t.hand_cards, sv)
                    end 
                end 			

                t.hand_card_num = v.hand_card_num or 0
                t.req_ready = v.req_ready or false -- 34 : boolean          #玩家是否发送准备好
                t.vote_ack = v.vote_ack or EVoteType.none
                t.niu_point = v.niu_point
                t.ex_niu_type = v.ex_niu_type --#额外牛牌型
                t.hand_cards_state = v.hand_cards_state
                t.chips = v.chips 
                t.round_score = v.round_score or 0-- 51 : integer          #本局积分
                t.total_score = v.total_score or 0 -- 52 : integer    #总积
                t.is_online = v.is_online -- 101 : boolean       #玩家是否在线
                t.game_state = v.game_state
                m_userGameInfo[v.seat_id] = t

                if m_tableInfo.state == nn.ETableState.game_over then 
                    tmp = {}
                    tmp.total_score = v.total_score
                    tmp.user_name = v.user_name
                    tmp.user_id = v.user_id
                    tmp.bIsOwner = v.user_id == m_tableInfo.owner
                    tmp.head_img = v.head_img	 
                    tmp.bIsSelf = v.seatId == self_seat_id
                    table.insert(over_result, tmp)
                end 
            end 
        end 
    end 

    if m_tableInfo.state == nn.ETableState.game_over then 
        m_GameOverInfo = over_result
    end 
end 

local function ParseTableInfo(tableInfo)
    m_tableInfo = m_tableInfo or {}
    m_tableInfo.owner = tableInfo.owner
    m_tableInfo.round = tableInfo.round
    m_tableInfo.state = tableInfo.state 
    m_tableInfo.private_key = tableInfo.private_key
    m_tableInfo.vote_dismiss_table_time = tableInfo.vote_dismiss_table_time / 100
    m_tableInfo.vote_dismiss_table_span = tableInfo.vote_dismiss_table_span / 100
    m_tableInfo.remain_act_time = tableInfo.remain_act_time
    m_tableInfo.vote_dismiss_table_starter = tableInfo.vote_dismiss_table_starter
    m_tableInfo.winner = tableInfo.winner
    m_tableInfo.vote_left_time = (tableInfo.vote_left_time or 0) / 100
    m_tableInfo.dices = tableInfo.dices
    m_tableInfo.turn_user = tableInfo.turn_user
    m_tableInfo.dealer = tableInfo.dealer
    m_tableInfo.act_timeout = math.floor(tableInfo.act_timeout or 100 / 100)
    
    if m_PlayerInfo == nil then 
        m_PlayerInfo = {}
    end 
    ParseGameRule(tableInfo.rules)
    ParseUserInfo(tableInfo.users)

    if m_tableInfo.vote_dismiss_table_starter > 0 then 
        m_tableInfo.vote_end_time = os.time() + m_tableInfo.vote_left_time
    end 
    CalculateRealSeatId()
end 

--===================== public interface end ================

--================= hall callbacks ======================
--sc2:: enter hall success callback
hall_pack[hall_msg_id.req_enter_hall_ok] = function(buf)
    m_bHasEnterHall = true
    facade:sendNotification(nn.PLAYER_ENTER_HALL_RSP, {errorcode=EGameErrorCode.EGE_Success, desc="", operation = m_currentOperation, param = m_RequestGameParam})
end 

--s2c:: enter hall failure callback
hall_pack[hall_msg_id.req_enter_hall_fail] = function(buf)
    local body = hall_sproto:decode("req_enter_hall_fail", buf)
    facade:sendNotification(Common.RENDER_MESSAGE_VALUE, body.desc)
    m_bHasEnterHall = false
end 

--sc2::pull table info
hall_pack[hall_msg_id.get_table_info_fail] = function(buf)
    local body = hall_sproto:decode("get_table_info_fail", buf)
    facade:sendNotification(nn.PLAYER_PULL_TABLE_INFO_RSP, {errorcode=EGameErrorCode.EGE_PullTableFail, desc=""})
end 

--s2c:: get table info ok rsp
hall_pack[hall_msg_id.your_table_info] = function(buf)
    local body = hall_sproto:decode("your_table_info", buf)

    game_service_id = body.table_service
    ClientConn.RegisterRspPack(game_service_id, game_pack)
    --save the game rules
    ParseGameRule(body.rules)
    m_privatekey = body.private_key
    --if operation is req online. so send pull table rsp command. we will do something in this command
    if m_currentOperation == EOperation.EO_ReqOnline or m_currentOperation == EOperation.EO_LeaveGame then 
        if game_service_id == nil or game_service_id == 0 or m_privatekey == nil or m_privatekey == 0 then 
            facade:sendNotification(nn.PLAYER_PULL_TABLE_INFO_RSP, {errorcode=EGameErrorCode.EGE_TableDismissed, desc="", operation = m_currentOperation})
        else 
            facade:sendNotification(nn.PLAYER_PULL_TABLE_INFO_RSP, {errorcode=EGameErrorCode.EGE_Success, desc="", operation = m_currentOperation})
        end 
    end 
end 

--s2c::successfully
hall_pack[hall_msg_id.you_enter_table] = function(buf)
   
    local body = hall_sproto:decode("you_enter_table", buf)
    Log("you enter table " .. body.table_service .. " " .. type(body.table_service))
    game_service_id = body.table_service
    ClientConn.RegisterRspPack(game_service_id, game_pack)
    ParseGameRule(body.rules)
    m_privatekey = body.private_key 

    --req online?
    facade:sendNotification(nn.PLAYER_CREATE_GAME_RSP, {errorcode=EGameErrorCode.EGE_Success, desc = ""})
end 

--s2c::left table ok
hall_pack[hall_msg_id.you_left_table] = function(buf)
    Log("you_left_table ")
    if m_tableInfo.state == nn.ETableState.dismissed or m_tableInfo.state == nn.ETableState.game_over then 
        if bReqLeft == true then 
            facade:sendNotification(nn.PLAYER_LEAVE_GAME_RSP, {errorcode=EGameErrorCode.EGE_Success, desc = ""})
        end 
    else 
        facade:sendNotification(nn.PLAYER_LEAVE_GAME_RSP, {errorcode=EGameErrorCode.EGE_Success, desc = ""})
    end 
end 

--create table ok callabck
hall_pack[hall_msg_id.req_create_private_table_ok] = function(buf)
    local body = hall_sproto:decode("req_create_private_table_ok", buf)
    --cache this information 
    ParseGameRule(body.rules)
    m_privatekey = body.private_key
end 

--create table faliure callback
hall_pack[hall_msg_id.req_create_private_table_fail] = function(buf)
     local body = hall_sproto:decode("req_create_private_table_fail", buf)
     facade:sendNotification(nn.PLAYER_CREATE_GAME_RSP, {errorcode=EGameErrorCode.EGE_CreateGameFail, desc = body.desc})
end 

--req join game failure
hall_pack[hall_msg_id.req_join_private_table_fail] = function(buf)
    local body = hall_sproto:decode("req_join_private_table_fail", buf)
    facade:sendNotification(nn.PLAYER_JOIN_GAME_RSP,{errorcode=EGameErrorCode.EGE_JoinGameFail, desc=body.desc})
end 

--s2c:: req left hall fail
hall_pack[hall_msg_id.req_left_hall_fail] = function(buf)
    local body = hall_sproto:decode("req_left_hall_fail", buf)
    
    facade:sendNotification(nn.PLAYER_LEAVE_HALL_RSP, {errorcode=EGameErrorCode.EGE_LeaveGameFail, desc=body.desc})
end 

--s2c:: req left hall success
hall_pack[hall_msg_id.req_left_hall_ok] = function(buf)
    facade:sendNotification(nn.PLAYER_LEAVE_HALL_RSP, {errorcode=EGameErrorCode.EGE_Success, desc=""})
end 

function GameProxy:ParseRecordData(self_user_id)
    if m_RecordDetail == nil then 
        return 
    end 

    m_PlayerInfo = {}
    m_tableInfo = {} 
    m_userGameInfo = {}

    m_privatekey = m_RecordDetail.private_key
    m_tableInfo.round = m_RecordRoundId

    local info = nil 
    local round = m_RecordDetail.round_records[m_RecordRoundId]
    if round ~= nil then 
        m_tableInfo.dealer = round.round_start_state_record.dealer
        m_tableInfo.dices = round.round_start_state_record.dices 
        m_tableInfo.table_cards = round.round_start_state_record.table_cards
        m_tableInfo.table_card_num = #m_tableInfo.table_cards 

        if round.round_start_state_record.user_start_play_infos then 
            for k,v in pairs(round.round_start_state_record.user_start_play_infos) do 
                if v then 
                    info = {} 
                    info.user_id = v.user_id 
                    info.user_name = v.user_name 
                    info.seat_id = v.seat_id 
                    info.hand_cards = v.hand_cards 
                    info.hand_card_num = #info.hand_cards
                    m_userGameInfo[v.seat_id] = info
                end 
            end 
        else 
            LogError("user start play infos is nil ")
        end 
		
		if round. round_end_record   then
			local body = round. round_end_record
			local _result = {}
			if body.users ~= nil then 
				local seatId = nil 
				for k,v in ipairs(body.users) do 
					seatId = v.seat_id
					_result[seatId] = {}     
					_result[seatId].money = v.money
					_result[seatId].room_card = v.room_card
					_result[seatId].hand_cards = v.hand_cards
					_result[seatId].hu_infos = v.hu_infos
					_result[seatId].score = v.score
					_result[seatId].total_score = v.total_score
					_result[seatId].bIsSelf = seatId == self_seat_id
					m_userGameInfo[seatId].score = v.score
					m_userGameInfo[seatId].total_score =  v.total_score
					m_userGameInfo[seatId].req_ready = false
					m_userGameInfo[seatId].hand_card_num = 0
					m_userGameInfo[seatId].req_start_round = false
				end 
			end 
			m_tableInfo.vote_dismiss_table_starter = 0
			m_roundOverData = _result
		end	
    end 

    for k,v in pairs(m_RecordDetail.user_record_infos) do 
        if v then 
            info = {}
            if self_user_id == v.user_id then 
                self_seat_id = tonumber(v.seat_id)
            end 
            info.user_id = v.user_id 
            info.user_name = v.user_name 
            info.head_img = v.head_img or default_url_head
            info.seat_id = tonumber(v.seat_id)
            info.total_score = tonumber(v.total_score)
			info.head_img = v.head_img
            m_userGameInfo[info.seat_id].total_score = info.total_score
            m_PlayerInfo[info.seat_id] = info
        end 
    end 
    CalculateRealSeatId()
end 

--s2c:: get record detail 
hall_pack[hall_msg_id.your_play_record_data] = function(buf)
    local body = hall_sproto:decode("your_play_record_data", buf)
    m_RecordDetail = nil 
    local errcode = EGameErrorCode.EGE_Success 
    m_bPlayGameRecord = true 

    if body.play_data == nil or body.play_data == "" then 
        errcode = EGameErrorCode.EGE_GetRecordDetailFail
        m_bPlayGameRecord = false 
    else 
        m_RecordDetail = game_sproto:decode("game_record", body.play_data)
        luaTool:SaveGameRecord(hall_service_id, body.record_id, buf) 
    end 
    facade:sendNotification(Common.GET_RECORD_DETAIL_RSP, {errorcode = errcode})
end 
--================= hall callbacks end ==================


--================= game callbacks ======================
local function CleanUserInfo(seat_id)
    if seat_id == nil or seat_id <= 0 then 
        return 
    end 

    local info = m_userGameInfo[seat_id] or {}
    info.hand_card_num = 0
    info.hand_cards = {}
    info.vote_ack = EVoteType.none

    if info.allow_acts ~= nil then 
        for sk, sv in ipairs(info.allow_acts) do 
            info.allow_acts[sk] = nil
        end 
    end 

    info.hand_card_num = 0
    info.req_ready = true
end
--s2c:: notification client who has ready
game_pack[game_msg_id.user_ready] = function(buf)
    local body = game_sproto:decode("user_ready", buf)
    if body.seat_id == self_seat_id then 
        for k,v in ipairs(m_PlayerInfo) do 
            CleanUserInfo(v.seat_id)
        end 
    end 
    m_bGamePlaying = true 
    PushCmd(Common.NTF_PLAYER_READY, {real_seat_id = m_PlayerInfo[body.seat_id].real_seat_id})
end 
    
--s2d:: game started 
game_pack[game_msg_id.game_start] = function(buf)
    --local body = game_sproto:decode("game_start", buf)
    m_bGamePlaying = true 
    m_tableInfo.state = nn.ETableState.game_start
    PushCmd(Common.NTF_GAME_START, nil)
end 

 -- s2c 广播桌子切换状态到回合开始,body round_start
game_pack[game_msg_id.round_start] = function(buf)
    local body = game_sproto:decode("round_start", buf)
    m_tableInfo.round = body.round
    m_tbGlobalNtf = {}
    m_tableInfo.state = nn.ETableState.round_start
    PushCmd(Common.NTF_ROUND_START, {round = body.round} )
end 

-- s2c 广播桌子切换状态到发牌 body begin_deal
game_pack[game_msg_id.begin_deal] = function(buf)
    local body = game_sproto:decode("begin_deal", buf)
    m_bIsShuffle = true
    m_bGamePlaying = true 
 
    m_tableInfo.state = nn.ETableState.deal
    
 
    local seat_id = nil 
    
    --parse user cards information
    local tb_cardsInfo = {}

    local m_dealerSeatId = nil 
    m_tableInfo.dealer = body.dealer

    if body.users ~= nil then 
        for k,v in pairs(body.users) do 
            seat_id = v.seat_id
            if m_userGameInfo[seat_id] == nil then 
                m_userGameInfo[seat_id] = {}
            end 
            local t = m_userGameInfo[seat_id]
            if seat_id == self_seat_id then       
                if t.hand_cards ~= nil then 
                    while #t.hand_cards > 0 do 
                        table.remove(t.hand_cards, 1)
                    end
                else 
                    t.hand_cards = {} 
                end 

                if v.hand_cards ~= nil then 
                    for _,card in ipairs(v.hand_cards) do 
                        table.insert(t.hand_cards, card)
                    end 
                else 
                    t.hand_cards = nil 
                end       
            end 
            t.hand_card_num = v.hand_card_num
            t.req_ready = false
            m_userGameInfo[seat_id] = t

            local tmp = m_PlayerInfo[seat_id].real_seat_id
            
            tb_cardsInfo[tmp] = {real_seat_id = tmp, hand_cards = t.hand_cards, card_num = t.hand_card_num}
        end 
    end 
    local tb_final = {}
    if body.dealer then 

        m_dealerSeatId = m_PlayerInfo[body.dealer].real_seat_id
        
        
        for i=m_dealerSeatId, 4 do 
            table.insert(tb_final, tb_cardsInfo[i])
        end 

        for i=1, m_dealerSeatId - 1 do 
            table.insert(tb_final, tb_cardsInfo[i])
        end 
    else
        tb_final = tb_cardsInfo
    end 
    --@todo::
    PushCmd(Common.NTF_SHUFFLE, {cards_info = tb_final, remain_cards = m_remaincards})
end 

-- s2c 广播桌子切换状态到游戏 body none
game_pack[game_msg_id.begin_play] = function(buf)
     m_tableInfo.state = nn.ETableState.play
     local owner_real_seat_id = self_real_seat_id
     for k,v in ipairs(m_PlayerInfo) do 
        if v.seat_id == m_tableInfo.dealer then 
            owner_real_seat_id = v.real_seat_id 
            break
        end 
    end 
     PushCmd(Common.NTF_PLAY_GAME, {real_seat_id = owner_real_seat_id, bIsSelf = GameProxy:IsOwner(), remain_time = m_tableInfo.act_timeout})
end 

-- s2c 广播桌子切换状态到 body round_over
game_pack[game_msg_id.round_over] = function(buf)
    local body = game_sproto:decode("round_over", buf)
    local _result = {}
    if body.users ~= nil then 
        local seatId = nil 
        for k,v in ipairs(body.users) do 
            seatId = v.seat_id
            _result[seatId] = {}     
            _result[seatId].money = v.money
            _result[seatId].hand_cards = v.hand_cards
            _result[seatId].score = v.score
            _result[seatId].total_score = v.total_score
            _result[seatId].bIsSelf = seatId == self_seat_id
            m_userGameInfo[seatId].score = v.score
            m_userGameInfo[seatId].total_score =  v.total_score
            m_userGameInfo[seatId].req_ready = false
            m_userGameInfo[seatId].hand_card_num = #v.hand_cards
            m_userGameInfo[seatId].hand_cards = v.hand_cards
            m_userGameInfo[seatId].req_start_round = false
        end 
    end 
 
    m_tableInfo.vote_dismiss_table_starter = 0
    m_roundOverData = _result
    m_tableInfo.state = nn.ETableState.round_over
    if m_tableInfo.round >= GameProxy:GetMaxRound() then 
        return 
    end 
    PushCmd(Common.NTF_ROUND_OVER,  m_roundOverData ) 
end 

-- s2c 广播游戏结束，庄家输光，超过设置的局数 body game_over
game_pack[game_msg_id.game_over] = function(buf)
    local body = game_sproto:decode("game_over", buf)
    local _result = {}
    if body.users ~= nil then 
        local seatId = nil 
        for k,v in ipairs(body.users) do 
            seatId = v.seat_id
            _result[seatId] = {}     
            _result[seatId].total_score = v.total_score
            _result[seatId].user_name = m_PlayerInfo[seatId].user_name
            _result[seatId].user_id = m_PlayerInfo[seatId].user_id
            _result[seatId].bIsOwner = m_PlayerInfo[seatId].user_id == m_tableInfo.owner
            _result[seatId].head_img = m_PlayerInfo[seatId].head_img	 
            _result[seatId].bIsSelf = seatId == self_seat_id
        end 
    end 
    m_GameOverInfo = _result
    m_bGamePlaying = false
    m_tableInfo.state = nn.ETableState.game_over
    if body.is_dismissed == true then 
        m_tableInfo.state = nn.ETableState.dismissed
        PushCmd(Common.NTF_GAME_OVER,{dismissed = body.is_dismissed})
    else 
        PushCmd(Common.NTF_ROUND_OVER, m_roundOverData )  
    end 
end 

--s2c:: ready failure
game_pack[game_msg_id.req_ready_fail] = function(buf)
    local body = game_sproto:decode("req_ready_fail", buf)
   
    facade:sendNotification(nn.PLAYER_REQ_READY_RSP,{errorcode = body.code, desc = body.desc})
end 

--s2c:: start round fail
game_pack[game_msg_id.req_start_round_fail] = function(buf)
    local body = game_sproto:decode("req_start_round_fail", buf)
    facade:sendNotification(nn.PLAYER_REQ_START_ROUND_RSP, {errorcode = body.code})
end 

--s2c:: ntf who has request start round
game_pack[game_msg_id.user_start_round] = function(buf)
    local body = game_sproto:decode("user_start_round", buf)
    if m_userGameInfo[body.seat_id] ~= nil then 
        m_userGameInfo[body.seat_id].req_start_round = true 
    end 
    m_bGamePlaying = true 
    if body.seat_id == self_seat_id then 
        for k,v in ipairs(m_PlayerInfo) do 
            CleanUserInfo(v.seat_id)
        end 
    end 
    facade:sendNotification(Common.NTF_PLAYER_START_ROUND, {real_seat_id = m_PlayerInfo[body.seat_id].real_seat_id, bIsSelf = body.seat_id == self_seat_id})
end 

--s2c:: request start game failure
game_pack[game_msg_id.req_start_game_fail] = function(buf)
    local body = game_sproto:decode("req_start_game_fail", buf)
    facade:sendNotification(nn.PLAYER_REQ_START_GAME_RSP, {errorcode = body.code})
end 

--s2c:: ntf who has request start game
game_pack[game_msg_id.user_start_game] = function(buf)
    local body = game_sproto:decode("user_start_game", buf)
    facade:sendNotification(nn.NTF_PLAYER_START_GAME, {seat_id = body.seat_id})
end 

--s2c:: request leave game failure
game_pack[game_msg_id.req_quit_game_fail] = function(buf)
    local body = game_sproto:decode("req_quit_game_fail", buf)
    facade:sendNotification(nn.PLAYER_LEAVE_GAME_RSP, {errorcode=EGameErrorCode.EGE_LeaveGameFail, desc=body.desc})
end 

--s2c:: ntf leave game
game_pack[game_msg_id.user_quit_game] = function(buf)
    local body = game_sproto:decode("user_quit_game", buf)
    local seat_id = body.seat_id
    if self_seat_id ~= nil and body.seat_id == self_seat_id then 
        facade:sendNotification(facade:sendNotification(nn.PLAYER_LEAVE_GAME_RSP, {errorcode=EGameErrorCode.EGE_Success, desc=""}))
    else  
        facade:sendNotification(Common.NTF_PLAYER_LEFT_GAME, {seat_id = body.seat_id})
    end 
end 

--s2c:: ntf table info
game_pack[game_msg_id.table_info] = function(buf)
    local body = game_sproto:decode("table_info", buf)
    ParseTableInfo(body)
    facade:sendNotification(nn.PLAYER_REQ_ONLINE_RSP,{errorcode=EGameErrorCode.EGE_Success, desc = ""})
end 

--s2c:: req left table rsp
game_pack[base_msg_id.ack_left_table] = function(buf)
    local body = common_sproto:decode("error", buf)
    bReqLeft = false 
    print("left table fail")
    facade:sendNotification(nn.PLAYER_LEAVE_GAME_RSP, {errorcode=body.code, desc = body.desc})
end 

--s2c:: ntf user enter table
game_pack[base_msg_id.user_enter_table] = function(buf)

    local body = base_sproto:decode("user_enter_table", buf)
    if m_PlayerInfo == nil then 
        m_PlayerInfo = {}
    end 
    local info = m_PlayerInfo[body.seat_id] or {}

    info.seat_id = body.seat_id
    info.user_name = body.user_name
    info.room_card = body.room_card
    info.user_id = body.user_id
    info.money = body.money 
    info.head_img = body.head_img 
    info.ip_address = body.ipaddr  
    if body.gps_x == nil then 
        info.latitude = 0
    else 
        info.latitude = tonumber(body.gps_x)
    end 
   
    if body.gps_y == nil then 
        info.longitude = 0
    else 
        info.longitude = tonumber(body.gps_y)
    end 
    info.real_seat_id = _CalculateRealSeatId(info.seat_id); 
    m_PlayerInfo[body.seat_id] = info 
    if m_userGameInfo[body.seat_id] == nil then 
        local tmp = {}
        tmp.score = 0
        tmp.total_score = 0
        tmp.req_ready = false 
        m_userGameInfo[body.seat_id] = tmp  
    end 
   
      
    facade:sendNotification(Common.NTF_PLAYER_JOINED_GAME, {real_seat_id = info.real_seat_id})
end 

--s2c::ntf user left table
game_pack[base_msg_id.user_left_table] = function(buf)
    local body = base_sproto:decode("user_left_table", buf)
    local seatId = body.seat_id 

    if m_tableInfo.state == nn.ETableState.dismissed then 
        return 
    end 

    if m_userGameInfo[seatId] ~= nil then
        --@todo free more info 
        m_userGameInfo[seatId] = nil 
    end 

    local m_realSeatId = nil 
    if m_PlayerInfo[body.seat_id] ~= nil then 
        m_realSeatId = m_PlayerInfo[body.seat_id].real_seat_id
    end 

    --clear cached message 
    m_PlayerInfo[body.seat_id] = nil 
    facade:sendNotification(Common.NTF_PLAYER_LEFT_GAME, {real_seat_id = m_realSeatId})

end 

--s2c::ntf user table has been dismissed
game_pack[base_msg_id.dismiss_table] = function(buf)
    --退出游戏
    Log("dismiss_table")
    facade:sendNotification(nn.PLAYER_LEAVE_GAME_RSP, {errorcode=EGameErrorCode.EGE_Success,desc = ""})
end 

--s2c:: ntf user reconnected 
game_pack[base_msg_id.user_online] = function(buf)
    local body = base_sproto:decode("user_online", buf)
    local seatId = body.seat_id
end 

--s2c:: ntf user offline
game_pack[base_msg_id.user_offline] = function(buf)
    local body = base_sproto:decode("user_offline", buf)
    local seatId = body.seat_id
end 

--s2c:: req dismiss table rsp
game_pack[base_msg_id.ack_dismiss_table] = function(buf)
    local body = common_sproto:decode("error", buf)
    facade:sendNotification(Common.PLAYER_DISMISS_TABLE_RSP, {errorcode = body.code, desc = body.desc})
end 

--s2d:: ntf user start vote
game_pack[base_msg_id.begin_vote_dismiss_table] = function(buf)
    local body = base_sproto:decode("begin_vote_dismiss_table", buf)
    bReqLeft = false
    local user_name = ""
    for k,v in ipairs(m_userGameInfo) do 
        if v then 
            v.vote_ack = EVoteType.none 
        end 
    end 

    if m_PlayerInfo[body.seat_id] ~= nil then 
        m_tableInfo.vote_dismiss_table_starter = body.seat_id
        user_name = m_PlayerInfo[body.seat_id].user_name 
        m_userGameInfo[body.seat_id].vote_ack = EVoteType.agree
    end 
    m_tableInfo.vote_dismiss_table_starter = body.seat_id
    m_tableInfo.vote_end_time = os.time() + m_tableInfo.vote_dismiss_table_time 
    PushCmd(Common.NTF_PLAYER_START_VOTE, {isSelf = body.seat_id == self_seat_id})
end 

--s2c:: ntf somebody has voted
game_pack[base_msg_id.user_vote_dismiss_table] = function(buf)
    local body = base_sproto:decode("user_vote_dismiss_table", buf)
    if body.agree == true then     
        m_userGameInfo[body.seat_id].vote_ack = EVoteType.agree
    else
        m_userGameInfo[body.seat_id].vote_ack = EVoteType.refuse
    end 
    if body.seat_id == self_seat_id then 
        PushCmd(Common.PLAYER_VOTE_DISMISS_RSP, {errorcode = EGameErrorCode.EGE_Success, desc = body.desc})
    elseif m_userGameInfo[self_seat_id].vote_ack ~= nil and m_userGameInfo[self_seat_id].vote_ack ~= EVoteType.none then 
        PushCmd(Common.NTF_PLAYER_VOTED, {vote_ack = m_userGameInfo[body.seat_id].vote_ack, seat_id = body.seat_id })
    end 
end 


--s2c::req_vote_dismiss_table_fail
game_pack[base_msg_id.req_vote_dismiss_table_fail] = function(buf)
    local body = common_sproto:decode("error", buf)
    m_tableInfo.vote_end_time = os.time()
    PushCmd(Common.PLAYER_VOTE_DISMISS_RSP, {errorcode = body.code, desc = body.desc})
end 

--s2c:: ntf vote over. 
game_pack[base_msg_id.end_vote_dismiss_table] = function(buf)
    local body = base_sproto:decode("end_vote_dismiss_table", buf)
    local m_bIsDismissed = body.is_dismiss
    m_tableInfo.vote_dismiss_table_starter = 0
    if m_bIsDismissed == true then 
        m_tableInfo.state = nn.ETableState.dismissed 
        --clear all command in quene, ensure we can open the game over menu
        LogWarning("room dismissed. clean up all command in buffer.")
        m_ExecutingCmd = nil
        m_tbGlobalNtf = {}
    end 

    local vote_param = nil 
    local not_vote_user = {}
    for k,v in ipairs(m_userGameInfo) do 
        if v and v.vote_ack == EVoteType.none then 
            v.vote_ack = EVoteType.agree 
            if k == self_seat_id then 
                vote_param = {errorcode = EGameErrorCode.EGE_Success, desc = body.desc}
            else 
                table.insert(not_vote_user, v.seat_id)
            end    
        end 
    end 

    local uimanager =  UIManager.getInstance()
    local bSendCmd =  uimanager:HasOpened(Common.MENU_VOTE_RESULT) == true

    if bSendCmd == true then 
        if vote_param == nil then      
            for _k,_v in ipairs(not_vote_user) do 
                facade:sendNotification(Common.NTF_PLAYER_VOTED, {vote_ack = EVoteType.agree , seat_id = _v })
            end 
        end     
    end
    PushCmd(Common.NTF_PLAYER_STOP_VOTE, m_bIsDismissed)
end 

--s2c:: table has been dismissed
game_pack[base_msg_id.dismiss_table] = function(buf)
    local body = base_sproto:decode("dismiss_table", buf)
    --facade:sendNotification(Common.RENDER_MESSAGE_VALUE,body.desc)
end 

--s2d::req onlie rsp
game_pack[base_msg_id.req_online_ok] = function(buf)
    local body = base_sproto:decode("req_online_ok", buf)
    self_seat_id = body.seat_id
    --facade:sendNotification(nn.PLAYER_REQ_ONLINE_RSP,{errorcode=EGameErrorCode.EGE_Success, desc = ""})
end 

--s2d::req onlie rsp
game_pack[base_msg_id.req_online_fail] = function(buf)
    local body = common_sproto:decode("error", buf)
    facade:sendNotification(nn.PLAYER_REQ_ONLINE_RSP,{errorcode=body.code, desc = body.desc})
end 

game_pack[base_msg_id.req_chat_fail] = function(buf)
    -- body
    local body = common_sproto:decode("error", buf)
    facade:sendNotification(Common.SEND_CHAT_RSP,{errorcode=body.code, desc = body.desc})
end

game_pack[base_msg_id.user_chat] = function(buf)
    local body = base_sproto:decode("user_chat", buf)
    local name = ""
    for k,v in ipairs(m_PlayerInfo) do 
        if v.seat_id == body.seat_id then 
            name = v.user_name 
        end 
    end 
    local m_msg = {type = body.chat_type, preset_msg = body.preset_text, preset_image = body.preset_image, msg = body.user_text, username = name}
    m_chatMsg:Add(m_msg)
    facade:sendNotification(Common.NTF_PLAYER_CHAT,{bIsSelf = self_seat_id == body.seat_id, msg = m_msg , real_seat_id = m_PlayerInfo[body.seat_id].real_seat_id})
end
 
--================= game callbacks end ==================



--==================public interface for query game data=========================
function GameProxy:GetRoomId()
    return m_privatekey
end 

function GameProxy:GetGameRule()
    return m_GameRule
end 

function GameProxy:GetAllPlayerInfo()
    return m_PlayerInfo
end 

function GameProxy:GetRealSeatId(seat_id)
    if m_PlayerInfo[seat_id] ~= nil then 
       return m_PlayerInfo[seat_id].real_seat_id
    end 
    return nil 
end 

--get player cards 
--@param seat_id. the index of table seat
function GameProxy:GetPlayerInfo(seat_id)
    return m_PlayerInfo[seat_id]
end 

--get player info
--@param real_seat_id. the index of tabel seat
function GameProxy:GetPlayerInfoWithRealSeatId(real_seat_id)
    for k,v in ipairs(m_PlayerInfo) do 
        if v and v.real_seat_id == real_seat_id then 
            return v 
        end 
    end 
    return nil
end 

--get player cards 
--@param real_seat_id. the index of tabel seat
function GameProxy:GetPlayerCards(real_seat_id)
    local seat_id = GetSeatId(real_seat_id)
    if seat_id == nil then 
        return nil 
    end  

    if m_userGameInfo[seat_id] ~= nil then 
        return m_userGameInfo[seat_id].hand_cards
    end 

    return nil 
end 

function GameProxy:GetPlayerGameInfo(real_seat_id)
    local seat_id = GetSeatId(real_seat_id)
    
    if seat_id and m_userGameInfo[seat_id] ~= nil then 
        return m_userGameInfo[seat_id]
    end 
    return nil
end 

function GameProxy:GetUserVoteResult(seat_id)
    if m_userGameInfo[seat_id] then 
        return m_userGameInfo[seat_id].vote_ack
    end 

    return EVoteType.none
end

function GameProxy:IsSelf(seat_id)
    return self_seat_id == seat_id
end 

function GameProxy:IsSelfRealSeatId(real_seat_id)
    return self_real_seat_id == real_seat_id
end 

function GameProxy:GetSelfRealSeatId()
    return self_real_seat_id
end

function GameProxy:GetSelfVoteState()
    return self:GetUserVoteResult(self_seat_id)
end
 
function GameProxy:GetRemainCards()
    return m_tableInfo.table_card_num
end 
 
function GameProxy:GetMaxRound()
    if m_GameRule == nil then 
        return  5
    end 
    return tonumber(m_GameRule["max_round"]) or 5
end 

function GameProxy:GetCurrentRound()
    return m_tableInfo.round
end 

function GameProxy:GetGameState()
    return m_tableInfo.state 
end 

function GameProxy:IsGamePlaying()
    return  m_bGamePlaying
end 

--是否是房主
function GameProxy:IsOwner()
    return m_PlayerInfo[self_seat_id].user_id == m_tableInfo.owner
end 

--是否是庄家
function GameProxy:IsDealer(real_seat_id)
    local seat_id = GetSeatId(real_seat_id)
    if seat_id and seat_id == m_tableInfo.dealer then 
        return true 
    end 

    return false
end 

function GameProxy:GetDealer()
    if m_tableInfo.dealer == nil or m_tableInfo.dealer == 0 then 
        return nil 
    end  
    return  m_PlayerInfo[m_tableInfo.dealer].real_seat_id
end 

function  GameProxy:GetRoomOwner()
    return m_tableInfo.owner
end

function GameProxy:GetCurrentAction()
    if m_currentActionInfo == nil then 
        return nil 
    end 
    return m_currentActionInfo.actions
end 

function GameProxy:GetUserScore(real_seat_id)
    local seat_id = GetSeatId(real_seat_id)

    if seat_id and m_userGameInfo[seat_id] == nil then 
        m_userGameInfo[seat_id] = {}
        m_userGameInfo[seat_id].total_score = 0
    end 
    return m_userGameInfo[seat_id].total_score or 0
end 

function GameProxy:GetHallService()
    return hall_service_id
end 

function GameProxy:IsPlayerEnough()
    if m_tableInfo == nil then 
        return false 
    end

    if m_PlayerInfo == nil then 
        return false 
    end 

    local max_player = 2
    return #m_PlayerInfo >= 2 --m_tableInfo. 
end 

function  GameProxy:HasShuffled()
    m_bIsShuffle = false
end

function  GameProxy:GetChatMsg()
    return m_chatMsg
end

function GameProxy:GetGameResult()
    return m_GameOverInfo
end

--@return game mode enum value. see: commandDef EGameMode.
function GameProxy:GetGameMode()
    if m_GameRule == nil then 
        return nn.EGameMode.EGM_3
    end 

    return m_GameRule.game_mode
end

function GameProxy:GetTurnUser()
    if m_tableInfo == nil then 
        return 0
    end 

    return m_tableInfo.turn_user
end

function GameProxy:IsPlayRecord()
    return m_bPlayGameRecord
end

function  GameProxy:IsTurnSelf(real_seat_id)
    if m_tableInfo == nil then 
        return false 
    end 
    if m_tableInfo.turn_user == nil then 
        return false 
    end 

    local seat_id = GetSeatId(real_seat_id)   
    return seat_id == m_tableInfo.turn_user
end

function GameProxy:IsInVote()
    if m_tableInfo == nil or m_PlayerInfo == nil  then 
        return 0,false
    end 

    if m_tableInfo.vote_dismiss_table_starter == 0 then 
        return 0, false
    end 

    return  m_tableInfo.vote_dismiss_table_starter, m_tableInfo.vote_dismiss_table_starter == self_seat_id
end
 
function GameProxy:GetRemainActTime()
    return m_tableInfo.remain_act_time
end

function GameProxy:GetVoteEndTime()
    -- body
    return m_tableInfo.vote_end_time
end

function GameProxy:GetVoteStarterName()
    if m_tableInfo.vote_dismiss_table_starter > 0 then 
        return m_PlayerInfo[m_tableInfo.vote_dismiss_table_starter].user_name
    end 

    return ""
end 

--================= interface for play record =========================
local function Record_RoundOver()
	facade:sendNotification(Common.NTF_ROUND_OVER, m_roundOverData)
end


local function Record_Shuffle()
    m_bIsShuffle = true
    m_bGamePlaying = true 
    local seat_id = nil 
    local tb_cardsInfo = {}
    local m_dealerSeatId = nil 
    if m_userGameInfo  then 
        for k,v in pairs(m_userGameInfo) do 
            seat_id = v.seat_id
            v.req_ready = false 
            local tmp = m_PlayerInfo[seat_id].real_seat_id
            tb_cardsInfo[tmp] = {real_seat_id = tmp, hand_cards = v.hand_cards, card_num = v.hand_card_num}
        end 
    end 

    m_dealerSeatId = m_PlayerInfo[m_tableInfo.dealer].real_seat_id
    
    local tb_final = {}
    for i=m_dealerSeatId, 4 do 
        table.insert(tb_final, tb_cardsInfo[i])
    end 
    for i=1, m_dealerSeatId - 1 do 
        table.insert(tb_final, tb_cardsInfo[i])
    end 
    --@todo::
    facade:sendNotification(Common.NTF_SHUFFLE,{dices = m_tableInfo.dices, cards_info = tb_final, remain_cards = m_tableInfo.table_card_num})
	
	--add cache 
	local tmp_user_info = m_record_data_cache[real_play_step].user_infos
	if not tmp_user_info then 
			tmp_user_info = {}
			m_record_data_cache[real_play_step].user_infos = tmp_user_info
			m_record_data_cache[real_play_step].record_step = m_RecordStep
	end		
	local tmp_help_copy = copy_cards_help
	for k,v in pairs(m_userGameInfo) do 
			 local tmp_real_seat_id = m_PlayerInfo[v.seat_id].real_seat_id
			 local tmp_tb_info = tb_cardsInfo[tmp_real_seat_id]
			tmp_user_info[k] = {real_seat_id = tmp_tb_info.real_seat_id,hand_cards = tmp_help_copy(tmp_tb_info.hand_cards) ,discard_cards = {}}
	end
	m_record_data_cache[real_play_step].remain_cards = GameProxy:GetRemainCards()
	
end 

local function Record_SetPiao() 
end 

local function Record_SwapGetCard()
    for k,v in ipairs(m_userGameInfo) do 
        facade:sendNotification(Common.NTF_SWAP_CARD_RESULT,{real_seat_id = m_PlayerInfo[v.seat_id].real_seat_id, cards = v.swap_in_cards, bIsDealer = m_tableInfo.dealer == v.seat_id})
    end 
end 

local function Record_UserActDone(body)
    --local body = game_sproto:decode("user_act_done", buf)
	if body.user_act == nn.EUserAct.draw_card then 
		local remain = m_tableInfo.table_card_num 
		remain = remain - 1
		if remain <= 0 then 
			remain = 0
		end 

		if body.seat_id == self_seat_id then 
			table.insert(m_userGameInfo[body.seat_id].hand_cards, body.card)
		end 
		--update table card
		m_tableInfo.table_card_num = remain 
		facade:sendNotification(Common.NTF_PLAYER_DRAW_CARD, {real_seat_id = m_PlayerInfo[body.seat_id].real_seat_id, card = body.card, remain_time = m_tableInfo.act_timeout})	
	else
		if  not body.seat_id  then 
			luaTool:Dump(body)
        end
	
        local m_info = {}
		m_info.real_seat_id = m_PlayerInfo[body.seat_id].real_seat_id
		m_info.user_act = body.user_act
		m_info.card = body.card 
		m_info.action_type = body.act_type
		if  body.provider then 
			m_info.provider = m_PlayerInfo[body.provider].real_seat_id
		end
		m_info.isSelf = body.seat_id == self_seat_id
		m_info.isNotHand = body.is_card_not_get
		facade:sendNotification(Common.NTF_PLAYER_ACT_DONE, {info = m_info})
		
	end
   
end 

local function Record_YouCanAct(body)
    if body.action_infos ~= nil then 
        for k,v in ipairs(body.action_infos) do 
            local t = {} 
            t.act_type = v.act_type
            t.act_cards = {}
            if v.act_cards ~= nil then 
                for _,sv in ipairs(v.act_cards) do 
                    table.insert(t.act_cards, sv )
                end 
            end 
            table.insert(acts, t)
        end 
    end 
    facade:sendNotification(Common.NTF_PLAYER_ACTION, {actions = acts, real_seat_id = m_PlayerInfo[self_seat_id].real_seat_id, remain_time = m_tableInfo.act_timeout})
end 

local function _PlayRecord(id)
	
	m_play_record_step_timer = id

	
    if m_PlayRecordState == EPlayRecordState.ERS_Playing then 
        if m_RecordGameStep == nn.ERecordGameStep.EGS_Ready then 

            if m_GameRule.piao_mode == nn.EPiaoType.piao then 
                m_RecordGameStep = nn.ERecordGameStep.EGS_SetPiao 
            else 
                if m_bIsShuffle == false then 
                    m_bIsShuffle = true 
                    facade:sendNotification(Common.NTF_ROUND_START)
                    Record_Shuffle()
                end 
            end 
        elseif m_RecordGameStep == nn.ERecordGameStep.EGS_SetPiao then 
            --shuffle 
            if m_bIsShuffle == false then 
                m_bIsShuffle = true 
                Record_Shuffle()
            end 
        elseif m_RecordGameStep == nn.ERecordGameStep.EGS_Shuffle then 
            m_RecordGameStep = nn.ERecordGameStep.EGS_Playing
        elseif m_RecordGameStep == nn.ERecordGameStep.EGS_Playing then   
            GameProxy:NextRecordStep(true)
        elseif m_RecordGameStep == nn.ERecordGameStep.EGS_Over then 
            
        end 
    else
        
        
    end 
   
   return true
end 

function GameProxy:GameShuffled()
    m_RecordGameStep = nn.ERecordGameStep.EGS_Shuffle
end


function GameProxy:NextRecordStep(send_notify)
		if m_RecordGameStep  ~=  nn.ERecordGameStep.EGS_Playing then 
			return
		end	
		
		local record_list = m_RecordDetail.round_records[m_tableInfo.round].record_list
		
		if record_list then 
		
			while true do
				local step = record_list[m_RecordStep]
				m_RecordStep = m_RecordStep+1
				
				
				if step then
					
					if step.req_user_act then 
					
					elseif step.you_can_act then 
						--Record_YouCanAct(step.you_can_act)
						--break
					elseif step.user_act_done then 
						--next step 
						real_play_step = real_play_step + 1
                        
						if  not m_record_data_cache[real_play_step] then 
							--add to cache 
							local tmp_info = step.user_act_done
							local tmp_index = real_play_step-1
							local tmp_last_cache = m_record_data_cache[tmp_index]
							local tmp_new_data = copy_cache_data_help(tmp_last_cache)
							local tmp_new_cache =  tmp_new_data .user_infos
							if tmp_info. user_act == nn.EUserAct.discard then 
								local tmp_rsid = tmp_info.seat_id
								if not tmp_new_cache[tmp_rsid].discard_cards then 
									tmp_new_cache[tmp_rsid].discard_cards = {}
								end	
								table.insert(tmp_new_cache[tmp_rsid].discard_cards , tmp_info.card)  
								delete_card_help(tmp_new_cache[tmp_rsid].hand_cards,tmp_info.card)	

							elseif 	tmp_info. user_act == nn.EUserAct.draw_card then 
								local tmp_rsid = tmp_info.seat_id

								table.insert(tmp_new_cache[tmp_rsid].hand_cards , tmp_info.card)  
								tmp_new_data.remain_cards = tmp_new_data.remain_cards - 1
									
							elseif 	tmp_info. user_act == nn.EUserAct.peng  then 
								local tmp_rsid = tmp_info.seat_id
								local tmp_user_info = tmp_new_cache[tmp_rsid]

								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)	
								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)
								if tmp_user_info.exposed_infos == nil then 
										tmp_user_info.exposed_infos = {}
								end
								table.insert(tmp_user_info.exposed_infos,{exposed_type = nn.EExposedType.peng,exposed_card = tmp_info.card,provider = tmp_info.provider})	

								local tmp_provider_info = tmp_new_cache[tmp_info.provider]
								
								table.remove(tmp_provider_info.discard_cards)							
				
							elseif tmp_info.user_act == nn.EUserAct.an_gang then										
								local tmp_rsid = tmp_info.seat_id
								local tmp_user_info = tmp_new_cache[tmp_rsid]

								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)	
								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)
								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)
								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)
								if tmp_user_info.exposed_infos == nil then 
										tmp_user_info.exposed_infos = {}
								end
								table.insert(tmp_user_info.exposed_infos,{exposed_type = nn.EExposedType.gang,exposed_card = tmp_info.card,provider = tmp_info.provider})	
								

								
							elseif tmp_info.user_act == nn.EUserAct.zhi_gang then										
								local tmp_rsid = tmp_info.seat_id
								local tmp_user_info = tmp_new_cache[tmp_rsid]

								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)	
								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)
								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)
								
								if tmp_user_info.exposed_infos == nil then 
										tmp_user_info.exposed_infos = {}
								end
								table.insert(tmp_user_info.exposed_infos,{exposed_type = nn.EExposedType.gang,exposed_card = tmp_info.card,provider = tmp_info.provider})	

								local tmp_provider_info = tmp_new_cache[tmp_info.provider]
								
								table.remove(tmp_provider_info.discard_cards)		

							elseif tmp_info.user_act == nn.EUserAct.wan_gang then										
								local tmp_rsid = tmp_info.seat_id
								local tmp_user_info = tmp_new_cache[tmp_rsid]

								delete_card_help(tmp_user_info.hand_cards,tmp_info.card)	
									
								for i,v in ipairs(tmp_user_info.exposed_infos) do 
										if v.exposed_card == tmp_info.card then 
												v.exposed_type = nn.EExposedType.gang
												break
										end		
								end	
							elseif tmp_info.user_act == nn.EUserAct.hu then	
									--tmp_user_info. is_hu = true
									
									local tmp_rsid = tmp_info.seat_id
									local tmp_user_info = tmp_new_cache[tmp_rsid]
									
									tmp_user_info.is_hu = true
									if not tmp_user_info.hu_infos then 
										tmp_user_info.hu_infos = {}
									end	
									table.insert(tmp_user_info.hu_infos , {hu_card = tmp_info.card ,is_card_not_get = tmp_info.is_card_not_get})
									
									if provider == tmp_user_info.seat_id then 
										delete_card_help(tmp_user_info.hand_cards,tmp_info.card)
									else
										if tmp_info.is_card_not_get then
										
										else
									
											local tmp_provider_info = tmp_new_cache[tmp_info.provider]
									
											table.remove(tmp_provider_info.discard_cards)
										end	
									end
									
							end
						
							tmp_new_data.record_step = m_RecordStep
							m_record_data_cache[real_play_step]  = tmp_new_data
						end
						
						if send_notify then 

							Record_UserActDone(step.user_act_done)
						else
							local tmp_data = m_record_data_cache[real_play_step]
							m_tableInfo.table_card_num = tmp_data.remain_cards
							facade:sendNotification(nn.NTF_RESET_PLAYER_INFOS , tmp_data)	
							
						end 
						 break
					elseif step.user_get_score then
						
					end 				
				else 
					m_RecordStep = m_RecordStep - 1
					m_RecordGameStep = nn.ERecordGameStep.EGS_Over
					--Record_RoundOver()
						m_PlayRecordState = EPlayRecordState.ERS_END
						if m_play_record_step_timer then
							LuaTimer.Delete(m_play_record_step_timer)
							m_play_record_step_timer = nil 
						end	
						Record_RoundOver()
					
					
					break
				end	--end if 
				
	
			end		
		end	

			
end

function GameProxy:PrevRecordStep()
	
	--reduce real_play_step
	if real_play_step> 1 then 
		real_play_step = real_play_step-1
	end
	
	

	local tmp_data = m_record_data_cache[real_play_step]
	if 	tmp_data  then 
		m_tableInfo.table_card_num = tmp_data.remain_cards
		facade:sendNotification(nn.NTF_RESET_PLAYER_INFOS , tmp_data)
		m_RecordStep = tmp_data.record_step
	else
		LogError(" fatal error !! no data when play record step :"..real_play_step)
	end	
	
	if  m_RecordGameStep == nn.ERecordGameStep.EGS_Over then 
			m_RecordGameStep = nn.ERecordGameStep.EGS_Playing 
			m_PlayRecordState = EPlayRecordState.ERS_Playing
			if not m_play_record_step_timer then 
				LuaTimer.Add(0,play_record_delay_step,_PlayRecord)
			end	
	end		
end

function GameProxy:IsRecordPlaying()
    return m_PlayRecordState == EPlayRecordState.ERS_Playing
end 

function GameProxy:IsRecordPaused()
    -- body
    return m_PlayRecordState == EPlayRecordState.ERS_Paused
end

function GameProxy:PlayRecord()
    if m_PlayRecordState == EPlayRecordState.ERS_Max then 
        m_PlayRecordState = EPlayRecordState.ERS_Playing
		m_RecordGameStep = nn.ERecordGameStep.EGS_Ready
		m_record_data_cache[real_play_step] = {}		
        LuaTimer.Add(0,play_record_delay_step,_PlayRecord)
    end 
end

function GameProxy:PauseRecord()
    if m_PlayRecordState == EPlayRecordState.ERS_Playing then 
        m_PlayRecordState = EPlayRecordState.ERS_Paused
		if m_play_record_step_timer then 
			LuaTimer.Delete(m_play_record_step_timer)
			m_play_record_step_timer = nil 
		end
    end 
end 

function  GameProxy:ResumeRecord()

    if m_PlayRecordState == EPlayRecordState.ERS_Paused then 
		if m_play_record_step_timer then 
			LuaTimer.Delete(m_play_record_step_timer)
			m_play_record_step_timer = nil
		end
		local tmp_data = m_record_data_cache[real_play_step]
		if 	tmp_data  then 
			facade:sendNotification(nn.NTF_RESET_PLAYER_INFOS , tmp_data)
			m_RecordStep = tmp_data.record_step
		else
			LogError(" fatal error !! no data when play record step :"..real_play_step)
		end		
		
        m_PlayRecordState = EPlayRecordState.ERS_Playing
		LuaTimer.Add(0,play_record_delay_step, _PlayRecord)
    end 
end

function GameProxy:RestartRecord()
		if m_play_record_step_timer then 
			LuaTimer.Delete(m_play_record_step_timer)
			m_play_record_step_timer = nil
		end

		m_RecordGameStep = nn.ERecordGameStep.EGS_Ready
		 real_play_step = 1
		 m_RecordStep = 1
		m_PlayRecordState = EPlayRecordState.ERS_Playing
				
				
		LuaTimer.Add(0,play_record_delay_step, _PlayRecord)				

end
--================= interface for play record =========================
return GameProxy
