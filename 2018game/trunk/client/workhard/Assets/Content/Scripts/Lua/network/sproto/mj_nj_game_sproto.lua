#游戏消息数据
#游戏规则
.game_rule {
    name  0 : string #规则名称
    value 1 : string #规则值
}
#番信息
.fan_info {
    fan_name 0 : string     #番名称
    fan_num 1 : integer     #番数
}
.score_info{
    seat_id 0 :integer
   
    score 1:integer
}
.lose_info{
    lose_type 0:integer
    lose_score 1:integer
}
#胡牌信息
.hu_info {
    hu_type 0 : integer         #胡牌类型
    hu_card 1 : integer         #胡德牌
    fans 6 : *fan_info          #胡牌的番列表
    score 7 : integer         #胡牌的积分
    hjzy_user 11 : integer      #是呼叫转移，点炮的玩家位置，
                                #否，0
    hjzy_score 12 : integer     #呼叫转移积分
    provider 13 :integer

    lose_infos 21 : *lose_info

    loser_seat_ids 31:*integer

    loser_scores    32:*integer


    is_card_not_get 41:boolean

    hu_index  51 :integer      #hu_index in this round
    
}


.exposed_info{
    exposed_type 0 : integer       #类型，定义common_data.lua:exposed_type
    exposed_cards 1 : *integer       #牌  
    provider      2 : integer        #provider's seat_id
}


.fengyu_info{
    type 0:integer
    score_infos 1: *score_info
    total_score 2: integer

}
#玩家信息
.user_info {
    user_id 0 : integer         #玩家编号
    user_name 1 : string        #玩家显示名称
    seat_id 2 : integer         #座位号1-4
    money 3 : integer           #金钱数量
    room_card 4 : integer       #房卡数量

    req_ready 5 : boolean    

    vote_ack  6: integer
    head_img  8:string

 
    hand_cards 12 : *integer    #玩家手中的牌，游戏结束前对自己有效，结束后所有人可见
 
   # tang_cards 14 : *integer    #玩家躺下的牌
    discard_cards 15 : *integer #玩家出的牌
   # peng_cards 16 : *integer    #玩家碰的牌，只发中心牌，客户端显示3张
  #  gang_infos 17 : *gang_info  #玩家杠牌信息
    exposed_infos  18:  *exposed_info  #peng,gang,etc 
    hand_card_num 21 : integer  #玩家手中的牌数量


    allow_acts 31 : *act_info        #玩家允许的行动列表
    user_act 32 : integer           #玩家在本回合的动作
    act_card 33 : integer           #动作关联的牌

    hu_infos 41 : *hu_info      #胡牌信息，支持血流成河，可以有多个

    score 51 : integer          #本局积分
    total_score 52 : integer    #总积分
    fengyu_infos  53 :*fengyu_info
    cha_jiao_infos  54 :*score_info

    #bunkos 61 : *bunko_info     #玩家输赢信息
         total_zi_mo_hu_count  61:integer
        total_dian_pao_count   62:integer
        total_pao_hu_count      63:integer
        total_gang_count      64:integer 

    is_online 101 : boolean       #玩家是否在线

    ipaddr  201:string 
    gps_x   202:string 
    gps_y  203:string
    gps_state 204 : integer

    piao_state  301:integer
    can_bao_jiao 311:boolean
    can_bao_gang_cards 312:*integer
    bao_jiao_type 321:integer
    bao_gang_cards 322:*integer

    is_fang_hu 331 :boolean
    fang_hu_cards  332:*integer
}
#桌子信息
.latest_discard_info{
    seat_id 0:integer
    card    1:integer
}

.hu_oder_info{
    seat_id 0 :integer
    hu_oder 1:integer
}

