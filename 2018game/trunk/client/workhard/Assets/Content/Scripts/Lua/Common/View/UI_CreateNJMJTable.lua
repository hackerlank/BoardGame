--[[
  * ui view class:: UI_CreateNJMJTable
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

--save game facade
local facade = nil

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_CreateNJMJTable') 

--cache all btns
local tb_btns = nil 

--cache all pages
local tb_Pages = nil 

local txt_ps = nil 

--keys for xzdd 
local KEY_MAX_ROUND = "max_round"
local KEY_ROOM_CARD = "pay_room_card"
local KEY_MAX_FAN = "max_fan"
local KEY_PAY_MODE = "pay_mode"
local KEY_ZI_MO = "zi_mo_mode"
local KEY_DU_ZI_MO = "enable_bao_jiao_du_zi_mo"
local KEY_BAO_ZI = "bao_zi_mode"
local KEY_YI_PAI_DUO_YONG = "enable_yi_pai_duo_yong"
local KEY_GAME_MODE = "game_mode"
local KEY_PIAO = "piao_mode"
local KEY_MAX_PLAYER = "max_player"
--keys for xzdd end

local FOCUSED_COLOR = UnityEngine.Color(135/255,2/255,0/255,255/255)
local DEFAULT_COLOR = UnityEngine.Color(89/255,76/255,67/255,255/255)

local DEFINED_ROUND = {{round=5,card=2}, {round=10,card=3}, {round=15,card=4}}
local DEFINED_FAN_LIMIT = {3,4,5}
local DEFINED_PAY = {1,2}
local DEFINED_ZIMO = {1,2}
local DEFINED_GAME_MODE = {1,2}
local DEFINED_MAX_PLAYER = {3,4}
local DEFINED_PIAO = {0,1,2,3}
local DEFINED_BAO_ZI = {0,1,2}

local m_RootPanel = nil 
local m_OpenAnimTween = nil 
local MENU_OPEN_ANIM_TIME = 0.3

local bCanPlaySound = false 

--================= callbacks begin ====================
local function OnRewind()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 

local function PlayOpenAnim() 
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DOMoveX(m_RootPanel, 640, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.OutExpo)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
end 

local function onClickCloseBtn()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

local function onClickCreateBtn()
    if facade ~= nil then 
        facade:sendNotification(Common.PRE_ENTER_HALL, {game_type = EGameType.EGT_NJMaJiang, game_rule=m_GameRule, operation = EOperation.EO_CreateGame})
    end 
end

--================ callabcks end =====================


--================ private interface =================
local function LoadNJMJSetting()
    m_GameRule = GetGameConfig():GetDefaultGameRule()
    if m_GameRule == nil then 
        return 
    end 
    local key = 1 
    local page = tb_Pages[ERoomMode.ERM_njmj]
    for k,v in pairs(m_GameRule) do 
        key = 1
        if k == KEY_MAX_ROUND then 
            for _,sv in ipairs(DEFINED_ROUND) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_Round[key].toggle.isOn = true 
        elseif k == KEY_MAX_FAN then 
            for _,sv in ipairs(DEFINED_FAN_LIMIT) do 
                if sv == v then 
                    key = _ 
                    break
                end 
            end 
            page.m_Limit[key].toggle.isOn = true 
        elseif k == KEY_YI_PAI_DUO_YONG then 
            page.m_YiPaiDuoYong.toggle.isOn = v 
        elseif k == KEY_BAO_ZI then 
            for _,sv in ipairs(DEFINED_BAO_ZI) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_BaoZi[key].toggle.isOn = true 
            --page.m_BaoZi.toggle.isOn = v 
        elseif k == KEY_DU_ZI_MO then 
            page.m_DuZiMo.toggle.isOn = v 
        elseif k == KEY_PIAO then 
            for _,sv in ipairs(DEFINED_PIAO) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_Piao[key].toggle.isOn = true 
        elseif k == KEY_PAY_MODE then 
            for _,sv in ipairs(DEFINED_PAY) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_Pay[key].toggle.isOn = true 
        elseif k == KEY_ZI_MO then 
            for _,sv in ipairs(DEFINED_ZIMO) do 
                if sv == v then 
                    key = _ 
                    break
                end 
            end 
            page.m_Zimo[key].toggle.isOn = true 
        elseif k == KEY_MAX_PLAYER then 
            for _,sv in ipairs(DEFINED_MAX_PLAYER) do 
                if sv == v then 
                    key = _ 
                    break
                end 
            end 
            page.m_PlayerLimit[key].toggle.isOn = true 
        end 
    end 

end 

local function InitialPanel_NJMJ()
    local root = transform:Find("Panel/pages/page1")
    local page = {}
    page.root = root.gameObject

    page.m_Round = {}

    --initial round 
    local trans = nil 
    for i=1,3 do 
        local item = {}
        trans = root:Find("round/section/" .. i)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_MAX_ROUND] == DEFINED_ROUND[i].round
                m_GameRule[KEY_MAX_ROUND] = DEFINED_ROUND[i].round
                m_GameRule[KEY_ROOM_CARD] = DEFINED_ROUND[i].card
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
                txt_ps.text = string.format(create_table_ps, tostring(DEFINED_ROUND[i].card))
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_Round, item)
    end 

    page.m_Limit = {}
    for t=1,3 do 
        local item = {}
        trans = root:Find("limit/section/" .. t)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_MAX_FAN] == DEFINED_FAN_LIMIT[t]
                m_GameRule[KEY_MAX_FAN] = DEFINED_FAN_LIMIT[t]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_Limit, item)
    end 
    
    page.m_Pay = {}
    for s=1,3 do 
        local item = {}
        trans = root:Find("pay/section/" .. s)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_PAY_MODE] == DEFINED_PAY[s]
                m_GameRule[KEY_PAY_MODE] = DEFINED_PAY[s]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_Pay, item)
    end 

    page.m_Zimo = {}
    for w=1, 2 do 
        local item = {}
        trans = root:Find("option/zimo/" .. w)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_ZI_MO] == DEFINED_ZIMO[w]
                m_GameRule[KEY_ZI_MO] = DEFINED_ZIMO[w]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_Zimo, item)
    end

    --yi pai duo yong
    page.m_YiPaiDuoYong = {}
    page.m_YiPaiDuoYong.toggle = root:Find("option/yipaiduoyong"):GetComponent("Toggle")
    page.m_YiPaiDuoYong.desc = root:Find("option/yipaiduoyong/desc"):GetComponent("Text")
    page.m_YiPaiDuoYong.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_YI_PAI_DUO_YONG] = isOn
        if isOn == true then 
            page.m_YiPaiDuoYong.desc.color = FOCUSED_COLOR
        else 
            page.m_YiPaiDuoYong.desc.color = DEFAULT_COLOR
        end
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    end)

    --bao zi
    page.m_BaoZi = {}
    for b=1, 3 do 
        local item = {}
        trans = root:Find("option/baozi/" .. b)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_BAO_ZI] == DEFINED_BAO_ZI[b]
                m_GameRule[KEY_BAO_ZI] = DEFINED_BAO_ZI[b]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_BaoZi, item)
    end

    --du zi mo
    page.m_DuZiMo = {}
    page.m_DuZiMo.toggle = root:Find("option/duzimo"):GetComponent("Toggle")
    page.m_DuZiMo.desc = root:Find("option/duzimo/desc"):GetComponent("Text")
    page.m_DuZiMo.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_DU_ZI_MO] = isOn
        if isOn == true then 
            page.m_DuZiMo.desc.color = FOCUSED_COLOR
        else 
            page.m_DuZiMo.desc.color = DEFAULT_COLOR
        end 
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --piao
    page.m_Piao = {}
    for j=1, 4 do 
        local item = {}
        trans = root:Find("option/piao/" .. j)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_PIAO] == DEFINED_PIAO[J]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
                m_GameRule[KEY_PIAO] = DEFINED_PIAO[j]
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_Piao, item)
    end 

    page.m_PlayerLimit = {}
    for k=1, 2 do 
        local item = {}
        trans = root:Find("members/section/" .. k)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_MAX_PLAYER] == DEFINED_MAX_PLAYER[K]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
                m_GameRule[KEY_MAX_PLAYER] = DEFINED_MAX_PLAYER[k]
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_PlayerLimit, item)
    end 

    page.LoadSetting = LoadNJMJSetting
    page.Free = function() 
        for _,v in ipairs(page.m_Round) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_Round[_] = nil 
        end 
        page.m_Round = nil 

        for _,v in ipairs(page.m_Limit) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_Limit[_] = nil 
        end 
        page.m_Limit = nil 

        for _,v in ipairs(page.m_Zimo) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_Zimo[_] = nil 
        end 
        page.m_Zimo = nil 

        for _,v in ipairs(page.m_Pay) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_Pay[_] = nil 
        end 
        page.m_Pay = nil 

        for _,v in ipairs(page.m_Piao) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_Piao[_] = nil 
        end 
        page.m_Piao = nil 

        for _,v in ipairs(page.m_PlayerLimit) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_PlayerLimit[_] = nil 
        end 
        page.m_PlayerLimit = nil 

        

        page.m_DuZiMo.toggle.onValueChanged:RemoveAllListeners()
        page.m_DuZiMo.desc = nil 
        page.m_DuZiMo = nil 

        page.m_YiPaiDuoYong.toggle.onValueChanged:RemoveAllListeners()
        page.m_YiPaiDuoYong.desc = nil 
        page.m_YiPaiDuoYong = nil 

        for _,v in ipairs(page.m_BaoZi) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_BaoZi[_] = nil 
        end 
        page.m_BaoZi = nil 
    end 
    tb_Pages[ERoomMode.ERM_njmj] = page
    bCanPlaySound = true
