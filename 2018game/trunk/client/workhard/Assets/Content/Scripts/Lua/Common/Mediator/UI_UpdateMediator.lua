--[[
  * ui mediator class:: UI_UpdateMediator
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
local mediator = class('UI_UpdateMediator',pm.Mediator)

--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.SET_UPDATE_PROGRESS)
    table.insert(notification, Common.SET_UPDATE_TIPS)
    table.insert(notification, Common.SHOW_CONNECT_SERVER)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()

    if name == Common.SET_UPDATE_TIPS then 
        self.viewComponent:SetUpdateTips(body)
    elseif name == Common.SET_UPDATE_PROGRESS then 
        local cur = 0
        local max = 1
        if body ~= nil and body.cur ~= nil and body.max ~= nil then 
            cur = body.cur
            max = body.max
        end 
        self.viewComponent:SetUpdateProgress(cur , max)
    elseif name == Common.SHOW_CONNECT_SERVER then
        self.viewComponent:RenderConnTip(true)
        self.viewComponent:ShowConnectTip(body)
    else 
        UnityEngine.Debug.LogError("[UI_UpdateMediator]:: do not recieve " .. name)
    end 
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:RenderConnTip(false)
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