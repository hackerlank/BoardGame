--[[
  * ui view class:: UI_Chat
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
--加载的预制消息
local m_tbPreDefinedMsg = nil 
local m_input = nil 
--表情panel
local m_EmojiPanel = nil 
--表情列表
local m_emojiList = nil 
--实例化的emoji item
local tb_emojiItems = nil 
--聊天列表
local m_chatList = nil 
--实例化的聊天的item
local tb_chatItems = nil 
--已经加载的assets
local m_LoadedAssets = nil 

local m_ChatParent = nil 

local m_ChatMsg = nil 
local m_bIsPlaying = false 

local m_ViewHeight = 0.0
local m_ViewRect = nil 
local m_ChatTemplate = nil 
local m_ChatCount = 0
local achor_posx = nil 
local _DefaultChatSize = UnityEngine.Vector2(630,26)
local VIEW_CONTENT_HEIGHT = 400
local CHAT_ITEM_INTERNAL = 5


--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_Chat') 
local chat_type = EChatType.user_text

local InlineTextManager

--================private interface begin =====================
--callback function of closeing animation has been completed
local function OnComplete()
    --facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    if m_ChatMsg then 
        if m_ChatMsg then 
            local len = m_ChatMsg.Count - 1
            local m_ChatMsg = nil 
            for i=0, len do 
                --filter preset_image type in chat list 
                msg = m_ChatMsg:getItem(i)
                if msg.type ~= EChatType.preset_image then 
                    m_ChatCount = m_ChatCount + 1
                    CreateNewMsg(msg)
            
                end 
            end 
            m_ChatMsg = nil 
        end 
    end 
    if InlineTextManager then 
        InlineTextManager.gameObject:SetActive(false)
        InlineTextManager.gameObject:SetActive(true)
    end	
    m_bIsPlaying = false 
end 

local function OnRewind()
    -- body
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end

--play the opening animation of menu
local function PlayOpenAmin()
    m_bIsPlaying = true 
    TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0, 0, 0)
    --play animation 
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DOMoveX(m_RootPanel, 640, MENU_OPEN_ANIM_TIME)
        
        gameObject:SetActive(true)
        --@todo you need to edit the animation style in here
        m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.Linear)
        DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
        DoTweenPathLuaUtil.OnComplete(m_OpenAnimTween, OnComplete)
        DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
        DoTweenPathLuaUtil.DOPlay(m_RootPanel)
    end)
end 

--callback function of close button
local function onClickCloseBtn()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

--fill pre-defined message
local function onClickFillMsgBtn(idx)
    local msg = m_tbPreDefinedMsg[idx]
    if msg ~= nil then 
        m_input.text = msg 
    end 
end 

local function onClickEmojiMsgBtn(desc)
    if desc ~= nil then 
        facade:sendNotification(Common.SEND_CHAT,{type=EChatType.user_text, msg=desc});
    end 
    m_EmojiPanel:SetActive(false)
end 

local function onClickEmojiBtn()
    m_EmojiPanel:SetActive(true)
end 

local  function onClickSendBtn()
    facade:sendNotification(Common.SEND_CHAT,{type=EChatType.user_text, msg=m_input.text});
end 


