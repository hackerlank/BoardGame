--[[
  * ui view class:: UI_Vote
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
local MENU_OPEN_ANIM_TIME = 0.11
local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30

local txt_tip = nil 

local txt_agree = nil 

local m_Timer = nil 
local endTime = nil  

local initial_agree_text = ""

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_Vote') 

--============ callback of buttons begin ====================
local function EnableBtns(bEnable)
    if tb_btns ~= nil then 
        for k,v in ipairs(tb_btns) do   
            if v then 
                v.interactable = bEnable 
            end 
        end 
    end 
end 
--callback function of close button
local function onClickCloseBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

local function onClickAggreBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.PLAYER_VOTE_DISMISS, true)
    --EnableBtns(false)
end 

local function onClickRefuseBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    facade:sendNotification(Common.PLAYER_VOTE_DISMISS, false)
    --EnableBtns(false)
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
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME, function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.Linear)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
end 

--bind callback for buttons in here
local function BindCallbacks()
    m_RootPanel = transform:Find('Panel')
    
    local btn = m_RootPanel:Find('btns/btn_close'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickRefuseBtn)
        table.insert(tb_btns, btn)
    end

    local btn = m_RootPanel:Find('btns/btn_refuse'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickRefuseBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/btn_aggre'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickAggreBtn)
        table.insert(tb_btns, btn)
        txt_agree = btn.gameObject.transform:Find("Text"):GetComponent("Text")
        initial_agree_text = txt_agree.text 
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
        LogError('[UI_Vote.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}

    BindCallbacks()

    txt_tip = transform:Find("Panel/txt_content"):GetComponent("Text")
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
    if m_Timer then 
        LuaTimer.Delete(m_Timer)
        m_Timer = nil 
    end 

    txt_sure = nil 

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
    txt_tip = nil 
    windowAsset = nil   
    facade = nil
    if gameObject ~= nil then 
        UnityEngine.GameObject.Destroy(gameObject);
    end 
    gameObject = nil 
end

local function StartFreshTimer(end_time)
    local remain = nil 
    local curTime = os.time()
    if end_time > 0 and end_time > curTime then 
        endTime = end_time 
        m_Timer = LuaTimer.Add(0,1000,function(id)
            curTime = os.time()
            remain = math.ceil(endTime - curTime)
            txt_agree.text = string.format("(%ss)", tostring(remain))
            if remain <= 0 then 
                --if m_Timer then 
                --    LuaTimer.Delete(m_Timer)
                --  m_Timer = nil 
                --end 

                --@todo try to send refuse msg?? or close self 
                onClickCloseBtn()
            end 
        end)
    end 
end 

function tbclass:FreshTip(user_name, emd_time )
    if txt_tip ~= nil then 
        txt_tip.text = string.format(luaTool:GetLocalize("dismiss_room"), tostring(user_name) )
    end 

    StartFreshTimer(emd_time)

end

function tbclass:NtfVoteFail()
    EnableBtns(true)
end 

function tbclass:NtfVoteSuccess()
    --
    onClickCloseBtn()
end 


function tbclass:NtfPlayerVoted(user_name,aggre)
end 
--Don't remove all of them
return tbclass