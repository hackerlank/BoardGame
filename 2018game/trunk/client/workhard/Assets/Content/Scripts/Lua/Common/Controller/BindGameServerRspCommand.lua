--[[
  * COMMAND:: BindGameServerRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local BindGameServerRspCommand = class('BindGameServerRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local Log = UnityEngine.Debug.Log

--constructor function. do not overwrite it
function BindGameServerRspCommand:ctor()
    self.executed = false
end

--coding function in here
function BindGameServerRspCommand:execute(note)
    --UnityEngine.Debug.Log('BindGameServerRspCommand')
    local state = note.body.state 
    local desc = note.body.desc 
    local timer = nil 
    if state == ESocketState.ESS_Connected then 
        timer = LuaTimer.Add(200,function()
            -- body
            facade:sendNotification(Common.PRE_LOGIN_GAME_SERVER)
            if timer then 
                LuaTimer.Delete(timer)
                timer = nil
            end 
        end)
        
    else
        BindServerHelper:ShowBindGameServerFailMenu(luaTool:GetLocalize("failed_connect_to_server")) 
    end 
end

return BindGameServerRspCommand