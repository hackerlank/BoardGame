--  集群配置文件，由preload.lua在每个服务启动前加载

_G.conf = _G.conf or {}

--集群节点信息
_G.conf.center_node_info = _G.conf.center_node_info or {
    node_name = "center",
    node_address = "127.0.0.1:2501",
    node_type = "center",
}
