-- 全局配置文件，由preload.lua加载
_G.conf = _G.conf or {}

-- 中心服务器节点
_G.conf.center_node_info = _G.conf.center_node_info or {
    node_id = 1,
    node_name = "center",
    node_address = "127.0.0.1:2501",
    node_type = "center",
}
-- 本度集群节点信息
_G.conf.self_node_info = _G.conf.self_node_info or {
    node_name = "plaza",
    node_address = "127.0.0.1:2503",
    node_type = "plaza",
}

-- 房间号过期时间
_G.conf.private_key_expire_time = 24*60*60*100

-- 大厅网页服务路径
_G.conf.backstage = _G.conf.backstage or {
    get_hall_list = "/backstage/plaza/get_hall_list",
    get_hall_info = "/backstage/plaza/get_hall_info",
}
