-- 一般游戏逻辑函数
local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register
local math = require "math"
local sprint_r = require"sprint_r"
local log = require "cc_log"
local clustersend = require "clustersend"
local niuniu_logic = require "niuniu_logic"
local card_color = require"poker_color"
local card_point = require "poker_point"

--local mj_cards_maker = require"real_mj_card"

local table_mode = _G.table_mode
local user_act = _G.user_act
local turn_type = _G.turn_type


local log = require("cc_log")
local spx = _G.spx
local game_msg_id = _G.game_msg_id
local game_sproto = _G.game_sproto

--桌子状态
local table_state = _G.table_state
--桌子信息
local info = _G.info
local conf = _G.conf
--玩家列表
local user_list = _G.user_list

local logic = _G.logic
local sender = _G.sender
local pack = _G.pack
local pack_map = _G.pack_map
local command = _G.command
local aux = _G.aux
local  user_game_state = _G.user_game_state

logic.ex_niu_funcs = {}

function logic.make_card(color,point)
    return color*16+point
end
--生成桌面的牌
function logic.init_left_cards()
    local t = {}

    for color=1,4 do
        for point=1,13 do
                table.insert(t,logic.make_card(color,point))
        end
    end

    return t

end
-- 洗牌
function logic.shuffle(cards)
    local t = cards
    local n=#t
    local x
    for i=1,n-1 do
        x=math.random(i+1,n)
        t[i],t[x]=t[x],t[i]
    end
end


-- 重置玩家动作user_act.none
function logic.reset_all_act()
    for _,user in pairs(info.users) do
        user.user_act=user_act.none
    end
end
--玩家离开桌子
function logic.user_left_table(user)
    local user_id = user.user_id
    local seat_id = user.seat_id

    log.info("logic.user_left_table(),user_id",user.user_id,"seat_id",seat_id)

    --取消监听玩家离线事件
    pcall(clustersend,user.gate_service,"remove_watcher",user_id,info.table_service)

    user_list[user_id] = nil
    info.users[seat_id] = nil
    info.user_num=info.user_num-1
    user.seat_id = 0

    pcall(skynet.call,info.room_service_id,"lua","user_left_table",user.user_id)

    sender.send_user_left_table(user)

    log.info("user left table,user_id",user_id,"seat_id",seat_id,"info.user_num",info.user_num)
end
-- 游戏开始，所有数据全部回复初始值
function logic.game_start()
    log.info("logic.game_start")
    command.cancel_timer()

    info.state=table_state.game_start

    --for record 


    --复位桌子服务数据
    info.round = 0
    info.state = table_state.game_start
   
    info.dealer = nil

 

    --复位玩家数据
    for _,user in pairs(info.users) do
	--    user.score           = 0
	    user.total_score     = 0
        user.round_score = 0
        user.hand_cards      =nil     
        user.hand_cards_num  = 0     
        user.hand_cards_state = user_hand_cards_state.close
        
        user.niu_point = 0 
        user.ex_niu_type = nil

        user.chips = 0

    end

    sender.send_game_start()

    logic.round_start()
end


--回合开始
function logic.round_start()
    log.info("logic.round_start()")
  
    info.round = info.round+1
    info.state = table_state.round_start


    --初始化数据
    info.left_cards = logic.init_left_cards()

    if not conf.is_test then 
        logic.shuffle(info.left_cards)
    end


    
    info.left_cards_num = # info.left_cards

    info.winner = nil

	
    for k,v in pairs(info.users) do
        local user = v
        user.phase_ack = phase_ack.none
   
        user.round_score = 0
        user.hand_cards      =nil     
        user.hand_cards_num  = 0     
        user.hand_cards_state = user_hand_cards_state.close
        
        user.niu_point = 0 
        user.ex_niu_type = nil

        user.chips = 0

        user.game_state = user_game_state.in_game

    end
  

    sender.send_round_start()

    logic.reset_all_act()


    logic.begin_deal()
       -- logic.bao_jiao(  )
       --logic.zhuang_bao_jiao()
    logic.play()
 
     
    
end

