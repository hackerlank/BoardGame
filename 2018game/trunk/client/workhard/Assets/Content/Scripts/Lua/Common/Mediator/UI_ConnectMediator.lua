--[[
  * ui mediator class:: UI_ConnectMediator
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
local mediator = class('UI_ConnectMediator',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.UPDATE_LOGIN_MENU)
    table.insert(notification, Common.LOGIN_GAME_SERVER_RSP)
    table.insert(notification, Common.LOGIN_GATE_SERVER_RSP)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.UPDATE_LOGIN_MENU == name then 
        self.viewComponent:UpdateLoginMenu(body)
    elseif Common.LOGIN_GAME_SERVER_RSP == name then 
        if body.errorcode ~= EGameErrorCode.EGE_Success then 
            self.viewComponent:UpdateLoginMenu(nil)
        end 
    elseif Common.LOGIN_GATE_SERVER_RSP == name then 
        if body.errorcode ~= EGameErrorCode.EGE_Success then 
            self.viewComponent:UpdateLoginMenu(nil)
        end 
    end
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)

    if param and param:GetCallBack() ~= nil then 
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

return mediator