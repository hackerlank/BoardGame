--[[
  * ui view class:: UI_WeChatShare
  * @Opened
  *   this function will be invoked after menu object has been created.each of menu view class
  *   must contains it.
  * @Init
  *   this function will be automatic called by Opened
  * @OnDisable
  *   this function will be invoked when player is hiding window. each of menu 
  *   menu view class must contains it.  called by mediator
  * @OnRestore
  *   this function will be invoked when player wants to re-render self. called by mediator
  * @OnClose
  *   this function will be called when player is closing self. called by mediator. 
  *   will call SafeRelease function to safely free assets .. etc
  * @SafeRelease
  *   unbind listeners, free asset references, destroy windown object ... etc. if self is not be called 
  *   will cause memory leak.
  * @NOTE
  *  if self want to revice unity events such as Update , FixedUpdate.please register self to lua game mode.
  *  Generally OnDestory function is useless for menu, so you should not implement OnDestory function.
]]
local tbclass = tbclass or {} 

--log function reference. remove these if needed
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
   
--cache gameobject of window
local gameObject = nil 

--cache transform of window
local transform = nil

--window name
local windownName = nil

--loaded lua asset. custom definition data type
local windowAsset = nil

--whether self has been opened
local bOpened = false

--save the mediator
local mediator = nil

--save all btns
local tb_btns = nil 

--save game facade
local facade = nil
--root panel.
local m_RootPanel = nil 
--saved the animation tween object of menu
local m_OpenAnimTween = nil 
--menu animation last time
local MENU_OPEN_ANIM_TIME = 0.15
local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_WeChatShare') 

local SHARE_FRIEND_PARAM = nil
local SHARE_TIMELINE_PARAM = nil

local bPlayCloseSound = true

--============ callback of buttons begin ====================
--callback function of close button
local function onClickCloseBtn()
    if bPlayCloseSound == true then 
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    end 
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

--share to friend
local function onClickFriendBtn()
    
    if SHARE_FRIEND_PARAM == nil then 
        local title = luaTool:GetLocalize("main_share_title")
        local desc = luaTool:GetLocalize("main_share_description")
        local url = luaTool:GetLocalize("main_share_url")
        local imgPath = nil --luaTool:GetLocalize("main_share_img_path")
        SHARE_FRIEND_PARAM = ci.GetWeChatShareParam().new(EShareType.EST_Text, EWeChatSceneType.EWCS_Friend, title, desc, url,nil, "", true)
    end 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    bPlayCloseSound = false
    facade:sendNotification(Common.WECHAT_SHARE, SHARE_FRIEND_PARAM)
    onClickCloseBtn()
end 

--share to timeline
local function onClickTimelineBtn()

    if SHARE_TIMELINE_PARAM == nil then 
        local title = luaTool:GetLocalize("main_share_title")
        local desc = luaTool:GetLocalize("main_share_description")
        local url = luaTool:GetLocalize("main_share_url")
        local imgPath = nil --luaTool:GetLocalize("main_share_img_path")
        SHARE_TIMELINE_PARAM = ci.GetWeChatShareParam().new(EShareType.EST_Text, EWeChatSceneType.EWCS_Timeline, title, desc, url, nil, "", true)
    end 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.WECHAT_SHARE, SHARE_TIMELINE_PARAM)
    bPlayCloseSound = false
    onClickCloseBtn()
end 
--============ callback of buttons end ======================

--================private interface begin =====================
--callback function of closeing animation has been completed
local function OnRewind()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 

--play the opening animation of menu
local function PlayOpenAmin()
    TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0, 0, 0)
    --play animation 
    --@todo you need to edit the animation style in here
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.InOutBack)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
end 

--bind callback for buttons in here
local function BindCallbacks()
    m_RootPanel = transform:Find('Panel')
    local btn = m_RootPanel:GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickCloseBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/btn_close'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickCloseBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/btn_friend'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickFriendBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/btn_timeline'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickTimelineBtn)
        table.insert(tb_btns, btn)
    end

end 
--================private interface end =====================

--opened events. called by uiManager
function tbclass:Opened(inTrans, inName, luaAsset)
    transform = inTrans
    windownName = inName
    windowAsset = luaAsset
    gameObject = transform.gameObject
    self:Init()
    bOpened = true
end 

--bind listeners, ...etc
function tbclass:Init()
    if transform == nil then 
        LogError('[UI_WeChatShare.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}

    BindCallbacks()

    PlayOpenAmin()
end 

--set the mediator
--@param inMediator 
function tbclass:SetMediator(inMediator)
    mediator = inMediator
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

    if tb_btns ~= nil then 
        for k,v in ipairs(tb_btns) do 
            if v then 
                v.onClick:RemoveAllListeners()
            end 
            tb_btns[k] = nil 
        end 
        tb_btns = nil 
    end 

    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_OpenAnimTween, true)
        m_OpenAnimTween = nil 
    end 
    m_RootPanel = nil 

    windowAsset = nil   
    facade = nil
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end

--Don't remove all of them
return tbclass