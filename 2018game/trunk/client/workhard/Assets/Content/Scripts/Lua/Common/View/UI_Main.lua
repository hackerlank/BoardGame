--[[
  * ui view class:: UI_Main
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

--save game facade
local facade = nil

--menu controls
local tb_btns = nil 
--player headicon
local img_headicon = nil 
--render player name
local txt_name = nil 
--render player unique id
local txt_id = nil 
--list of game 
local m_GameList = nil 
--diamond
local txt_diamond = nil 

--radio message transform
local m_TransRadio = nil 
local m_RadioRectTransform = nil 
--radio text controls
local txt_radio = nil
--radio initial pos 
local m_RadioMsgInitialPos = nil 
--radio animation per 1 second
local RADIO_ANIM_SPEED = 70
--mask width
local m_RadioMaskWidth = 0
--message that need to be rendered
local tb_NeedRenderMessage = nil 
--radio tween 
local m_RadioTween = nil 

--save lua assets of menu loaded
local tb_LoadedLuaAssets = nil 

--instanced game items
local m_tbInstancedGameItems = nil 
local current_selected = nil 

--opened events. called by uiManager
function tbclass:Opened(inTrans, inName, luaAsset)
    transform = inTrans
    windownName = inName
    windowAsset = luaAsset
    self:Init()
    bOpened = true
end 

--=================ui callbacks ======================
local function onClickGameBtn(data)
    if data == nil then 
        return 
    end 
    local iGameType = data:GetGameType()
    if iGameType == nil or type(iGameType) ~= "number" then 
        return
    end

    if iGameType ~= EGameType.EGT_Coming then 
        if GBC.IsInstalledGame(iGameType) then
            if facade ~= nil then 
                facade:sendNotification(Common.SET_GAME_TYPE, iGameType) 
                facade:sendNotification(Common.OPEN_UI_COMMAND, data:GetMenuOpenParam())  
            end
        else        
        -- current_selected = data
        -- local param = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil, 6, DownloadGameSureCallback, DownloadGameCancelCallback)
            --facade:sendNotification(Common.OPEN_UI_COMMAND, param)
        end
    end 
end 

local JOIN_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_JOIN_ROOM,EMenuType.EMT_Common,nil,false)
local function onClickJoinGameBtn(data)
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.OPEN_UI_COMMAND, JOIN_MENU_PARAM)    
end 

local function onClickCreateGameBtn(data)
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    --facade:sendNotification(Common.OPEN_UI_COMMAND, JOIN_MENU_PARAM)    
end 

local ACHIEVE_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_ACHIEVE, EMenuType.EMT_Common, nil, false)
local function onClickAchieveBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.OPEN_UI_COMMAND, ACHIEVE_MENU_PARAM)
end 

local SETTING_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_SETTING, EMenuType.EMT_Common, nil, false)
local function onClickSettingBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.OPEN_UI_COMMAND, SETTING_MENU_PARAM)
end 

local USER_DETAIL_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_USER_DETAIL, EMenuType.EMT_Common, nil, false)
local function onClickHeadBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.OPEN_UI_COMMAND, USER_DETAIL_MENU_PARAM)
end 

local MAIL_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_MAIL, EMenuType.EMT_Common, nil, false)
local function onClickStoreBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    --facade:sendNotification(Common.OPEN_UI_COMMAND, MAIL_MENU_PARAM)
end 

local WECHAT_SHARE_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_WECHAT_SHARE, EMenuType.EMT_Common, nil, false)
local function onClickShareBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.OPEN_UI_COMMAND, WECHAT_SHARE_MENU_PARAM)
end 

local PURCHASE_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_PURCHASE, EMenuType.EMT_Common, nil, false)
local function onClickBuyBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    facade:sendNotification(Common.OPEN_UI_COMMAND, PURCHASE_MENU_PARAM)
end 

local HELP_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_HELP, EMenuType.EMT_Common, nil, false)
local function onClickClubBtn()
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
    --facade:sendNotification(Common.OPEN_UI_COMMAND, HELP_MENU_PARAM)
