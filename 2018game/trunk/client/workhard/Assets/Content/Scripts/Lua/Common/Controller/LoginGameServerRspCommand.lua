--[[
 * Command::Deal login game response 
]]
local LoginGameRspCommand = class('LoginGameRspCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError
local Log = UnityEngine.Debug.Log

function LoginGameRspCommand:ctor()
	self.executed = false
end

function LoginGameRspCommand:execute(note)
    if note.body == nil then 
        return 
    end 
    local proxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(Common.LOGIN_PROXY)
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    if EGameErrorCode.EGE_Success == note.body.errorcode then 
        --try to save the token
        local login_type = note.body.param.login_type
        local extra_param = note.body.param.params
        if extra_param ~= nil then 
            for k,v in pairs(extra_param) do 
                if v.name == "access_token" then 
                    if login_type == ELoginType.wei_xin then 
                        WeChatSDK.BackupWeChatAccessToken(v.value)
                    end         
                end
            end 
        end 


        local gate_Address = proxy:GetGateAddress()
        if gate_Address ~= nil and gate_Address ~= "" then 
            --delay 0.3s and then connect to gate server
            local timer = LuaTimer.Add(300, function()
                BindServerHelper:BindGateServer(false)
                if timer then 
                    LuaTimer.Delete(timer)
                    timer = nil 
                end 
            end)
        else 
            LogError("[LoginGameRspCommand]:: the gate address is invalid.")
        end 
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        --the body is the failure login game reason
       -- local tipKey = string.format("%s%s",CONST_ERROR_MSGKEY_TITLE, tostring(note.body.errorcode))
        LogError("Login failed " .. tostring(note.body.code ) .. " desc=" .. tostring(note.body.desc))
        --if note.body.code == 1 then 
            WeChatSDK.LogoutWeChatAuth()
        --end 
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, note.body.desc)
        --if the login menu has not been opened, so directly open this window
        --[[if false ==  UIManager.getInstance():HasOpened(Common.MENU_LOGIN)  then 
            local param = ci.GetUiParameterBase().new(Common.MENU_LOGIN, EMenuType.EMT_Common, nil)
            facade:sendNotification(Common.OPEN_UI_COMMAND, param)
        end ]]
    end 
end

return LoginGameRspCommand