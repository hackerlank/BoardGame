--游戏消息编号
return {
    -- s2c 桌子状态
    table_info          = 1013,

    -- s2c 广播所有玩家游戏开始，同步游戏数据，body table_info
    game_start          = 1041,
    -- s2c 广播桌子切换状态到回合开始,body round_start
    round_start         = 1042,
    -- s2c 广播桌子切换状态到发牌 body begin_deal
    begin_deal          = 1043,

    -- s2c 广播桌子切换状态到piao
    --begin_bet      = 1045,
    -- s2c 广播桌子切换状态到游戏 body none++
    --end_bet         = 1049,

    begin_play          = 1046,
    -- s2c 广播桌子切换状态到 body round_over
    round_over          = 1047,
    -- s2c 广播游戏结束，庄家输光，超过设置的局数 body game_over
    game_over           = 1048,

    --[[
        c2s 玩家进入桌子后请求准备好,body none
    ]]
    req_ready           = 1051,
    -- s2c 请求准备好失败,body req_ready_fail
    req_ready_fail      = 1052,
    --[[
        s2c 广播其他玩家准备好,body user_is_ready
    ]]
    user_ready          = 1053,

    --c2s 请求开牌
    req_open_cards = 1081,

    --s2c 请求开牌结果
    req_open_cards_fail = 1082,

    req_open_cards_ok = 1083,
 
    -- s2c 广播玩家开牌,
    user_open_cards      = 1086,




    --s2c last ,通知玩家获得tax
   -- user_get_tax =  1131,

    --c2s 房主要求开始游戏
    owner_req_start_game = 1131,

    --sc2 房主要求开始失败
    owner_req_start_game_fail = 1132,

    --c2s 房主要求开始游戏
    owner_req_start_round = 1133,

    --sc2 房主要求开始失败
    owner_req_start_round_fail = 1134,

    


    -- c2s 玩家请求开始新局,body none
    req_start_round     = 1141,
    -- s2c 玩家请求开始新局失败，body req_start_round_fail
    req_start_round_fail= 1142,
    -- s2c 广播玩家请求开始新局,user_start_round
    user_start_round    = 1143,

    -- c2s 玩家请求开始新游戏,body none
    req_start_game      = 1151,
    -- s2c 玩家请求开始新游戏失败,body req_start_game_fail
    req_start_game_fail = 1152,
    -- s2c 广播玩家请求开始新游戏,body user_start_game
    user_start_game     = 1153,

    -- c2s 玩家请求退出游戏,body none
    req_quit_game       = 1156,
    -- s2c 玩家请求退出游戏失败,body req_quit_game_fail
    req_quit_game_fail  = 1157,
    -- s2c 广播玩家退出游戏,body user_quit_game
    user_quit_game      = 1158,

}
