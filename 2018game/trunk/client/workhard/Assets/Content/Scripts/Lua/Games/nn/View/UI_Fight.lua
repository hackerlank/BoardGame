--[[
  * ui view class:: UI_Fight
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
  
--menu animation last time
local MENU_OPEN_ANIM_TIME = 0.11

--delay play open animation of window
local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30

--open animation style
local CONST_OPEN_ANIM_STYLE = DG.Tweening.Ease.InOutBack

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
--whether is playing opening animation of window
local m_IsPlaying = false

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_Fight') 

--close self can restore param
local CLOSE_CAN_RESTORE_PARAM = ci.GetUICloseParam().new(true, 'UI_Fight') 

--private function table
local m_PrivateFunc = {}

--================private interface begin =====================
--callback function of closeing animation has been completed
m_PrivateFunc.OnComplete = function()
    --you can to something after animation done
end 

m_PrivateFunc.OnRewind = function()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end

--play the opening animation of menu
--there is a simple scale animation.
m_PrivateFunc.PlayOpenAmin = function()
    m_IsPlaying = true
    gameObject:SetActive(false)
    TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0, 0, 0)
    LuaTimer.Add( CONST_PLAY_OPEN_ANIM_DELAY_TIME ,function(timer) 
        --delete the timer
        LuaTimer.Delete(timer)
        --play animation 
        gameObject:SetActive(true)
        
        --@todo you need to edit the animation style in here
        m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, CONST_OPEN_ANIM_STYLE)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnComplete(m_OpenAnimTween, m_PrivateFunc.OnComplete)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, m_PrivateFunc.OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
end 

--callback function of close button
m_PrivateFunc.onClickCloseBtn = function()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 


--bind callback for buttons in here
m_PrivateFunc.BindCallbacks = function()
    local btn = m_RootPanel:GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(m_PrivateFunc.onClickCloseBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/btn_close'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(m_PrivateFunc.onClickCloseBtn)
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
    m_IsPlaying = false
    if transform == nil then 
        LogError('[UI_Fight.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_RootPanel = transform:Find('Panel')
    
    --register callback of buttons
    m_PrivateFunc.BindCallbacks()
end 

--set the mediator
--@param inMediator 
function tbclass:SetMediator(inMediator)
    mediator = inMediator
end 

--OnDisable:: called by mediator
function tbclass:OnDisable()
    if gameObject then 
        gameObject:SetActive(false)
    end 
end 

--OnRestore:: called by mediator
function tbclass:OnRestore()
    if gameObject then 
        gameObject:SetActive(true)

        --if has open animation . so play this animation
    end 
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
    CLOSE_SELF_PARAM = nil 
    CLOSE_CAN_RESTORE_PARAM = nil 
    if gameObject ~= nil then 
        UnityEngine.GameObject.Destroy(gameObject);
    end 
    gameObject = nil 
end

--Don't remove all of them
return tbclass