--[[
  * ui view class:: UI_CreateZhaJinHuaTable
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
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_CreateZhaJinHuaTable') 

--cache all btns
local tb_btns = nil 

--cache all pages
local tb_Pages = nil 

local txt_ps = nil 

--keys for xzdd 
local KEY_MAX_ROUND = "max_round"
local KEY_ROOM_CARD = "pay_room_card"
local KEY_PAY_MODE = "pay_mode"
local KEY_235 = "enable_235_win_plane"
local KEY_TAX = "enable_tax"
local KEY_SHOW_LAST_CARDS = "enable_show_last_hand_cards"
local KEY_TABLE_MODE = "table_mode"
--keys for xzdd end

local FOCUSED_COLOR = UnityEngine.Color(135/255,2/255,0/255,255/255)
local DEFAULT_COLOR = UnityEngine.Color(89/255,76/255,67/255,255/255)

local DEFINED_ROUND = {{round=5,card=5}, {round=10,card=20}, {round=15,card=30}, {round=20,card=40}}
local DEFINED_PAY = {1,2,3,4}
local DEFINED_TABLE_MODE = {1,2}

local m_RootPanel = nil 
local m_OpenAnimTween = nil 
local MENU_OPEN_ANIM_TIME = 0.3

local bCanPlaySound = false 

local EPages = {
    default=1
}

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
        facade:sendNotification(Common.PRE_ENTER_HALL, {game_type = EGameType.EGT_ZhaJinHua, game_rule=m_GameRule, operation = EOperation.EO_CreateGame})
    end 
end

--================ callabcks end =====================


--================ private interface =================
local function LoadZhaJinHuaSetting()
    m_GameRule = GetGameConfig():GetDefaultGameRule()
    if m_GameRule == nil then  
        return 
    end 
    local key = 1 
    local page = tb_Pages[EPages.default]
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
        elseif k == KEY_PAY_MODE then 
            for _,sv in ipairs(DEFINED_PAY) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_TableMode[key].toggle.isOn = true 
        elseif k == KEY_TABLE_MODE then 
            for _,sv in ipairs(DEFINED_TABLE_MODE) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_Pay[key].toggle.isOn = true 
        elseif k == KEY_TAX then 
            page.m_chixi.toggle.isOn = v 
        elseif k == KEY_SHOW_LAST_CARDS then 
            page.m_showcard.toggle.isOn = v 
        elseif k == KEY_235 then 
            page.m_235.toggle.isOn = true
        end 
    end 

end 

local function InitialPanel_ZhaJinHua()
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

    page.m_TableMode = {}
    for i=1,2 do 
        local item = {}
        trans = root:Find("members/section/" .. i)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[KEY_TABLE_MODE] == DEFINED_TABLE_MODE[i]
                m_GameRule[KEY_TABLE_MODE] = DEFINED_PAY[i]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_TableMode, item)
    end 

    --chixi
    page.m_chixi = {}
    page.m_chixi.toggle = root:Find("option/chixi"):GetComponent("Toggle")
    page.m_chixi.desc = root:Find("option/chixi/desc"):GetComponent("Text")
    page.m_chixi.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_TAX] = isOn
        if isOn == true then 
            page.m_chixi.desc.color = FOCUSED_COLOR
        else 
            page.m_chixi.desc.color = DEFAULT_COLOR
        end
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --show card
    page.m_showcard = {}
    page.m_showcard.toggle = root:Find("option/showcard"):GetComponent("Toggle")
    page.m_showcard.desc = root:Find("option/showcard/desc"):GetComponent("Text")
    page.m_showcard.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[KEY_SHOW_LAST_CARDS] = isOn
        if isOn == true then 
            page.m_showcard.desc.color = FOCUSED_COLOR
        else 
            page.m_showcard.desc.color = DEFAULT_COLOR
        end
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

     --235
     page.m_235 = {}
     page.m_235.toggle = root:Find("option/235"):GetComponent("Toggle")
     page.m_235.desc = root:Find("option/235/desc"):GetComponent("Text")
     page.m_235.toggle.onValueChanged:AddListener(function(isOn) 
         m_GameRule[KEY_235] = isOn
         if isOn == true then 
             page.m_235.desc.color = FOCUSED_COLOR
         else 
             page.m_235.desc.color = DEFAULT_COLOR
         end
         if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
     end)



    page.LoadSetting = LoadZhaJinHuaSetting
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

        for _,v in ipairs(page.m_Pay) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_Pay[_] = nil 
        end 
        page.m_Pay = nil 

        page.m_chixi.toggle.onValueChanged:RemoveAllListeners()
        page.m_chixi.desc = nil 
        page.m_chixi = nil 

        page.m_235.toggle.onValueChanged:RemoveAllListeners()
        page.m_235.desc = nil 
        page.m_235 = nil 

        page.m_showcard.toggle.onValueChanged:RemoveAllListeners()
        page.m_showcard.desc = nil 
        page.m_showcard = nil 
    end 
    tb_Pages[EPages.default] = page
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

    InitialPanel_ZhaJinHua()
    
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
    mode = mode or EPages.default
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