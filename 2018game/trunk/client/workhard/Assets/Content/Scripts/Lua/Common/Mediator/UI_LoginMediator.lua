local mediator = class('UI_LoginMediator',pm.Mediator)

function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.PRE_LOGIN_GAME_SERVER)
	return notification
end

function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.PRE_LOGIN_GAME_SERVER == name then 
        self.viewComponent:StartAutoLogin()
    end
end

function mediator:Opened(param)
    local str = UnityEngine.PlayerPrefs.GetString("PlayerAccount") 
    local userInfo = JsonTool.Decode(str)
    local name = ""
    local password = ""
    if userInfo ~= nil then 
        name = userInfo.username
        password = userInfo.password
    end 
    self.viewComponent.FreshWindow(name, password)
    --self.viewComponent:StartAutoLogin()
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