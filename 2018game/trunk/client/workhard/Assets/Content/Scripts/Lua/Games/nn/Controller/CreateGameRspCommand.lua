--[[
  * COMMAND:: CreateGameRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local CreateGameRspCommand = class('CreateGameRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function CreateGameRspCommand:ctor()
    self.executed = false
end

--coding function in here
function CreateGameRspCommand:execute(note)
    UnityEngine.Debug.Log('CreateGameRspCommand')
   
    if note.body == nil then
        LogError("[CreateGameRspCommand]:: the body is nil. will return")
        return
    end 
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local errorcode = note.body.errorcode
    local desc = tostring(note.body.desc)
    if note.body.errorcode == EGameErrorCode.EGE_Success then 
       facade:sendNotification(nn.PLAYER_REQ_ONLINE, note.body)
    else
        facade:sendNotification(nn.PLAYER_LEAVE_HALL)
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
    end
     
end

return CreateGameRspCommand