end 

--load game item data
--[[local function LoadGameItemData(gameItem, data)
    local listItem = {}
    local trans = gameItem.transform
    listItem.img = trans:Find("img_gameicon"):GetComponent("Image")
    GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_Sprite, data:GetGameIconPath(), function(asset)
        if asset and asset:IsValid() == true and listItem.img then
            local img_size = asset:GetAsset().rect.size 
            listItem.img.sprite = asset:GetAsset()   
            listItem.img:GetComponent("RectTransform").sizeDelta = UnityEngine.Vector2(img_size.x, img_size.y)          
        end 
    end)
    gameItem.name = data:GetGameId()
    listItem.btn = gameItem.transform:GetComponent("Button")
    listItem.btn.onClick:AddListener(function()
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose)
        onClickCreateGameBtn(data)
    end)
    --listItem.btn.interactable = mediator:IsGameEnabled(data:GetGameType())

    listItem.download = trans:Find("download").gameObject
    trans = listItem.download.transform
    --listItem.download:SetActive(GetLuaGameManager().IsInstallGame(data:GetGameType()) == false)
    listItem.slider = trans:Find("Slider"):GetComponent("Slider")
    listItem.slider.gameObject:SetActive(false)
    listItem.slider.value = 0
    listItem.gameType = data:GetGameType()
    listItem.state = trans:Find("state"):GetComponent("Text")
    listItem.state.gameObject:SetActive(false)
    listItem.download_tip = trans:Find("download_tip").gameObject
    m_tbInstancedGameItems[#m_tbInstancedGameItems + 1] = listItem
end ]]

--render msg
local function _RenderMsg()
    if m_RadioTween ~= nil and DoTweenPathLuaUtil.IsPlaying(m_RadioTween) == true then 
        return 
    end 
    TransformLuaUtil.SetTransformLocalPos(m_TransRadio, m_RadioMsgInitialPos.x, m_RadioMsgInitialPos.y, m_RadioMsgInitialPos.z)
    if tb_NeedRenderMessage == nil or #tb_NeedRenderMessage <= 0 then 
        return
    end

    local msg = tb_NeedRenderMessage[1]
    table.remove(tb_NeedRenderMessage, 1)
    txt_radio.text = tostring(msg) 
    local dis = m_RadioMaskWidth + GameHelper.CalculateTextSize(txt_radio) + 50.0
    local duration =  dis / RADIO_ANIM_SPEED
    local posx = m_RadioMsgInitialPos.x - dis 
   
    if m_RadioTween == nil then 
        m_RadioTween = DoTweenPathLuaUtil.DOMoveX(m_TransRadio, posx, duration)
        DoTweenPathLuaUtil.SetEaseTweener(m_RadioTween, DG.Tweening.Ease.Linear)
        DoTweenPathLuaUtil.SetAutoKill(m_RadioTween, false)
        DoTweenPathLuaUtil.OnComplete(m_RadioTween, tbclass.OnRadioAnimCompleted)
    else
        m_RadioTween:ChangeEndValue(m_RadioMsgInitialPos.x, posx, duration) 
    end 
    DoTweenPathLuaUtil.DORestart(m_TransRadio)
end 


