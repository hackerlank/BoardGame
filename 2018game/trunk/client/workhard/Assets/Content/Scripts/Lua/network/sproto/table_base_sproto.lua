#炸对子桌子通讯协议
#游戏规则
.game_rule {
    name  0 : string #规则名称
    value 1 : string #规则值
}
#玩家进入桌子
.user_enter_table {
    seat_id     0 : integer         #座位号
    user_name   1 : string          #玩家名字
    user_id     2 : integer         #玩家编号
    room_card   3 : integer         #房卡
    money       4 : integer         #金钱
    head_img    5 : string          #玩家头像，可能为空
    ipaddr      11: string          #ip地址
    gps_x       12: string          #经度
    gps_y       13: string          #纬度
    gps_state   14: integer         #gps状态
}
#玩家离开桌子
.user_left_table {
    seat_id 0 : integer #玩家编号
}
#桌子解散了
.dismiss_table {
    desc 0 : string     #房间解散原因说明
}
#玩家请求上线成功
.req_online_ok {
    seat_id 0 : integer #玩家编号
}
#玩家上线
.user_online {
    seat_id 0 : integer #玩家编号
}
#玩家离线
.user_offline {
    seat_id 0 : integer #玩家编号
}
#开始投票终止游戏
.begin_vote_dismiss_table {
    seat_id 0 : integer     #发起玩家编号
}
#请求投票
.req_vote_dismiss_table {
    agree 0 : boolean      #是否同意终止
}
#有玩家投票
.user_vote_dismiss_table {
    seat_id 0 : integer     #玩家座位
    agree 1 : boolean      #是否同意终止
}
#本轮投票解散桌子结束
.end_vote_dismiss_table {
    is_dismiss 0 : boolean      #是否解散桌子
}
#玩家请求聊天
.req_chat {
    chat_type      1 : integer        #玩家聊天类型，定义types/chat_type.lua
    preset_text    2 : string         #预设文本
    preset_image   3 : string         #预设图形
    user_text      11: string         #玩家自己输入的文本
    user_voice     12: string         #玩家自己输入的语音
	user_voice_args 13: string		  #玩家自己输入的语音的参数
}
#玩家开始聊天
.user_chat {
    seat_id        0 : integer        #玩家座位号
    chat_type      1 : integer        #玩家聊天类型，定义types/chat_type.lua
    preset_text    2 : string         #预设文本
    preset_image   3 : string         #预设图形
    user_text      11: string         #玩家自己输入的文本
    user_voice     12: string         #玩家自己输入的语音
}
