
--[[
  * CLASS:: UI_GeneralTip.
  *   controll the main menu render state
  * @ transform the window 
  * @Opened
  *   this function will be invoked after menu object has been created.each of menu view class
  *   must contains it.
  * @Init
  *   this function will be automatic called by Opened if open this menu without restore type. 
  *   otherwise will not init again. 
  * @Closed
  *   this function will be invoked when menu object has been disabled or destroied. each of menu 
  *   menu view class must contains it. because we must manually release assets, callback etc to 
  *   avoid memory leak.
  * @NOTE
  *  if self want to revice unity events such as Update , FixedUpdate.please register self to lua game mode.
  *  Generally OnDestory function is useless for menu, so you should not implement OnDestory function.  l
]]
local tbclass = tbclass or {}

local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30
local transform = nil
local windownName = nil
local windowAsset = nil

local SELF_CLOSE_PARAM = nil 
local facade = nil 

local txt_title = nil 
local txt_content = nil 
local btn_sure = nil 
local txt_sure = nil 
local btn_cancel = nil 
local txt_cancel = nil 

local yesCallback = nil 
local noCallBack = nil 

--root panel.
local m_RootPanel = nil 
--saved the animation tween object of menu
local m_OpenAnimTween = nil 
--menu animation last time
local MENU_OPEN_ANIM_TIME = 0.15

local ETouchedBtn=
{
    ETB_Yes=0,
    ETB_No=1,
    ETB_Max=2
}

local m_CurrentTouchedBtn = ETouchedBtn.ETB_Max

local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_GeneralTip') 


--================private interface begin =====================
local function PreClose()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

--callback function of closeing animation has been completed
local function OnRewind()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 

--play the opening animation of menu
local function PlayOpenAmin()
    TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0, 0, 0)
    --play animation 
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME, function(timer)
        LuaTimer.Delete(timer)
        --@todo you need to edit the animation style in here
        m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.InOutBack)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
end 

--================private interface end =====================

--[[
 * Opened will be called  after menu object has been created, each of menu view class must contains self.
 * @param inTrans  the transform object of menu window. it will help us to init the menu.
 * @param inName the name of menu window. it also as the key to avoid open same menu more than once in UIManager
 * @param bRestore if bRestore is true, will init the menu. 
 *
]]
function tbclass:Opened(inTrans, inName, luaAsset)
    transform = inTrans
    windownName = inName
    windowAsset = luaAsset
    SELF_CLOSE_PARAM = ci.GetUICloseParam().new(false, windownName)
    self:Init()
 
end 

function tbclass:Init()
    txt_title = transform:Find("Panel/text_title"):GetComponent("Text")
    txt_content = transform:Find("Panel/text_content"):GetComponent("Text")
    btn_sure = transform:Find("Panel/btnBG/btn_sure"):GetComponent("Button")
    txt_sure = transform:Find("Panel/btnBG/btn_sure/Text"):GetComponent("Text")
    btn_cancel = transform:Find("Panel/btnBG/btn_cancel"):GetComponent("Button")
    txt_cancel = transform:Find("Panel/btnBG/btn_cancel/Text"):GetComponent("Text")
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    m_RootPanel = transform:Find("Panel")
    PlayOpenAmin()
end 

function tbclass:FreshWindow(tipObj, content, cb_yes, cb_no)
    if tipObj ~= nil then 
        txt_title.text = tipObj:GetTitle()
        content = content or tipObj:GetContent()
        txt_content.text = content
        txt_sure.text = tipObj:GetSureText()
        txt_cancel.text = tipObj:GetCancelText()
    end 

    yesCallback = cb_yes
    noCallBack = cb_no

    btn_sure.onClick:AddListener(function() 
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose) 
        m_CurrentTouchedBtn = ETouchedBtn.ETB_Yes
        PreClose()
    end)

    btn_cancel.onClick:AddListener(function()
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back)
        m_CurrentTouchedBtn = ETouchedBtn.ETB_No
        PreClose()
    end )
    
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
    windowAsset = nil   

   
     
    if btn_sure ~= nil then 
        btn_sure.onClick:RemoveAllListeners()
    end 

    if btn_cancel ~= nil then 
        btn_cancel.onClick:RemoveAllListeners()
    end 

    btn_sure = nil
    btn_cancel = nil
    txt_cancel = nil
    txt_sure = nil
    txt_title = nil 
    txt_content = nil 

    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
    if m_CurrentTouchedBtn == ETouchedBtn.ETB_Yes then 
        if yesCallback then 
            yesCallback()
        end 
    elseif m_CurrentTouchedBtn == ETouchedBtn.ETB_No then 
        if noCallBack then 
            noCallBack()
        end 
    end 
    m_CurrentTouchedBtn = ETouchedBtn.ETB_Max
end 

return tbclass