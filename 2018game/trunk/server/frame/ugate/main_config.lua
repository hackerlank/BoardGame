--服务器公共配置参数，这个文件由preload.lua提前加载到服务
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
    node_name = "ugate1",
    node_address = "127.0.0.1:2506",
    node_type = "ugate",
}
-- 用户网关配置
_G.conf.gate_info = _G.conf.gate_info or {
    address = "192.168.50.201",
    port = 3102,
    maxclient = 1024,
    nodelay = true,
}

--玩家存活时间，单位厘秒，默认60秒
_G.conf.user_dead_time = 60*100
--检查死链接时间，默认30秒
_G.conf.check_dead_time = 30*100
