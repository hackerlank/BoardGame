require("ddz_style")
require("poker_color")
require("poker_point")

local ddz_logic = {}

function ddz_logic.get_card_color (card)
    return  math.fmod( card,16 )
end

function ddz_logic.get_card_point(card)
       return math.floor( card/16 )
end        

--是否顺子
function ddz_logic.is_straight( cards )
    -- body
    return false
end   


function ddz_logic.is_plane(cards)

end

--是否三带
function ddz_logic.is_three_add(cards)

end

--是否对子
function ddz_logic.is_pair(cards)

end

--是否炸弹
function ddz_logic.is_bomb(cards)

end    


function ddz_logic.get_cards_style(cards)
    if not cards or #cards == 0 then 
            return ddz_style.none 

    local tmp_count = #cards 

    if  tmp_count == 1 then 
            return ddz_style.single
    elseif tmp_count == 2 then 
        local tmp_point1 = ddz_logic.get_card_point(card[1])
        local tmp_point2 = ddz_logic.get_card_point(card[2])
        

        if  tmp_point1 == tmp_point2
            return ddz_style.pair
        else
             return ddz_style.none   
        end 
    elseif tmp_count ==   3
        local tmp_point1 = ddz_logic.get_card_point(card[1])
        local tmp_point2 = ddz_logic.get_card_point(card[2])
        local tmp_point3 = ddz_logic.get_card_point(card[3])

        if  tmp_point1 == tmp_point2 and tmp_point1 == tmp_point3 then
            return ddz_style.three
        else
            return ddz_style.none   
        end     
    elseif tmp_count ==   4
        local tmp_point1 = ddz_logic.get_card_point(card[1])
        local tmp_point2 = ddz_logic.get_card_point(card[2])
        local tmp_point3 = ddz_logic.get_card_point(card[3])
        local tmp_point4 = ddz_logic.get_card_point(card[4])

        if  tmp_point1 == tmp_point2 and tmp_point1 == tmp_point3 then
            return ddz_style.bomb
        else
            return ddz_style.none   
        end      
    else
        return ddz_logic.get_cards_style_ex(cards)
    end
end

function ddz_logic.get_cards_style_ex(cards)
    if  #cards < 4 then 
        return ddz_style.none
    end    

    local tmp_count = #cards
    local tmp_count_info = ddz_logic.get_cards_count_info(cards)

    

end    

function ddz_logic.get_cards_count_info(cards)
    local tmp_info = {}
    for i,v in ipairs(cards) do 
        if not tmp_info[v] then 
            tmp_info[v] = 1
        else    
         tmp_info[v] = tmp_info[v]+1
        end
    return tmp_info     
end    

return ddz_logic