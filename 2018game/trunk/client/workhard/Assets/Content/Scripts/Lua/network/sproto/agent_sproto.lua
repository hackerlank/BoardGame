# 广场服务消息定义
# 查询大厅服务器信息
.get_hall_info {
    # 大厅服务编号
    hall_service 0 : integer
}
# 大厅信息
.hall_info {
    # 大厅服务编号
    hall_service 0 : integer

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
    user_num 7 : integer
}
# 注册的大厅列表
.hall_list {
    hall 0 : *hall_info
}
#请求查询私有房间
.req_query_private_table {
    private_key 1 : integer #房间号
}
#查询私有房间结果
.ack_query_private_table {
    private_key     1 : integer #房间号
    hall_service    2 : integer #大厅服务，房间号过期为0
}

#玩家信息
.user_info {
    user_name 0 : string        #玩家名字
    user_id 1 : integer         #玩家编号
    room_card 2 : integer       #房卡
    money 3 : integer           #金钱
    head_img 4 : string         # 玩家头像，可能为空
}
#玩家请求支付
.req_pay {
    user_id     0 : integer     #玩家编号
    pay_type    1 : integer     #支付类型
    params      11: integer     #支付参数
}
#玩家支付结果
.ack_pay {
    code        0  : boolean     #结果 0成功，其他失败
    desc        1  : string      #错误说明
    pay_type    2  : integer     #支付类型
    params      11 : integer     #支付参数
}
#玩家请求更新gps地址
#   gps_x   经度
#   gps_y   维度
#   state   gps状态
.req_update_gps {
    gps_x 1 : string
    gps_y 2 : string
    state 3 : integer
}

# 查询大厅版本信息
.get_hall_version_info {
    hall_service 1 : integer
}
# 大厅版本信息
# hall_service   大厅编号
# desc      版本说明
.hall_version_info {
    hall_service 1 : integer
    desc    2 : string
}