local function InitialGameList() 
    m_GameList = {} 
    local root = transform:Find("Panel/games")
    for i=1, root.childCount do 
        local game = {}
        local trans = root:Find("game_" .. i)
        game.gameObject = trans.gameObject
        game.img_card = trans:Find("img_card"):GetComponent("Image")
        game.img_name = trans:Find("img_name"):GetComponent("Image")
        game.img_game_icon = trans:Find("img_game_icon"):GetComponent("Image")
        game.img_coming = trans:Find("img_comingsoon"):GetComponent("Image")
        game.img_bg = trans:GetComponent("Image")
        game.img_coming.enabled = false 
        game.btn = trans:GetComponent("Button")
        table.insert(tb_btns, game.btn)
        game.trans = trans 
        table.insert(m_GameList, game)
    end 


    local allGamesInfos = luaTool:GetGamesInfos()
    local len = #allGamesInfos 
    for j=1, len do 
        if m_GameList[j] then 
            -- LoadGameItemData(m_GameList[j] , v)
            local v = allGamesInfos[j]
            local game = m_GameList[j]
            local bg_path = string.format("%s%s",UI_IMAGE_PATH, v:GetBGIconPath())
            game.btn.onClick:RemoveAllListeners()
            game.btn.onClick:AddListener(function() 
                onClickGameBtn(v)
            end)
            GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_Sprite, bg_path , function(asset) 
                    if asset and asset:IsValid() == true then 
                        game.img_bg.sprite = asset:GetAsset() 
                        tb_LoadedLuaAssets[bg_path] = asset
                    else 
                        game.img_bg.enabled = false 
                    end 
            end)

            local game_type = v:GetGameType() 
            if game_type == EGameType.EGT_MAX then 
                game.img_card.enabled = false 
                game.img_name.enabled = false 
                game.img_coming.enabled = false 
                game.img_game_icon.enabled = false 
                game.btn.interactable = false 
            else 
                game.btn.interactable = true
                game.img_card.enabled = true 
                game.img_name.enabled = true 
                game.img_coming.enabled = game_type == EGameType.EGT_Coming 
                game.img_game_icon.enabled = true 
                local card_icon_path = string.format("%s%s",UI_IMAGE_PATH,v:GetCardIconPath())
                local name_icon_path = string.format("%s%s",UI_IMAGE_PATH,v:GetNameIconPath())
                local game_icon_path = string.format("%s%s",UI_IMAGE_PATH,v:GetGameIconPath())
                GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_Sprite, card_icon_path , function(asset) 
                    if asset and asset:IsValid() == true then 
                        game.img_card.sprite = asset:GetAsset() 
                        tb_LoadedLuaAssets[card_icon_path] = asset
                    else 
                        game.img_bg.enabled = false 
                    end 
                end)
                GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_Sprite, name_icon_path , function(asset) 
                    if asset and asset:IsValid() == true then 
                        game.img_name.sprite = asset:GetAsset() 
                        tb_LoadedLuaAssets[name_icon_path] = asset
                    else 
                        game.img_bg.enabled = false 
                    end 
                end)
                GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_Sprite, game_icon_path , function(asset) 
                    if asset and asset:IsValid() == true then 
                        game.img_game_icon.sprite = asset:GetAsset() 
                        tb_LoadedLuaAssets[game_icon_path] = asset
                    else 
                        game.img_bg.enabled = false 
                    end 
                end)

            end 
        else 
            m_GameList[j].gameObject:SetActive(false)
        end 
    end 
end 


--radio animation completed event
function tbclass:OnRadioAnimCompleted()
    txt_radio.text = ""
    _RenderMsg()    
end 

