--Command:: register new account 
local RegisterAccountCommand = class('RegisterAccountCommand', pm.SimpleCommand)


function RegisterAccountCommand:ctor()
    self.executed = false
end

function RegisterAccountCommand:execute(note)
 
    --[[local password = "123456"
    local loginType = LoginType.user_name
    local user_name = string.format("%s%s%s%s%s%s%s", "user",os.date("%y"), os.date("%m"), os.date("%d"),os.date("%H"),os.date("%M"), os.date("%S") )
    local param = ci.GetLoginGameParam().new(loginType, user_name, password)
    local loginProxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(Common.LOGIN_PROXY)
    loginProxy:RegisterAccount(param)]]
    
end

return RegisterAccountCommand