--[[
  * ui view class:: UI_CreateNiuNiuTable
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
local MENU_OPEN_ANIM_TIME = 0.3

--delay play open animation of window
local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30

--open animation style
local CONST_OPEN_ANIM_STYLE = DG.Tweening.Ease.OutExpo

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
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_CreateNiuNiuTable') 

--close self can restore param
local CLOSE_CAN_RESTORE_PARAM = ci.GetUICloseParam().new(true, 'UI_CreateNiuNiuTable') 

--private function table
local m_PrivateFunc = {}

local txt_ps = nil 

local last_focused_game = nil 

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
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DOMoveX(m_RootPanel, 640, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, CONST_OPEN_ANIM_STYLE)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
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

--callback function of create btn
m_PrivateFunc.onClickCreateBtn = function()
    if facade ~= nil then 
        facade:sendNotification(Common.PRE_ENTER_HALL, {game_type = EGameType.EGT_ZhaJinHua, game_rule=m_GameRule, operation = EOperation.EO_CreateGame})
    end 
end

--real switch panel in here
m_PrivateFunc.SwithPanel = function(game)
    game = game or EGameType.EGT_NiuNiu
    local page  = tb_Pages[game]
    if page == nil then 
        return 
    end 

    if last_focused_game ~= nil then 
        if last_focused_game ~= game then 
            local last_page =  tb_Pages[last_focused_game]
            last_page.root:SetActive(false)
        else 
            return 
        end 
    end 
    if page.root ~= nil then 
        page.root:SetActive(true)
    end

    if page.LoadSetting ~= nil then 
        page.LoadSetting()
    end  
    last_focused_game = game
end 

--load niu niu setting 
m_PrivateFunc.LoadNiuNiuSetting = function()
end 

--initial niu niu panel 
m_PrivateFunc.InitialPanel_NiuNiu = function()
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



    page.LoadSetting = m_PrivateFunc.LoadNiuNiuSetting
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
    tb_Pages[EGameType.EGT_NiuNiu] = page
    bCanPlaySound = true
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
        LogError('[UI_CreateNiuNiuTable.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_RootPanel = transform:Find('Panel')
    
    txt_ps = transform:Find("Panel/bottom/txt_tip"):GetComponent("Text")
    tb_Pages = {}
    create_table_ps = luaTool:GetLocalize("create_table_ps")
    btn = transform:Find("Panel/bottom/btn_create"):GetComponent("Button")
    btn.onClick:AddListener(onClickCreateBtn)
    table.insert(tb_btns, btn)

    tb_Pages = {}

    m_PrivateFunc.InitialPanel_NiuNiu()

    --register callback of buttons
    m_PrivateFunc.BindCallbacks()
    m_PrivateFunc.PlayOpenAmin()
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

function tbclass:SwithPanel(game)
    m_PrivateFunc.SwithPanel(game)
end

--Don't remove all of them
return tbclass