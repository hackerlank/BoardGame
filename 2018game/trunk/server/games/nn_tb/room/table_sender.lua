--桌子服务消息发送函数集
local skynet = require("skynet")
local clustersend = require "clustersend"
local math = require("math")
local tostring = _G.tostring

local log  = require("cc_log")

local spx = _G.spx
local game_msg_id = _G.game_msg_id
local game_sproto = _G.game_sproto
local common_sproto = _G.common_sproto

local table_state = _G.table_state
local info = _G.info
local conf = _G.conf
local user_list = _G.user_list
local sender = _G.sender
local logic = _G.logic
local user_hand_cards_state = _G.user_hand_cards_state or require("user_hand_cards_state")

--生成table_info数据结构
function sender.get_table_info(user)
    local t = {
        owner = info.owner,
        round = info.round,
        state = info.state,
        private_key = info.private_key,
        rules = {},
        users = {},
     --   dices = info.dices,
        left_table_cards_num = info.left_table_cards_num,
     --   decide_dealer_time = conf.decide_dealer_time,
     --   bet_time = conf.bet_time,
        vote_dismiss_table_time = conf.vote_dismiss_table_time,
        vote_dismiss_table_span = conf.vote_dismiss_table_span,
        vote_dismiss_table_starter = info.vote_dismiss_table_starter,
    }
    local vote_timer = info.vote_dismiss_table_timer
    if vote_timer then
        t.left_vote_dismiss_table_time = math.ceil(vote_timer:left_time())
        t.left_vote_dismiss_table_span = 0
    else
        t.left_vote_dismiss_table_time = 0
        local vote_span = conf.vote_dismiss_table_span-logic.last_vote_dismiss_table_span()
        if vote_span < 0 then
            vote_span = 0
        end
        t.left_vote_dismiss_table_span = math.ceil(vote_span)
    end

    for k,v in pairs(info.rules) do
        table.insert(t.rules,{name=k,value=v})
    end
 


    for seat_id,seat_user in pairs(info.users) do
        t.users[seat_id] = {
            user_id = seat_user.user_id,
            user_name = seat_user.user_name,
            seat_id = seat_user.seat_id,
            money = seat_user.money,
            room_card = seat_user.room_card,
            head_img = seat_user.head_img,

            game_state = seat_user.game_state,
           
            round_score = seat_user.round_score,
          
            total_score = seat_user.total_score,

            phase_ack = seat_user.phase_ack,
            
            is_online = logic.is_user_online(seat_user),
            ipaddr = seat_user.ipaddr,
            gps_x = tostring(seat_user.gps_x),
            gps_y = tostring(seat_user.gps_y),
            gps_state = seat_user.gps_state,

            ack_vote_dismiss_table = seat_user.ack_vote_dismiss_table,

            hand_cards_state = seat_user.hand_cards_state,

            hand_cards_num =seat_user.hand_cards_num,

        }

        --根据状态，判断是否发送牌面
        if t.hand_cards_state == user_hand_cards_state.open then 
            t.hand_cards = {}
                for _i2,_v2 in ipairs(seat_user.hand_cards) do 
                    table.insert( t.hand_cards, _v2 )
                end   
              
        else    
                if seat_user == user and seat_user.hand_cards then 
                    t.hand_cards = {}
                    for _i2,_v2 in ipairs(seat_user.hand_cards) do 
                        table.insert( t.hand_cards, _v2 )
                    end  
                end    
                
        end
    end

    return t
end
--发送玩家信息给玩家
function sender.send_table_info(user)
    log.debug("send_table_info(),user_id",user.user_id)
    local t = sender.get_table_info(user)

    local body = game_sproto:encode("table_info",t)
    local np = spx.encode_pack1(info.table_service,game_msg_id.table_info,body)

    sender.send_user_pack(user,np)
end
--发送游戏开始消息给所有玩家
function sender.send_game_start()
    log.debug("send_game_start()")

    for _,user in pairs(user_list) do
        local t = sender.get_table_info(user)

        local body = game_sproto:encode("table_info",t)
        local np = spx.encode_pack1(info.table_service,game_msg_id.game_start,body)

        sender.send_user_pack(user,np)
    end
end

--给每个玩家发送回合开始消息
function sender.send_round_start()
    log.debug("send_round_start()")
    local body = game_sproto:encode("round_start",{round=info.round})
	local np = spx.encode_pack1(info.table_service,game_msg_id.round_start,body)

    for _,dst in pairs(user_list) do
	    sender.send_user_pack(dst,np)
    end
end

--通知所有玩家发牌
function sender.send_begin_deal()
    log.debug("send_begin_deal()")

    local t = {
        dices = info.dices,
        users = {},
        table_card_num = info.card_num,
        }
    for seat_id,user in pairs(info.users) do
        t.users[seat_id] = {
            seat_id = seat_id,
            cards = user.cards,
            chip = user.chip,
            stake = user.stake,
            score = user.score,
            own_score = user.own_score,
            total_score = user.total_score,
        }
    end
    local body = game_sproto:encode("begin_deal",t)
	local np = spx.encode_pack1(info.table_service,game_msg_id.begin_deal,body)

    for _,dst in pairs(user_list) do
	    sender.send_user_pack(dst,np)
    end
