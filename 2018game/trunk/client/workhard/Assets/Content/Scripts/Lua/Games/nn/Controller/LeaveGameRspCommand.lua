--[[
  * COMMAND:: LeaveGameRspCommand. 
  *   deal response of leave game.
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local LeaveGameRspCommand = class('LeaveGameRspCommand', pm.SimpleCommand)

--constructor function. do not overwrite it
function LeaveGameRspCommand:ctor()
    self.executed = false
end

--coding function in here
function LeaveGameRspCommand:execute(note)
    local body = note.body
    if body == nil then
        UnityEngine.Debug.LogError("[LeaveGameRspCommand]:: the body is nil. will return")
        return
    end 
   
    local errorcode = body.errorcode
    local desc = tostring(body.desc)
    local facade =  pm.Facade.getInstance(GAME_FACADE_NAME)
    if errorcode == EGameErrorCode.EGE_Success then 
        facade:sendNotification(nn.PLAYER_LEAVE_HALL)
        --facade:retrieveProxy(nn.GAME_PROXY_NAME):LeaveHall()
    else 
        if desc == "" then 
            facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.leavegamefail")
        else 
            facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
        end 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
    end
    
end

return LeaveGameRspCommand