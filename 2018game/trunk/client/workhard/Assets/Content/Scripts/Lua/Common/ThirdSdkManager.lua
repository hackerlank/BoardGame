--[[
* third sdk manager. in here will register all third sdk
]]
local ThirdSdks = ThirdSdks or {}
local luaWeChatSdk = nil 

function ThirdSdks.Init()
    if GameHelper.isWithWeChat then 
        --init wechat sdk
        --careful save the appSecret
        luaWeChatSdk = depends("ThirdSdk.LuaWeChatSdk")
        luaWeChatSdk.Init()
    end 

    --coding for init other sdk
end 

function ThirdSdks.OnDestroy()
    if luaWeChatSdk ~= nil then 
        luaWeChatSdk.OnDestroy()
    end 
end 


return ThirdSdks