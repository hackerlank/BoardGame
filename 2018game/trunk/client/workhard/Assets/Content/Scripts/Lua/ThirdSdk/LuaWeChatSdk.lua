--[[
* wechar sdk for lua version
* deal login, share, pay response of wechat sdk
]]
local luaWeChatSdk = luaWeChatSdk or {}
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError

local m_WeChatCallbackInstance = nil 

--do not modify this section
local WECHAT_ERRORCODE_KEY_CONST = "errorcode_wechat."
local facade = nil 

--wechat login callback
local function onWeChatLogin(result)
    local m_result = JsonTool.Decode(result)
    local errcode = math.floor(tonumber(m_result.errcode))
    local tipKey = string.format("%s%s",WECHAT_ERRORCODE_KEY_CONST, errcode)
    if errcode == 0 then 
        --construct parameters for prepare login server
        local param = {}
        param[1] = {name = "refresh_token", value = m_result.refresh_token}
		param[2] = {name = "access_token", value = m_result.access_token}
		param[3] = {name = "openid", value = m_result.openid}

        --facade:sendNotification(Common.WECHAT_GET_USER_INFO)
        --send notification to login game
        facade:sendNotification(Common.LOGIN_GAME_SERVER, ci.GetLoginGameParam().new(ELoginType.wei_xin, param))
    else 
        facade:sendNotification(Common.OPEN_UI_COMMANDM, OCCLUSION_MENU_CLOSE_PARAM)
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, tipKey)
    end 
end

--wechat share callback
local function onWeChatShare(result)
    --Log("onWeChatShare " .. tostring(result))
    local m_result = JsonTool.Decode(result)
    local errcode = math.floor(tonumber(m_result.errcode))
    local tipKey = string.format("%s%s",WECHAT_ERRORCODE_KEY_CONST, errcode)
    if errcode == EGameErrorCode.EGE_Success then 
        tipKey = WECHAT_ERRORCODE_KEY_CONST .. "share"
    end 
    facade:sendNotification(Common.RENDER_MESSAGE_KEY, tipKey)
end 

--wechat pay callback
local function onWeChatPay(result)
    --Log("onWeChatPay " .. tostring(result))
    local m_result = JsonTool.Decode(result)
    local tipKey = nil 
    local errcode = math.floor(tonumber(m_result.errcode))
    if errcode == 0 then 
        tipKey = string.format("%s%s",WECHAT_ERRORCODE_KEY_CONST, "share")
    else 
        tipKey = string.format("%s%s",WECHAT_ERRORCODE_KEY_CONST, errcode)
    end 
    facade:sendNotification(Common.RENDER_MESSAGE_KEY, tipKey)
end 

local function onWeChatGetUserInfo(result)

    local m_result = JsonTool.Decode(result) 
    print(result)
    local errcode = math.floor(tonumber(m_result.errcode))
    if errcode == 0 then 
        local loginProxy = pm.Facade.getInstance().retrieveProxy(Common.LOGIN_PROXY)
       -- loginProxy:SetUserInfos(m_result)
    else    
        local tipKey = string.format("%s%s",WECHAT_ERRORCODE_KEY_CONST, errcode)
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, tipKey)
    end
end 

--[[AppID : wxcd3a9a8ef9081e16
AppSecret : 06348052aef42ac3dbd07d554ae41799]]

--[[zchilin 
WeChatSDK.Init("wx730dca9bb5e4dcdc", "f8d462216096ad2b8c5b90f22c46028d")
]]
function luaWeChatSdk.Init()
    Log("init lua wechat manager ....")
    WeChatSDK.Init("wxcd3a9a8ef9081e16", "06348052aef42ac3dbd07d554ae41799")
    m_WeChatCallbackInstance = WeChatCallback.Instance
    --register listener
    m_WeChatCallbackInstance.onLoginWeChat:AddListener(onWeChatLogin)
    m_WeChatCallbackInstance.onWeChatPay:AddListener(onWeChatPay)
    m_WeChatCallbackInstance.onWeChatShare:AddListener(onWeChatShare)
    m_WeChatCallbackInstance.onGetUserInfoWeChat:AddListener(onWeChatGetUserInfo)
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
end 

function luaWeChatSdk.OnDestroy()
    m_WeChatCallbackInstance.onLoginWeChat:RemoveAllListeners()
    m_WeChatCallbackInstance.onWeChatPay:RemoveAllListeners()
    m_WeChatCallbackInstance.onWeChatShare:RemoveAllListeners()
    m_WeChatCallbackInstance.onGetUserInfoWeChat:RemoveAllListeners()
    facade = nil 
end 

return luaWeChatSdk