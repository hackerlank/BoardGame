--[[
  * ui view class:: UI_Achieve
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
local tb_listItems = nil 

--save game facade
local facade = nil
--root panel.
local m_RootPanel = nil 
--saved the animation tween object of menu
local m_OpenAnimTween = nil 
--menu animation last time
local MENU_OPEN_ANIM_TIME = 0.11

local m_AchieveList = nil 
local txt_none = nil 
local m_AchieveGO = nil 
local m_selectedRecord = nil 
local m_bTouchedRecord = false 

local m_LoadedAssets = nil 
local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_Achieve') 

local CLOSE_CAN_RESTORE_PARAM = ci.GetUICloseParam().new(true, 'UI_Achieve') 

--============ callback of buttons begin ====================
--callback function of close button
local function onClickCloseBtn()
    if m_selectedRecord == nil then 
        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Back) 
    end 
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
    if m_bTouchedRecord == true then 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_CAN_RESTORE_PARAM)
        local MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_ACHIEVE_DETAIL, EMenuType.EMT_Common, 'UI_Achieve', false, nil, m_selectedRecord)
        facade:sendNotification(Common.OPEN_UI_COMMAND, MENU_PARAM)
        m_selectedRecord = nil 
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

local function OnComplete()
    m_AchieveGO:SetActive(true)
end 

--play the opening animation of menu
local function PlayOpenAmin()
    gameObject:SetActive(false)
    TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0, 0, 0)
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        --play animation 
        --@todo you need to edit the animation style in here
        
        if gameObject then 
            gameObject:SetActive(true)
            
            if m_OpenAnimTween == nil then 
                m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
                DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.Linear)
                DoTweenPathLuaUtil.SetAutoKill(m_OpenAnimTween, false)
                DoTweenPathLuaUtil.OnComplete(m_OpenAnimTween, OnComplete)
                DoTweenPathLuaUtil.OnRewind(m_OpenAnimTween, OnRewind)
                DoTweenPathLuaUtil.DOPlay(m_RootPanel)
            else 
                DoTweenPathLuaUtil.DORestart(m_RootPanel)
            end 
        end 
    end)
end 