function   logic.begin_deal(  )
    -- body
    if conf.is_test then
        logic.cheat_deal()
    else 
        logic.deal()
    end

  

    log.info("left_cards num is :"..#info.left_cards)
    for _,v in pairs(info.left_cards ) do 
       
        log.info(v)
    end

    sender.send_begin_deal()    
end



--cheat init_cards()
 function logic.cheat_deal()
    command.cancel_timer()

end

-- 发牌开始
function logic.deal()
    log.info("logic.deal()")
	log.info(type(info.left_cards[1]))
    command.cancel_timer()

    info.state=table_state.deal

    local users = info.users
    local table_cards = info.left_cards
    
	info.turn_user = info.dealer 
    local user_card_num = conf.user_hand_cards_num

    
    for k,v in pairs(info.users) do
        local user  = v
        if not user.hand_cards then 
            user.hand_cards = {}
        end    
        
        for _=1,user_card_num do
            table.insert(user.hand_cards,table_cards[#table_cards])
            table.remove( table_cards,#table_cards )
        end

        user.hand_cards_state = user_hand_cards_state.close
    end

end






--开始游戏
function logic.play()
   -- command.start_timer(conf.act_timeout,logic.turn_user_act_timeout)

      

    log.info("start dealer action")
    info.state =  table_state.play

    sender.send_begin_play()

   -- logic.game_circle()
 

end

    

function logic.user_discard_timeout()

end

--等待回合玩家动作
function logic.turn_user_act_timeout()

	
end




--等待其他玩家动作超时
function logic.other_user_act_timeout()

end

--房主开始
function logic.owner_req_start_game(user)

end

--房主开始
function logic.owner_req_start_game(user)
    if user.user_id ~= info.owner then 
        sender.send_owner_req_start_game_fail(user,0,"you not owner")
        return
    elseif info .start_game_mode ~= start_game_mode.owner then
            sender.send_owner_req_start_round_fail(user,0,"start when full user")        
    else 
        if info.state==table_state.idle then
            if info.user_num>=tonumber(conf.min_table_users)   then
                if logic.is_all_ready() then
                    log.info("owner start game  now . enough user")
                    logic.game_start()
                end
            else 
                sender.send_owner_req_start_game_fail(user,0,"not enough user")
                log.error("not enough user,user num is :"..info.user_num.." and min user is :"..conf.min_table_users)
            end
        else
                 sender.send_owner_req_start_game_fail(user,0,"wrong table state")
        end
    end    
end

function logic.owner_req_start_round(user)
    if user.user_id ~= info.owner then 
        sender.send_owner_req_start_round_fail(user,0,"you not owner")
        return
    elseif info .start_game_mode ~= start_game_mode.owner then
            sender.send_owner_req_start_round_fail(user,0,"start when full user")
    else 
        if info.state ==  table_state.round_over and info.state ~=  table_state.game_over then 
            if info.user_num>=tonumber(conf.min_table_users) and logic.is_all_ready() then
                log.info("owner start game  now . enough user")
                logic.round_start()
            else 
                sender.send_owner_req_start_round_fail(user,0,"not enough user")
                log.info("not enough user,user num is :"..info.user_num)
            end
        else
                 sender.send_owner_req_start_round_fail(user,0,"wrong table state")
        end
    end  
end

-- 玩家准备好了
function logic.user_is_ready(user)


    if info.state~=table_state.idle  then 
        return
    end     

        log.info("logic.user_is_ready()",user.user_id)
	user.phase_ack = phase_ack.ready

    sender.send_user_is_ready(user)

    if info.state==table_state.idle then
        if info.user_num>=tonumber(conf.min_table_users) and logic.is_all_ready() then
            if info.start_game_mode == start_game_mode.full then 
                log.info("game start now . enough user")
                logic.game_start()
            else
                log.info("full . wait owner start game")
            end
        else 
            for k,v in pairs (info.users) do 
            log.info("user "..v.seat_id.." ready state is :"..v.phase_ack)
            end

        end
        return
    end
  
end

function logic.is_all_ready()
    for _,user in pairs(info.users) do
        if user.phase_ack~=phase_ack.ready then
            return false
        end
    end

    return true
end

function logic.get_winner(user1,user2)
    if user1.ex_niu_type > user2.ex_niu_type then 
          return user1
    elseif user1.ex_niu_type < user2.ex_niu_type then  
        return user2
    else
        if user1.niu_point == user2.niu_point then 
            local tmp_index = info.hand_cards_num
            if    niuniu_logic.compareCard (user1.sorted_cards[tmp_index],user2.sorted_cards[tmp_index]) then 
                return user2
            else
                return user1
            end        
        elseif user1.niu_point> user2.niu_point then        
            return user1
        else
            return user2
        end          
    end
end


function logic.make_ex_niu_funcs()
    local test_funcs = logic.ex_niu_funcs
    if info.enable_straight then 
        test_funcs[niu_style.straight] = niuniu_logic.is_straight
    end    
    if info .enable_suited then 
      test_funcs[niu_style.suited] = niuniu_logic.is_suited
    end

    if info.enable_full_house then 
       test_funcs[niu_style.full_house] = niuniu_logic.is_full_house
    end
    
    if info .enbale_five_big then 
      test_funcs[niu_style.five_big] = niuniu_logic.is_five_big
    end

    if info.enable_bomb then 
      test_funcs[niu_style.bomb] = niuniu_logic.is_bomb
    end

    if info .enable_five_small then
     test_funcs[niu_style.five_small] = niuniu_logic.is_five_small
    end

    if info.enable_flush then
        test_funcs[niu_style.flush] = niuniu_logic.is_flush
    end
end

function logic.get_ex_type(five_cards)
    local tmp_point = niuniu_logic.splitNiuCards(five_cards)

    if tmp_point>0 then 

        local tmp_sorted = five_cards
        local tmp_type = 0
        for k,tmp_func in pairs(logic.ex_niu_funcs) do 
                if tmp_func(tmp_sorted) then 
                    if k >tmp_type then 
                        tmp_type = k
                    end
                end        
        end

        if tmp_type == 0 and tmp_point == 10 then 
              tmp_type =   niu_style.niuniu
        end
        return tmp_type,tmp_point

    else 
        if logic.ex_niu_funcs[niu_style.flush] then 
            local tmp_sorted = niuniu_logic.sort_cards(five_cards)
            if  logic.ex_niu_funcs[niu_style.flush](tmp_sorted) then 
                    return niu_style.flush,tmp_point
            else
                  
            end
        else

        end

        return 0 ,tmp_point     
    end
end

function logic.get_user_niu_info(user)

    local five_cards = {}
    for i,v in ipairs(user.hand_cards) do 
        table.insert(five_cards,{color = math.floor(v/16),point = math.fmod(v,16) })
    end
    user.sort_cards = niuniu_logic.sort_cards(five_cards)    

    user.ex_niu_type ,user.niu_point =  logic.get_ex_type(five_cards)
end

-- 回合结束
function logic.round_over()
 

    log.info("logic. round_over")
    command.cancel_timer()

    --modify state
       info.state=table_state.round_over
       info.round_over_time_string = os.date("%Y-%m-%d %H:%M:%S", os.time())

       --count score and change_state
    local tmp_winner 
    for _,tmp_user in pairs(info.users) do 
        logic.get_user_niu_info(user)
        tmp_winner = tmp_winner or tmp_user
        if tmp_user.game_state == game_state.in_game then 
            tmp_winner = logic.get_winner(tmp_winner,tmp_user)
        end
    end    
    info .winner = tmp_winner

    local tmp_fan  = ex_type_fan[tmp_winner.ex_niu_type]
    if not tmp_fan then 
        log.error("fatal error .. no fan found for ex_type:"..tostring(tmp_winner.ex_niu_type))
        tmp_fan = 1
    end    
    local tmp_score = info.base_chip * tmp_fan
  

    --add score to total score
    for _,tmp_user in pairs(info.users) do 
        if tmp_user == info.winner then 
                tmp_user.round_score = tmp_score *info.user_num
        else
             tmp_user.round_score = tmp_score *-1 
        end
        tmp_user.total_score = tmp_user.total_score+ tmp_user.round_score
        tmp_user.hand_cards_state = user_hand_cards_state.open
    end    

     sender.send_round_over()


 
    logic.reset_all_act()

   

    local is_game_over = false

    --if is_game_over or info.round>=info.max_round then
    --    command.start_timer(conf.round_over_time,logic.game_over)
    --else
     --  command.start_timer(conf.round_over_time,logic.round_start)
    --end

    if info.round>=info.max_round then
        logic.game_over(false)
      --  return
    end
    
end
-- 游戏结束
function logic.game_over(is_dismissed)
    log.info("logic.game_over()")
    command.cancel_timer()

    info.state=table_state.game_over

    logic.reset_all_act()

    sender.send_game_over(is_dismissed)

    --write score 
    local tmp_gsi = {}
    for k,v in pairs(info.users)  do
        table.insert( tmp_gsi, {user_id =v.user_id ,score = v.total_score,user_name=v.user_name,head_img = v.head_img} )
    end    

    

    --log.info(sprint_r( game_sproto:decode("game_brief",tmp_brief)))

    info.game_brief.game_score_infos =tmp_gsi
    local tmp_rules = {}
    for k,v in pairs (info.rules)  do 
            --print("game rule k is :"..k.."and  v is :"..v)
          table.insert(tmp_rules,{name =k,value = v})
    end
  
    info.game_brief.game_rules = tmp_rules

    local tmp_user_record_infos = {}

    for k,v in pairs(info.users) do 
        table.insert( tmp_user_record_infos,{user_id = v.user_id,user_name = v.user_name,head_img=v.head_img,
            seat_id = v.seat_id, total_score = v.total_score} )
    end

    info .game_record. user_record_infos = tmp_user_record_infos
    info.game_record.private_key =  info. private_key

    local tmp_brief = game_sproto:encode("game_brief", info.game_brief)
    

    if not tmp_brief then 
        log.error("no brief after encode game_brief")
        log.error(sprint_r(info.game_brief))
    else 
       local tmp_b =  game_sproto:decode("game_brief", tmp_brief)
        log.info(sprint_r(tmp_b))
    end


    local tmp_record_data =        game_sproto:encode("game_record", info.game_record) 

    if not tmp_record_data then 
        log.error("no brief after encode tmp_record_data")
        log.error(sprint_r(info.game_record))
    else 
       local tmp_b =  game_sproto:decode("game_record", tmp_record_data)
        log.info(sprint_r(tmp_b))
    end

        logic.write_play_record(conf.record_version,
        tmp_brief,
        tmp_record_data
        
    )    



    command.start_timer(conf.game_over_time,command.dismiss_table)


end





function    logic.user_start_round( user )
    -- body
        log.info("logic  user start new round")

        for k,v in pairs(info.users)  do 
            log.info("user seat_id :"..v.seat_id .."  state is :"..tostring(v.phase_ack))
        end
        log.info("current user phase_ack is :"..user.phase_ack)

    local b_ok = false
    if info.state ==  table_state.round_over and info.state ~=  table_state.game_over then 
            if user.phase_ack ~= phase_ack.ready then
                b_ok = true
                user.phase_ack = phase_ack.ready

                --send to all 
                log.info("begin send start round toall")
                sender.send_user_start_round(user)

                local tmp_ready_num = 0
                for k,v in pairs(info.users)  do
                        if  v.phase_ack == phase_ack.ready then 
                            tmp_ready_num = tmp_ready_num+1
                        end    
                end

                if tmp_ready_num == conf.max_table_users then 
                        logic.round_start()
                end
            end    
    end

    if not b_ok then 
            sender.send_req_start_round_fail(user,1," wrong act")
    end
end



function   logic.user_restart_game( user )
   local b_ok = false
   if conf.allow_restart_game then 
        if info.state ==  table_state.game_over  then 
                if user.phase_ack ~= phase_ack.ready then
                    b_ok = true
                    user.phase_ack = phase_ack.ready

                    --send to all 
                    log.info("begin send start round toall")
                    sender.send_user_start_game(user)

                    local tmp_ready_num = 0
                    for k,v in pairs(info.users)  do
                            if  v.phase_ack == phase_ack.ready then 
                                tmp_ready_num = tmp_ready_num+1
                            end    
                    end

                    if tmp_ready_num == conf.max_table_users then 
                            logic.game_start()
                    end
                end    
        end
    end

    if not b_ok then 
            sender.send_req_start_game_fail(user,1," wrong act")
    end  
end

function  logic.copy_cards(in_cards )
    -- body
    local tmp_out_cards = {}
    if in_cards then 
        for i,v  in ipairs(in_cards) do 
            table.insert(tmp_out_cards,v)
        end    
    end    
    return tmp_out_cards
end

function  logic.copy_niu_cards(in_cards )
    -- body
    local tmp_out_cards = {}
    if in_cards then 
        for i,v  in ipairs(in_cards) do 
            table.insert(tmp_out_cards,{color = v.color,point = v.point})
        end    
    end    
    return tmp_out_cards
end



function logic.process_dismiss_table(  )
    -- body
    -- command.dismiss_table("投票结束，房间解散")
    --go to game_over
    logic.game_over(true)

    command.start_timer(conf.dismiss_table_time,command.dismiss_table)
end

--function  logic.real_dismiss(  )
    -- body
 --   command.dismiss_table("投票结束，房间解散")
--end
function logic.req_open_cards(user)
    if user.game_state == user_game_state.in_game and  user.hand_cards_state ~= user_hand_cards_state.open then 
          sender.  send_req_open_cards_ok(user)
          user.hand_cards_state = user_hand_cards_state.open
          sender.send_user_open_cards(user)

          --check if all open 
          local tmp_all_open = true
          for k,v in pairs (info.users) do 
                if v.game_state == user_game_state.in_game  and v.hand_cards_state ~= user_hand_cards_state.open then
                    tmp_all_open = false
                    break
                end    
          end

          if tmp_all_open then 
            logic.round_over()
          end  
    else
        sender.sensend_req_open_cards_faild(user,0,"you can not open ")
    end    

end