--游戏规制信息验证
local tonumber = _G.tonumber
local toboolean = require("toboolean")

--[[
    规则信息，规定各个字段的合法范围
    table_mode          桌子模式（一般，翻倍，疯狂）
    max_round           局数
    pay_room_card       局数扣除的房卡数量，和max_round一一对应
    base_chip            用户下注基数
    pay_mode            谁支付房卡
    start_game_mode     开始游戏的模式。人满开或者房主开
    enable_flush         是否支持同花顺
    enable_straight          是否支持顺子牛
    enable_suited        是否支持同花牛
    enbale_five_big     是否支持五花牛
    enable_five_small   是否支持五小牛
    enable_full_house   是否支持葫芦牛
    enable_bomb         是否支持炸弹牛
    

]]
local game_rule = {
    table_mode          = {1,2,3},
    max_round           = {5,10,15,20},
    pay_room_card       = {5,20,30,40},
    pay_mode            = {1,2,3,4},
    base_chip           = {10,20,100},
    start_game_mode     =   {1,2},
    enable_flush        = {true,false},
    enable_straight          ={true,false},
    enable_suited        = {true,false},
    enbale_five_big        = {true,false},
    enable_five_small        = {true,false},
    enable_full_house        = {true,false},
    enable_bomb        = {true,false},
}

--规则转换工具
local rule_parser = {
    table_mode           = tonumber,
    max_round           = tonumber,
    pay_room_card       = tonumber,
    pay_mode            = tonumber,
    start_game_mode     = tonumber,
    base_chip           = tonumber,
    enable_flush        = toboolean,
    enable_straight          =toboolean,
    enable_suited        = toboolean,
    enbale_five_big     = toboolean,
    enable_five_small     = toboolean,
    enable_full_house     = toboolean,
    enable_bomb     = toboolean,
}

--要检查的规则和错误提示
local rule_error = {
    table_mode          = "没有正确设置：游戏模式",
    max_round           = "没有正确设置：局数",
    pay_room_card       = "没有正确设置：局数对应支付的房卡数",
    pay_mode            = "没有正确设置：谁支付房卡",
    base_chip            = "没有正确设置：下注分数",
    --start_game_mode     = "没有正确设置：开始游戏方式",
   
}

--检查某个值是否表的成员，失败返回error
function game_rule.assert_is_member(rules,k_)
    local v_ = rules[k_]
    if not v_ then
        return error(rule_error[k_] or "游戏规则没有设置：["..k_.."]")
    end

    local parser = rule_parser[k_]
    if not parser then
        return error(rule_error[k_] or "游戏规则转换错误：["..k_.."]")
    end

    local rule = game_rule[k_]
    if not rule then
        return error(rule_error[k_] or "游戏规则没有配置：["..k_.."]")
    end

    local _v = parser(v_)

    for _,v in pairs(rule) do
        if v==_v then
            return
        end
    end
    return error(rule_error[k_] or "游戏规则设置错误：["..k_.."]")
end

--验证规则合法性
function game_rule.verify(rules)
    for k,v in pairs( rules) do
            print("rule is : key :"..tostring(k).."  and  value:"..v)
    end

    return pcall(function ()
        game_rule.assert_is_member(rules,"table_mode")

        game_rule.assert_is_member(rules,"max_round")

        game_rule.assert_is_member(rules,"pay_room_card")
        
        game_rule.assert_is_member(rules,"pay_mode")

        game_rule.assert_is_member(rules,"base_chip")

       -- game_rule.assert_is_member(rules,"start_game_mode")
       
        return true
    end)
end

--得到私有桌子消费房卡数量，rules已经经过verify验证
function game_rule.get_private_table_cost(rules)
    local max_round = tonumber(rules.max_round)

    for i,v in pairs(game_rule.max_round) do
        if v==max_round then
            return game_rule.pay_room_card[i]
        end
    end

    return nil
end

return game_rule
