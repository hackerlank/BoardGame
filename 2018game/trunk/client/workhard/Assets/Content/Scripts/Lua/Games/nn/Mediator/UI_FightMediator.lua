--[[
  * ui mediator class:: UI_FightMediator
  * inherits from mediator class of lua mvc plugin. control view render state
  * @ctor
  *   don't recoding
  * @listNotificationInterests
  *   list all notifications that self interests
  * @handleNotification
  *   deal notification events
  * @OnDisable
  *   this function will be invoked when player is hiding window.each of menu 
  *   view class must contains it.called by ui manager
  * @OnRestore
  *   this function will be invoked when player wants to active self. called by ui manager
  * @OnClose
  *   this function will be called when player is closing self. called by ui mediator.
]]

--must named file first
local mediator = class('UI_FightMediator',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local game_proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

local m_RoundOverMenuParam = ci.GetUiParameterBase().new(nn.GAME_ROUND_OVER_MENU,EMenuType.EMT_Games, nil, false)
local m_GameOverMenuParam = ci.GetUiParameterBase().new(nn.GAME_GAME_OVER_MENU, EMenuType.EMT_Games, nil, false)

--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification,Common.NTF_PLAYER_JOINED_GAME)
    table.insert(notification,Common.NTF_PLAYER_LEFT_GAME)
    table.insert(notification,Common.NTF_ROUND_START)
    table.insert(notification,Common.NTF_PLAYER_READY)
    table.insert(notification,Common.NTF_USER_GET_SCORE)
    table.insert(notification,Common.NTF_PLAYER_ACTION)
    table.insert(notification,Common.NTF_GAME_START)
    table.insert(notification,Common.NTF_PLAYER_ACT_DONE)
    table.insert(notification,Common.NTF_PLAY_GAME)
    table.insert(notification,Common.NTF_SHUFFLE)
    table.insert(notification,Common.NTF_ROUND_OVER)
    table.insert(notification,Common.NTF_PLAYER_CHAT)
    table.insert(notification,Common.NTF_PLAYER_START_ROUND)
    table.insert(notification,Common.NTF_PLAYER_DRAW_CARD)
    table.insert(notification,Common.PLAYER_RECONNECTED)
    table.insert(notification,Common.PLAYER_DISMISS_TABLE_RSP)

    table.insert(notification,nn.PLAYER_REQ_ACT_RSP)
    table.insert(notification,nn.PLAYER_REQ_READY_RSP)
    table.insert(notification,nn.NTF_USER_OPEN_CARDS)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.PLAYER_RECONNECTED == name then 
        self.viewComponent:CleanupTable(true)
        self:PlayerReconnected()
    elseif Common.PLAYER_DISMISS_TABLE_RSP == name then
        --解散房间回复
        if body.errorcode == EGameErrorCode.EGE_Success then 
        else
            facade:sendNotification(Common.RENDER_MESSAGE_VALUE, body.desc) 
        end 
    elseif Common.NTF_ROUND_OVER == name then 
        self.viewComponent:NtfRoundOver()
    elseif Common.NTF_PLAYER_JOINED_GAME == name then
        --玩家加入游戏
        self.viewComponent:NtfPlayerJoinedGame(body.real_seat_id)
    elseif Common.NTF_PLAYER_LEFT_GAME == name then
        --玩家离开游戏通知
        self.viewComponent:NtfPlayerLeftGame(body.real_seat_id)
    elseif Common.NTF_ROUND_START == name then
        --对局开始
        self.viewComponent:FreshRound(game_proxy:GetCurrentRound(), game_proxy:GetMaxRound())
        self.viewComponent:NtfRoundStart()
    elseif Common.NTF_PLAYER_READY == name then
        --玩家已经准备好
        if game_proxy:IsSelfRealSeatId(body.real_seat_id) == true then 
            self.viewComponent:CleanupTable()
            facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        end 
        self.viewComponent:NtfPlayerReady(body.real_seat_id)
    elseif Common.NTF_PLAYER_START_ROUND == name then 
        if body.bIsSelf == true then 
            self.viewComponent:CleanupTable()
            facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        end 
        self.viewComponent:NtfPlayerReady(body.real_seat_id)
    elseif Common.NTF_USER_GET_SCORE == name then 
        facade:sendNotification(Common.EXECUTE_CMD_DONE)
        --show score
    elseif Common.NTF_GAME_START == name then 
        --通知游戏开始
        self.viewComponent:NtfPlayGame(game_proxy:GetGameState(), game_proxy:GetGameRule().start_game_mode)
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
    elseif Common.NTF_PLAY_GAME == name then
        --swith table state
        self.viewComponent:NtfPlayGame(body.real_seat_id, body.bIsSelf, body.remain_time)
    elseif Common.NTF_SHUFFLE == name then
        --发牌通知
        self.viewComponent:NtfShuffle(body.cards_info)
    elseif Common.NTF_PLAYER_CHAT == name then 
        if body.bIsSelf == true then 
            facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        end 
        --render a tips 
        self.viewComponent:NtfRecievedMsg(body.real_seat_id, body.msg)
    elseif nn.PLAYER_REQ_READY_RSP == name then 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        if body.errorcode ~= EGameErrorCode.EGE_Success then 
            facade:sendNotification(Common.RENDER_MESSAGE_VALUE, body.desc)
        end 
    elseif nn.NTF_USER_OPEN_CARDS == name then 
        self.viewComponent:NtfPlayerOpenCards(body.real_seat_id, body.hand_cards)
    end  
end

