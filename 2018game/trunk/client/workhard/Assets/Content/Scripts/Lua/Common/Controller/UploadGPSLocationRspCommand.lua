--[[
  * COMMAND:: UploadGPSLocationRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local UploadGPSLocationRspCommand = class('UploadGPSLocationRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function UploadGPSLocationRspCommand:ctor()
    self.executed = false
end

--coding function in here
function UploadGPSLocationRspCommand:execute(note)
    --UnityEngine.Debug.Log('UploadGPSLocationRspCommand')
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local body = note.body
    if body.errorcode == EGameErrorCode.EGE_Success then 
        --facade:sendNotification(Common.RENDER_MESSAGE_VALUE, luaTool:GetLocalize("upload_gps_success"))
    else 
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, body.desc)
    end 
end

return UploadGPSLocationRspCommand