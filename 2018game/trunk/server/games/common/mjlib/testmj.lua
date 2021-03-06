package.path = package.path..";../../../lualib/?.lua"
local mj_logic = require("mj_logic")
local print_r = require("print_r")

local test_cards = {
    --测试花猪
    {{},{},{11,12,13,14,15,16,37,38,39,21,22,23,24,24},false},
    {{11},{},{14,15,16,37,38,39,21,22,23,24,24},false},
    {{},{11},{14,15,16,37,38,39,21,22,23,24,24},false},
    --测试清一色
    {{},{},{11,12,13,14,15,16,17,17,17,18,18,18,19,19},true,"is_qing_yi_se",true},
    {{11},{},{14,15,16,17,17,17,18,18,18,19,19},true,"is_qing_yi_se",true},
    {{},{11},{14,15,16,17,17,17,18,18,18,19,19},true,"is_qing_yi_se",true},
    --测试普通
    {{},{},{11,12,13,14,15,16,17,18,19,21,22,23,24,24},true},
    {{},{},{11,12,13,14,15,16,17,18,19,22,22,22,24,24},true},
    {{},{},{33,33,33,34,34,34,34,35,35,35,35,36,36,36},true},
    {{},{},{36,36,35,35,35,35,33,33,33,25,25},false},
    --测试带根
    {{},{},{11,11,11,11,12,13,16,17,18,21,22,23,24,24},true,"gen",1},
    {{25},{15},{11,11,11,11,12,13,16,17,18,24,24},true,"gen",2},
    {{},{11},{14,15,16,17,18,19,21,22,23,24,24},true,"gen",1},
    {{},{11,13},{17,18,19,21,22,23,24,24},true,"gen",2},
    --测试七对
    {{},{},{11,11,12,12,13,13,14,14,15,15,16,16,17,17},true,"is_qi_dui",true},
    {{},{},{11,11,12,12,13,13,14,14,15,15,16,16,27,27},true,"is_qi_dui",true},
    {{},{},{11,11,12,12,13,13,14,14,15,15,16,16,17,17},true,"is_qi_dui",true},
    {{},{},{11,11,11,11,13,13,14,14,15,15,16,16,19,19},true,"is_qi_dui",true},
    {{},{},{11,11,11,11,13,13,14,14,15,15,16,16,17,17},true,"is_qi_dui",true},
    {{},{},{11,11,11,11,22,22,22,22,23,23,23,23,26,26},true,"is_qi_dui",true},
    {{},{},{11,11,11,11,22,22,22,22,23,23,23,23,26,27},false},
    {{},{},{11,11,12,12,13,13,14,14,15,15,16,16,17,19},false},
    {{},{13,14},{15,15,16,16,17,17},false},
    {{},{11},{13,13,14,14,15,15,16,16,17,17},false},
    --(对对胡)大对子
    {{},{},{11,11,11,12,12,12,23,23,23,24,24,24,25,25},true,"is_dui_dui_hu",true},
    {{},{},{11,11,11,12,12,12,23,23,23,24,24,24,25,28},false},
    --带幺九
    {{},{},{11,12,13,14,15,16,17,18,19,21,22,23,24,24},true,"is_dai_yao_jiu",false},
    {{},{},{11,12,13,11,12,13,17,18,19,17,18,19,19,19},true,"is_dai_yao_jiu",true},
    {{},{},{11,11,11,12,13,21,22,23,17,18,19,27,28,29},true,"is_dai_yao_jiu",true},
    {{},{},{11,11,11,11,12,13,21,22,23,17,18,19,29,29},true,"is_dai_yao_jiu",true},
    {{11},{},{11,12,13,17,18,19,17,18,19,19,19},true,"is_dai_yao_jiu",false},
    {{},{11},{12,13,14,17,18,19,17,18,19,19,19},true,"is_dai_yao_jiu",false},
    --将对
    {{},{},{15,15,15,12,12,12,28,28,28,22,22,22,25,25},true,"is_jiang_dui",true},
    {{},{},{15,15,15,15,12,12,28,28,22,22,22,22,25,25},true,"is_jiang_dui",false},
    {{},{},{11,11,11,12,12,12,28,28,28,22,22,22,25,25},true,"is_jiang_dui",false},
    --将七对
    {{},{},{15,15,15,15,12,12,28,28,22,22,22,22,25,25},true,"is_jiang_qi_dui",true,true},
    {{},{},{15,15,15,15,12,12,28,28,22,22,22,22,25,25},true,"is_jiang_qi_dui",true},
    {{},{},{11,11,12,12,15,15,28,28,22,22,18,18,25,25},true,"is_jiang_qi_dui",false},
    --中张
    {{},{},{13,13,12,12,15,15,28,28,22,22,18,18,25,25},true,"is_zhong_zhang",true},
    {{},{},{15,15,15,12,12,12,23,23,23,24,24,24,25,25},true,"is_zhong_zhang",true},
    {{},{},{11,11,11,12,12,12,23,23,23,24,24,24,25,25},true,"is_zhong_zhang",false},
    {{},{},{11,11,12,12,15,15,28,28,22,22,18,18,25,25},true,"is_zhong_zhang",false},
}

