--[[
  * ui view class:: UI_Update
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

--cache the window object
tbclass.transform = nil

--window name
tbclass.windownName = nil

--loaded lua asset. custom definition data type
tbclass.windowAsset = nil

--opened events. called by uiManager
function tbclass:Opened(inTrans, inName, luaAsset)
    self.transform = inTrans
    self.windownName = inName
    self.windowAsset = luaAsset
    self:Init()
    self.bOpened = true
end 

--bind listeners, ...etc
function tbclass:Init()
    self.text_tip = self.transform:Find("Panel/text_updatestate"):GetComponent("Text")
    self.slider_progress = self.transform:Find("Panel/slider_progress"):GetComponent("Slider")
    self.text_conn = self.transform:Find("Panel/text_conn"):GetComponent("Text")

    self:RenderConnTip(false)
end 

function tbclass:SetUpdateTips(inTip)
    inTip = inTip or ""
    self.text_tip.text = inTip
end 

function tbclass:SetUpdateProgress(inCur, inMax)
    inCur = inCur or 0
    inMax = inMax or 0
    local progress = 0
    if inMax <= 0  or inCur <= 0 then 
        progress = 0
    else
        progress = inCur / inMax
    end 

    self.slider_progress.value = progress
end 

function tbclass:ShowConnectTip(inTip)
    inTip = inTip or ""
    self.text_conn.text = inTip
end 

function tbclass:RenderConnTip(bRender)
    if bRender then 
        self.text_conn.gameObject:SetActive(bRender)
        self.text_tip.gameObject:SetActive(false)
        self.slider_progress.gameObject:SetActive(false)
    else 
        self.text_conn.gameObject:SetActive(bRender)
        self.text_tip.gameObject:SetActive(true)
        self.slider_progress.gameObject:SetActive(true)
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
    self.bOpened = false
    self:SafeRelease()
    self.transform = nil
end 

--release asset reference, unbind listeners...etc
function tbclass:SafeRelease()
    if self.windowAsset ~= nil then 
        self.windowAsset:Free(1)
    end 
    self.windowAsset = nil   
    self.text_conn = nil
    self.text_tip = nil
    self.slider_progress = nil
    if self.transform ~= nil then 
        --UnityEngine.GameObject.Destroy(self.transform.gameObject);
    end 
end

--Don't remove all of them
return tbclass