--[[
  * ui view class:: UI_VoteResult
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

local m_VoteEndTime = nil 
local m_VoteTimer = nil 
local txt_countdown = nil 
local DEFINE_TIP_STRING = luaTool:GetLocalize("vote_remain_time_ps")

local m_VoteInfos = nil 
local FOCUSED_COLOR = UnityEngine.Color(135/255,2/255,0/255,255/255)
local DEFAULT_COLOR = UnityEngine.Color(89/255,76/255,67/255,255/255)
--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_VoteResult') 

local m_LoadedAssets = nil 

--============ callback of buttons begin ====================
--callback function of close button
local function onClickCloseBtn()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
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

    btn = m_RootPanel:Find('btns/btn_agree'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(onClickCloseBtn)
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
    if transform == nil then 
        LogError('[UI_VoteResult.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_VoteInfos = {}
    local root = transform:Find("Panel/users")
    local item = nil 
    for i=1,4 do 
        item = {}
        item.trans = root:Find("user_" .. i)
        item.txt_name =  item.trans:Find("name"):GetComponent("Text")
        item.img_head = item.trans:Find("head/icon"):GetComponent("Image")
        item.img_state = item.trans:Find("vote"):GetComponent("Image")
        table.insert(m_VoteInfos, item)
    end  

    m_LoadedAssets = {}
    txt_countdown = transform:Find("Panel/txt_countdown"):GetComponent("Text")
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
    if m_VoteTimer then 
        LuaTimer.Delete(m_VoteTimer)
        m_VoteTimer = nil 
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

local function StartUpdateRemainTime()
    local curTime = os.time()
    local remain = 0 
    if curTime < m_VoteEndTime then 
        if m_VoteTimer == nil then 
            m_VoteTimer = LuaTimer.Add(0,1000, function ()
                curTime = os.time()
                remain = math.ceil( m_VoteEndTime - curTime )
                txt_countdown.text = string.format(DEFINE_TIP_STRING,  tostring(remain) )
                if remain <= 0 then 
                    if m_VoteTimer then 
                        LuaTimer.Delete(m_VoteTimer)
                        m_VoteTimer = nil 
                    end 
                end 
            end)
        end 
    else 
        txt_countdown.text = string.format(DEFINE_TIP_STRING,  tostring(remain) )
    end 
end 

function tbclass:InitialMenu(param, endTime)
    local use_count = #param
    for k,v in ipairs(param) do 
        local vote = m_VoteInfos[v.seat_id]
        if vote then 
            vote.txt_name.text = v.user_name 
            local state_path = ""
            if v.bIsSelf == true then 
                vote.txt_name.color = FOCUSED_COLOR
            else 
                vote.txt_name.color = DEFAULT_COLOR
            end 

            if v.state == EVoteType.agree then 
                vote.img_state.enabled = true 
                state_path = "Assets/Content/ArtWork/UI/Common/images/agree.png"
            elseif v.state == EVoteType.refuse then 
                state_path = "Assets/Content/ArtWork/UI/Common/images/refuse.png"
                vote.img_state.enabled = true 
            else 
                vote.img_state.enabled = false
            end 

            if vote.trans.gameObject.activeSelf == false then 
                vote.trans.gameObject:SetActive(true)
            end 
            if state_path ~= "" then 
                if m_LoadedAssets[state_path] == nil then 
                    GetResourceManager().LoadAsset(GameHelper.EAssetType.EAT_Sprite, state_path, function(asset)
                        if asset and asset:IsValid() == true then 
                            vote.img_state.sprite = asset:GetAsset()
                            m_LoadedAssets[state_path] = asset
                        end 
                    end)
                else
                    vote.img_state.sprite = m_LoadedAssets[state_path]:GetAsset()
                end 
            end 

            if v.head_img then 
                GetHeadIconManager().LoadIcon(v.head_img, function(asset)
                    if asset and asset:IsValid() then 
                        vote.img_head.enabled = true
                        vote.img_head.sprite = asset:GetAsset()
                    else 
                        vote.img_head.enabled = false
                    end 
                end)
            else 
                vote.img_head.enabled = false
            end 
        end 
    end 

    if use_count  < #m_VoteInfos then 
        for i=use_count + 1, #m_VoteInfos do 
            if m_VoteInfos[i] then 
                m_VoteInfos[i].trans.gameObject:SetActive(false)
            end 
        end 
    end 

    m_VoteEndTime = endTime

    StartUpdateRemainTime()
end 

function tbclass:FreshWindow(seat_id, state)
    local vote = m_VoteInfos[seat_id]
    if vote then 
        local state_path = ""
        if state == EVoteType.agree then 
            vote.img_state.enabled = true 
            state_path = "Assets/Content/ArtWork/UI/Common/images/agree.png"
        elseif state == EVoteType.refuse then 
            state_path = "Assets/Content/ArtWork/UI/Common/images/refuse.png"
            vote.img_state.enabled = true 
        else 
            vote.img_state.enabled = false
        end 

        if state_path ~= "" then 
            if m_LoadedAssets[state_path] == nil then 
                GetResourceManager().LoadAsset(GameHelper.EAssetType.EAT_Sprite, state_path, function(asset)
                    if asset and asset:IsValid() == true then 
                        vote.img_state.sprite = asset:GetAsset()
                        m_LoadedAssets[state_path] = asset
                    end 
                end)
            else
                vote.img_state.sprite = m_LoadedAssets[state_path]:GetAsset()
            end 
        end 
    end 
end 

function tbclass:CloseWindow()
    onClickCloseBtn()
end 
--Don't remove all of them
return tbclass