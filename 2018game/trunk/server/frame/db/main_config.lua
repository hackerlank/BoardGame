--全局配置文件，由preload.lua加载
_G.conf = _G.conf or {}

--中心服务器节点
_G.conf.center_node_info = _G.conf.center_node_info or {
    node_id = 1,
    node_name = "center",
    node_address = "127.0.0.1:2501",
    node_type = "center",
}
--本度集群节点信息
_G.conf.self_node_info = _G.conf.self_node_info or {
    node_name = "db",
    node_address = "127.0.0.1:2502",
    node_type = "db",
}

--mysqld配置
_G.conf.mysqld = _G.conf.mysqld or {
    min_pool_size = 10,
    check_db_time = 5*60*100,
    config = {
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
}

--redis配置
_G.conf.redis = {
    host = "127.0.0.1",
    port = 6377,
    db   = 0,
    auth = "123789",
}

--微信配置
_G.conf.weixin = _G.conf.weixin or {
    -- app id
    appid = "wx8e7a6832f6b2e182",
    -- app 密匙
    secret = "78c9f6660658ca07a970990f6a4e3b7f",
    -- 商户编号
    mch_id = "1489415012",
    -- 商户密匙
    key = "LIRVtqlXrLdKLSg0L9lOZ0mYeSGLNBR5",
    -- 支付结果通知url
    notify_url = "http://myyxt.top:8080/weixin_pay_result",
    -- 支付超时
    pay_timeout = 5*60,
    -- 通知回掉httpd路径
    pay_notify_path = "/weixin/pay_order",

    -- code登录url
    auth_code_url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code",
    -- 验证url
    verify_token_url = "https://api.weixin.qq.com/sns/auth?access_token=%s&openid=%s",
    -- 获取用户信息url
    user_info_url = "https://api.weixin.qq.com/sns/userinfo?access_token=%s&openid=%s",
    -- 刷新令牌
    refresh_token_url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wxcd3a9a8ef9081e16&grant_type=refresh_token&refresh_token=%s",
    -- 预支付
    unified_order_url = "https://api.mch.weixin.qq.com/pay/unifiedorder",
    -- 微信支付结果通知网址
    pay_notify_url = "https://api.mch.weixin.qq.com/pay/unifiedorder",
}

-- 玩家初始游戏币
_G.conf.newbie_money = _G.conf.newbie_money or 1000
-- 玩家初始房卡
_G.conf.newbie_room_card = _G.conf.newbie_room_card or 10
-- 注册名字单词过滤
_G.conf.world_filter = _G.conf.world_filter or {
    "~","!","@","#","$","%","^","&","*","(",")","-","_","+","=","[","]","{","}","\\","|",";",":","'","\"",
    ",",".","<",">","/","?"," "
}
