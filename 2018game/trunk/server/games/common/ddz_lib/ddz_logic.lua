package.path = package.path..";../../../lualib/?.lua"
require("ddz_style")
require("poker_color")
require("poker_point")
require("math")
local min_straight_length =5
local min_straight_pair_length =3
local min_straight_three_length = 2

local print_r=require("print_r")


local ddz_logic = {}

	local cmp_func = function(cardA,cardB)
		if cardA.point ~= cardB.point then
		return cardA.point<cardB.point
		else
			return cardA.color<cardB.color
		end
	end	

function ddz_logic.sort_cards(cards)
	local tmp_result = {}
	for i,v in ipairs(cards) do 
		table.insert(tmp_result,{color = v.color,point = v.point})
	end	



	table.sort(tmp_result,cmp_func)

	return tmp_result
end

function ddz_logic.get_card_color (card)
    return  math.fmod( card,16 )
end

function ddz_logic.get_card_point(card)
       return math.floor( card/16 )
end        

--info key is count ,value is a table of sorted cards.
function ddz_logic.get_count_info(cards)
        local tmp_info = {}
        local max_count,num
        max_count = 1
        num = 0
        for i,v in ipairs(cards)  do 
                local tmp_point = v.point
                if not tmp_info[tmp_point] then
                    tmp_info[tmp_point] = 1
                else
                    tmp_info[tmp_point] = tmp_info[tmp_point]+1
                end        
        end

        
        local tmp_result = {}
        for k,v in pairs(tmp_info) do 
            if not tmp_result[v] then
              tmp_result[v] = {k}
              if v>max_count then 
                max_count = v
              end  
            else
                table.insert(tmp_result[v],k)
            end    

        end

        for k,v in pairs(tmp_result) do 
            num = num+1
               table.sort(v) 
        end

        return tmp_result, max_count,num

end



--是否顺子
function ddz_logic.is_straight(cards, count_info,max_count,num )
    -- body
    if num~=1 then
         return false
    elseif #cards <min_straight_length then
        return false
    elseif max_count~=1 then
        return false
    else
        for k,v in pairs(count_info) do 
                for i=1,#v-1 do 
                    if v[i+1] - i ~=1 then 
                        return false
                    end    
                end
        end
    end

    return true
end   

function ddz_logic.is_straight_pair(cards,count_info,max_count,num)
    if num~=1 then
         return false
    elseif #cards <min_straight_pair_length then
        return false
    elseif max_count~=2 then 
        return false
    else
        for k,v in pairs(count_info) do 
                for i=1,#v-1 do 
                    if v[i+1] - i ~=1 then 
                        return false
                    end    
                end
        end
    end

    return true
end

function ddz_logic.is_straight_three(cards,count_info,max_count,num)
    if num~=1 then
         return false
    elseif #cards <min_straight_three_length then
        return false
    elseif max_count~=3 then 
        return false
    else
        for k,v in pairs(count_info) do 
                for i=1,#v-1 do 
                    if v[i+1] - i ~=1 then 
                        return false
                    end    
                end
        end
    end

    return true
end

function ddz_logic.is_plane(cards,count_info,max_count,num)
    print("check plane start")
    local tmp_total_count = #cards
    if tmp_total_count < 8 or max_count<3 then
        print("wrong total when check plane")
         return false
    elseif  math.fmod(tmp_total_count,4)~=0  then
        print("wrong total for 4 when check plane")
        return false   
    else
        --find >=3 
        local tmp_cards = {}
        for k,v in pairs(count_info) do 
            if k>=3 then 
                for _,v1 in ipairs(v) do
                    table.insert(tmp_cards,v1)
                end
            end
        end 

        local tmp_three_count =#tmp_cards 
   
        table.sort(tmp_cards)
        local tmp_max_straight_count =1
        local tmp_current_count = 1
        print_r(tmp_cards)
        for i=1,#tmp_cards-1  do 
            if tmp_cards[i+1] - tmp_cards[i] ~=1 then 
               
                tmp_current_count = 1
            else
                 tmp_current_count = tmp_current_count+1 
                 if tmp_current_count>tmp_max_straight_count then 
                    tmp_max_straight_count = tmp_current_count
                 end      
            end
        end        
        
        print("max sc is :"..tmp_max_straight_count)
        if tmp_max_straight_count *4 >= tmp_total_count then
            return true
        else
            return false
        end        

    end
    return true     

end

function ddz_logic.is_three(cards,count_info,max_count,num)
    if max_count == 3 and num ==1 and #cards == 3 then
        return true
    else
        return false
    end        
end

--是否三带
function ddz_logic.is_three_and_one(cards,count_info,max_count,num)
    if max_count == 3 and num ==2 and #cards == 4 then 
        return true
    else
        return false
    end        
end

--
function ddz_logic.is_single(cards)
    if #cards == 1 then 
        return true
    else
        return false
    end        
end

--是否对子
function ddz_logic.is_pair(cards,count_info,max_count,num)
    if max_count == 2 and num ==1 and #cards==2 then
        return true
    else
        return false
    end        
end

--是否炸弹
function ddz_logic.is_bomb_4(cards,count_info,max_count,num)
    if max_count == 4 and num ==1 and #cards == 4 then
        return true
    else
        return false
    end        
end    

function ddz_logic.is_bomb_8(cards,count_info,max_count,num)
    if max_count == 8 and num ==1 and #cards == 8 then
        return true
    else
        return false
    end         
end


function ddz_logic.get_cards_style(cards)
    
end

   


return ddz_logic