--[[
  * COMMAND:: ReqOpenCardRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ReqOpenCardRspCommand = class('ReqOpenCardRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--replace nn with xxx
--local game_proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

--constructor function. do not overwrite it
function ReqOpenCardRspCommand:ctor()
    self.executed = false
end

--coding function in here
function ReqOpenCardRspCommand:execute(note)
    --Log('ReqOpenCardRspCommand')
    local errcode = note.body.errorcode 
    local desc = note.body.desc or ""
    if errcode == EGameErrorCode.EGE_Success and (  desc == nil or desc == "") then 
    else 
        --@todo accroding to the errorcode
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    end 
    facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
end

return ReqOpenCardRspCommand