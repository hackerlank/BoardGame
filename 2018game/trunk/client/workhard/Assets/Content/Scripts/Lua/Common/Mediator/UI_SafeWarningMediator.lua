--[[
  * ui mediator class:: UI_SafeWarningMediator
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
local mediator = class('UI_SafeWarningMediator',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local game_proxy = nil 
--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.ON_TOUCHED_EXIT_BTN)
    table.insert(notification, Common.NTF_PLAYER_READY)
    table.insert(notification, Common.NTF_PLAYER_LEFT_GAME)
    table.insert(notification, Common.NTF_PLAYER_JOINED_GAME)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
     print(name)
    if Common.ON_TOUCHED_EXIT_BTN == name then 
        --send exit game command in here
        facade:sendNotification('leave_game_command -- need to be overwrite')
    elseif  Common.NTF_PLAYER_READY == name then 
       
        if game_proxy:IsSelfRealSeatId(body.real_seat_id) == true then 
            self.viewComponent:NtfCloseSelf()
        end 
    elseif Common.NTF_PLAYER_JOINED_GAME == name then 
        self.viewComponent:FreshWindow(self:GetLocationInfo())
    elseif Common.NTF_PLAYER_LEFT_GAME == name then 
        local game_type = GetLuaGameManager().GetGameType() 
        if game_type == EGameType.EGT_ZhaJinHua then 
            local locations = self:GetLocationInfo()
            if #locations <= 1 then 
                self.viewComponent:NtfCloseSelf()
            else 
                self.viewComponent:FreshWindow(locations)
            end 
        else 
            self.viewComponent:NtfCloseSelf()
        end 
    end 
end

function mediator:GetLocationInfo()
    -- body
    local proxy_name = GetLuaGameManager().GetGameName() .. ".game_proxy"
    game_proxy = facade:retrieveProxy(proxy_name)
    local locations = {} 
    if game_proxy ~= nil then 
        local playerInfo = game_proxy:GetAllPlayerInfo()
        local loc = nil 
        for k,v in pairs(playerInfo) do 
            if v then 
                if game_proxy:IsSelf(v.seat_id) == false then 
                    loc = {}

                    loc.head_icon = v.head_img
                    loc.ip_address = v.ip_address
                    loc.latitude = v.latitude
                    loc.longitude = v.longitude
                    table.insert(locations, loc)
                end 
            end 
        end 
    end 
    return locations
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)

    if param and param:GetCallBack() ~= nil then 
        local cb = param:GetCallBack()
        cb()
    end 

    --
    self.viewComponent:FreshWindow(self:GetLocationInfo())
    
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