--[[
  * COMMAND:: BindGateServerRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local BindGateServerRspCommand = class('BindGateServerRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local LogError = UnityEngine.Debug.LogError
local Log = UnityEngine.Debug.Log
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local timer = nil 

--constructor function. do not overwrite it
function BindGateServerRspCommand:ctor()
    self.executed = false
end

--coding function in here
function BindGateServerRspCommand:execute(note)
    --UnityEngine.Debug.Log('BindGateServerRspCommand')
    local state = note.body.state 
    local desc = note.body.desc 
 
    if state == ESocketState.ESS_Connected then 
        facade:sendNotification(Common.LOGIN_GATE_SERVER, connOperation)
    elseif state == ESocketState.ESS_ConnecttingFailed then  
        local delayTime = 6
        --facade:sendNotification(Common.UPDATE_LOGIN_MENU, string.format(luaTool:GetLocalize("re_connect_countdown"), tostring(delayTime)))
        timer = LuaTimer.Add(1000,1000, function(id)
            delayTime = delayTime - 1 
            if delayTime == 0 then 
                if timer then 
                    LuaTimer.Delete(timer)
                    timer = nil 
                end 
                BindServerHelper:BindGateServer(true)
            else 
                facade:sendNotification(Common.UPDATE_LOGIN_MENU, string.format(luaTool:GetLocalize("re_connect_countdown"), tostring(delayTime)))
            end 
        end)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        BindServerHelper:ShowBindGateServerFailMenu(desc) 
    end 
    
    --[[if state == ESocketState.ESS_Invalid then 
		facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    elseif state == ESocketState.ESS_Connectting then 
		facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    elseif state == ESocketState.ESS_NetError then 
		facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    elseif state == ESocketState.ESS_ConnecttingFailed then 
		facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    elseif state == ESocketState.ESS_Quit then 
		facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    else
        LogError("[ClientConn]:: invalid socket state") 
    end ]]
end

return BindGateServerRspCommand