--[[
    炸对子桌子服务全局数据
    这个模块必须最先加载，不然可能导致其他依赖模块无法正常运行
    所有其他模块用到的数据都必须在这里定义
]]

local cc_root = _G.cc_root

--加载公共数据模块
require "common_data"





--[[
    桌子服务全局数据，在game_table_data.lua中声明
    round               桌子当前回合数
    state               桌子当前状态
    left_cards               桌子剩余的牌
    left_cards_num            桌子剩余的牌数量
    table_mode          桌子模式
   
    max_chip_one_turn   单次最大加注数
    max_round           最大回合数
    private_table_cost  私有房间消费房卡
    is_dismiss_table    是否已经开始解散桌子
    is_refund           是否在解散桌子时退款
    dealer              庄家
    turn_user           当前行动的玩家




    record_data         游戏录像数据

    winner              赢家

    current_min_chips      当前最小下注数目
]]
--_G.info = _G.info or {}

--[[
    玩家信息附加数据，在game_table_data.lua中声明
    user.phase_ack       玩家响应行为
    user.hand_cards           玩家牌
    user.hand_cards_num       玩家牌张数
    user.game_state      玩家状态
    user.round_score
    user.total_score

    user.hand_cards_state
    
    user.sorted_cards
    user.niu_point
    user.ex_niu_type

    user.chips          玩家下注数
]]
--_G.user_info = _G.user_info or {}

-- sproto封装api
local spx = _G.spx
-- 扎金花消息编号
_G.game_msg_id = _G.game_msg_id or dofile("../sproto/game.msgid.lua")
-- 扎金花消息协议
_G.game_sproto = _G.game_sproto or spx.parse_file("../sproto/game.sproto")
--通用消息
_G.common_sproto = _G.common_sproto or spx.parse_file(cc_root.."sproto/game.sproto")
