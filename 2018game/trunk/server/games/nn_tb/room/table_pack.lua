-- 炸对子桌子服务网络封包处理函数集
-- 这组函数只对用户信息合法性进行判断，不做逻辑判断
local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register

local log = require("cc_log")

local phase_ack = _G.phase_ack

local logic = _G.logic
local sender = _G.sender

local spx = _G.spx
local game_msg_id = _G.game_msg_id
local game_sproto = _G.game_sproto

local table_state = _G.table_state
local conf = _G.conf
local info = _G.info
local user_list = _G.user_list
local pack = _G.pack
local pack_map = _G.pack_map
local command = _G.command

-- 玩家准备好
function pack.user_ready(np)
    local user_id = np.user_id

    log.debug("pack.user_ready(),user_id",user_id)

    local user = user_list[user_id]
    if not user then
        log.error("pack.user_ready(),user_id",user_id,"is not found")
        return
    end
    logic.user_is_ready(user)
end



function pack.req_start_round(np)
    local user_id = np.user_id
    print("pack.req_start_round,user_id",user_id)

    local user = user_list[user_id]
   if not user then
        print("user_id",user_id,"not found")
        return
    end  
    logic.user_start_round(user)
end
function pack.req_start_game(np)
    local user_id = np.user_id
    print("pack.req_start_game,user_id",user_id)

    local user = user_list[user_id]
   if not user then
        print("user_id",user_id,"not found")
        return
    end  
    logic.user_restart_game(user)    
end
function pack.req_quit_game(np)
    local user_id = np.user_id
    print("pack.req_quit_game,user_id",user_id)
end

function pack.req_open_cards(np)
    local user_id = np.user_id
    local user = user_list[user_id]
   if not user then
        print("user_id",user_id,"not found")
        return
    end 
   
    logic.req_open_cards(user)

end

function pack.owner_req_start_game(np)
    local user_id = np.user_id
    print("pack.owner_req_start_game,user_id",user_id)

    local user = user_list[user_id]
   if not user then
        print("user_id",user_id,"not found")
        return
    end  
    logic.owner_req_start_game(user)
end

function pack.owner_req_start_round(np)
    local user_id = np.user_id
    print("pack.owner_req_start_round,user_id",user_id)

    local user = user_list[user_id]
   if not user then
        print("user_id",user_id,"not found")
        return
    end  
    logic.owner_req_start_round(user)
end

-- 关联消息处理函数
pack_map[game_msg_id.req_start_round]                = pack.req_start_round
pack_map[game_msg_id.req_start_game]                = pack.req_start_game                                                
pack_map[game_msg_id.owner_req_start_round]                = pack.owner_req_start_round    
--pack_map[game_msg_id.owner_req_start_game]                = pack.owner_req_start_game  
pack_map.register(game_msg_id.owner_req_start_game,       pack.owner_req_start_game)
pack_map.register(game_msg_id.req_ready,       pack.user_ready)

pack_map.register(game_msg_id.req_open_cards,    pack.req_open_cards)
                                               

