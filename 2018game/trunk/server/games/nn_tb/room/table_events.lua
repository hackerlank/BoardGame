local skynet = require("skynet")

local log = require("cc_log")
local sprint_r = require("sprint_r")

require("table_state")
--加载最先加载桌子数据
require "table_data"
--加载游戏逻辑
require "table_logic"
--消息发送函数集
require "table_sender"
--封包处理函数集
require "table_pack"

local table_msg_id = _G.table_msg_id

local phase_ack = _G.phase_ack
local table_mode = _G.table_mode
local table_state = _G.table_state
local command = _G.command
local user_list = _G.user_list
local conf = _G.conf
local info = _G.info

local logic = _G.logic
local sender = _G.sender

local toboolean = require("toboolean")
local tonumber = _G.tonumber
--[[
    游戏基础事件挂接，游戏开发者可以在这里处理基础的桌子服务事件
    start                   桌子服务启动
    open_table              桌子即将对玩家开放，在这里进行最后的初始化工作
    can_user_enter_table    询问玩家是否允许进入桌子
    user_enter_table        玩家进入桌子
    req_left_table     询问玩家是否允许离开桌子
    user_left_table         玩家离开桌子
    req_left_table          玩家请求离开桌子，如果要阻止玩家离开，返回false和desc
    req_dismiss_table       询问是否可以解散桌子
    dismiss_table           桌子即将解散
    user_online             玩家上线
    user_offline            玩家离线
]]
local table_events = _G.table_events

--桌子服务启动，param 传递给服务的参数
function table_events.start(param)
    log.info("table_events.start,param",param)

    --检查参数
    assert(conf.min_table_users     ,"invalid conf.min_table_users     ")
    assert(conf.max_table_users     ,"invalid conf.max_table_users     ")
    assert(conf.table_timer_span    ,"invalid conf.table_timer_span    ")
    assert(conf.dismiss_table_time  ,"invalid conf.dismiss_table_time  ")
    assert(conf.user_hand_cards_num     ,"invalid conf.user_hand_cards_num     ")
    assert(conf.game_start_time     ,"invalid conf.game_start_time     ")
  --  assert(conf.decide_dealer_time  ,"invalid conf.decide_dealer_time  ")
  --  assert(conf.bet_time            ,"invalid conf.bet_time            ")
    assert(conf.deal_time           ,"invalid conf.deal_time           ")
    assert(conf.round_over_time     ,"invalid conf.round_over_time     ")
    assert(conf.game_over_time      ,"invalid conf.game_over_time      ")

    --初始化_G.info参数
    info.round           = 0
    info.state           = table_state.closed
    
    info.cards           = {}
    info.card_num        = 0
    info.table_mode      = conf.room_card
    info.base_chip       = _G.conf.base_chip
    info.max_add_chip    = 0
  --  info.is_refund       = true

    --生成桌子上的卡牌
    --logic.new_table_cards()
end
--[[
    打开桌子，之后可以让玩家进入桌子,并接受玩家消息
    table_info_ 参数
        table_type  桌子类型
        rules       游戏规则
        owner       房间创建者编号
]]
function table_events.open_table(table_info_)
    log.info("table_events.open_table()\n"..sprint_r(table_info_))

    local rules = table_info_.rules
    info.table_type = table_info_.table_type
    for k,v in pairs(rules) do
        info.rules[k] = v
    end
    info.owner = table_info_.owner

    --规则合法性由大厅负责检查
    info.table_mode = tonumber(rules.table_mode)
   -- info.base_chip = tonumber(rules.base_chip)
    info.base_chip = tonumber(rules.base_chip)
    info.max_round = tonumber(rules.max_round)

    info.start_game_mode = tonumber(rules.start_game_mode)

    enable_flush= toboolean(rules.enable_flush)
    enable_straight          = toboolean(rules.enable_straight)
    enable_suited = toboolean(rules.enable_suited) 
    enbale_five_big = toboolean(rules.enbale_five_big)
    enable_five_small = toboolean(rules.enable_five_small)
    enable_full_house = toboolean(rules.enable_full_house)
    enable_bomb = toboolean(rules.enable_bomb)


    info.private_table_cost = tonumber(rules.private_table_cost)
    if not info.private_table_cost then
        return false,"没有设置私有房间消费房卡数量"
    end

    info.state = table_state.idle
    info.is_dismiss_table = false

    logic.make_ex_niu_funcs()
    return true
