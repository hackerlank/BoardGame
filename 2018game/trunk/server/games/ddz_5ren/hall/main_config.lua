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
    node_name = "ddz_5ren_hall1",
    node_address = "127.0.0.1:2931",
    node_type = "ddz_5ren_hall",
}

--mysql配置
_G.conf.mysql = _G.conf.mysql or {
    host="127.0.0.1",
    port=3306,
    database="cnc_game",
    user="ccgame",
    password="K1Sk44O2DK#yQHs2",
    max_packet_size = 1024 * 1024,
    on_connect=function (db)
        _G.logic.on_connect(db)
    end
}

--[[
    大厅配置
    hall_name               大厅名称
    hall_type               大厅类型
    hall_desc               大厅说明
    hall_version            大厅版本
    client_version          最小客户端版本

    table_min_users         桌子最小玩家数量
    table_max_users         桌子最大玩家数量
    match_table_time        公共桌子匹配作为时间，单位厘秒
    allow_public_table      允许公共房间，匹配模式
    allow_private_table     允许私有房间，房卡模式
    max_play_record         最多读取录像条数
]]
_G.conf.hall_name = "五人斗地主大厅"
_G.conf.hall_type = "ddz_5ren"
_G.conf.hall_desc = "五人斗地主大厅"
_G.conf.hall_version = 1
_G.conf.client_version = 1

_G.conf.table_min_users = 5
_G.conf.table_max_users = 5
_G.conf.match_table_time = 10*100
_G.conf.allow_public_table = false
_G.conf.allow_private_table = true
_G.conf.private_key_expire_time = 24*60*60*100

_G.conf.max_play_record = 10
