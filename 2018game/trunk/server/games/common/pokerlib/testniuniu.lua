package.path = package.path..";../../../lualib/?.lua"
local niuniu_logic = require("niuniu_logic")
local print_r = require("print_r")

local poker_color = require ("poker_color")
local poker_point =require ("poker_point")

local niu_style = require ("niu_style")

local cards = { {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_H,point =poker_point.point_5  },
        {color=poker_color.color_D,point =poker_point.point_5  },{color=poker_color.color_S,point =poker_point.point_2  },
        {color=poker_color.color_H,point =poker_point.point_2  }}

  

 local num,split_cards =  niuniu_logic. splitNiuCards(cards)     


--print("niu num  is :"..num)
local tmp_three = split_cards[1] 
local tmp_two = split_cards[2]
-- print("split result is :")
  --  print("three card is :")
    for i,v in ipairs(tmp_three)    do 
       -- print ("color:"..v.color.."  point:"..v.point)
    end
    --print ("tow card is:")
     for i,v in ipairs(tmp_two)    do 
        --print ("color:"..v.color.."  point:"..v.point)
    end       


local sorted = niuniu_logic.sort_cards(cards)

    for i,v in ipairs(sorted)    do 
        --print ("color:"..v.color.."  point:"..v.point)
    end

local tmp_info = niuniu_logic.  count_cards(cards)

for k,v in pairs(tmp_info) do 
    --print("key is :"..k .."  and v is :"..v )
 end   

if niuniu_logic.is_full_house(tmp_info) then 
   -- print("cards is full_house")
else
   -- print("cards is not full_house")
end

local test_cards = {}
--test_cards[niu_style.niuniu]={ {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_H,point =poker_point.point_5  },
  --      {color=poker_color.color_D,point =poker_point.point_6  },{color=poker_color.color_S,point =poker_point.point_2  },  {color=poker_color.color_H,point =poker_point.point_2  }}

test_cards[niu_style.straight]={ {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_S,point =poker_point.point_6  },
        {color=poker_color.color_D,point =poker_point.point_7  },{color=poker_color.color_C,point =poker_point.point_8  },  {color=poker_color.color_S,point =poker_point.point_9  }}

test_cards[niu_style.suited]={ {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_S,point =poker_point.point_7  },
        {color=poker_color.color_S,point =poker_point.point_K  },{color=poker_color.color_S,point =poker_point.point_2  },  {color=poker_color.color_S,point =poker_point.point_A  }}

test_cards[niu_style.full_house]={ {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_H,point =poker_point.point_5  },
        {color=poker_color.color_D,point =poker_point.point_5  },{color=poker_color.color_S,point =poker_point.point_2  },  {color=poker_color.color_H,point =poker_point.point_2  }}

test_cards[niu_style.five_big]={ {color=poker_color.color_S,point =poker_point.point_J  } ,{color=poker_color.color_H,point =poker_point.point_J  },
        {color=poker_color.color_D,point =poker_point.point_Q  },{color=poker_color.color_C,point =poker_point.point_Q  },  {color=poker_color.color_H,point =poker_point.point_Q  }}

test_cards[niu_style.bomb]={ {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_H,point =poker_point.point_5  },
        {color=poker_color.color_D,point =poker_point.point_5  },{color=poker_color.color_C,point =poker_point.point_5  },  {color=poker_color.color_H,point =poker_point.point_A  }}

test_cards[niu_style.five_small]={ {color=poker_color.color_S,point =poker_point.point_4  } ,{color=poker_color.color_H,point =poker_point.point_2  },
        {color=poker_color.color_D,point =poker_point.point_A  },{color=poker_color.color_S,point =poker_point.point_2  },  {color=poker_color.color_H,point =poker_point.point_A  }}

test_cards[niu_style.flush]={ {color=poker_color.color_S,point =poker_point.point_8  } ,{color=poker_color.color_S,point =poker_point.point_9  },
        {color=poker_color.color_S,point =poker_point.point_10  },{color=poker_color.color_S,point =poker_point.point_J  },  {color=poker_color.color_S,point =poker_point.point_Q  }}

local test_funcs= {}

test_funcs[niu_style.straight] = niuniu_logic.is_straight
test_funcs[niu_style.suited] = niuniu_logic.is_suited
test_funcs[niu_style.full_house] = niuniu_logic.is_full_house
test_funcs[niu_style.five_big] = niuniu_logic.is_five_big
test_funcs[niu_style.bomb] = niuniu_logic.is_bomb
test_funcs[niu_style.five_small] = niuniu_logic.is_five_small
test_funcs[niu_style.flush] = niuniu_logic.is_flush

local function get_ex_type(five_cards)
    local tmp_point = niuniu_logic.splitNiuCards(five_cards)

    if tmp_point>0 then 

        local tmp_sorted = niuniu_logic.sort_cards(five_cards)
        local tmp_type = 0
        for k,tmp_func in pairs(test_funcs) do 
                if tmp_func(tmp_sorted) then 
                    if k >tmp_type then 
                        tmp_type = k
                    end
                end        
        end

        if tmp_type == 0 and tmp_point == 10 then 
              tmp_type =   niu_style.niuniu
        end
        return tmp_type

    else 
        if test_funcs[niu_style.flush] then 
            local tmp_sorted = niuniu_logic.sort_cards(five_cards)
            if  test_funcs[niu_style.flush](tmp_sorted) then 
                    return niu_style.flush
            else
                  
            end
        else

        end

        return 0      
    end
end

for k,v in pairs(test_cards) do 
        if k == get_ex_type(v) then 
            print("check success ... k is :"..k)
        else
            print("check failed ... k is :"..k)

        end
end 

--local tmp_niu = tmp_func(test_cards[niu_style.niuniu])
--print("test cards 1 result is :"..tmp_niu)