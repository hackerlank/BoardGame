--[[
*Remove all controllers, mediators, views, and commands when player has kill the game
]]
local UnregisterExtraCommand = class('UnregisterExtraCommand', pm.SimpleCommand)


function UnregisterExtraCommand:ctor()
	self.executed = false
end

function UnregisterExtraCommand:execute(note)
	local gameName = GetLuaGameManager().GetGameName()

	if nn == nil then 
		depends(root_path.GAME_MVC_CONTROLLER_PATH .. 'CommandDef')
	end 
	
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	
	if nil ~= facade then 
		if nil ~= nn.tb_commands then 
			for k,v in ipairs(nn.tb_commands) do 
				if v and v.name ~= nil and v.name ~= "" then 
					facade:removeCommand(v.name)
				end 
			end 
		end 

		if nil ~= nn.tb_proxy  then 
			for k,v in ipairs(nn.tb_proxy) do 
				if v and v.name ~= nil and v.name ~= "" then 
					facade:removeProxy(v.name)
				end 
			end 
		end 
		--UnityEngine.Debug.Log("unregister command of:: " .. gameName)
	end 
end

return UnregisterExtraCommand