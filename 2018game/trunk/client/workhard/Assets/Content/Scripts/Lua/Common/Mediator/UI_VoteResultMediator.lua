--[[
  * ui mediator class:: UI_VoteResultMediator
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
local mediator = class('UI_VoteResultMediator',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.ON_TOUCHED_EXIT_BTN)
    table.insert(notification, Common.NTF_PLAYER_VOTED)
    table.insert(notification, Common.NTF_PLAYER_STOP_VOTE)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.ON_TOUCHED_EXIT_BTN == name then 
        --send exit game command in here
        facade:sendNotification('leave_game_command -- need to be overwrite')
    elseif Common.NTF_PLAYER_VOTED == name then 
        self.viewComponent:FreshWindow(body.seat_id, body.vote_ack)
        facade:sendNotification(Common.EXECUTE_CMD_DONE)
    elseif Common.NTF_PLAYER_STOP_VOTE == name then 
        --delay close self and popup new command
        local timer = LuaTimer.Add(1000, function()     
            if timer then 
                LuaTimer.Delete(timer)
                timer = nil 
            end 
            facade:sendNotification(Common.EXECUTE_CMD_DONE)
            if self.viewComponent then 
                self.viewComponent:CloseWindow()
            end 
        end)
    end 
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)

    if param and param:GetCallBack() ~= nil then 
        local cb = param:GetCallBack()
        cb()
    end 

    local proxy_name = GetLuaGameManager().GetGameName() .. ".game_proxy"
    local proxy =  facade:retrieveProxy(proxy_name)
    local players = proxy:GetAllPlayerInfo()
    local param = {} 
    local state = proxy:GetGameState()
    for k,v in ipairs(players) do 
        if v then 
            table.insert(param, {seat_id=v.seat_id, user_name=v.user_name, bIsSelf = proxy:IsSelf(v.seat_id), state = proxy:GetUserVoteResult(v.seat_id), head_img = v.head_img})
        end 
    end 
    self.viewComponent:InitialMenu(param, proxy:GetVoteEndTime())
    --if state ~= mj_cdxz.ETableState.dismissed then 
        facade:sendNotification(Common.EXECUTE_CMD_DONE)
    --else

    --end 
end 

--OnRestore:: dont remove.. called by uimanager
function mediator:OnRestore()

end 

--OnDisable:: dont remove.. called by uimanager
function mediator:OnDisable()

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

return mediator