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

local FOCUSED_COLOR = UnityEngine.Color(135/255,2/255,0/255,255/255)
local DEFAULT_COLOR = UnityEngine.Color(89/255,76/255,67/255,255/255)

--private function table
local m_PrivateFunc = {}

local txt_ps = nil 

local focused_game = nil 

--for nn begin 
local NN_TABLE_MODE = {1,2,3}
local NN_MAX_ROUND = {5,10,15,20}
local NN_COST_CARD = {5,20,30,40}
local NN_PAY_MODE = {1,2,3,4}
local NN_BASE_CHIP = {10,20,30}

--[[
    enable_flush         是否支持同花顺
    enable_straight          是否支持顺子牛
    enable_suited        是否支持同花牛
    enable_five_big     是否支持五花牛
    enable_five_small   是否支持五小牛
    enable_full_house   是否支持葫芦牛
    enable_bomb         是否支持炸弹牛
]]
local NN_KEY_TABLE_MODE = "table_mode"
local NN_KEY_ROUND = "max_round"
local NN_KEY_ROOM_CARD = "pay_room_card"
local NN_KEY_BASE_CHIP = "base_chip"
local NN_KEY_PAY_MODE = "pay_mode"
local NN_KEY_FLUSH = "enable_flush"
local NN_KEY_STRAIGHT = "enable_straight"
local NN_KEY_SUITED = "enable_suited"
local NN_KEY_FIVE_BIG = "enable_five_big"
local NN_KEY_FIVE_SMALL = "enable_five_small"
local NN_KEY_FULL_HOUSE = "enable_full_house"
local NN_KEY_BOMB = "enable_bomb"
--for nn end

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
        m_OpenAnimTween = DoTweenPathLuaUtil.DOMoveX(m_RootPanel, 960, MENU_OPEN_ANIM_TIME)
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
        facade:sendNotification(Common.PRE_ENTER_HALL, {game_type = EGameType.EGT_NiuNiu, game_rule=m_GameRule, operation = EOperation.EO_CreateGame})
    end 
end

--real switch panel in here
m_PrivateFunc.SwithPanel = function(game)
    game = game or EGameType.EGT_NiuNiu
    local page  = tb_Pages[game]
    if page == nil then 
        return 
    end 

    if focused_game ~= nil then 
        if focused_game ~= game then 
            local last_page =  tb_Pages[focused_game]
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
    focused_game = game
end 

--load niu niu setting 
m_PrivateFunc.LoadNiuNiuSetting = function()
    m_GameRule = GetGameConfig():GetDefaultGameRule()
    if m_GameRule == nil then  
        return 
    end 
    local key = 1 
    local page = tb_Pages[EGameType.EGT_NiuNiu]
    for k,v in pairs(m_GameRule) do 
        key = 1
        if k == NN_KEY_ROUND then 
            for _,sv in ipairs(NN_MAX_ROUND) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_Round[key].toggle.isOn = true 
        elseif k == NN_KEY_TABLE_MODE then 
            for _,sv in ipairs(NN_TABLE_MODE) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_TableMode[key].toggle.isOn = true 
        elseif k == NN_KEY_PAY_MODE then 
            for _,sv in ipairs(NN_PAY_MODE) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_Pay[key].toggle.isOn = true 
        elseif k == NN_KEY_BASE_CHIP then 
            for _,sv in ipairs(NN_BASE_CHIP) do 
                if sv == v then 
                    key = _
                    break
                end 
            end 
            page.m_BaseChip[key].toggle.isOn = true 
        elseif k == NN_KEY_FLUSH then 
            page.m_flush.toggle.isOn = v 
        elseif k == NN_KEY_BOMB then 
            page.m_bomb.toggle.isOn = v 
        elseif k == NN_KEY_SUITED then 
            page.m_suited.toggle.isOn = v
        elseif k == NN_KEY_STRAIGHT then 
            page.m_straight.toggle.isOn = v 
        elseif k == NN_KEY_FULL_HOUSE then 
            page.m_fullhouse.toggle.isOn = v 
        elseif k == NN_KEY_FIVE_SMALL then 
            page.m_fivesmall.toggle.isOn = v
        elseif k == NN_KEY_FIVE_BIG then 
            page.m_fivebig.toggle.isOn = v
        end 
    end 
