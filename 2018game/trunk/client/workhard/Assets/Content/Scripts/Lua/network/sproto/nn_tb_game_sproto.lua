#游戏消息数据
#游戏规则
.game_rule {
    name  0 : string #规则名称
    value 1 : string #规则值
}

.score_info{
    seat_id 0 :integer
   
    score 1:integer
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

    game_state 9: integer    #玩家状态
 
    hand_cards 12 : *integer    #玩家手中的牌

    hand_cards_num 21 : integer  #玩家手中的牌数量

    niu_point 31:integer    #牛点数
    ex_niu_type 32:integer      #额外牛牌型

    round_score 51 : integer          #本局积分
    total_score 52 : integer    #总积分

    chips       53:integer      #下注数目    

    hand_cards_state 71:    integer

    is_online 101 : boolean       #玩家是否在线

    ipaddr  201:string 
    gps_x   202:string 
    gps_y  203:string
    gps_state 204 : integer

}




.table_info {
    owner 0 : integer                   #房间创建者
    rules 1 : *game_rule                #游戏规则
    round 2 : integer                   #牌局回合数量
    state 3 : integer                   #游戏状态
    users 5 : *user_info(seat_id)       #玩家列表
    turn_user 7 : integer               #本回合轮到的玩家座位号
    dealer 8 : integer                  #庄家编号

    winner 10:integer                   #赢家座位号
     
    private_key 21:integer

    vote_dismiss_table_time 41:integer    #解散桌子投票超时  
    vote_dismiss_table_span 42:integer    #  解散桌子间隔时间 

    vote_dismiss_table_starter              43:integer      

    act_timeout 53 : integer            #行动时间

    remain_act_time  56:integer

    round_over_time  71:string

    vote_left_time   72:integer   
  
}
#一轮游戏开始
.round_start {
    round 0 : integer       #游戏局数
}
#切换游戏转状态:发牌
.begin_deal {
    
    users 1 : *user_info(seat_id)   #当前的玩家信息，有效字段
                                    #seat_id,hand_card_num,hand_cards
    dealer 2 : integer              #庄家座位号
    
}

.req_open_cards_fail{
    code 0 : integer        #定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}

.user_open_cards{
    seat_id 1:integer
    hand_cards 2 :*integer
}

.owner_req_start_game_fail{
    code 0 : integer        #定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}


.owner_req_start_round_fail{
    code 0 : integer        #定义common_data.lua:act_error_code
    desc 1 : string         #错误说明
}


#一轮游戏结束，现实小结
.round_over {
   
    users 1 : *user_info(seat_id)   #玩家本局积分
                                    #有效字段
                                    #seat_id
                                    #money
                                    #room_card
                                    #hand_cards
                                    #score
                                    #total_score
                                    
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