end

--通知所有玩家开始play
function sender.send_begin_play()
    log.debug("send_begin_play()")

	local np = spx.encode_pack1(info.table_service,game_msg_id.begin_play,nil)

    for _,dst in pairs(user_list) do
	    sender.send_user_pack(dst,np)
    end
end


--返回一局游戏结束消息
function sender.get_round_over()
    local t = { users = {} }
    if info.table_cards and #info.table_cards > 0 then 
        t.table_cards = info.table_cards
    end    

    for seat_id,seat_user in pairs(info.users) do
        local t_user = {
            seat_id = seat_user.seat_id,
            money = seat_user.money,
            room_card = seat_user.room_card,
            head_img = seat_user.head_img,
            hand_cards = seat_user.hand_cards,

            --hu_infos = {},

            round_score = seat_user.round_score,
            total_score = seat_user.total_score,
            niu_point = seat_user.niu_point,
            ex_niu_type =seat_user.ex_niu_type,
            --user_bunkos = seat_user.bunkos,

            is_online = logic.is_user_online(seat_user),
        }

         t.users[seat_id] = t_user
    end

     t.round_over_time = info.round_over_time_string

    return t
end

--通知所有玩家回合结束
function sender.send_round_over()
    log.debug("send_round_over()")

    local t = sender.get_round_over()

    local body = game_sproto:encode("round_over",t)
	local np = spx.encode_pack1(info.table_service,game_msg_id.round_over,body)

    for _,dst in pairs(user_list) do
	    sender.send_user_pack(dst,np)
    end
end
--通知所有玩家大局结束
function sender.send_game_over()
    log.debug("send_game_over()")

	local np = spx.encode_pack1(info.table_service,game_msg_id.game_over,nil)

    for _,dst in pairs(user_list) do
	    sender.send_user_pack(dst,np)
    end
end
--通知玩家准备好
function sender.send_user_is_ready(user)
    log.debug("send_user_is_ready(),user_id",user.user_id)

	local body = game_sproto:encode("user_ready",{seat_id=user.seat_id})
	local np = spx.encode_pack1(info.table_service,game_msg_id.user_ready,body)

    for _,dst in pairs(user_list) do
        sender.send_user_pack(dst,np)
    end
end

function sender.send_user_open_cards(user)
   log.debug("send_user_open_cards(),user_id",user.user_id)
    local tmp_cards = {}
    for i,v in ipairs(user.hand_cards) do 
        table.insert(tmp_cards,v)
    end    

	local body = game_sproto:encode("user_open_cards",{seat_id=user.seat_id,hand_cards = tmp_cards})
	local np = spx.encode_pack1(info.table_service,game_msg_id.user_open_cards,body)

    for _,dst in pairs(user_list) do
        sender.send_user_pack(dst,np)
    end
end

function sender.send_req_open_cards_ok(user)
    

	local np = spx.encode_pack1(info.table_service,game_msg_id.req_open_cards_ok,nil)
 
	sender.send_user_pack(user,np)
    
end

function  sender.send_req_open_cards_fail( user,error_code,reason )
    -- body
    local body = game_sproto:encode("req_open_cards_fail",{code=error_code,desc = reason})

	local np = spx.encode_pack1(info.table_service,game_msg_id.req_open_cards_fail,body)
 
	sender.send_user_pack(user,np)    
end

 

--玩家请求开始新局结果
function sender.send_req_start_round_fail(user,code,desc)
	local body = game_sproto:encode("req_start_round_fail",{code=code,desc=desc})
	local np = spx.encode_pack1(info.table_service,game_msg_id.req_start_round_fail,body)

    sender.send_user_pack(user,np)
end
--广播玩家开始新局
function sender.send_user_start_round(user)
    print(" send user start round to all")
	local body = game_sproto:encode("user_start_round",{seat_id=user.seat_id})
	local np = spx.encode_pack1(info.table_service,game_msg_id.user_start_round,body)

    for _,dst in pairs(user_list) do
        sender.send_user_pack(dst,np)
    end
end

--玩家请求开始新局结果
function sender.send_owner_req_start_game_fail(user,code,desc)
     print(" send_owner_req_start_game_fail")
	local body = game_sproto:encode("owner_req_start_game_fail",{code=code,desc=desc})
	local np = spx.encode_pack1(info.table_service,game_msg_id.owner_req_start_game_fail,body)

    sender.send_user_pack(user,np)
end
--广播玩家开始新局
function sender.send_owner_req_start_round_fail(user,code,desc)
     print(" send_owner_req_start_round_fail")
	local body = game_sproto:encode("owner_req_start_round_fail",{code=code,desc=desc})
	local np = spx.encode_pack1(info.table_service,game_msg_id.owner_req_start_round_fail,body)

    sender.send_user_pack(user,np)
end