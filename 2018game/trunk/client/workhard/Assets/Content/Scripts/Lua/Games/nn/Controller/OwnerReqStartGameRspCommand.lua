--[[
  * COMMAND:: OwnerReqStartGameRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local OwnerReqStartGameRspCommand = class('OwnerReqStartGameRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function OwnerReqStartGameRspCommand:ctor()
    self.executed = false
end

--coding function in here
function OwnerReqStartGameRspCommand:execute(note)
    --UnityEngine.Debug.Log('OwnerReqStartGameRspCommand')
    local errcode = note.body.errorcode 
    local desc = note.body.desc or ""
    if errcode == EGameErrorCode.EGE_Success and (  desc == nil or desc == "") then 
    else 
        --@todo accroding to the errorcode
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    end 
    facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
end

return OwnerReqStartGameRspCommand