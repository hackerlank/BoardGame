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
    node_name = "agent",
    node_address = "127.0.0.1:2508",
    node_type = "agent",
}