end
function table_events.can_user_enter_table(user)
    log.info("table_events.can_user_enter_table,user_id",user.user_id)
    if info.user_num<conf.max_table_users then
   
        if info.state~=table_state.closed and info.state~=table_state.game_over and info.state~=table_state.dismissed then
            log.error("no,info.state",info.state)
            return true,"游戏已经开始"
        else
            log.error("no,info.state",info.state)
            return false,"游戏已经结束，或桌子不可用"
        end

    
    else
        log.error("no,table is full")
        return false,"房间人数已经满了"
    end
end
function table_events.user_enter_table(user)
    log.info("table_events.user_enter_table,user_id",user.user_id)

    user.phase_ack      = phase_ack.none
    user.game_state     = user_game_state.observer

    -- test code
    --logic.test_play_record()
end
function table_events.req_left_table(user)
    local user_id = user.user_id
    local gate_service = user.gate_service
    local fd = user.fd
    log.info("table_events.req_left_table,user_id",user_id)

    if info.state==table_state.game_over then
        log.debug("table_events.req_left_table(),table is game_over,dismiss")
        sender.send_error(gate_service,fd,table_msg_id.ack_left_table,0)
        command.dismiss_table("玩家【"..user.user_name.."】离开，房间解散")
        return
    end
    if info.state==table_state.idle then
        sender.send_error(gate_service,fd,table_msg_id.ack_left_table,0)

        if user.user_id==info.owner then
            log.debug("table_events.req_left_table(),user is owner,dismiss")
            --房主离开，解散桌子
            command.dismiss_table("房主离开，房间解散")
        else
            log.debug("table_events.req_left_table(),table is idle,left ok")
            command.user_left_table(user_id)
        end
        return
    end
    if info.is_dismiss_table then
        log.debug("table_events.req_left_table(),table is dismiss,left ok")
        sender.send_error(gate_service,fd,table_msg_id.ack_left_table,0)
        return
    end

    --正在投票
    if logic.is_vote_dismiss_table() then
        log.debug("table_events.req_left_table(),table is ovting,left fail")
        sender.send_error(gate_service,fd,table_msg_id.ack_left_table,1,"正在进行解散房间的投票")
        return
    end

    --上次投票间隔时间没到
    if logic.last_vote_dismiss_table_span()<conf.vote_dismiss_table_span then
        log.debug("table_events.req_left_table(),vote dismiss soon")
        sender.send_error(gate_service,fd,table_msg_id.ack_left_table,1,"请等待一段时间再发起投票")
        return
    end

    --开始投票
    sender.send_error(gate_service,fd,table_msg_id.ack_left_table,0)
    logic.start_vote_dismiss_table(user,conf.vote_dismiss_table_time)
    return false,"游戏开始后必须投票解散房间"
end
function table_events.user_left_table(user)
    log.info("table_events.user_left_table,user_id",user.user_id)
end
function table_events.req_dismiss_table(user)
    return false,"本游戏不支持解散请求"
end
function table_events.dismiss_table()
    log.info("table_events.dismiss_table")
    info.state = table_state.dismissed

    --退还房主房卡
    logic.refund()
end
function table_events.user_online(user)
    log.info("table_events.user_online,user_id",user.user_id)
    sender.send_table_info(user)

   -- if info.state==table_state.idle and user.phase_ack==phase_ack.none then
     --   logic.user_is_ready(user)
   -- end

    --玩家上线取消投票
    --if logic.is_vote_dismiss_table() then
    --    logic.end_vote_dismiss_table(false)
    --end
end
function table_events.user_offline(user)
    log.info("table_events.user_offline,user_id",user.user_id)
end

return table_events
