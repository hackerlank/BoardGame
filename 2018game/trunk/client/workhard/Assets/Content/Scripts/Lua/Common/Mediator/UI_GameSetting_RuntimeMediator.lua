--[[
  * ui mediator class:: UI_GameSetting_RuntimeMediator
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
local mediator = class('UI_GameSetting_RuntimeMediator',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local proxy = nil 
--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.ON_TOUCHED_EXIT_BTN)
    table.insert(notification, Common.NTF_PLAYER_START_VOTE)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.ON_TOUCHED_EXIT_BTN == name then 
        --send exit game command in here
        facade:sendNotification('leave_game_command -- need to be overwrite')
    elseif Common.NTF_PLAYER_START_VOTE == name then 
        self.viewComponent:NtfStartVote()
    end 
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)
    local setting = GameSetting.getInstance()
    proxy = facade:retrieveProxy(GetLuaGameManager().GetGameName() .. ".game_proxy")
    
    self.viewComponent:FreshWindow(setting:IsEnableMusic(), setting:IsEnableSound())
    if param and param:GetCallBack() ~= nil then 
        local cb = param:GetCallBack()
        cb()
    end 
    
    
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

    proxy = nil 
end 

--onRemove:: dont remove.. called by super class
function mediator:onRemove()
    self = nil
end


function  mediator:IsPlayRecord()
    proxy:IsPlayRecord()
end

function mediator:IsGamePlay()
    return proxy:IsGamePlaying()
end

return mediator