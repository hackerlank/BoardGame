--[[
  * ui view class:: UI_Notification
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
local comp_animation = depends('Common.ViewAnimation.UIAnim_Notification')

--log function reference. remove these if needed
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--cache the window object
local transform = nil

--window name
local windownName = nil

--loaded lua asset. custom definition data type
local windowAsset = nil

--whether self has been opened
local bOpened = false

--save the mediator
local mediator = nil

--elements
--background image of notification
local img_bg = nil 

local nAniDelayTime = 2.0;  --暂停多少秒开始移动(可以消失)
local nUpAniTime    = 0.5;  --上翻动画持续时间
local nDelayDelTime = 1.5;  --动画结束后多少秒删除

--notis buffer
local notis_active = {}
local notis_inactive = {}

--the unique key of self
local render_notis = nil

--opened events. called by uiManager
function tbclass:Opened(inTrans, inName, luaAsset)
    transform = inTrans
    windownName = inName
    windowAsset = luaAsset
    self:Init()
    bOpened = true
end 

--bind listeners, ...etc
function tbclass:Init()

    if transform == nil then 
        LogError('[UI_Notification.Init]:: missing transform')
        return
    end 

    img_bg = transform:Find("Panel/bg"):GetComponent("Image")
    img_bg.enabled = false 
    --init animation component
    if comp_animation ~= nil then 
        comp_animation:Init(transform, self)
    end 

    --ComponentKey = "UI_" .. luaTool:GetGuid()

    --GetGameManager().GetGameMode():RegisterComponent(self, ComponentKey)
end 

--set the mediator
--@param inMediator 
function tbclass:SetMediator(inMediator)
    mediator = inMediator
end 

local function StartRenderNotis()
    --get the best item 

    local idx = 1

    if render_notis == nil then 
        render_notis = {}
        render_notis.itemIdx = 1
        render_notis.weight = nil 
    end 

    render_notis.weight = notis_active[idx]:GetWeight()
    comp_animation:ShowNotification( notis_active[idx]:GetMsg(), true)
    comp_animation:StartAnimation(false)
    
end 

function tbclass:RenderNotification(content, weight)
    if content == nil then 
        return 
    end 

    local item = nil 
    if #notis_inactive  > 0 then 
        item = notis_inactive[1]
        notis_inactive[1] = nil 
    end 

    if item == nil then 
        item = ci.GetNotificationItem().new(content, ENotiWeight.ENW_System)
    else 
        item:Reset(content, ENotiWeight.ENW_System)
    end 

    --insert to active list
    notis_active[#notis_active + 1] = item

    if img_bg.enabled == false then 
        img_bg.enabled = true
    end 

    --start render notis
    if render_notis == nil then
        StartRenderNotis()
    elseif render_notis.weight < item:GetWeight() then 
        --play the lastest one

    end 
end 

function tbclass:OnAnimCompleted()

    local tmp = notis_active[render_notis.itemIdx]
    notis_active[render_notis.itemIdx] = nil 
    notis_inactive[#notis_inactive+1] = tmp

    if #notis_active <= 0 then 
        render_notis = nil 
        img_bg.enabled = false
    else 
        --directly play new one
        StartRenderNotis()
    end 
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
    if comp_animation ~= nil then 
        comp_animation:OnClose()
    end 
   -- GetGameManager().GetGameMode():RemoveComponent(ComponentKey)
    self:SafeRelease()
    transform = nil
end 

--release asset reference, unbind listeners...etc
function tbclass:SafeRelease()
    if windowAsset ~= nil then 
        windowAsset:Free(1)
    end 
    windowAsset = nil   
    img_bg = nil 
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end

--Don't remove all of them
return tbclass