--[[
  * ui view class:: UI_CreateCDMJTable
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
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_CreateCDMJTable') 

--cache all btns
local tb_btns = nil 

--cache all pages
local tb_Pages = nil 

--keys for xzdd 
local KEY_MAX_ROUND = "max_round"
local KEY_ROOM_CARD = "pay_room_card"
local KEY_MAX_FAN = "max_fan"
local KEY_PAY_MODE = "pay_mode"
local KEY_ZI_MO = "zi_mo_mode"
local KEY_ENABLE_MQZZ = "enable_mqzz"
local KEY_DA_DUIZI_2 = "da_dui_zi_2_fan"
local KEY_TDH = "enable_tian_di_hu"
local KEY_YJJD = "enable_yjjd"
local KEY_HAI_DI_LAO = "enable_hdlp"
local KEY_HU_JIAO_ZHUAN_YI = "enable_hjzy"
local KEY_SWAP_CARD =  "swap_cards_mode"
local KEY_DIAN_GANG = "dgh_mode"
local KEY_GAME_MODE = "game_mode"
--keys for xzdd end

local FOCUSED_COLOR = UnityEngine.Color(135/255,2/255,0/255,255/255)
local DEFAULT_COLOR = UnityEngine.Color(89/255,76/255,67/255,255/255)

local XZDD_ROUND = {{round=4,card=2}, {round=8,card=3}, {round=12,card=4}}
local XZDD_LIMIT = {3,4,5,0}
local DEFINED_PAY = {1,2,3}
local DEFINED_ZIMO = {1,2}
local DEFINED_SWAP_CARD = {0,1,2}
local DEFINED_GANG = {1,2}
local DEFINED_GAME_MODE = {1,2}

local m_RootPanel = nil 
local m_OpenAnimTween = nil 
local MENU_OPEN_ANIM_TIME = 0.3

local create_table_ps = nil 
local txt_ps = nil 

local bCanPlaySound = false

--================= callbacks begin ====================
local function OnRewind()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 


local function onClickCloseBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

local function onClickCreateBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    if facade ~= nil then 
        facade:sendNotification(Common.PRE_ENTER_HALL, {game_type = EGameType.EGT_CDMaJiang, game_rule=m_GameRule, operation = EOperation.EO_CreateGame})
    end 
end

--================ callabcks end =====================


--================ private interface =================
local function LoadXZDDSetting()
    m_GameRule = GetGameConfig():GetDefaultGameRule()
    if m_GameRule == nil then 
        return 
    end 
    bCanPlaySound = false
    local key = 1 
    local page = tb_Pages[ERoomMode.ERM_xzdd]
    for k,v in pairs(m_GameRule) do 
        key = 1 
        if k == KEY_MAX_ROUND then 
            for _,sv in ipairs(XZDD_ROUND) do 
                if sv == v then 
                    key = _
                    txt_ps.text = string.format(create_table_ps, tostring(sv.card))
                    break
                end 
            end 
            page.m_Round[key].toggle.isOn = true 
        elseif k == KEY_GAME_MODE then 
            for _,sv in ipairs(DEFINED_GAME_MODE) do 
                if sv == v then 
                    key = _
                end 
            end 
            page.m_GameMode[key].toggle.isOn = true 
        elseif k == KEY_MAX_FAN then 
            for _,sv in ipairs(XZDD_LIMIT) do 
                if sv == v then 
                    key = _ 
                    break
                end 
            end 
            page.m_Limit[key].toggle.isOn = true 
        elseif k == KEY_ENABLE_MQZZ then 
            page.m_Mqzz.toggle.isOn = v 
        elseif k == KEY_HAI_DI_LAO then 
            page.m_Haidi.toggle.isOn = v 
        elseif k == KEY_HU_JIAO_ZHUAN_YI then 
            page.m_HuJiao.toggle.isOn = v 
        elseif k == KEY_SWAP_CARD then 
            for _,sv in ipairs(DEFINED_SWAP_CARD) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_SwapCard[key].toggle.isOn = true 
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
        elseif k == KEY_YJJD then 
            page.m_Yaojiuduijiang.toggle.isOn = v 
        elseif k == KEY_TDH then
            page.m_Tiandihu.toggle.isOn = true 
        elseif k == KEY_DA_DUIZI_2 then 
            page.m_Daduizi.toggle.isOn = v
        end 
        --[[elseif k == KEY_DIAN_GANG then 
            for _,sv in ipairs(DEFINED_GANG) do 
                if sv == v then 
                    key = _ 
                    break
                end 
            end 
            page.m_Gang[key].toggle.isOn = true 
        end ]]
    end 

    bCanPlaySound = true
end 

local function InitialPanel_XZDD()
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
                local bSame = m_GameRule[KEY_MAX_ROUND] == XZDD_ROUND[i].round
                m_GameRule[KEY_MAX_ROUND] = XZDD_ROUND[i].round
                m_GameRule[KEY_ROOM_CARD] = XZDD_ROUND[i].card
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
            txt_ps.text = string.format(create_table_ps, tostring(XZDD_ROUND[i].card))
        end) 
        table.insert(page.m_Round, item)
    end 

    page.m_GameMode = {}
    for z=1,2 do 
        local item = {} 
        trans = root:Find("option/xzxl/" .. z)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_GAME_MODE] == DEFINED_GAME_MODE[z]
                m_GameRule[KEY_GAME_MODE] = DEFINED_GAME_MODE[z]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 

        end)
        table.insert(page.m_GameMode, item)
    end 

    page.m_Limit = {}
    for t=1,4 do 
        local item = {}
        trans = root:Find("limit/section/" .. t)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
           
            if isOn == true then 
                local bSame = m_GameRule[KEY_MAX_FAN] == XZDD_LIMIT[t]
                m_GameRule[KEY_MAX_FAN] = XZDD_LIMIT[t]
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

    --[[page.m_Gang = {}
    for z=1, 2 do 
        local item = {}
        trans = root:Find("option/zimo/" .. z)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            
            if isOn == true then 
                local bSame = m_GameRule[KEY_DIAN_GANG] == DEFINED_GANG[z]
                m_GameRule[KEY_DIAN_GANG] = DEFINED_GANG[z]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_Gang, item)
    end]]

    --mqzz
    page.m_Mqzz = {}
    page.m_Mqzz.toggle = root:Find("option/menqing"):GetComponent("Toggle")
    page.m_Mqzz.desc = root:Find("option/menqing/desc"):GetComponent("Text")
    page.m_Mqzz.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_ENABLE_MQZZ] = isOn
        if isOn == true then 
            page.m_Mqzz.desc.color = FOCUSED_COLOR
        else 
            page.m_Mqzz.desc.color = DEFAULT_COLOR
        end
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --DA DUIZI
    page.m_Daduizi = {}
    page.m_Daduizi.toggle = root:Find("option/daduizi"):GetComponent("Toggle")
    page.m_Daduizi.desc = root:Find("option/daduizi/desc"):GetComponent("Text")
    page.m_Daduizi.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_DA_DUIZI_2] = isOn
        if isOn == true then 
            page.m_Daduizi.desc.color = FOCUSED_COLOR
        else 
            page.m_Daduizi.desc.color = DEFAULT_COLOR
        end 
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --TianDiHu
    page.m_Tiandihu = {}
    page.m_Tiandihu.toggle = root:Find("option/tiandihu"):GetComponent("Toggle")
    page.m_Tiandihu.desc = root:Find("option/tiandihu/desc"):GetComponent("Text")
    page.m_Tiandihu.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_TDH] = isOn
        if isOn == true then 
            page.m_Tiandihu.desc.color = FOCUSED_COLOR
        else 
            page.m_Tiandihu.desc.color = DEFAULT_COLOR
        end 
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --YaoJiuJiangDui
    page.m_Yaojiuduijiang = {}
    page.m_Yaojiuduijiang.toggle = root:Find("option/yaojiuduijiang"):GetComponent("Toggle")
    page.m_Yaojiuduijiang.desc = root:Find("option/yaojiuduijiang/desc"):GetComponent("Text")
    page.m_Yaojiuduijiang.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_YJJD] = isOn
        if isOn == true then 
            page.m_Yaojiuduijiang.desc.color = FOCUSED_COLOR
        else 
            page.m_Yaojiuduijiang.desc.color = DEFAULT_COLOR
        end 
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --HaiDiLaoPao
    page.m_Haidi = {}
    page.m_Haidi.toggle = root:Find("option/haidi"):GetComponent("Toggle")
    page.m_Haidi.desc = root:Find("option/haidi/desc"):GetComponent("Text")
    page.m_Haidi.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_HAI_DI_LAO] = isOn
        if isOn == true then 
            page.m_Haidi.desc.color = FOCUSED_COLOR
        else 
            page.m_Haidi.desc.color = DEFAULT_COLOR
        end 
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --HuJiaoZhuanYi
    page.m_HuJiao = {}
    page.m_HuJiao.toggle = root:Find("option/hujiaozhuanyi"):GetComponent("Toggle")
    page.m_HuJiao.desc = root:Find("option/hujiaozhuanyi/desc"):GetComponent("Text")
    page.m_HuJiao.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_HU_JIAO_ZHUAN_YI] = isOn
        if isOn == true then 
            page.m_HuJiao.desc.color = FOCUSED_COLOR
        else 
            page.m_HuJiao.desc.color = DEFAULT_COLOR
        end 
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --swap card
    page.m_SwapCard = {}
    for j=1, 3 do 
        local item = {}
        trans = root:Find("option/swap/" .. j)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            m_GameRule[KEY_SWAP_CARD] = DEFINED_SWAP_CARD[j]
            if isOn == true then 
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_SwapCard, item)
    end 

    page.LoadSetting = LoadXZDDSetting
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

        for _,v in ipairs(page.m_SwapCard) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_SwapCard[_] = nil 
        end 
        page.m_SwapCard = nil 

       --[[ for _,v in ipairs(page.m_Gang) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_Gang[_] = nil 
        end]] 
        page.m_SwapCard = nil 

        for _,v in ipairs(page.m_GameMode) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_GameMode[_] = nil 
        end 
        page.m_GameMode = nil 

        page.m_Daduizi.toggle.onValueChanged:RemoveAllListeners()
        page.m_Daduizi.desc = nil 
        page.m_Daduizi = nil 

        page.m_Haidi.toggle.onValueChanged:RemoveAllListeners()
        page.m_Haidi.desc = nil 
        page.m_Haidi = nil 

        page.m_Yaojiuduijiang.toggle.onValueChanged:RemoveAllListeners()
        page.m_Yaojiuduijiang.desc = nil 
        page.m_Yaojiuduijiang = nil 

        page.m_Mqzz.toggle.onValueChanged:RemoveAllListeners()
        page.m_Mqzz.desc = nil 
        page.m_Mqzz = nil 

        page.m_Tiandihu.toggle.onValueChanged:RemoveAllListeners()
        page.m_Tiandihu.desc = nil 
        page.m_Tiandihu = nil 

        page.m_HuJiao.toggle.onValueChanged:RemoveAllListeners()
        page.m_HuJiao.desc = nil 
        page.m_HuJiao = nil 
    end 
    tb_Pages[ERoomMode.ERM_xzdd] = page
end 

local function PlayOpenAmin() 
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DOMoveX(m_RootPanel, 640, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.OutExpo)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
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

    btn = transform:Find("Panel/bottom/btn_create"):GetComponent("Button")
    btn.onClick:AddListener(onClickCreateBtn)
    table.insert(tb_btns, btn)

    txt_ps = transform:Find("Panel/bottom/txt_tip"):GetComponent("Text")
    tb_Pages = {}
    create_table_ps = luaTool:GetLocalize("create_table_ps")
    InitialPanel_XZDD()

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