local function InitialList()
    m_AchieveGO = m_RootPanel:Find("achieveList").gameObject
    m_AchieveList = m_RootPanel:Find("achieveList"):GetComponent("GameScrollRect")
    if m_AchieveList ~= nil then 
        m_AchieveList:SetColumn(12)
        m_AchieveList:SetListInfos(nil,true)
        local m_Content = m_AchieveList.content
        if m_Content ~= nil then 
            local count = m_Content.childCount
            for i=0, count-1 do 
                local trans = m_Content:GetChild(i)
                if trans ~= nil then 
                    local t = {}
                    t.item = trans:GetComponent("SlotItemInfo")
                    
                    t.img_game = trans:Find("img_game"):GetComponent("Image")
                    t.txt_roomId = trans:Find("txt_roomId"):GetComponent("Text")
                    t.btn = trans:GetComponent("Button")
                    t.txt_user1 = trans:Find("txt_username1"):GetComponent("Text")
                    t.txt_user2 = trans:Find("txt_username2"):GetComponent("Text")
                    t.txt_user3 = trans:Find("txt_username3"):GetComponent("Text")
                    t.txt_user4 = trans:Find("txt_username4"):GetComponent("Text")
                    t.txt_user4.text = ""
                    t.txt_date =  trans:Find("txt_date"):GetComponent("Text")
                    local record = nil 
                    
                    t.btn.onClick:AddListener(function() 
                        m_bTouchedRecord = true
                        if record ~= nil   then            
                            m_selectedRecord = record.roundInfos
                        else 
                            m_selectedRecord = nil 
                        end 
                        AudioManager.getInstance():PlaySound(EGameSound.EGS_Btn_Choose) 
                        onClickCloseBtn()
                    end)

                    t.Free = function ()
                        t.item.onValueChanged:RemoveAllListeners()
                        t.img_game = nil
                        t.txt_roomId = nil 
                        t.btn.onClick:RemoveAllListeners()
                        t.btn = nil 
                        t.txt_user1 = nil 
                        t.txt_user2 = nil 
                        t.txt_user3 = nil 
                        t.txt_user4 = nil 
                        record = nil 
                    end
       
                    if t.item ~= nil then 
                        t.item.onValueChanged:AddListener(function()
                            record = t.item.info 
                            if record ~= nil then 
                                t.txt_roomId.text = string.format("%s%s", luaTool:GetLocalize("room_title"), tostring(record.roomId))
								t.txt_date.text = string.format("%s%s", luaTool:GetLocalize("date"),tostring(record.record_time))
								if record.game_score_infos then 
									local tmp_game_info = record.game_score_infos
									for i=1,#tmp_game_info do 
										local tmp_txt
										if i==1 then 
											tmp_txt = t.txt_user1
										elseif i==2 then
											tmp_txt = t.txt_user2
										elseif i==3 then
											tmp_txt = t.txt_user3
										elseif i==4 then
											tmp_txt = t.txt_user4					
										end
										tmp_txt.text = string.format( "%s:%s", tmp_game_info[i].user_name, tostring(tmp_game_info[i].score))
									end
                                end
                                
                                if record.game_type ~= nil then 
                                    local path = "Assets/Content/ArtWork/UI/Common/images/"
                                    if record.game_type == EGameType.EGT_CDMaJiang then 
                                        path = path ..  "icon_cdmj.png"
                                    elseif record.game_type == EGameType.EGT_NJMaJiang then 
                                        path = path ..  "icon_njmj.png"
                                    elseif record.game_type == EGameType.EGT_ZhaJinHua then 
                                    end 
                                    
                                    if m_LoadedAssets[path] == nil then 
                                        GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_Sprite, path, function(asset) 
                                            if asset ~= nil then 
                                                m_LoadedAssets[path] = asset
                                                t.img_game.sprite = asset:GetAsset() 
                                            else 
                                                t.img_game.sprite = nil 
                                            end 
                                        end)
                                    else
                                        t.img_game.sprite = m_LoadedAssets[path]:GetAsset() 
                                    end 
                                end 
                            else 
                                t.txt_user4.text = ""
                                t.txt_user3.text = ""
                                t.txt_user2.text = ""
                                t.txt_user1.text = ""
                                t.txt_date.text = ""
                                t.img_game.sprite = nil 
                                t.txt_roomId.text = ""
                            end 
                
                        end)
                    end 
                    table.insert(tb_listItems, t)
                end 
            end 
        end 
    end 

    m_AchieveGO:SetActive(false)
end 

--bind callback for buttons in here
local function BindCallbacks()
    m_RootPanel = transform:Find('Panel')
    local btn = m_RootPanel:GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function() 
            m_bTouchedRecord = false 
            onClickCloseBtn()
        end)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('btns/btn_close'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function() 
             m_bTouchedRecord = false
             onClickCloseBtn()
        end)
        table.insert(tb_btns, btn)
    end
    m_selectedRecord = nil 
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
        LogError('[UI_Achieve.Init]:: missing transform')
        return
    end 
    if m_RootPanel == nil then 
        m_RootPanel = transform:Find("Panel")
    end 
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    tb_listItems = {}
    m_LoadedAssets = {}

    txt_none = transform:Find("Panel/txt_none").gameObject
    txt_none:SetActive(false)
    BindCallbacks()

    InitialList()
    PlayOpenAmin()

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
        PlayOpenAmin()
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

    if tb_listItems ~= nil then 
        for k,v in ipairs(tb_listItems) do 
            if v then 
                v.Free()
            end 
            tb_listItems[k] = nil 
        end 
        tb_listItems = nil 
    end 

    if m_LoadedAssets ~= nil then 
        for k,v in pairs(m_LoadedAssets) do 
            if v then 
                v:Free()
            end 
            m_LoadedAssets[k] = nil 
        end 
        m_LoadedAssets = nil 
    end 

    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_OpenAnimTween, true)
        m_OpenAnimTween = nil 
    end 
    m_RootPanel = nil 

    windowAsset = nil   
    facade = nil
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end

function tbclass:NtfRecordsUpdated(records)
    if records == nil then 
        return 
    end 
    if m_AchieveList ~= nil and records ~= nil and #records > 0 then 
        local tmp_list = ListObject()  
        for k,v in pairs(records) do 
            tmp_list:Add(v)
        end	
        m_AchieveList:SetListInfos(tmp_list, true)
        txt_none:SetActive(false)
    else 
        txt_none:SetActive(true)
    end 
end 

--Don't remove all of them
return tbclass