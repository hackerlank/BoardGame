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
    node_name = "httpd",
    node_address = "127.0.0.1:2507",
    node_type = "httpd",
}

-- httpd配置信息
_G.conf.httpd = _G.conf.httpd or {
    address = "0.0.0.0",
    port = "8081",
    host = "runger.net",
    password = "123789abc"
}
