local mediator = class('UI_MainMediator',pm.Mediator)

local loginProxy = nil 

function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.CLOSE_UI_MAIN)
    table.insert(notification, Common.UPDATE_DOWNLOADING_PROG)
    table.insert(notification, Common.STARTED_DOWNLAOD_GAME)
    table.insert(notification, Common.DOWNLOADED_GAME)
    table.insert(notification, Common.WAIT_DOWNLOAD_GAME)
	return notification
end

function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()

    if Common.CLOSE_UI_MAIN == name then 
        local facade = pm.Facade.getInstance(GAME_FACADE_NAME)  
        facade:sendNotification(Common.CLOSE_UI_COMMAND, body)
    elseif Common.WAIT_DOWNLOAD_GAME == name then 
        self.viewComponent:PrepareDownloadGame(body)
    elseif Common.STARTED_DOWNLAOD_GAME == name then 
        self.viewComponent:StartedDownloadGame(body)
    elseif Common.UPDATE_DOWNLOADING_PROG == name then 
        self.viewComponent:UpdateDownloadingProg(body)
    elseif Common.DOWNLOADED_GAME == name then 
        self.viewComponent:DownloadedGame(body)
    end 
end

function mediator:Opened(param)
    self.viewComponent:SetMediator(self)
    loginProxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(Common.LOGIN_PROXY)
    self.viewComponent:FreshPlayerInfo(loginProxy:GetUserName(),loginProxy:GetHeadImageUrl(), loginProxy:GetUserId(), loginProxy:GetRoomCard())

    if param then 
        local cb = param:GetCallBack()
        if cb then 
            cb()
        else 
            print("callback is nil main ")
        end 
    end 

    if loginProxy:IsRenderWelcomeMsg() == true then 
        self.viewComponent:RenderMsg(luaTool:GetLocalize("game_warning_ps"))
        loginProxy:DontRenderWelcome()
    end 
end 

--OnRestore:: dont remove.. called by uimanager
function mediator:OnRestore()
    if self.viewComponent.OnRestore then 
        self.viewComponent:OnRestore()
    end 
end 

--OnDisable:: dont remove.. called by uimanager
function mediator:OnDisable()
    if self.viewComponent.OnDisable then 
        self.viewComponent:OnDisable()
    end 
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
    loginProxy = nil 
end 

function mediator:onRemove()
    self = nil
end

function mediator:IsGameEnabled(game_type)
    return loginProxy:IsGameEnabled(game_type)
end 
return mediator