--[[
 * Command:: call LoginGame function for login game client.
]]
local LoginGameServerCommand = class('LoginGameServerCommand', pm.SimpleCommand)


function LoginGameServerCommand:ctor()
	self.executed = false
end

function LoginGameServerCommand:execute(note)
    if note.body == nil then 
        return 
    end 

    local login_type = note.body:GetLoginType()
    local param = note.body:GetExtraParam()
    local proxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(Common.LOGIN_PROXY)
    if proxy ~= nil then 
        proxy:LoginGame(login_type, param)
    end
end

return LoginGameServerCommand