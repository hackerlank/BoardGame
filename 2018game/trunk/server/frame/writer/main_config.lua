--全局配置文件，由preload.lua加载
_G.conf = _G.conf or {}

--mysql配置
_G.conf.mysql = _G.conf.mysql or {
    host="127.0.0.1",
    port=3306,
    database="cnc_auth",
    user="ccgame",
    password="K1Sk44O2DK#yQHs2",
    max_packet_size = 1024 * 1024,
    on_connect=function (db)
        db:query("set charset utf8mb4")
    end
}

--redis配置
_G.conf.redis = {
        host = "127.0.0.1",
        port = 6377,
        db   = 0,
        auth = "123789",
}

--多久刷新一次用户数据，单位1/100秒
_G.conf.flush_user_time = 100*100
