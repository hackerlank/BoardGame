--[[
  * ui view class:: UI_Log
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

local m_LogList  = nil 
local m_ListItem = nil 

local m_allLogs = ListObject()
local m_infoLogs = ListObject()
local m_warningLogs = ListObject()
local m_errorLogs = ListObject()
local ELogType = UnityEngine.LogType

local m_ShowPanelTween = nil 
local m_ShowPanelTweenTime = 0.3

local btn_hide = nil 
local btn_show = nil 

local m_currentFocus = -1 

local m_DetailPanel = nil 
local txt_detail = nil 

local DEFINED_INFO_COLOR = UnityEngine.Color(21/255, 236/255, 138/255, 255/255)
local DEFINED_WARNING_COLOR = UnityEngine.Color(249/255, 190/255, 0/255, 255/255)
local DEFINED_ERROR_COLOR = UnityEngine.Color(240/255, 49/255, 5/255, 255/255)

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_Log') 

--close self can restore param
local CLOSE_CAN_RESTORE_PARAM = ci.GetUICloseParam().new(true, 'UI_Log') 

--================private interface begin =====================
--callback function of closeing animation has been completed
local function OnComplete()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 

--play the opening animation of menu
local function PlayOpenAmin()
    --TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0.1, 0.1, 0.1)
    --play animation 
    gameObject:SetActive(true)
    --@todo you need to edit the animation style in here
    m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, m_ShowPanelTweenTime)
    DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.Linear)
    DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
    DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnComplete)
    DoTweenPathLuaUtil.DOPlay(m_RootPanel)
end 

--callback function of close button
local function onClickCloseBtn()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 


local function onClickFilterBtn(logType)
    if m_currentFocus ~= nil and m_currentFocus == logType  then 
        return
    end 
    m_currentFocus = logType
    if logType == nil then 
        m_LogList:SetListInfos(m_allLogs,true)
    elseif logType == ELogType.Log then 
        m_LogList:SetListInfos(m_infoLogs,true)
    elseif logType == ELogType.Warning then 
        m_LogList:SetListInfos(m_warningLogs,true)
    elseif logType == ELogType.Error then 
        m_LogList:SetListInfos(m_errorLogs,true)
    end 
end 

local function onClickShowDetailBtn(info)
    local s = info.m_content .. "\n" .. info.m_track
    if txt_detail then 
        txt_detail.text = s 
        local logType = info.m_LogType
        if logType == ELogType.Log then 
            txt_detail.color = DEFINED_INFO_COLOR
        elseif logType == ELogType.Warning then 
            txt_detail.color = DEFINED_WARNING_COLOR
        elseif logType == ELogType.Error then 
            txt_detail.color = DEFINED_ERROR_COLOR
        end 
    end 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    if m_DetailPanel then 
        m_DetailPanel:SetActive(true)
    end 
end 

local function onClickHideDetailBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    m_DetailPanel:SetActive(false)
end 


local function onShowPanelComplete()
    btn_show.gameObject:SetActive(false)
    btn_hide.gameObject:SetActive(true)

    if m_currentFocus == nil then 
        onClickFilterBtn(nil)
    end 
end 

local function onShowPanelRewind()
    btn_show.gameObject:SetActive(true)
    btn_hide.gameObject:SetActive(false)
end 

local function onClickHideBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
end 

local function onClickShowBtn()
    if m_ShowPanelTween == nil then 
        m_ShowPanelTween = DoTweenPathLuaUtil.DOMoveX(m_RootPanel, 640, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_ShowPanelTween, DG.Tweening.Ease.OutExpo)
        DoTweenPathLuaUtil.SetAutoKill(m_ShowPanelTween, false)
        DoTweenPathLuaUtil.OnComplete(m_ShowPanelTween, onShowPanelComplete)
        DoTweenPathLuaUtil.OnRewind(m_ShowPanelTween, onShowPanelRewind)
       
    end 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    DoTweenPathLuaUtil.DORestart(m_RootPanel)
end 

--bind callback for buttons in here
local function BindCallbacks()
    local btn = m_RootPanel:GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickCloseBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/btn_hide'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickHideBtn)
        table.insert(tb_btns, btn)
        btn_hide = btn 
        btn_hide.gameObject:SetActive(false)
    end

    btn = m_RootPanel:Find('btns/btn_show'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickShowBtn)
        table.insert(tb_btns, btn)
        btn_show = btn
    end

    btn = m_RootPanel:Find('btns/filter/btn_all'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function()  AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose) onClickFilterBtn(nil) end)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/filter/btn_info'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function()  AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose) onClickFilterBtn(ELogType.Log) end)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/filter/btn_warning'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function()  AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose) onClickFilterBtn(ELogType.Warning) end)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/filter/btn_error'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function()  AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose) onClickFilterBtn(ELogType.Error) end)
        table.insert(tb_btns, btn)
    end

end 

local function InitialLogList()
    m_ListItem = {}
    m_LogList = m_RootPanel:Find("logList").gameObject
    m_LogList = m_RootPanel:Find("logList"):GetComponent("GameScrollRect")
    if m_LogList ~= nil then 
        m_LogList:SetColumn(25)
        m_LogList:SetListInfos(nil,true)
        local m_Content = m_LogList.content
        if m_Content ~= nil then 
            local count = m_Content.childCount
            for i=0, count-1 do 
                local trans = m_Content:GetChild(i)
                if trans ~= nil then 
                    local t = {}
                    t.item = trans:GetComponent("SlotItemInfo")
                    t.text = trans:Find("text"):GetComponent("Text")
                    t.btn = trans:GetComponent("Button")

                    t.Free = function()
                        t.item = nil 
                        t.text = nil 
                        t = nil 
                    end

                    if t.item then 
                        t.item.onValueChanged:AddListener(function() 
                            t.text.text = t.item.info.m_content
                            local logType = t.item.info.m_LogType
                            if logType == ELogType.Log then 
                                t.text.color = DEFINED_INFO_COLOR
                            elseif logType == ELogType.Warning then 
                                t.text.color = DEFINED_WARNING_COLOR
                            elseif logType == ELogType.Error then 
                                t.text.color = DEFINED_ERROR_COLOR
                            end 
                        end)
                    end 

                    t.btn.onClick:AddListener(function()
                        onClickShowDetailBtn(t.item.info)
                    end)

                    table.insert(m_ListItem, t)
                end 
            end 
        end 
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
        LogError('[UI_Log.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_RootPanel = transform:Find('Panel')
    BindCallbacks()
    InitialLogList()

    m_DetailPanel = m_RootPanel:Find("Panel").gameObject
    local btn = m_DetailPanel:GetComponent("Button")
    btn.onClick:AddListener(onClickHideDetailBtn)
    table.insert(tb_btns, btn)
    txt_detail = m_DetailPanel.transform:Find("content"):GetComponent("Text")
    m_DetailPanel:SetActive(false)
    Logs.Instance.luaTable = self
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

function  tbclass:FreshWindow()
    onClickFilterBtn(nil)
end

function  tbclass.OnLogCallback(params)

    if params == nil then 
        return 
    end 

    local log = {}
    log.m_LogType = params.logType
    log.m_content = params.content
    log.m_track = params.track
    m_allLogs:Add(log)
    if log.m_LogType == ELogType.Log then 
        m_infoLogs:Add(log)
    elseif log.m_LogType == ELogType.Warning then 
        m_warningLogs:Add(log)
    elseif log.m_LogType == ELogType.Error then 
        m_errorLogs:Add(log)
    end 
end
--Don't remove all of them
return tbclass