end 

--initial niu niu panel 
m_PrivateFunc.InitialPanel_NiuNiu = function()
    local root = transform:Find("Panel/pages/page1")
    local page = {}
    page.root = root.gameObject

    --initial round 
    local trans = nil 
    page.m_Round = {}
    for i=1,4 do 
        local item = {}
        trans = root:Find("round/section/" .. i)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[NN_KEY_ROUND] == NN_MAX_ROUND[i]
                m_GameRule[NN_KEY_ROUND] = NN_MAX_ROUND[i]
                m_GameRule[NN_KEY_ROOM_CARD] = NN_COST_CARD[i]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
                txt_ps.text = string.format(create_table_ps, tostring(NN_COST_CARD[i]))
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_Round, item)
    end 

    page.m_BaseChip = {} 
    for j=1,3 do 
        local item = {}
        trans = root:Find("base_chip/section/" .. j)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[NN_KEY_BASE_CHIP] == NN_BASE_CHIP[j]
                m_GameRule[NN_KEY_BASE_CHIP] = NN_BASE_CHIP[j]
                item.desc.color = FOCUSED_COLOR
                if bCanPlaySound == true and bSame == false then 
                    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
                end 
            else 
                item.desc.color = DEFAULT_COLOR
            end 
        end) 
        table.insert(page.m_BaseChip, item)
    end 

    
    page.m_Pay = {}
    for s=1,3 do 
        local item = {}
        trans = root:Find("pay/section/" .. s)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[NN_KEY_PAY_MODE] == NN_PAY_MODE[s]
                m_GameRule[NN_KEY_PAY_MODE] = NN_PAY_MODE[s]
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
    for i=1,3 do 
        local item = {}
        trans = root:Find("members/section/" .. i)
        item.toggle = trans:GetComponent("Toggle")
        item.desc = trans:Find("desc"):GetComponent("Text")
        item.toggle.onValueChanged:AddListener(function(isOn) 
            if isOn == true then 
                local bSame = m_GameRule[NN_KEY_TABLE_MODE] == NN_TABLE_MODE[i]
                m_GameRule[NN_KEY_TABLE_MODE] = NN_TABLE_MODE[i]
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

    --flush 同花顺
    page.m_flush = {}
    page.m_flush.toggle = root:Find("option/flush"):GetComponent("Toggle")
    page.m_flush.desc = root:Find("option/flush/desc"):GetComponent("Text")
    page.m_flush.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[NN_KEY_FLUSH] = isOn
        if isOn == true then 
            page.m_flush.desc.color = FOCUSED_COLOR
        else 
            page.m_flush.desc.color = DEFAULT_COLOR
        end
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --straight 顺子牛
    page.m_straight = {}
    page.m_straight.toggle = root:Find("option/straight"):GetComponent("Toggle")
    page.m_straight.desc = root:Find("option/straight/desc"):GetComponent("Text")
    page.m_straight.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[NN_KEY_STRAIGHT] = isOn
        if isOn == true then 
            page.m_straight.desc.color = FOCUSED_COLOR
        else 
            page.m_straight.desc.color = DEFAULT_COLOR
        end
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

     --suited 同花牛
     page.m_suited = {}
     page.m_suited.toggle = root:Find("option/suited"):GetComponent("Toggle")
     page.m_suited.desc = root:Find("option/suited/desc"):GetComponent("Text")
     page.m_suited.toggle.onValueChanged:AddListener(function(isOn) 
         m_GameRule[NN_KEY_SUITED] = isOn
         if isOn == true then 
             page.m_suited.desc.color = FOCUSED_COLOR
         else 
             page.m_suited.desc.color = DEFAULT_COLOR
         end
         if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
     end)


     --five_big 五大牛
    page.m_fivebig = {}
    page.m_fivebig.toggle = root:Find("option/five_big"):GetComponent("Toggle")
    page.m_fivebig.desc = root:Find("option/five_big/desc"):GetComponent("Text")
    page.m_fivebig.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[NN_KEY_FIVE_BIG] = isOn
        if isOn == true then 
            page.m_fivebig.desc.color = FOCUSED_COLOR
        else 
            page.m_fivebig.desc.color = DEFAULT_COLOR
        end
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

    --five_small wu xiao niu
    page.m_fivesmall = {}
    page.m_fivesmall.toggle = root:Find("option/five_small"):GetComponent("Toggle")
    page.m_fivesmall.desc = root:Find("option/five_small/desc"):GetComponent("Text")
    page.m_fivesmall.toggle.onValueChanged:AddListener(function(isOn) 
        m_GameRule[NN_KEY_FIVE_SMALL] = isOn
        if isOn == true then 
            page.m_fivesmall.desc.color = FOCUSED_COLOR
        else 
            page.m_fivesmall.desc.color = DEFAULT_COLOR
        end
        if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
    end)

     --full_house 葫芦牛
     page.m_fullhouse = {}
     page.m_fullhouse.toggle = root:Find("option/full_house"):GetComponent("Toggle")
     page.m_fullhouse.desc = root:Find("option/full_house/desc"):GetComponent("Text")
     page.m_fullhouse.toggle.onValueChanged:AddListener(function(isOn) 
         m_GameRule[NN_KEY_FULL_HOUSE] = isOn
         if isOn == true then 
             page.m_fullhouse.desc.color = FOCUSED_COLOR
         else 
             page.m_fullhouse.desc.color = DEFAULT_COLOR
         end
         if bCanPlaySound == true then 
            AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        end 
     end)

      --full_house 葫芦牛
      page.m_bomb = {}
      page.m_bomb.toggle = root:Find("option/bomb"):GetComponent("Toggle")
      page.m_bomb.desc = root:Find("option/bomb/desc"):GetComponent("Text")
      page.m_bomb.toggle.onValueChanged:AddListener(function(isOn) 
          m_GameRule[NN_KEY_BOMB] = isOn
          if isOn == true then 
              page.m_bomb.desc.color = FOCUSED_COLOR
          else 
              page.m_bomb.desc.color = DEFAULT_COLOR
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

        for _,v in ipairs(page.m_TableMode) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_TableMode[_] = nil 
        end 
        page.m_TableMode = nil 

        for _,v in ipairs(page.m_BaseChip) do 
            if v then 
                v.toggle.onValueChanged:RemoveAllListeners()
                v.toggle = nil 
                v.desc = nil 
            end 
            page.m_BaseChip[_] = nil 
        end 
        page.m_BaseChip = nil

        page.m_flush.toggle.onValueChanged:RemoveAllListeners()
        page.m_flush.desc = nil 
        page.m_flush = nil 

        page.m_straight.toggle.onValueChanged:RemoveAllListeners()
        page.m_straight.desc = nil 
        page.m_straight = nil 

        page.m_suited.toggle.onValueChanged:RemoveAllListeners()
        page.m_suited.desc = nil 
        page.m_suited = nil 

        page.m_fivebig.toggle.onValueChanged:RemoveAllListeners()
        page.m_fivebig.desc = nil 
        page.m_fivebig = nil 

        page.m_fivesmall.toggle.onValueChanged:RemoveAllListeners()
        page.m_fivesmall.desc = nil 
        page.m_fivesmall = nil 

        page.m_fullhouse.toggle.onValueChanged:RemoveAllListeners()
        page.m_fullhouse.desc = nil 
        page.m_fullhouse = nil

        page.m_bomb.toggle.onValueChanged:RemoveAllListeners()
        page.m_bomb.desc = nil 
        page.m_bomb = nil
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
    btn.onClick:AddListener(m_PrivateFunc.onClickCreateBtn)
    table.insert(tb_btns, btn)

    tb_Pages = {}

    m_PrivateFunc.InitialPanel_NiuNiu()

    --register callback of buttons
    m_PrivateFunc.BindCallbacks()
    m_PrivateFunc.PlayOpenAmin()

    m_PrivateFunc.SwithPanel(focused_game)
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