--[[
  * ui view class:: UI_Loading
  * @Opened
  *   this function will be invoked after menu object has been created.each of menu view class
  *   must contains it.
  * @Init
  *   this function will be automatic called by Opened
  * @OnDisable
  *   this function will be invoked when player is hiding window. each of menu 
  *   menu view class must contains it.  called by mediator
  * @OnRestore
  *   this function will be invoked when player wants to re-render  called by mediator
  * @OnClose
  *   this function will be called when player is closing  called by mediator. 
  *   will call SafeRelease function to safely free assets .. etc
  * @SafeRelease
  *   unbind listeners, free asset references, destroy windown object ... etc. if self is not be called 
  *   will cause memory leak.
  * @NOTE
  *  if self want to revice unity events such as Update , FixedUpdate.please register self to lua game mode.
  *  Generally OnDestory function is useless for menu, so you should not implement OnDestory function.
]]
local tbclass = tbclass or {} 

local floor = math.floor

--cache the window object
local transform = nil

--window name
local windownName = nil

--loaded lua asset. custom definition data type
local windowAsset = nil

local text_tip = nil 

local slider = nil 

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
    text_tip = transform:Find("Panel/text_loading"):GetComponent("Text")
    --slider = transform:Find("Panel/Slider"):GetComponent("Slider")
end 

--fresh menu
function tbclass:FreshWindow(fProgress)
    fProgress = fProgress or 0
    if fProgress >= 1.0 then 
        fProgress = 1.0
    end 

    if fProgress < 0.0 then 
        fProgress = 0.0
    end 
   --[[ if text_tip ~= nil then 
        text_tip.text = "loading level " .. floor(fProgress * 100) .. "%"
        slider.value = fProgress
    end]]
end 

--OnDisable:: called by mediator
function tbclass:OnDisable()
    if transform then 
        transform.gameObject:SetActive(false)
    end 
end 

--OnRestore:: called by mediator
function tbclass:OnRestore()
    if transform then 
        transform.gameObject:SetActive(true)
    end 
end 


--OnClose:: called by mediator
function tbclass:OnClose()
    bOpened = false
   -- local cor = coroutine.create( function() 
     --   UnityEngine.Yield(UnityEngine.WaitForSeconds(0.2))
        self:SafeRelease()
        transform = nil
    --end )
   -- coroutine.resume( cor)
   

end 

--release asset reference, unbind listeners...etc
function tbclass:SafeRelease()
    if windowAsset ~= nil then 
        windowAsset:Free(1)
    end 
    text_tip = nil
    slider = nil
    windowAsset = nil   
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end

--Don't remove all of them
return tbclass