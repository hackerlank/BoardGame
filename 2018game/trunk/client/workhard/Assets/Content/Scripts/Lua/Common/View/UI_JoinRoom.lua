--[[
  * ui view class:: UI_JoinRoom
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
local MENU_OPEN_ANIM_TIME = 0.3
--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_JoinRoom') 
--render entered number
local tb_txtNums = nil
--save entered number
local tb_inputNums = nil 
--error message
local txt_errmsg = nil 

local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30

--============ callback of buttons begin ====================
--callback function of close button
local function onClickCloseBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

--callback function of input buttons 
local function onClickInputBtn(num)
    local len = #tb_inputNums 
    if len >= 6 then 
        return 
    end 
    table.insert(tb_inputNums, num)
    tb_txtNums[#tb_inputNums].text = num 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    if #tb_inputNums == MAX_ROOM_ID_LEN then    
        local s = table.concat(tb_inputNums)
        facade:sendNotification(Common.PRE_JOIN_GAME, s)
    end 
end 

--callback function of delete button
local function onClickDeleteBtn()
    local len = #tb_inputNums 
    if len <= 0 then 
        return 
    end 
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
    tb_txtNums[#tb_inputNums].text = "-" 
    table.remove(tb_inputNums, #tb_inputNums)
end 

--callback function of paste button
local function onClickPasteBtn()
    --try to get content from clipboard
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    local clipboard_roomId = GetLuaGameManager().GetClipboardRoomId()
    if clipboard_roomId ~= nil then 
        local str = tostring(clipboard_roomId)
        local t = {} 
        for k,v in string.gmatch(str, "%d") do 
            onClickInputBtn(tonumber(k))
        end 
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
    --play animation 
    --@todo you need to edit the animation style in here
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DOMoveX(m_RootPanel, 640, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.OutExpo)
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

    local keyboard_root = m_RootPanel:Find("btns/keyboard")
    if keyboard_root ~= nil then
        for i=0, 9 do 
            btn = keyboard_root:Find("btn_"..i):GetComponent("Button")
            btn.onClick:AddListener(function() onClickInputBtn(i) end)
            table.insert(tb_btns, btn)
        end 

        btn = keyboard_root:Find("btn_paste"):GetComponent("Button")
        btn.onClick:AddListener(onClickPasteBtn)
        table.insert(tb_btns, btn)

        btn = keyboard_root:Find("btn_delete"):GetComponent("Button")
        btn.onClick:AddListener(onClickDeleteBtn)
        table.insert(tb_btns, btn)
    end 

    local  txt = nil 
    tb_txtNums = {}
    for i=1, MAX_ROOM_ID_LEN do 
        txt = m_RootPanel:Find(string.format("roomid/num_%d/txt",i)):GetComponent("Text")
        txt.text = "-"
        table.insert(tb_txtNums, txt)
    end 

    txt_errmsg = m_RootPanel:Find("txt_errmsg"):GetComponent("Text")
    txt_errmsg.text = ""

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
        LogError('[UI_JoinRoom.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}

    tb_inputNums = {}

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

    if tb_txtNums ~= nil then 
        for k,v in ipairs(tb_txtNums) do 
            tb_txtNums[k] = nil 
        end 
        tb_txtNums = nil 
    end 
    txt_errmsg = nil

    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_OpenAnimTween, true)
        m_OpenAnimTween = nil 
    end 
    m_RootPanel = nil 
    tb_inputNums = nil 
    windowAsset = nil   
    facade = nil
    if gameObject ~= nil then 
        UnityEngine.GameObject.Destroy(gameObject);
    end 
    gameObject = nil 
end

function tbclass:ClearEnterRoomId()
    for k,v in ipairs(tb_txtNums) do 
        if v then 
            v.text = "-"
        end 
    end 

    for k,v in ipairs(tb_inputNums) do 
        tb_inputNums[k] = nil 
    end 

    tb_inputNums= {}
end 

--Don't remove all of them
return tbclass