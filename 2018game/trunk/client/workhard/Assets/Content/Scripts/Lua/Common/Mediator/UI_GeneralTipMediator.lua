local mediator = class(Common.MENU_GENERAL_TIP .. 'Mediator',pm.Mediator)

function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.CLOSE_GENERAL_TIP)
	return notification
end

function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()

    if Common.CLOSE_GENERAL_TIP == name then 
        local facade = pm.Facade.getInstance(GAME_FACADE_NAME)  
        facade:sendNotification(Common.CLOSE_UI_COMMAND, body)
    end 
end

function mediator:Opened(param)

    if param ~= nil and param:IsGeneralTip() then 
        local tipObj = luaTool:GetGeneralTip(param:GetTipID())
        local content = param:GetContent()

        if tipObj == nil then 
            UnityEngine.Debug.LogError("Failed to load tip content with id " .. param:GetTipID())
        else 
            self.viewComponent:FreshWindow(tipObj, content, param:GetSureCallback(), param:GetCancelCallback())
        end 
    end 
end 

function mediator:OnRestore()

end 

function mediator:OnDisable()

end 

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

function mediator:onRemove()
    self = nil
end
return mediator