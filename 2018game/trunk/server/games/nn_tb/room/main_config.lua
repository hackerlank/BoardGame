--服务器公共配置参数，这个文件由preload.lua提前加载到服务
_G.conf = _G.conf or {}

--中心服务器节点
_G.conf.center_node_info = _G.conf.center_node_info or {
    node_id         = 1,
    node_name       = "center",
    node_address    = "127.0.0.1:2501",
    node_type       = "center",
}
--本度集群节点信息
_G.conf.self_node_info = _G.conf.self_node_info or {
    node_name       = "nn_tb_room1",
    node_address    = "127.0.0.1:2922",
    node_type       = "nn_tb_room",
}

--[[
    房间配置
    hall_node_name      大厅节点名称
    table_service_name  桌子服务名称
    max_room_tables     房间最大桌子数量
    max_room_users      房间最大玩家数量
    record_version      录像版本
]]
_G.conf.hall_node_name      = "nn_tb_hall1"
_G.conf.table_service_name  = "game_table"
_G.conf.max_room_tables     = 100
_G.conf.max_room_users      = 600
_G.conf.client_version      = 1
_G.conf.record_version      = 1

--[[
    --必要参数
    min_table_users     最小玩家数量
    max_table_users     最大玩家数量
    table_timer_span    定时器时间，单位厘秒
    dismiss_table_time  解散桌子延迟时间

    --游戏参数
    max_round           一轮最大回合数
    max_table_cards     --桌子最大牌的数量

    game_start_time     游戏开始延迟时间，单位厘秒
    decide_dealer_time  选择庄家时间
    bet_time            下注时间
    deal_time           发牌显示时间
    round_over_time     回合结束等待时间
    game_over_time      游戏结束等待时间
    max_user_cards      玩家最多牌数量
    vote_dismiss_table_time 解散桌子投票超时
    vote_dismiss_table_span 解散桌子间隔时间
]]
_G.conf.min_table_users             = 2
_G.conf.max_table_users             = 6
_G.conf.table_timer_span            = 1*100
_G.conf.dismiss_table_time          = 50
_G.conf.max_table_cards             = 52
_G.conf.user_hand_cards_num         = 5
_G.conf.game_start_time             = 1*1
--_G.conf.decide_dealer_time          = 2000*100
_G.conf.bet_time                    = 2000*100
_G.conf.deal_time                   = 2000*100
_G.conf.round_over_time             = 2000*100
_G.conf.game_over_time              = 2000*100
_G.conf.vote_dismiss_table_time     = 5*60*100
_G.conf.vote_dismiss_table_span     = 5*60*100

_G.conf.base_chips = 10
