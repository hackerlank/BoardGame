package.path = package.path..";../../../lualib/?.lua"
local ddz_logic = require("ddz_logic")
local print_r = require("print_r")

local poker_color = require ("poker_color")
local poker_point =require ("poker_point")

local ddz_style = require ("ddz_style")

local cards = { {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_H,point =poker_point.point_5  },
        {color=poker_color.color_D,point =poker_point.point_5  },{color=poker_color.color_S,point =poker_point.point_2  },
        {color=poker_color.color_H,point =poker_point.point_2  },{color=poker_color.color_S,point =poker_point.point_5  } }

--print_r(ddz_logic.get_count_info(cards))

local testfunc={}

testfunc[ddz_style.single]=ddz_logic.is_single
testfunc[ddz_style.pair] = ddz_logic.is_pair
testfunc[ddz_style.three] = ddz_logic.is_three
testfunc[ddz_style.straight] =ddz_logic.is_straight
testfunc[ddz_style.straight_pair] = ddz_logic.is_straight_pair
testfunc[ddz_style.straight_three] = ddz_logic.is_straight_tree
testfunc[ddz_style.plane] = ddz_logic.is_plane
testfunc[ddz_style.three_and_one] = ddz_logic.is_three_and_one
testfunc[ddz_style.bomb_4] = ddz_logic.is_bomb_4
testfunc[ddz_style.bomb_8] = ddz_logic.is_bomb_8


local function get_cards_style (cards)
     local tmp_info,tmp_max,tmp_num =    ddz_logic.get_count_info(cards)
                print_r(tmp_info)
     for k,tmp_fun in pairs(testfunc) do 
        if not tmp_fun then
                print("no func for :"..k) 
        end        
        if tmp_fun(cards,tmp_info,tmp_max,tmp_num) then 
                return k
        end
     end

     return 0           
end
   
 local cards2 = { {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_H,point =poker_point.point_5  },
        {color=poker_color.color_D,point =poker_point.point_5  },{color=poker_color.color_S,point =poker_point.point_2  },
         }
  

local tmp_test_cards ={}

tmp_test_cards[ddz_style.plane] = {
       {color=poker_color.color_S,point =poker_point.point_5  } ,{color=poker_color.color_H,point =poker_point.point_5  },
        {color=poker_color.color_D,point =poker_point.point_5  },{color=poker_color.color_S,point =poker_point.point_7  },
        {color=poker_color.color_H,point =poker_point.point_7  },{color=poker_color.color_C,point =poker_point.point_7  },
        {color=poker_color.color_D,point =poker_point.point_8  },{color=poker_color.color_S,point =poker_point.point_8  },
          {color=poker_color.color_H,point =poker_point.point_8  },{color=poker_color.color_S,point =poker_point.point_9  },
          {color=poker_color.color_C,point =poker_point.point_9  },{color=poker_color.color_D,point =poker_point.point_9 },
}

for k,v in pairs(tmp_test_cards) do 
        local tmp = get_cards_style(v) 
        if tmp~= k then 
                print("test failed ,style is :"..k.."  result is :"..tmp)
        else
                
        end        

        print("test ok ")
end
