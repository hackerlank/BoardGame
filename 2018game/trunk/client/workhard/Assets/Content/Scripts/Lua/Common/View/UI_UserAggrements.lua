--[[
  * ui view class:: UI_UserAggrements
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
local MENU_OPEN_ANIM_TIME = 0.25
local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30

local m_list = nil 
local tb_listItems = nil 

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_UserAggrements') 

--================private interface begin =====================
--callback function of closeing animation has been completed
local function OnComplete()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 

local endPos = UnityEngine.Vector3(640,360,0)
--play the opening animation of menu
local function PlayOpenAmin()
    --play animation 
    gameObject:SetActive(true)
    --@todo you need to edit the animation style in here
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME, function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DOMove(m_RootPanel, endPos, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.InOutExpo)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnComplete)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
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


--bind callback for buttons in here
local function BindCallbacks()
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

end 

local function InitialList()
    tb_listItems = {}
    m_list = m_RootPanel:Find("list"):GetComponent("GameScrollRect")
    local szContent = luaTool:ReadFile("Common/UserAggrements")
    if not szContent or #szContent <= 0 then
		szContent = ""
	else
		szContent = string.gsub(szContent, "\r", "");
	end

	local tbLines = luaTool:Split(szContent, "\n");

    local listConent = ListObject()
    local newLine = ""
    local m_start = nil 
    local m_end = nil 
    for k,v in pairs(tbLines) do 
        listConent:Add(v)
        if k == 1 then  
            listConent:Add("")
        end  
    end 

    if m_list ~= nil then 
        m_list:SetColumn(listConent.Count)
        m_list:SetListInfos(nil,true)
        local m_Content = m_list.content
        if m_Content ~= nil then 
            local count = m_Content.childCount
            for i=0, count-1 do 
                local trans = m_Content:GetChild(i)
                if trans ~= nil then 
                    local item = trans:GetComponent("SlotItemInfo")
                    local txt_content = trans:GetComponent("Text")
                    if item ~= nil then 
                        item.onValueChanged:AddListener(function()
                            info = item.info 
                            if info ~= nil then 
                                txt_content.text = info
                            else 
                                txt_content.text = ""
                            end 
                
                        end)
                        table.insert(tb_listItems, item)
                    end 
                end 
            end 
        end 
    end 

    m_list:SetListInfos(listConent,true)
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
        LogError('[UI_UserAggrements.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_RootPanel = transform:Find('Panel')
    InitialList()
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

    if tb_listItems ~= nil then 
        for k,v in ipairs(tb_listItems) do 
            if v then 
                v.onValueChanged:RemoveAllListeners()
            end 
            tb_listItems[k] = nil 
        end 
        tb_listItems = nil 
    end 
    m_list = nil 

    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_OpenAnimTween, true)
        m_OpenAnimTween = nil 
    end 
    m_RootPanel = nil 

    windowAsset = nil   
    facade = nil
    if gameObject ~= nil then 
        UnityEngine.GameObject.Destroy(gameObject);
    end 
    gameObject = nil 
end

--Don't remove all of them
return tbclass