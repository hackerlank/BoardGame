
--[[
  * COMMAND:: LoginGateServerCommand. 
  *   login gate server
  *
  *   with facade. like::
  *   facade:sendNotification(command-string ,note)
  *   Warning:: note can not be nil 
]]

local LoginGateServerCommand = class('LoginGateServerCommand', pm.SimpleCommand)

--constructor function. do not overwrite it
function LoginGateServerCommand:ctor()
    self.executed = false
end

--coding function in here
function LoginGateServerCommand:execute(note)
    local loginProxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(Common.LOGIN_PROXY)
    --loginProxy:StartHeart()
    loginProxy:LoginGate()
end

return LoginGateServerCommand