
--[[
  * CLASS:: UI_Login.
  *   controll the main menu render state
  * @ transform the window 
  * @Opened
  *   this function will be invoked after menu object has been created.each of menu view class
  *   must contains it.
  * @Init
  *   this function will be automatic called by Opened if open this menu without restore type. 
  *   otherwise will not init again. 
  * @OnClose
  *   this function will be invoked when menu object has been disabled or destroied. each of menu 
  *   menu view class must contains it. because we must manually release assets, callback etc to 
  *   avoid memory leak.
  * @NOTE
  *  if self want to revice unity events such as Update , FixedUpdate.please register self to lua game mode.
  *  Generally OnDestory function is useless for menu, so you should not implement OnDestory function.  l
]]
local tbclass = tbclass or {}

local transform = nil
local windownName = nil
local windowAsset = nil

local btn_tourist = nil 
local btn_wechat = nil 
local facade = nil 

local m_EnterPanel = nil 
local btn_enterLogin = nil 
local m_nameInput = nil 
local m_passwordInput = nil 

local btn_aggrement = nil 
local toggle_agreement = nil 
local btn_close = nil 

--[[
 * Opened will be called  after menu object has been created, each of menu view class must contains 
 * @param inTrans  the transform object of menu window. it will help us to init the menu.
 * @param inName the name of menu window. it also as the key to avoid open same menu more than once in UIManager
 * @param bRestore if bRestore is true, will init the menu. 
 *
]]
function tbclass:Opened(inTrans, inName, luaAsset)
    transform = inTrans
    windownName = inName
    windowAsset = luaAsset
    self:Init()
end 

local function CreateNewPlayer()
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))

    local userName = "test101"-- .. math.random(1,1000)
    local password = "123"

    facade:sendNotification(Common.REGISTER_ACCOUNT, ci.GetLoginGameParam().new(userName, password))
end 

local function LoginGame(name, password)
    if toggle_agreement.isOn == true then 
        if UIManager.getInstance():HasOpened(Common.MENU_CONNECT) == false then
            facade:sendNotification(Common.OPEN_UI_COMMAND, CONNECT_MENU_OPEN_PARAM)
        end
        facade:sendNotification(Common.UPDATE_LOGIN_MENU, luaTool:GetLocalize("user_login"))
        UnityEngine.PlayerPrefs.SetInt(DEFINED_KEY_LOGIN_TYPE, ELoginType.user_name)
        facade = pm.Facade.getInstance(GAME_FACADE_NAME)
        local login_type = ELoginType.user_name
        local params = {}
        params[1] = {name="user_name",value=name}
        params[2] = {name="user_pass",value=password}
        --cache login name and password
        UnityEngine.PlayerPrefs.SetString(DEFINED_KEY_USER_NAME, name)
        UnityEngine.PlayerPrefs.SetString(DEFINED_KEY_PASSWROD, password)
        facade:sendNotification(Common.LOGIN_GAME_SERVER, ci.GetLoginGameParam().new(login_type, params))
    else 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.disaggre")
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
    end 
end 

local function IsCanAutoLogin()
    if UnityEngine.PlayerPrefs.HasKey(DEFINED_KEY_LOGIN_TYPE) == true then 
        local type = UnityEngine.PlayerPrefs.GetInt(DEFINED_KEY_LOGIN_TYPE)
        if type == ELoginType.user_name then 
            local name =  UnityEngine.PlayerPrefs.GetString(DEFINED_KEY_USER_NAME)
            local pwd = UnityEngine.PlayerPrefs.GetString(DEFINED_KEY_PASSWROD)
            if name and pwd then 
                if name ~= "" and pwd ~= "" then 
                    return true, type 
                end 
            end 
        elseif type == ELoginType.wei_xin then 
            return true, type
        end 
    end 

    return false
end 

local function onClickBtnLogin()
    local name = m_nameInput.text 
    local password = m_passwordInput.text 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    LoginGame(name, password)
end 

local function onClickWeChatLogin()
    if GameHelper.isEditor == true then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.notsurpported")
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
    elseif WeChatSDK.IsWeChatInstalled() == false then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.notinstalled")
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
    else 
        if toggle_agreement.isOn == false then 
            facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.disaggre")
            facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
        else 
            if UIManager.getInstance():HasOpened(Common.MENU_CONNECT) == false then
                facade:sendNotification(Common.OPEN_UI_COMMAND, CONNECT_MENU_OPEN_PARAM)
            end
            facade:sendNotification(Common.UPDATE_LOGIN_MENU, luaTool:GetLocalize("user_login"))
            UnityEngine.PlayerPrefs.SetInt(DEFINED_KEY_LOGIN_TYPE, ELoginType.wei_xin)
            facade:sendNotification(Common.WECHAT_LOGIN)
        end 
    end     
end 

local USER_AGGREMENT_MENU_PARAM = nil
local function onClickOpenAggrementMenuBtn()
    if USER_AGGREMENT_MENU_PARAM == nil then 
        USER_AGGREMENT_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_USER_AGGREMENT, EMenuType.EMT_Common, nil, false)
    end 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.OPEN_UI_COMMAND, USER_AGGREMENT_MENU_PARAM)
end 

