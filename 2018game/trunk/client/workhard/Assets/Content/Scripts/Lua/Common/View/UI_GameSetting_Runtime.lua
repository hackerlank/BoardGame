--[[
  * ui view class:: UI_GameSetting_Runtime
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

local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30
--cache gameObject of window
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

--save game facade
local facade = nil

--cache all btns for we can quickly remove listeners of them
local tb_btns = nil 
--sound setting transforms 
local tb_SoundSet = nil 
--music setting transforms
local tb_MusicSet = nil 
--animation time amount
local AMIN_TIME = 0.06

local btn_logout = nil 
local btn_dismiss = nil

--whether setting has been modified
local bDirty = false 

local m_RootPanel = nil 
local m_OpenAnimTween = nil 
local MENU_OPEN_ANIM_TIME = 0.15

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, Common.MENU_SETTING_RUNTIME) 

--==================== callbacks of button begin====================
local function _Close()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

local function onClickCloseBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    _Close()
end 

--switch account
local function onClickLogoutBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    --facade:sendNotification(Common.LOGOUT)
    if mediator:IsPlayRecord() == true then 
        facade:sendNotification(mj_cdxz.EXIT_PLAY_RECORD)
    else 
        local command = GetLuaGameManager().GetGameName() .. ".player_leave_game"
        facade:sendNotification(command)
        _Close()
    end 
end 

local function onClickDismissBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    _Close()
    local command = GetLuaGameManager().GetGameName() .. ".player_leave_game"
    pm.Facade.getInstance(GAME_FACADE_NAME):sendNotification(command)
    
end 
--==================== callbacks of button end======================pleav

--================private interface begin =====================
--callback function of closeing animation has been completed
local function OnRewind()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 

--play the opening animation of menu
local function PlayOpenAmin()
    TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0, 0, 0)
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        --play animation 
        gameObject:SetActive(true)
        m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.InOutBack)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
end 

local function onSoundSettingChanged(bEnabled, bPostEvent)
     bPostEvent = bPostEvent or true 
     
    if bEnabled == true then 
        if tb_SoundSet.tween ~= nil then 
            DoTweenPathLuaUtil.DOPlayBackwards(tb_SoundSet.m_FlagTrans)
        end 
    else 
        if tb_SoundSet.tween == nil then 
            tb_SoundSet.tween =  DoTweenPathLuaUtil.DOMoveX(tb_SoundSet.m_FlagTrans,tb_SoundSet.m_EndPos.x,  AMIN_TIME)
            DoTweenPathLuaUtil.SetAutoKill(tb_SoundSet.tween, false)
            DoTweenPathLuaUtil.OnComplete(tb_SoundSet.tween, function()
                    tb_SoundSet.btn_enable.gameObject:SetActive(true)
                    tb_SoundSet.btn_disable.gameObject:SetActive(false)
                end)

                DoTweenPathLuaUtil.OnRewind(tb_SoundSet.tween, function()
                    tb_SoundSet.btn_enable.gameObject:SetActive(false)
                    tb_SoundSet.btn_disable.gameObject:SetActive(true)
                end)
        end 
        DoTweenPathLuaUtil.DORestart(tb_SoundSet.m_FlagTrans)
    end 

    if bPostEvent == true then 
        facade:sendNotification(Common.ON_SOUND_SETTING_CHANGED, ci:GetMusicSoundSettingChangedParam().new(bEnabled, nil))
        bDirty = true
    end 
end 

local function onMusicSettingChanged(bEnabled, bPostEvent)
    bPostEvent = bPostEvent or true 
    if bEnabled == true then 
        if tb_MusicSet.tween ~= nil then 
            DoTweenPathLuaUtil.DOPlayBackwards(tb_MusicSet.m_FlagTrans)
        end 
    else 
        if tb_MusicSet.tween == nil then 
            tb_MusicSet.tween =  DoTweenPathLuaUtil.DOMoveX(tb_MusicSet.m_FlagTrans,tb_MusicSet.m_EndPos.x,  AMIN_TIME)
            DoTweenPathLuaUtil.SetAutoKill(tb_MusicSet.tween, false)
            DoTweenPathLuaUtil.OnComplete(tb_MusicSet.tween, function()
                    tb_MusicSet.btn_enable.gameObject:SetActive(true)
                    tb_MusicSet.btn_disable.gameObject:SetActive(false)
                end)

                DoTweenPathLuaUtil.OnRewind(tb_MusicSet.tween, function()
                    tb_MusicSet.btn_enable.gameObject:SetActive(false)
                    tb_MusicSet.btn_disable.gameObject:SetActive(true)
                end)
        end 
        DoTweenPathLuaUtil.DORestart(tb_MusicSet.m_FlagTrans)
    end 

    if bPostEvent == true then 
        facade:sendNotification(Common.ON_MUSIC_SETTING_CHANGED, ci:GetMusicSoundSettingChangedParam().new(bEnabled, nil))
        bDirty = true
    end 