.table_info {
    owner 0 : integer                   #房间创建者
    rules 1 : *game_rule                #游戏规则
    round 2 : integer                   #牌局回合数量
    state 3 : integer                   #游戏状态
    table_card_num 4 : integer          #桌子剩余牌数量
    users 5 : *user_info(seat_id)       #玩家列表
    dices 6 : *integer                  #骰子点数
    turn_user 7 : integer               #本回合轮到的玩家座位号
    dealer 8 : integer                  #庄家编号
    multi_gunner 9:integer
    user_hu_orders 10:*hu_oder_info               

    is_turn_user_discard 11 : boolean       

    is_turn_user_draw  12 :  boolean

    is_turn_user_just_gang 13 : boolean

    private_key 21:integer

    vote_dismiss_table_time 41:integer    #解散桌子投票超时  
    vote_dismiss_table_span 42:integer    #  解散桌子间隔时间 

    vote_dismiss_table_starter              43:integer      



    act_timeout 53 : integer            #行动时间


    remain_act_time  56:integer

    current_action_num 57 : integer

    latest_discard  61: latest_discard_info                # latest_discard_info
    round_over_time  71:string

    vote_left_time   72:integer   

    

  
}
#一轮游戏开始
.round_start {
    round 0 : integer       #游戏局数
}
#切换游戏转状态:发牌
.begin_deal {
    dices 0 : *integer              #骰子点数
    users 1 : *user_info(seat_id)   #当前的玩家信息，有效字段
                                    #seat_id,hand_card_num,hand_cards
    dealer 2 : integer              #庄家座位号
    table_card_num 11 : integer     #桌面上剩下的牌数量
}

