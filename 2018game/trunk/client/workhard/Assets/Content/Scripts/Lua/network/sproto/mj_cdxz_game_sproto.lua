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
.lose_info
{
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

    lose_infos 21 : lose_info

    loser_seat_ids 31:*integer

    is_card_not_get 41:boolean

    hu_index  51 :integer      #hu_index in this round
    
}


.exposed_info
{
    exposed_type 0 : integer       #类型，定义common_data.lua:exposed_type
    exposed_cards 1 : *integer       #牌  
    provider      2 : integer        #provider's seat_id
}

#输赢信息
.bunko_info {
    type 0 : integer        #输赢类型，定义common_data.lua:bunko_type
    score 1 : integer       #输赢积分,正为赢，负为输
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

    que_card_color 11 : integer #玩家缺门的类型
    hand_cards 12 : *integer    #玩家手中的牌，游戏结束前对自己有效，结束后所有人可见
    swap_cards 13 : *integer    #玩家交换的牌
    tang_cards 14 : *integer    #玩家躺下的牌
    discard_cards 15 : *integer #玩家出的牌
   # peng_cards 16 : *integer    #玩家碰的牌，只发中心牌，客户端显示3张
  #  gang_infos 17 : *gang_info  #玩家杠牌信息
    exposed_infos  18:  *exposed_info  #peng,gang,etc 
    hand_card_num 21 : integer  #玩家手中的牌数量
    swap_card_num 22 : integer  #交换的牌数量

    allow_acts 31 : *act_info        #玩家允许的行动列表
    user_act 32 : integer           #玩家在本回合的动作
    act_card 33 : integer           #动作关联的牌

    hu_infos 41 : *hu_info      #胡牌信息，支持血流成河，可以有多个

    is_flower_pig 42:boolean    #if is_pig when round_over

    score 51 : integer          #本局积分
    total_score 52 : integer    #总积分
    fengyu_infos  53 :*fengyu_info
    cha_jiao_infos  54 :*score_info

    #bunkos 61 : *bunko_info     #玩家输赢信息
         total_zi_mo_hu_count  61:integer
        total_dian_pao_count   62:integer
        total_pao_hu_count      63:integer
        total_gang_count      64:integer 

        total_ming_gang_count   65:integer
        total_an_gang_count     66:integer
        total_bei_cha_jiao_count   67:integer

    is_online 101 : boolean       #玩家是否在线

    ipaddr  201:string 
    gps_x   202:string 
    gps_y  203:string
    gps_state 204 : integer
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


    swap_cards_time 51 : integer        #换牌时间
    ding_que_time 52 : integer          #定缺时间
    act_timeout 53 : integer            #行动时间

    remain_swap_swap_cards_time 54:integer
    remain_ding_que_time  55:integer
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
#广播开始换牌
.begin_swap_cards {
    swap_cards_mode 0 : integer     #换牌模式，定义common_data.lua:swap_cards_mode
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
#玩家请求换牌
.req_swap_cards {
    cards 0 : *integer #要换牌列表
}
#玩家请求换牌操作失败
.req_swap_cards_fail {
    code 0 : integer    #错误代码，定义common_data.lua:act_error_code
    desc 1 : string     #错误说明
}
#广播玩家换牌
.user_swap_cards {
    seat_id 0 : integer     #玩家编号
    card_num 1 : integer    #换牌的数量
}
#广播换牌result
.swap_cards_results {
    direction 0 : integer       #换牌方向，定义common.swap_cards_direction
                                #经典换牌有效
    new_cards 1 : *integer      #玩家换到的新牌
    hand_cards 2: *integer      #hand cards now
}
#玩家请求定缺
.req_ding_que {
    card_color 0 : integer   #定缺的牌类型，参见mj_info.lua:mj_color
}
#回应玩家定缺
.req_ding_que_fail {
    code 0 : integer        #错误代码，定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}

.que_info{
        seat_id 0 : integer         #玩家座位号
    que_card_color 1 : integer      #定缺的牌花色，参见mj_info.lua:mj_color
}

#广播玩家定缺
.user_ding_que {
    seat_id 0 : integer              #玩家座位号
}

.ding_que_result{
    que_infos   0   :*que_info  
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
#玩家行动结果
.act_result {
    seat_id 0 : integer         #玩家座位
    user_act 1 : integer        #玩家行动类型，过、失败的玩家为user_act.none
                                #比如被抢杠、抢碰胡牌的玩家
    act_card 2 : integer        #行动相关的牌
    scores 3 : *integer         #行动改变的玩家分数

    gang_type 11 : integer      #如果是杠，指明杠牌类型
    hu_type 21 : integer        #如果是胡，指明胡牌类型
    fans 22 : *fan_info         #胡牌的番
}
#广播回合结束
.turn_over {
    act_results 0 : *act_result #所有玩家的有效行动结果
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

.user_act_done{
    seat_id 0 :integer   #玩家座位号
    user_act 1 :integer  #defined in user_act.lua  
    card     2:integer   #玩家act的牌
    act_type 3:integer   #extra info .gang_type or hu_type
    provider 4:integer   #who provide the card .seat_id
    is_card_not_get 11:boolean 
    hu_index 21 :integer   #just for hu . hu_index in round
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


.user_play_state
{
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


.user_swap_info{
  
    out_cards 0:*integer
    in_cards  1:*integer
}

.user_start_play_info {
    user_id 0 : integer         #玩家编号
    user_name 1 : string        #玩家显示名称
    seat_id 2 : integer         #座位号1-4
    swap_info 3: user_swap_info
    que_card_color 4 : integer #玩家缺门的类型
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
    user_act_done 41:user_act_done
    user_get_score 51:user_get_score
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