end 

--============private interface end ===========================



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
        LogError('[UI_GameSetting.Init]:: missing transform')
        return
    end 
    m_RootPanel = transform:Find("Panel")
    gameObject:SetActive(false)
   
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    local btn = transform:Find("Panel/btns/btn_close"):GetComponent("Button")
    btn.onClick:AddListener(onClickCloseBtn)
    table.insert(tb_btns, btn)

    btn_logout = transform:Find("Panel/btns/btn_logout"):GetComponent("Button")
    btn_logout.onClick:AddListener(onClickLogoutBtn)
    table.insert(tb_btns, btn_logout)

    btn_dismiss = transform:Find("Panel/btns/btn_dismiss"):GetComponent("Button")
    btn_dismiss.onClick:AddListener(onClickDismissBtn)
    table.insert(tb_btns, btn_dismiss)

    local trans = nil 
    trans = transform:Find("Panel/section/sound")
    tb_SoundSet = {} 
    tb_SoundSet.btn_enable = trans:Find("btn_enable"):GetComponent("Button")
    tb_SoundSet.btn_enable.onClick:AddListener(function() 
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose) 
        onSoundSettingChanged(true) 
    end)
    tb_SoundSet.btn_disable = trans:Find("btn_disable"):GetComponent("Button")
    tb_SoundSet.btn_disable.onClick:AddListener(function()
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        onSoundSettingChanged(false)
    end)
    tb_SoundSet.m_FlagTrans = trans:Find("img_flag")
    tb_SoundSet.m_EndPos = trans:Find("endpos").position

    trans = transform:Find("Panel/section/music")
    tb_MusicSet = {} 
    tb_MusicSet.btn_enable = trans:Find("btn_enable"):GetComponent("Button")
    tb_MusicSet.btn_enable.onClick:AddListener(function()
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        onMusicSettingChanged(true) 
    end)
    tb_MusicSet.btn_disable = trans:Find("btn_disable"):GetComponent("Button")
    tb_MusicSet.btn_disable.onClick:AddListener(function()
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        onMusicSettingChanged(false) 
    end)
    tb_MusicSet.m_FlagTrans = trans:Find("img_flag")
    tb_MusicSet.m_EndPos = trans:Find("endpos").position
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
    if bDirty then 
        facade:sendNotification(Common.ON_SAVE_GAMESETTING)
    end
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

    if tb_SoundSet ~= nil then 
        tb_SoundSet.btn_enable.onClick:RemoveAllListeners()
        tb_SoundSet.btn_enable = nil 
        tb_SoundSet.btn_disable.onClick:RemoveAllListeners()
        tb_SoundSet.btn_disable = nil 
        tb_SoundSet.m_FlagTrans = nil 
        tb_SoundSet.m_EndPos = nil 
        if tb_SoundSet.tween ~= nil then 
            DoTweenPathLuaUtil.Kill(tb_SoundSet.tween, false)
        end 
        tb_SoundSet.tween = nil 
        tb_SoundSet = nil 
    end 

    if tb_MusicSet ~= nil then 
        tb_MusicSet.btn_enable.onClick:RemoveAllListeners()
        tb_MusicSet.btn_enable = nil 
        tb_MusicSet.btn_disable.onClick:RemoveAllListeners()
        tb_MusicSet.btn_disable = nil 
        tb_MusicSet.m_FlagTrans = nil 
        tb_MusicSet.m_EndPos = nil 
        if tb_MusicSet.tween ~= nil then 
            DoTweenPathLuaUtil.Kill(tb_MusicSet.tween, false)
        end 
        tb_MusicSet.tween = nil 
        tb_MusicSet = nil 
    end 
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_OpenAnimTween, true)
        m_OpenAnimTween = nil 
        m_RootPanel = nil 
    end 
    windowAsset = nil   
    facade = nil
    if transform ~= nil then 
        transform.gameObject:SetActive(false)
        UnityEngine.GameObject.Destroy(transform.gameObject)
    end 
end

function tbclass:FreshWindow(bEnabledMusic, bEnabledSound)
    
    onSoundSettingChanged(bEnabledSound, false)
    onMusicSettingChanged(bEnabledMusic, false)
    local cor = coroutine.create(function() 

        UnityEngine.Yield(UnityEngine.WaitForSeconds(AMIN_TIME))
        PlayOpenAmin()
    end)
    coroutine.resume(cor)

    local renderDismiss = true 
    if mediator:IsPlayRecord() == true then 
        renderDismiss = false 
    elseif mediator:IsGamePlay() == false then 
        renderDismiss = false 
    end 

    if renderDismiss == true then 
        btn_dismiss.gameObject:SetActive(true)
        btn_logout.gameObject:SetActive(false)
    else 
        btn_dismiss.gameObject:SetActive(false)
        btn_logout.gameObject:SetActive(true)
    end 

end

function tbclass:NtfStartVote()
    -- body
    --_Close()
end



--Don't remove all of them
return tbclass