_G.mj_rule.ding_que = true

--测试胡牌验证
local function test_hu()
    local unmatched_num = 0
    for i,v in pairs(test_cards) do
        local peng_cards = v[1]
        local gang_cards = v[2]
        local hand_cards = v[3]
        local pre_ok=v[4]
        local fan_type = v[5]
        local fan_value = v[6]
        local detail = v[7]

        local hu_info = mj_logic.get_hu_info(peng_cards,gang_cards,hand_cards)
        local hand_info = mj_logic.analyse_cards(hand_cards)
        if hu_info.is_hu then
            mj_logic.check_qing_yi_se(hu_info,hand_info,hand_cards,peng_cards,gang_cards)
            mj_logic.check_gen(hu_info,hand_info,hand_cards,peng_cards,gang_cards)
            mj_logic.check_dui_dui_hu(hu_info,hand_info,hand_cards,peng_cards,gang_cards)
            mj_logic.check_dai_yao_jiu(hu_info,hand_info,hand_cards,peng_cards,gang_cards)
            mj_logic.check_jiang_dui(hu_info,hand_info,hand_cards,peng_cards,gang_cards)
            mj_logic.check_jiang_qi_dui(hu_info,hand_info,hand_cards,peng_cards,gang_cards)
            mj_logic.check_zhong_zhang(hu_info,hand_info,hand_cards,peng_cards,gang_cards)
           -- mj_logic.calc_hu_info({enable_yjjd = true,enable_mqzz = true},hand_cards,peng_cards,gang_cards)
        end

        if detail then
            print_r(hu_info)
        end

        if hu_info.is_hu~=pre_ok then
            print("unmatched",i)
            print("peng_cards",mj_logic.get_cards_s(peng_cards))
            print("gang_cards",mj_logic.get_cards_s(gang_cards))
            print("hand_cards",mj_logic.get_cards_s(hand_cards))
            print("preok",pre_ok)
            print_r(hu_info)
            print("")
            unmatched_num = unmatched_num+1
        else
            if hu_info.is_hu then
                if fan_type and (hu_info[fan_type]~=fan_value) then
                    print("unmatched",i)
                    print("peng_cards",mj_logic.get_cards_s(peng_cards))
                    print("gang_cards",mj_logic.get_cards_s(gang_cards))
                    print("hand_cards",mj_logic.get_cards_s(hand_cards))
                    print("preok",pre_ok)

                    print("expect fan_type",fan_type,"fan_value",fan_value,"now",hu_info[fan_type])
                    print(mj_logic.get_cards_s(hand_cards),pre_ok)
                    print_r(hu_info)

                    print("hand_info")
                    print_r(hand_info)

                    print("")
                    unmatched_num=unmatched_num+1
                end
            end
        end
    end

    print("all done,unmatched",unmatched_num)
end
--测试删除
local function test_rm_cards()
    local cards = {11,12,12,13,15,17,19,19,19}
    local rcs = {11,13,17,19,19}
    local dst = mj_logic.remove_cards(cards,rcs)
    print("cards",mj_logic.get_cards_s(cards))
    print("rcs",mj_logic.get_cards_s(rcs))
    print("dst",mj_logic.get_cards_s(dst))
end
--测试加入牌
local function test_add_cards()
    local cards = {11,12,12,13,15,17,19,19,19}
    local acs = {11,13,17,19}
    print("cards",mj_logic.get_cards_s(cards))
    mj_logic.add_cards(cards,acs)
    print("cards",mj_logic.get_cards_s(cards))
    print("acs",mj_logic.get_cards_s(acs))
end
--测试一组索引指定的牌
local function test_index_cards()
    local cards = {11,12,12,13,15,17,19,19,19}
    local indexs = {1,3,4,7,9}
    local dst = mj_logic.get_index_cards(cards,indexs)
    print("cards",mj_logic.get_cards_s(cards))
    print("indexs",mj_logic.get_cards_s(indexs))
    print("dst",mj_logic.get_cards_s(dst))
end


local function test_gang()
        local hand_cards = {11,11,11,11,21} 
        local table_cards = 11
        local peng_cards = {}
        local draw_cards = 11

        print("test can peng , must be true, result is :" ..tostring(mj_logic.check_can_gang(hand_cards,peng_cards,draw_cards)))

        local hand_cards2 = {11,11,11,21,22} 
        --local table_cards = 11
        local peng_cards2 = {}
        local draw_cards2 = 11

    print("test can peng , must be false, result is :" ..tostring(mj_logic.check_can_gang(hand_cards2,peng_cards2,draw_cards2)))
end

local function main()
        test_hu()
    --test_gang()
end
main()