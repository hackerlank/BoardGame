local UnregisterExtraCommand = class('UnregisterExtraCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError


function UnregisterExtraCommand:ctor()
	self.executed = false
end

function UnregisterExtraCommand:execute(note)

    if Common == nil then 
        local commandDef = 'Common.Controller.CommandDef'
        depends(commandDef)
    end 
	
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

    if facade ~= nil then
        --register proxy first
        if nil ~= Common.tb_proxy then 
            for k,v in ipairs(Common.tb_proxy) do 
                if nil ~= v then 
                    if facade:hasProxy(v.name) then 
                        facade:removeProxy(v.name)
                    end 
                end 
            end 
        end 
        

        if Common.tb_commands ~= nil then 
            for k,v in ipairs(Common.tb_commands) do 
                if nil ~= v then 
                    if v.name ~= nil and v.script ~= "" then 
                        facade:removeCommand(v.name)
                    end 
                end 
            end 
        else 
            LogError("Failed to unregister common command because Common.tb_commands is nil..")
        end 

        if Common.tb_cmdUpdate ~= nil then 
            for k,v in ipairs(Common.tb_cmdUpdate) do 
                if nil ~= v then 
                    if v.name ~= nil and v.script ~= "" then 
                        facade:removeCommand(v.name)
                    end 
                end 
            end 
        else 
            LogError("Failed to unregister common command because Common.tb_commands is nil..")
        end 

        if Common.GameRegisterExtraCommand then 
            for k,v in pairs(Common.GameRegisterExtraCommand) do 
                facade:removeCommand(k)
            end 
        end 
    end 
end

return UnregisterExtraCommand