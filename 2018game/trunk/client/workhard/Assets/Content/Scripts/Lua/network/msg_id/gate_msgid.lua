-- 网关服务消息编号定义
return {
    -- c2s玩家登录 body user_login
    user_login = 1,
    -- s2c玩家登录失败 body user_login_fail
    user_login_fail = 2,
    -- s2c玩家登录成功 body user_login_ok
    user_login_ok = 3,
    -- c2s玩家登出 body user_logout
    user_logout = 5,
    -- s2c玩家登出失败 body user_logout_fail
    user_logout_fail = 6,
    -- s2c玩家登出成功 body none
    user_logout_ok = 7,
    -- s2c玩家被踢掉 body user_kick
    user_kick = 10,
    -- 心跳包，服务器收到封包后原样发回客户端,body ping
    ping    = 11,
}
