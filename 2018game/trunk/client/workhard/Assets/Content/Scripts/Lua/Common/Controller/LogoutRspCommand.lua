--[[
  * COMMAND:: LogoutRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local LogoutRspCommand = class('LogoutRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function LogoutRspCommand:ctor()
    self.executed = false
end

--coding function in here
function LogoutRspCommand:execute(note)
    --UnityEngine.Debug.Log('LogoutRspCommand')
    local errcode = note.body.errorcode
    local desc = note.body.desc 
    if errcode == EGameErrorCode.EGE_Success then 
        --switch level to login 
        ClientConn.Disconnect()
        WeChatSDK.LogoutWeChatAuth()
        UnityEngine.PlayerPrefs.DeleteKey(DEFINED_KEY_LOGIN_TYPE)
        facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
        --local levelInfo =  luaTool:GetLevelInfo(0, 1, 2) 
        --facade:sendNotification(Common.SWITCH_LEVEL_COMMAND,{level=levelInfo, restoreType = ERestoreType.EST_None })
    else 
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    end
end

return LogoutRspCommand