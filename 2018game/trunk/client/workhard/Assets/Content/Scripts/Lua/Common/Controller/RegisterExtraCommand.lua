--this command will be invoked when puremvc has been inited. The first command of games
local RegisterExtraCommand = class('RegisterExtraCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

function RegisterExtraCommand:ctor()
	self.executed = false
end

function RegisterExtraCommand:execute(note)
    if Common == nil then 
	    depends("Common.Controller.CommandDef")
    end
	
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	if facade == nil then 
        LogError("Cant load the facade object instance.... will return")
        return
	end 

    local bValid = true
    --register proxy first
    if nil ~= Common.tb_proxy then 
        for k,v in ipairs(Common.tb_proxy) do 
            bValid = v.name ~= nil and v.name ~= "" and v.script ~= nil and v.script ~= ""
            if bValid then 
                if facade:hasProxy(v.name) == false then 
                    local proxy = depends(v.script)
                    if nil ~= proxy then 
                        --facade:registerProxy(proxy.new(v.name))
                        facade:registerProxy(proxy)
                    end 
                else 
                    LogWarning("proxy map contains " .. v.name .. ". will skip")
                end 
            else 
                LogError("RegisterExtraCommand:: Invalid proxy skip it ");
            end 
        end 
    end 

    if Common.tb_commands ~= nil then 
        for k,v in ipairs(Common.tb_commands) do 
            if nil ~= v then 
                bValid = v.name ~= nil and v.name ~= "" and v.script ~= nil and v.script ~= ""
                if bValid then 
                    local command = depends(v.script)
                    facade:registerCommand(v.name, command)
                else 
                    LogError("RegisterExtraCommand:: Invalid command skip it");
                end 
            end 
        end 
	else 
        LogError("Failed to register common command because Common.tb_commands is nil.")
    end 
end

return RegisterExtraCommand