
--[[
  * COMMAND:: RegisterUpdatesCommand. 
  *   edit helpful in here ......
  *
  *   with facade. like::
  *   facade:sendNotification(command-string ,note)
  *   Warning:: note can not be nil 
]]

local RegisterUpdatesCommand = class('RegisterUpdatesCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function RegisterUpdatesCommand:ctor()
    self.executed = false
end

--coding function in here
function RegisterUpdatesCommand:execute(note)
    local commandDef = 'Common.Controller.CommandDef'
    depends(commandDef)
    
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    if facade == nil then 
          LogError("Cant load the facade object instance.... will return")
          return
    end 

      local bValid = true

      if Common.tb_cmdUpdate ~= nil then 
          for k,v in ipairs(Common.tb_cmdUpdate) do 
              if nil ~= v then 
                  bValid = v.name ~= nil and v.name ~= "" and v.script ~= nil and v.script ~= ""
                  if bValid then 
                      local command = depends(v.script)
                      facade:registerCommand(v.name, command)
                  else 
                      LogError("RegisterUpdateCommand:: Invalid command skip it");
                  end 
              end 
          end 
    else 
        LogError("Failed to register common command because Common.tb_commands is nil.")
    end 
end

return RegisterUpdatesCommand