--bind callback for buttons in here
local function BindCallbacks()
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

    btn = m_RootPanel:Find("btns/btn_tiaokan"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(function() onClickFillMsgBtn(1) end)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("btns/btn_wanliu"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(function() onClickFillMsgBtn(3) end)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("btns/btn_cuicu"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(function() onClickFillMsgBtn(2) end)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("btns/btn_award"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(function() onClickFillMsgBtn(4) end)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("btns/btn_baoyuan"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(function() onClickFillMsgBtn(5) end)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("btns/btn_emoji"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickEmojiBtn)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("btns/btn_send"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickSendBtn)
        table.insert(tb_btns, btn)
    end 

end 

local function  InitialEmojiPanel()
    tb_emojiItems = {} 
	
    m_EmojiPanel = transform:Find("Panel/emoji").gameObject
    local btn =  m_EmojiPanel:GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(function() onClickEmojiMsgBtn(nil) end)
        table.insert(tb_btns, btn)
    end 

    m_EmojiPanel:SetActive(false)
    m_emojiList = m_EmojiPanel.transform:Find("emojiList"):GetComponent("GameScrollRect")
    local s = luaTool:GetEmojis()

    if m_emojiList ~= nil then 
        m_emojiList:SetColumn(s.Count)
        local m_Content = m_emojiList.content
        if m_Content ~= nil then 
            local count = m_Content.childCount
            for i=0, count-1 do 
                local trans = m_Content:GetChild(i)
                if trans ~= nil then 
                    local item = trans:GetComponent("SlotItemInfo")
                    local img_emoji = trans:GetComponent("Image")
                    local btn = trans:GetComponent("Button")
                    
                    local record = nil 
                    local link = "<sprite=>"

                    btn.onClick:AddListener(function() 
                        --facade:sendNotification(Common.SEND_CHAT,{type=3, msg=link});
                        onClickEmojiMsgBtn(link)

                    end)
                    table.insert(tb_btns, btn)
                    if item ~= nil then 
                        item.onValueChanged:AddListener(function()
                            info = item.info 
                            if info ~= nil then 
                                link = info.content
                                img_emoji.sprite = info.list_sprites:getItem(0)
                            else 

                            end 
                
                        end)
                        table.insert(tb_emojiItems, item)
                    end 
                end 
            end 
        end 
    end 
    m_emojiList:SetListInfos(s,true)
end

local function  InitialChatList()
    --[[tb_chatItems = {} 
    m_chatList = m_RootPanel:Find("chatList"):GetComponent("ChatScrollRect")
    if m_chatList ~= nil then 
        m_chatList:SetColumn(10)
        local m_Content = m_chatList.content
        if m_Content ~= nil then 
            local count = m_Content.childCount
            for i=0, count-1 do 
                local trans = m_Content:GetChild(i)
                if trans ~= nil then 
                    local item = trans:GetComponent("SlotItemInfo")
                    local txt_username = trans:Find("txt_username"):GetComponent("Text")
                    local txt_date = trans:Find("txt_date"):GetComponent("Text")
                    local txt_msg = trans:Find("txt_msg"):GetComponent("Text")

                    if item ~= nil then 
                        item.onValueChanged:AddListener(function()
                            local info = item.info 
                            if info ~= nil then 
                                txt_username.text = info.username
                                txt_date.text = info.date 
                                txt_msg.text = info.msg 
                            else 
                                txt_username.text = ""
                                txt_date.text = "" 
                                txt_msg.text = ""
                            end 
                
                        end)
                        table.insert(tb_chatItems, item)
                    end 
                end 
            end 
        end 
    end 

    m_chatList:SetListInfos(nil,true)]]
    -- body

    m_chatList = m_RootPanel:Find("chatList"):GetComponent("ScrollRect")
    m_ChatTemplate = m_chatList.content:Find("InlinText/Panel_Text/template")
    m_ChatTemplate.gameObject:SetActive(false)
    m_ViewRect = m_chatList.content:GetComponent("RectTransform")
    achor_posx = m_ChatTemplate:GetComponent("RectTransform").anchoredPosition.x
    m_ChatParent = m_ChatTemplate.parent
	
	InlineTextManager = m_RootPanel:Find("chatList/Viewport/Content/InlinText")
end

local function  LoadEmojis()
    local path = {} 
    local s = luaTool:GetEmojis()
    local loop = s.Count 
    for i=0, loop-1 do 
        table.insert(path, s:getItem(i).path)
    end 

    GetResourceManager().LoadAssetsAsync(GameHelper.EAssetType.EAT_Sprite, path, function(asset)
        if asset and img_emoji then
            for k,v in ipairs(asset) do 
                if v then 
                    m_LoadedAssets[v:GetAssetPath()] = v:GetAsset()
                end 
            end      
        end 
    end)
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
        LogError('[UI_Chat.Init]:: missing transform')
        return
    end 
    gameObject:SetActive(false)
    LoadEmojis()
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_RootPanel = transform:Find('Panel')
    m_tbPreDefinedMsg = {}
    for i=1,5 do 
        table.insert(m_tbPreDefinedMsg, luaTool:GetLocalize("chat_" .. i))
    end 
    m_input = transform:Find("Panel/input/enter"):GetComponent("InputField")
    m_input.text = ""
    m_LoadedAssets = {}
    _DefaultChatSize = UnityEngine.Vector2(630,26)
    InitialChatList()
    InitialEmojiPanel()
    BindCallbacks()
    m_ViewHeight = 0
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
    m_ChatCount = 0
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

    if tb_chatItems ~= nil then 
        for k,v in ipairs(tb_chatItems) do 
            if v then 
                v.onValueChanged:RemoveAllListeners()
            end 
            tb_chatItems[k] = nil 
        end 
        tb_chatItems = nil 
    end 

    if tb_emojiItems ~= nil then 
        for k,v in ipairs(tb_emojiItems) do 
            if v then 
                v.onValueChanged:RemoveAllListeners()
            end 
            tb_emojiItems[k] = nil 
        end 
        tb_emojiItems = nil 
    end 

    m_chatList = nil 
    m_emojiList = nil 
    m_EmojiPanel = nil 
    m_tbPreDefinedMsg = nil 
    m_input = nil 

    m_ViewHeight = 0.0
    m_ViewRect = nil 
    m_ChatTemplate = nil 
    m_ChatCount = 0
    achor_posx = nil 
    _DefaultChatSize = nil


    if m_LoadedAssets ~= nil then 
        for k,v in pairs(m_LoadedAssets) do 
            v:Free()
            m_LoadedAssets[k] = nil 
        end 
    end 
    m_LoadedAssets = nil 

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

local function CreateNewMsg(msg)
    local user_name = nil 
    local chat_date = nil 
    local chat_content = nil 
    local trans = nil 
    local go = nil 
    local rect = nil 
    local txt_rect = nil 


    go = UnityEngine.GameObject.Instantiate(m_ChatTemplate.gameObject)
    if go then 
        trans = go.transform
        go.name = "chat_" .. m_ChatCount
        txt_username = trans:Find("info/txt_username"):GetComponent("Text")
        txt_date = trans:Find("info/txt_date"):GetComponent("Text")
        txt_msg = trans:Find("txt_msg"):GetComponent("InlineText")
        rect = trans:GetComponent("RectTransform")
        trans:SetParent(m_ChatParent)
        txt_username.text = msg.username
        txt_date.text = msg.date 
        txt_msg.text = msg.msg 
        
        go:SetActive(true)
        txt_msg:SetVerticesDirty()
        TransformLuaUtil.SetTransformLocalScale(trans, 1,1,1)
        TransformLuaUtil.SetTransformPos(trans,0,0,0)
        --chat item default size
        local self_size = UnityEngine.Vector2(655, 60)
        local line_height =  _DefaultChatSize.y
        local line = math.ceil( txt_msg.preferredHeight / line_height)
        local txt_rect =  trans:Find("txt_msg"):GetComponent("RectTransform")
        local txt_height = 26
        local diff_height = 0
       -- print(" bHasEmoji " .. tostring(txt_msg.bHasEmoji) .. " " .. txt_msg.text)
        if txt_msg.bHasEmoji == true then 
            txt_height = line * 70
        elseif line >= 1 then 
            txt_height = line * line_height 
        end 

        --extand size y
        local diff_height = txt_height - line_height
        --update txt_msg anchor position
        local anchoredPosition = txt_rect.anchoredPosition 
        anchoredPosition.y = anchoredPosition.y - diff_height / 2 
        txt_rect.anchoredPosition = anchoredPosition
        txt_rect.sizeDelta = UnityEngine.Vector2(_DefaultChatSize.x, txt_height )
        self_size.y = self_size.y +  diff_height
        --update chat item size
        rect.sizeDelta = self_size  

        
        --update self anchor position
        local _pos = nil 
        if m_ViewHeight == 0 then 
            m_ViewHeight = self_size.y / 2 * -1
            _pos = UnityEngine.Vector2(achor_posx, m_ViewHeight);
            rect.anchoredPosition= _pos;
        else
            --force the internal is 5 between two chat items
            m_ViewHeight = m_ViewHeight - diff_height / 2
            if diff_height > 0 then 
                local last_item_rect = m_ChatParent:GetChild(m_ChatParent.childCount-2):GetComponent("RectTransform") 
                local last_y = last_item_rect.anchoredPosition.y - last_item_rect.rect.yMax
                local diff_y = last_y - (m_ViewHeight  + self_size.y / 2 )
                if diff_y > CHAT_ITEM_INTERNAL then 
                    m_ViewHeight = m_ViewHeight + diff_y - CHAT_ITEM_INTERNAL 
                end         
            end 
            _pos = UnityEngine.Vector2(achor_posx, m_ViewHeight);
            rect.anchoredPosition= _pos;
        end 
        --update the next chat item anchor position
        m_ViewHeight = m_ViewHeight - self_size.y - CHAT_ITEM_INTERNAL
        
        --update chat list view size
        m_ViewRect.sizeDelta = UnityEngine.Vector2(m_ViewRect.sizeDelta.x,math.abs(m_ViewHeight));
        if math.abs( m_ViewHeight) <= VIEW_CONTENT_HEIGHT then 
            m_ViewRect.anchoredPosition = UnityEngine.Vector2(0,0)
        else 
            --always focus the last message
            local achor_y = math.abs( m_ViewHeight + VIEW_CONTENT_HEIGHT )
            m_ViewRect.anchoredPosition = UnityEngine.Vector2(0,achor_y)
            m_chatList:StopMovement()
        end 
    end 
end 

function tbclass:RecievedMsg(msg, m_bIsSelf)
    --m_chatList:RegisterItem(msg)
   -- if m_bIsSelf == true then 
        if m_input then 
            m_input.text = ""
        end 
        --use for magic emoji
        if msg.type == EChatType.preset_image then 
            return 
        end 
        
        if msg then 
            m_ChatCount = m_ChatCount + 1
            CreateNewMsg(msg)
			
			if InlineTextManager then 
				InlineTextManager.gameObject:SetActive(false)
				InlineTextManager.gameObject:SetActive(true)
			end	
        end 
    --end 
end

function tbclass:FreshWindow(msgs)
    -- body
    if msgs then 
        if m_bIsPlaying == true then 
            m_ChatMsg = msgs 
        else 
            local len = msgs.Count - 1
            local msg = nil 
            for i=0, len do 
                --filter preset_image type in chat list 
                msg = msgs:getItem(i)
                if msg.type ~= EChatType.preset_image then 
                    m_ChatCount = m_ChatCount + 1
                    CreateNewMsg(msg)
            
                end 
            end 
        end 
    end 	
end

--Don't remove all of them
return tbclass