end 
--============== private interface  end=================

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
        LogError('[UI_CreateCDMJTable.Init]:: missing transform')
        return
    end 
    
    m_RootPanel = transform:Find("Panel")
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    local btn = transform:Find("Panel/btn_close"):GetComponent("Button")
    btn.onClick:AddListener(onClickCloseBtn)
    table.insert(tb_btns, btn)

    txt_ps = transform:Find("Panel/bottom/txt_tip"):GetComponent("Text")
    tb_Pages = {}
    create_table_ps = luaTool:GetLocalize("create_table_ps")
    btn = transform:Find("Panel/bottom/btn_create"):GetComponent("Button")
    btn.onClick:AddListener(onClickCreateBtn)
    table.insert(tb_btns, btn)

    tb_Pages = {}

    InitialPanel_NJMJ()
    
    PlayOpenAnim()

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
        for k,v in pairs(tb_btns) do 
            if v then 
                v.onClick:RemoveAllListeners()
                tb_btns[k] = nil 
            end 
        end 
        tb_btns = nil 
    end 
   
    if tb_Pages ~= nil then 
        for k,v in ipairs(tb_Pages) do 
            if v and v.Free then 
                v.Free()
            end 
            tb_Pages[k] = nil 
        end 
        tb_Pages = nil 
    end 
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_OpenAnimTween, true)
        m_OpenAnimTween = nil 
        m_RootPanel = nil 
    end 
    windowAsset = nil   
    facade = nil
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end

function tbclass:SwithMode(mode)
    local page  = tb_Pages[mode]
    if page == nil then 
        return 
    end 
    if page.root ~= nil then 
        page.root:SetActive(true)
    end

    if page.LoadSetting ~= nil then 
        page.LoadSetting()
    end  
end 

--Don't remove all of them
return tbclass