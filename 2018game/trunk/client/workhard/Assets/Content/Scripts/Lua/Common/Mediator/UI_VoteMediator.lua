--[[
  * ui mediator class:: UI_VoteMediator
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
local mediator = class('UI_VoteMediator',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.PLAYER_VOTE_DISMISS_RSP)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.ON_TOUCHED_EXIT_BTN == name then 
        --send exit game command in here
        facade:sendNotification('leave_game_command -- need to be overwrite')
    elseif Common.PLAYER_VOTE_DISMISS_RSP == name then 
        if body.errorcode == EGameErrorCode.EGE_Success then 
            self.viewComponent:NtfVoteSuccess()
            local menu_param = ci.GetUiParameterBase().new(Common.MENU_VOTE_RESULT, EMenuType.EMT_Common,nil, false)
            facade:sendNotification(Common.OPEN_UI_COMMAND, menu_param)
            print("try to open result panel")
        else 
            facade:sendNotification(Common.RENDER_MESSAGE_VALUE, body.desc)
            self.viewComponent:NtfVoteFail()
        end 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        facade:sendNotification(Common.EXECUTE_CMD_DONE)
    end 
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)

    if param and param:GetCallBack() ~= nil then 
        local cb = param:GetCallBack()
        cb()
    end 

    local user_name = param:GetMenuParam()
    local game_proxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(GetLuaGameManager().GetGameName() .. ".game_proxy")
    self.viewComponent:FreshTip(user_name, game_proxy:GetVoteEndTime())
    facade:sendNotification(Common.EXECUTE_CMD_DONE)
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