local function InitialEnterPanel()
    m_EnterPanel = transform:Find("Panel")
    btn_enterLogin = m_EnterPanel:Find("btns/btn_login"):GetComponent("Button")
    btn_enterLogin.onClick:AddListener(onClickBtnLogin)
    
    m_nameInput = m_EnterPanel:Find("input/name/InputField"):GetComponent("InputField")
    m_passwordInput = m_EnterPanel:Find("input/password/InputField"):GetComponent("InputField")

    local name = "test111"
    local pwd = "123"
    if UnityEngine.PlayerPrefs.HasKey(DEFINED_KEY_PASSWROD) == true then 
       name = UnityEngine.PlayerPrefs.GetString(DEFINED_KEY_USER_NAME)
       pwd = UnityEngine.PlayerPrefs.GetString(DEFINED_KEY_PASSWROD)
    end 

    m_nameInput.text = name
    m_passwordInput.text = pwd

    btn_close = m_EnterPanel:GetComponent("Button")
    if btn_close then 
        btn_close.onClick:AddListener(function()
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
            btn_tourist.gameObject:SetActive(true)
            btn_wechat.gameObject:SetActive(true)
            m_EnterPanel.gameObject:SetActive(false)  
        end)
    end 
end 

function tbclass:Init()
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    btn_tourist = transform:Find("btn_tourist"):GetComponent("Button") --transform:Find("Panel/btnBG/btn_tourist"):GetComponent("Button")
    btn_tourist.gameObject:SetActive(true)
    btn_tourist.onClick:AddListener(function() 
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        btn_tourist.gameObject:SetActive(false)
        btn_wechat.gameObject:SetActive(false)
        m_EnterPanel.gameObject:SetActive(true)
    end)
    
    transform:Find("txt_gamewarning"):GetComponent("Text").text = luaTool:GetLocalize("game_warning_ps")
    btn_wechat = transform:Find("btn_wechat"):GetComponent("Button") --transform:Find("Panel/btnBG/btn_wechat"):GetComponent("Button")
    btn_wechat.gameObject:SetActive(true)
    btn_wechat.onClick:AddListener(function() 
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        onClickWeChatLogin()
    end)

    btn_aggrement = transform:Find("btn_aggrement"):GetComponent("Button")
    btn_aggrement.onClick:AddListener(onClickOpenAggrementMenuBtn)

    toggle_agreement = transform:Find("toggle_aggre"):GetComponent("Toggle")
    if UnityEngine.PlayerPrefs.HasKey(DEFINED_KEY_AGGREMENT) == false then 
        UnityEngine.PlayerPrefs.SetInt(DEFINED_KEY_AGGREMENT, 1)
        toggle_agreement.isOn = true 
    else 
        toggle_agreement.isOn = UnityEngine.PlayerPrefs.GetInt(DEFINED_KEY_AGGREMENT) == 1
    end 

    toggle_agreement.onValueChanged:AddListener(function (isOn) 
        local value = 1 
        if isOn == false then 
            value = 0
        end 
        if bInit == false then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
        UnityEngine.PlayerPrefs.SetInt(DEFINED_KEY_AGGREMENT, value)
    end)
    InitialEnterPanel()

    if GameHelper.isDistribution == true then 
        btn_tourist.gameObject:SetActive(false)
    end 

    local txt_version = transform:Find("txt_version"):GetComponent("Text")
    if GameHelper.isEditor == true  or GameHelper.isDistribution == true  then 
        txt_version.text = ""
    else
        local m_content = luaTool:ReadFile("Common/GameVersion")
        local json_data = nil 
        if m_content and  m_content ~= "" then 
            json_data = JsonTool.Decode(m_content) 
        end 

        if json_data == nil then 
            txt_version.text = ""
        else
            local currentPlatform = GameHelper.runtimePlatform
            local verison_data = nil 
            for k,v in pairs(json_data) do 
                if v then 
                    if v.platform == currentPlatform then 
                        verison_data = v 
                        break
                    end 
                end 
            end
            if verison_data then 
                txt_version.text = "内部测试版本：" .. verison_data.development_version 
            else 
                txt_version.text = ""
            end 
        end
    end 
end 

function  tbclass:StartAutoLogin()
    local bAuto, type = IsCanAutoLogin()
    if bAuto == true then 
        --show mask menu
        if type == ELoginType.wei_xin then 
            onClickWeChatLogin()
        else
            local name =  UnityEngine.PlayerPrefs.GetString(DEFINED_KEY_USER_NAME)
            local pwd = UnityEngine.PlayerPrefs.GetString(DEFINED_KEY_PASSWROD)
            m_nameInput.text = name 
            m_passwordInput.text = pwd
            LoginGame(name, pwd)
        end 
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
    end 
end 

function tbclass:FreshWindow(name, password)
   
end 

--OnDisable:: called by mediator
function tbclass:OnDisable()

end 

--OnRestore:: called by mediator
function tbclass:OnRestore()

end 

--OnClose:: called by mediator
function tbclass:OnClose()
    bOpened = false
    self:SafeRelease()
    transform = nil
end 

--release asset reference, unbind listeners...etc
function tbclass:SafeRelease()
    if windowAsset ~= nil then 
        windowAsset:Free(1)
    end 
    windowAsset = nil   

    if btn_login ~= nil then 
        btn_login.onClick:RemoveAllListeners()
        btn_login = nil
    end 

    if btn_new ~= nil then 
        btn_new.onClick:RemoveAllListeners()
        btn_new = nil
    end 

    if btn_close then 
        btn_close.onClick:RemoveAllListeners()
    end 
    btn_close = nil 

    if btn_aggrement ~= nil then 
        btn_aggrement.onClick:RemoveAllListeners()
    end 
    btn_aggrement = nil 
    if toggle_agreement ~= nil then 
        toggle_agreement.onValueChanged:RemoveAllListeners()
    end 
    toggle_agreement = nil 
    USER_AGGREMENT_MENU_PARAM = nil
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end 
return tbclass