function mediator:FreshGame()
    local state = game_proxy:GetGameState() 
    local rule = game_proxy:GetGameRule()
    local tmp = nil 
    local round_result = nil 
    local self_game_info = nil 
    local self_real_seat_id = nil 
    local bNotShuffle = false

    self.viewComponent:FreshGameRule(rule)
    self.viewComponent:FreshRoomId(game_proxy:GetRoomId())

    local all_players = game_proxy:GetAllPlayerInfo()
    self.viewComponent:FreshPlayerInfo(game_proxy:GetAllPlayerInfo())

    self.viewComponent:FreshRound(game_proxy:GetCurrentRound(), game_proxy:GetMaxRound())
    --shuffle??

    for _k,_v in pairs(all_players) do 
        local i = _v.real_seat_id
        tmp = game_proxy:GetPlayerGameInfo(i)
        if self:IsSelfRealSeatId(_v.real_seat_id) == true then 
            self_game_info = tmp
            self_real_seat_id = i
            break
        end 
    end 

    for k,v in pairs(all_players) do 
        local seat_id = v.seat_id
        local i = v.real_seat_id
        tmp = game_proxy:GetPlayerGameInfo(i)
        local bShowReady = tmp.req_ready  
        if bShowReady == true and state ~= nn.ETableState.idle then 
            if tmp.req_start_round then 
                bShowReady = tmp.req_start_round
            end 
            if bShowReady == true and tmp.hand_card_num > 0 and state ~= nn.ETableState.round_over then 
                bShowReady = false 
            end 
        end 
        self.viewComponent:PlayerReconnected(tmp, i, bShowReady, state)
        if state == nn.ETableState.round_over and self_game_info.req_ready == false then 
            if round_result == nil then 
                round_result = {}
            end 
            local tmp_result = {}
            tmp_result.room_card = tmp.room_card or 0
            tmp_result.hand_cards = tmp.hand_cards
            tmp_result.score = tmp.score
            tmp_result.total_score = tmp.total_score
            tmp_result.bIsSelf = game_proxy:IsSelfRealSeatId(i)
            round_result[seat_id] = tmp_result     
        end 
    end 

    self.viewComponent:NtfPlayGame(state, rule.start_game_mode, false) 
    if state == nn.ETableState.play then 

    elseif state == nn.ETableState.game_over then 
        facade:sendNotification(Common.NTF_GAME_OVER, {dismissed = false})   
    end 

    if round_result ~= nil then 
        facade:sendNotification(Common.NTF_ROUND_OVER, round_result)
    end      

    local vote_req_user, bIsSelf = game_proxy:IsInVote()
    if vote_req_user > 0 then 
        --open vote menu 
        local state = game_proxy:GetSelfVoteState() 
        if state == EVoteType.none then 
            facade:sendNotification(Common.NTF_PLAYER_START_VOTE, {isSelf = bIsSelf})
        else
            local vote_result_menu = ci.GetUiParameterBase().new(Common.MENU_VOTE_RESULT,  EMenuType.EMT_Common, nil, false)
            facade:sendNotification(Common.OPEN_UI_COMMAND, vote_result_menu)
        end 
    end 

end 

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)

    if param and param:GetCallBack() ~= nil then 
        self:FreshGame()
        local cb = param:GetCallBack()
        cb()
    end 
end 

--OnRestore:: dont remove.. called by uimanager
function mediator:OnRestore()
    if self.viewComponent ~= nil  then 
        if self.viewComponent.OnRestore then 
            self.viewComponent:OnRestore()
        end 
    end 
end 

--OnDisable:: dont remove.. called by uimanager
function mediator:OnDisable()
    if self.viewComponent ~= nil  then 
        if self.viewComponent.OnDisable then 
            self.viewComponent:OnDisable()
        end 
    end
end 

--OnClose:: dont remove.. called by uimanager
function mediator:OnClose()
    if self.viewComponent ~= nil  then 
        if self.viewComponent.OnClose then
            self.viewComponent:OnClose()
        elseif self.viewComponent.SafeRelease then 
            self.viewComponent:SafeRelease()
        end 
    end 
    self.viewComponent = nil
end 

--onRemove:: dont remove.. called by super class
function mediator:onRemove()
    self = nil
end

function mediator:GetRealSeatId(seat_id)
    return game_proxy:GetRealSeatId(seat_id)
end 

function mediator:GetPlayerInfo(seat_id)
    return game_proxy:GetPlayerInfo(seat_id)
end 

function mediator:GetPlayerInfoWithRealSeatId(real_seat_id)
    return game_proxy:GetPlayerInfoWithRealSeatId(real_seat_id)
end 

function mediator:GetPlayerCards(real_seat_id)
    return game_proxy:GetPlayerCards(real_seat_id)
end 

function mediator:GetSelfRealSeatId()
    return game_proxy:GetSelfRealSeatId()
end 

function mediator:IsSelfRealSeatId(real_seat_id)
    return game_proxy:IsSelfRealSeatId(real_seat_id)
end 

function mediator:IsOwner()
    return game_proxy:IsOwner()
end 

function mediator:GetRoomOwner()
    return game_proxy:GetRoomOwner()
end

function mediator:IsDealer(real_seat_id)
    return game_proxy:IsDealer(real_seat_id)
end 

function mediator:IsTurnSelf(real_seat_id)
    return game_proxy:IsTurnSelf(real_seat_id)
end

function mediator:IsSelfLastestDiscard(real_seat_id)
    return game_proxy:IsSelfLastestDiscard(real_seat_id)
end

function mediator:GetCurrentAction()
    return game_proxy:GetCurrentAction()
end 

function mediator:GetUserScore(real_seat_id)
    return game_proxy:GetUserScore(real_seat_id)
end 

return mediator