#一轮游戏结束，现实小结
.round_over {
    table_cards 0:*integer  #left table_cards
    users 1 : *user_info(seat_id)   #玩家本局积分
                                    #有效字段
                                    #seat_id
                                    #money
                                    #room_card
                                    #hand_cards
                                    #hu_infos
                                    #score
                                    #total_score
                                    #bunkos
    round_over_time  11:  string                                 
}
#游戏结束，显示最终结算
.game_over {
              
    users 0 : *user_info(seat_id)  #玩家本局积分，有效字段同round_over
    is_dismissed 1:boolean         #is dismiss to gameover or not
}
#玩家请求准备好失败
.req_ready_fail {
    code 0 : integer        #定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}
#通知玩家准备好了
.user_ready {
    seat_id 0 : integer #玩家座位号
}

#玩家请求piao
.req_piao{
    piao_state 0:integer
}

.req_ding_piao{
    piao_state 0:integer
}

#玩家请求piao操作失败
.req_piao_fail {
    code 0 : integer    #错误代码，定义common_data.lua:act_error_code
    desc 1 : string     #错误说明
}

.req_ding_piao_fail {
    code 0 : integer    #错误代码，定义common_data.lua:act_error_code
    desc 1 : string     #错误说明
}
#广播玩家piao
.piao_info{
    seat_id 0:integer
    piao_state 1:integer
}

.user_piao {
    seat_id 0:integer
    piao_state 1:integer
}


.user_ding_piao {
    seat_id 0:integer
    piao_state 1:integer
}
#广播piao
.piao_results {
    piao_infos 0 : *piao_info       

}

.you_can_bao_jiao{
    can_bao_gang_cards 0: *integer
}


.req_bao_jiao{
    bao_jiao_type 0 :integer
    bao_gang_cards 1:*integer
}

.user_bao_jiao{
    seat_id 0: integer
    bao_jiao_type 1 :integer
    bao_gang_cards 2:*integer
    can_discard_cards 3:*integer   #just for dealer bao_jiao
}

.req_bao_jiao_fail {
    code 0 : integer    #错误代码，定义common_data.lua:act_error_code
    desc 1 : string     #错误说明
}


#玩家摸牌
.user_draw_card {
    seat_id 0 : integer     #玩家座位号
    card 1 : integer        #拿到的牌，仅自己可见，其他玩家无效
}
#广播回合开始，其他玩家必须等待轮到的玩家发出动作才能响应
.new_turn {
    seat_id 0 : integer     #玩家座位号
}



.user_can_discard{
    seat_id 0: integer
    remain_time 1:integer    #remain_time for discard
}

.act_info{
    act_type 0:integer
    act_cards 1:*integer
}
#玩家可以行动了
.you_can_act {
   
    action_num 0: integer         #操作编号（流水号）
    action_infos  1 :*act_info       #card for the act
    remain_time 2:integer            #remain_time for act   
}



# user req action
.req_user_act{
    user_act 0 :integer  #defined in user_act.lua   
     card    1:integer   
     action_num 2 :integer   #对应的操作编号。从you_can_act获得
} 

.req_user_act_fail{
    code 0 : integer        #定义common_data.lua:act_error_code
    desc 1 : string         #错误说明 
}


.act_done_info{
    seat_id 0 :integer   #玩家座位号
    user_act 1 :integer  #defined in user_act.lua  
    card     2:integer   #玩家act的牌
    act_type 3:integer   #extra info .gang_type or hu_type
    provider 4:integer   #who provide the card .seat_id
    is_card_not_get 11:boolean 
    hu_index 21 :integer   #just for hu . hu_index in round
}


.user_act_done{
    act_done_infos 0:*act_done_info
}

.req_discard_fail{
    code 0 : integer        #错误代码，定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
} 

.user_discard{
    seat_id 0 :integer   #玩家座位号
    card    1:integer   #玩家act的牌

}

#玩家请求开始新局失败
.req_start_round_fail {
    code 0 : integer        #错误代码，定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}
#通知玩家开始新局
.user_start_round {
    seat_id 0 : integer #玩家座位号
}
#玩家请求开始游戏失败
.req_start_game_fail {
    code 0 : integer        #错误代码，定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}
#通知玩家开始游戏
.user_start_game {
    seat_id 0 : integer #玩家座位号
}
#玩家请求退出游戏失败
.req_quit_game_fail {
    code 0 : integer        #错误代码，定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}
#通知玩家退出游戏
.user_quit_game {
    seat_id 0 : integer #玩家座位号
}

#玩家请求出牌
.req_discard {
    card 0 : integer        #玩家要出的牌
}

.front_info{
    cards 0 :*integer
    type  1 :*integer
}

.user_play_info{
    seat_id 0 :integer
    hand_cards 1 :*integer
    user_front_info 2:*front_info
}

.discard_info{
    seat_id  0:integer
    cards     1:*integer
}


.user_play_state{
    seat_id 0 :integer
    user_play_state 1:integer
}
.table_play_info{
    
    user_play_info 0:*user_play_info
    user_discard_info 1: *discard_info
    last_discard 2: integer
    current_active_user 3:integer
    
    user_score_info 4:*score_info
    user_play_state 5:*user_play_state
    table_play_state 6:integer
    table_left_cards 7:*integer
}

.action_info{
    action_id   0:integer
    action_type 1:integer
    relavent_user 2:*integer
    relavent_card 3:integer
    action_source 4:integer
    table_result 5:table_play_info

}

.user_get_score{
    seat_id     0:integer
    score_type  1 :integer #defined in common.score_type
    score       2:integer
    target_score_infos 3:*score_info 
}




.user_start_play_info {
    user_id 0 : integer         #玩家编号
    user_name 1 : string        #玩家显示名称
    seat_id 2 : integer         #座位号1-4
    piao_state  4:integer
   hand_cards 5 : *integer       #cards in hand

}


.round_start_state_record{
    dealer 0 :integer
    dices   1 :*integer
    table_cards  2 :*integer
    user_start_play_infos 3 :*user_start_play_info
    
}

.record_info{
    record_step_id 0 :integer
    seat_id   1 : integer
    you_can_act 21 : you_can_act
    req_user_act 31: req_user_act
    user_act_done 41:act_done_info
    user_get_score 51:user_get_score
    user_bao_jiao 61:user_bao_jiao
    
}    



.round_record{
    round 0:integer
    round_start_state_record 1 : round_start_state_record
    record_list 2:*record_info
    round_end_record 3: round_over
}

.user_record_info{
    user_id 0:integer
    user_name 1:string  
    head_img 2:string
    seat_id 3:integer 
    total_score 4:integer
}
.game_record{
           
    round_records      0 :  *round_record
    user_record_infos  1 :  *user_record_info
    private_key        2:   integer
}

.record_score_info{
    user_id 0:integer
    user_name 1:string
    score   2:integer
    head_img 3:string
}
.round_score_info{

    round 0:integer
    score_infos 1:*record_score_info
    time 3:string
    game_rules  4: *game_rule

}
.game_brief{
    game_score_infos 0:*record_score_info
    round_score_infos 1:*round_score_info
    game_rules       2:*game_rule
}

