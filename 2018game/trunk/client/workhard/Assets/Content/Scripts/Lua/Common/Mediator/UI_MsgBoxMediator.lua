--[[
  * ui mediator class:: UI_MsgBoxMediator
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
local mediator = class('UI_MsgBoxMediator',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.RENDER_MESSAGE_KEY)
    table.insert(notification, Common.RENDER_MESSAGE_VALUE)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.RENDER_MESSAGE_KEY == name then 
        self.viewComponent:ShowMsgWithKey(body)
    elseif Common.RENDER_MESSAGE_VALUE == name then 
        self.viewComponent:ShowMsgWithContent(body)
    end 
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)
    --try to render tip
    GetLuaGameManager().ShowDuplicateRoomIdTip()
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