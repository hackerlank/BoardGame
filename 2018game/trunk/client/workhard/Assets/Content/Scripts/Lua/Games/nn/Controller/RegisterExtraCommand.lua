local RegisterExtraCommand = class('RegisterExtraCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning
local Log = UnityEngine.Debug.Log

function RegisterExtraCommand:ctor()
	self.executed = false
end

function RegisterExtraCommand:execute(note)
	local game_manager = GetLuaGameManager()
	local gameName = game_manager.GetGameName()
	local game_type = game_manager.GetGameType()
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	local login_proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
	

	if nn == nil then 		
		local commandDef = 'CommandDef'	
		depends(root_path.GAME_MVC_CONTROLLER_PATH .. commandDef)
	end 
	Log("registering extra command of:: " .. gameName)
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	local hall_type = note.body.hall_type
	--register proxy
	if nil ~= nn.tb_proxy then 
		for k,v in ipairs(nn.tb_proxy) do 
			if facade:hasProxy(v.name) == false then 
				local finalPath = root_path.GAME_MVC_PROXY_PATH .. v.script
				local proxy = depends(finalPath)
				if nil ~= proxy then 
					proxy:SetHallServiceId(login_proxy:GetHallServiceId(hall_type))
					facade:registerProxy(proxy)		
				else 
					LogError("Failed to register proxy:: " .. v.name)
				end 
			else 
				LogWarning("Has registered proxy:: " .. v.name .. ". will skip")
			end  
		end 
	end

	--register commands
	if nil ~= nn.tb_commands  then 
		for k,v in ipairs(nn.tb_commands) do 
			if facade:hasCommand(v.name) == false then 
				local command = depends(root_path.GAME_MVC_CONTROLLER_PATH .. v.script)
				if command ~= nil then 
					facade:registerCommand(v.name, command)
				else 
					LogError("Failed to register command:: " .. v.name)
				end 
			else 
				LogWarning("Has registered:: " .. v.name .. ". will skip")
			end
		end 
	end 
end

return RegisterExtraCommand