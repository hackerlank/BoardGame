--[[
  * COMMAND:: JoinGameRspCommand. 
  *   deal response of join game.
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local JoinGameRspCommand = class('JoinGameRspCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function JoinGameRspCommand:ctor()
    self.executed = false
end

--coding function in here
function JoinGameRspCommand:execute(note)
    local body = note.body
    if body == nil then
        LogError("[JoinGameRspCommand]:: the body is nil. will return")
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        return
    end 
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local errorcode = body.errorcode
    local desc = tostring(body.desc)

    if errorcode == EGameErrorCode.EGE_Success then 
        facade:sendNotification(nn.PLAYER_REQ_ONLINE)
    else
        facade:sendNotification(nn.PLAYER_LEAVE_HALL)
        facade:sendNotification(Common.NTF_JOIN_GAME_FAILED)
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
    end 
end

return JoinGameRspCommand