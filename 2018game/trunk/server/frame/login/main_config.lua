--全局配置文件，由preload.lua加载
_G.conf = _G.conf or {}

--中心服务器节点
_G.conf.center_node_info = _G.conf.center_node_info or {
    node_id = 1,
    node_name = "center",
    node_address = "127.0.0.1:2501",
    node_type = "center",
}
--集群节点信息
_G.conf.self_node_info = _G.conf.self_node_info or {
    node_name = "login",
    node_address = "127.0.0.1:2504",
    node_type = "login",
}