--bind listeners, ...etc
function tbclass:Init()
    if transform == nil then 
        LogError('[UI_Main.Init]:: missing transform')
        return
    end 
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    tb_NeedRenderMessage = {}
    btn = transform:Find("Panel/bottom/btn_join"):GetComponent("Button")
    if btn ~= nil then  
        btn.onClick:AddListener(function() onClickJoinGameBtn() end)
    end 
    table.insert(tb_btns, btn)

    btn = transform:Find("Panel/bottom/btn_create"):GetComponent("Button")
    if btn ~= nil then  
        btn.onClick:AddListener(function() onClickCreateGameBtn() end)
    end 
    table.insert(tb_btns, btn)
    

    btn = transform:Find("Panel/bottom/btn_achive"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickAchieveBtn)
    end 
    table.insert(tb_btns, btn)

    btn = transform:Find("Panel/bottom/btn_invite"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickInviteCodeBtn)
    end 
    table.insert(tb_btns, btn)

    btn = transform:Find("Panel/bottom/btn_setting"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickSettingBtn)
    end 
    table.insert(tb_btns, btn)

    btn = transform:Find("Panel/bottom/btn_club"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickClubBtn)
    end 
    table.insert(tb_btns, btn)

    btn = transform:Find("Panel/bottom/btn_store"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickStoreBtn)
    end 
    table.insert(tb_btns, btn)

    btn = transform:Find("Panel/bottom/btn_share"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickShareBtn)
    end 
    table.insert(tb_btns, btn)

    btn = transform:Find("Panel/top/diamond/btn_purchase"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickBuyBtn)
        btn.gameObject:SetActive(false)
    end 
    table.insert(tb_btns, btn)

    img_headicon = transform:Find("Panel/top/userInfo/mask/img_icon"):GetComponent("Image")

    btn = transform:Find("Panel/top/userInfo/head_bg"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickHeadBtn)
    end 
    table.insert(tb_btns, btn)

    txt_name = transform:Find("Panel/top/userInfo/txt_name"):GetComponent("Text")
    txt_id = transform:Find("Panel/top/userInfo/txt_id"):GetComponent("Text")
    tb_LoadedLuaAssets = {} 
    InitialGameList()
    --m_GameList = transform:Find("Panel/listgames"):GetComponent("CardRoundSelectorEx")
    txt_diamond = transform:Find("Panel/top/diamond/txt_diamond"):GetComponent("Text")
    m_tbInstancedGameItems = {}

    m_TransRadio = transform:Find("Panel/top/radio/mask/txt_msg")
    m_RadioRectTransform = m_TransRadio:GetComponent("RectTransform")
    m_RadioMaskWidth = transform:Find("Panel/top/radio/mask"):GetComponent("RectTransform").rect.width
    txt_radio = m_TransRadio:GetComponent("Text")
    m_RadioMsgInitialPos = m_TransRadio.localPosition
    txt_radio.text = ""
end 

--instance game list
--[[function tbclass:InitialGameList()
    local allGamesInfos = luaTool:GetGamesInfos()
    for _, v in ipairs(allGamesInfos) do
        local gameItem = m_GameList:Spawn()
        LoadGameItemData(gameItem, v)
    end
    m_GameList:Reset()
end]]

--render message 
function tbclass:RenderMsg(msg)
    if msg ~= nil then 
        table.insert(tb_NeedRenderMessage, msg)
        _RenderMsg()
    end 
    
end 

--fresh player information 
function tbclass:FreshPlayerInfo(username, headimageurl, userid, roomCard)
    if headimageurl ~= nil then 
        GetHeadIconManager().LoadIcon(headimageurl, function(sprite) 
            if sprite ~= nil and sprite:IsValid() == true then 
                img_headicon.enabled = true
                img_headicon.sprite = sprite:GetAsset()
            else 
                img_headicon.enabled = false
            end 
        end)
    end 

    if txt_name ~= nil then 
        txt_name.text = username
    end 

    userid = userid or ""
    if txt_id ~= nil then 
        txt_id.text = string.format("ID:%s", tostring(userid))
    end 

    roomCard = roomCard or 0
    if txt_roomCard ~= nil then 
        txt_roomCard.text = tostring(roomCard)
    end 
end 

--set the mediator
--@param inMediator 
function tbclass:SetMediator(inMediator)
    mediator = inMediator
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
    self:SafeRelease()
    transform = nil
end 

--release asset reference, unbind listeners...etc
function tbclass:SafeRelease()
    if windowAsset ~= nil then 
        windowAsset:Free(1)
    end 
    if tb_btns ~= nil then 
        while #tb_btns > 0 do 
            tb_btns[1].onClick:RemoveAllListeners()
            tb_btns[1] = nil 
            table.remove(tb_btns,1)
        end 
    end 
    tb_btns = nil 
    
    if m_RadioTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_RadioTween, true )
        m_RadioTween = nil 
    end 
    m_TransRadio = nil 
    m_RadioRectTransform = nil 
    txt_radio = nil
    m_RadioMsgInitialPos = nil 
    tb_NeedRenderMessage = nil 

    windowAsset = nil   
    facade = nil
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end

--Don't remove all of them
return tbclass