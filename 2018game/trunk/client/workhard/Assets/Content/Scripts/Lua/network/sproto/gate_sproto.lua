# 登录服务消息定义
# 登录帐号
.user_login {
    # 玩家编号
    user_id 0 : integer
    # 帐号名称
    auth_code 1 : string
}
# 登录失败
.user_login_fail {
    # 错误原因
    desc 0 : string
}
# 登录成功
# hall_service  代理服务编号
# hall_service  玩家所在的大厅服务器地址
# hall_type     玩家所在大厅服务类型
# ipaddr        客户端ip地址
.user_login_ok {
    agent_service   0 : integer
    hall_service    1 : integer
    hall_type       2 : string
    ipaddr          3 : string
}
# 登出帐号
.user_logout {
    # 帐号名称
    user_id 0 : string
}
# 登出失败
.user_logout_fail {
    # 错误原因
    desc 0 : string
}
# 玩家被踢掉
.user_kick {
    # 踢掉的原因说明
    desc 0 : string
}
.ping {
    data 0 : integer    #数据会被服务器原样发回
}
