--[[
  * ui view class:: UI_Fight
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
--the prameter of send message to wechat
local m_WeChatShareParam = { bIsLink = true, scene = EWeChatSceneType.EWCS_Friend, share_type = EShareType.EST_Text}
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
--whether is playing opening animation of window
local m_IsPlaying = false
--private function table
local m_PrivateFunc = {}
--seat info 
local m_SeatInfo = nil
--common panel 
local m_CommonPanel = nil 
--chat panel
local m_ChatPanel = nil 
--share panel 
local m_SharePanel = nil 


--================private interface begin =====================
--callback function of exit button
m_PrivateFunc.onClickExitBtn = function()
    facade:sendNotification(nn.PLAYER_LEAVE_GAME)
end 

--share room information to wechat 
m_PrivateFunc.onClickShareBtn = function()
    facade:sendNotification(nn.SEND_MSG_WECHAT, m_WeChatShareParam)
end

--duplicate room inforamtion to clipboard 
m_PrivateFunc.onClickDuplicateBtn = function()
    facade:sendNotification(nn.DUPLICATE_ROOM_ID)
end

--callback function of setting button
m_PrivateFunc.onClickSettingBtn = function()
end 

--render chat panel
m_PrivateFunc.ShowChatPanel = function(bShow) 
end 

--update system time and power
--@param time curent time of os
m_PrivateFunc.UpdateTimeAndPower = function(time)
    if m_CommonPanel.img_devicepower ~= nil then 
        m_CommonPanel.img_devicepower.fillAmount = GameHelper.batteryLevel
    end 
    if m_CommonPanel.txt_time ~= nil then
        hour = os.date("%H",time)
        min = os.date("%M", time)

        m_CommonPanel.txt_time.text = hour .. ":" .. min
    end 
end 

--bind callback for buttons in here
m_PrivateFunc.BindCallbacks = function()
    local btn = m_RootPanel:Find('top/btn_back'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(m_PrivateFunc.onClickExitBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('top/btn_setting'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(m_PrivateFunc.onClickSettingBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find('bottom/btn_chat'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function() m_PrivateFunc.ShowChatPanel(true) end)
        table.insert(tb_btns, btn)
    end

end 

--initial share panel 
m_PrivateFunc.InitialSharePanel = function()
    m_SharePanel = {} 
    local trans = m_RootPanel:Find("share")
    m_SharePanel.gameObject = trans.gameObject 
    local btn = trans:Find("btn_dismiss"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:RemoveAllListeners()
        btn.onClick:AddListener(m_PrivateFunc.onClickExitBtn)
        m_SharePanel.dimiss_obj = btn.gameObject 
    end 
    table.insert(tb_btns, btn)

    btn = trans:Find("btn_share"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:RemoveAllListeners()
        btn.onClick:AddListener(m_PrivateFunc.onClickShareBtn)
    end 
    table.insert(tb_btns, btn)

    btn = trans:Find("btn_duplicate"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:RemoveAllListeners()
        btn.onClick:AddListener(m_PrivateFunc.onClickDuplicateBtn)
    end 
    table.insert(tb_btns, btn)

    m_SharePanel.Free = function()
        m_SharePanel.dimiss_obj = nil 
        m_SharePanel.gameObject = nil 
        m_SharePanel = nil 
    end
end

--initial common info panel of game 
m_PrivateFunc.InitialCommonPanel = function()
    m_CommonPanel = {} 
    m_CommonPanel.txt_time =  m_RootPanel:Find("top/txt_date"):GetComponent("Text")
    m_CommonPanel.txt_netdelay = m_RootPanel:Find("top/txt_netdelay"):GetComponent("Text")
    m_CommonPanel.img_devicepower = m_RootPanel:Find("top/power/fill"):GetComponent("Image")
    m_CommonPanel.img_devicepower.fillAmount = 1
    m_CommonPanel.txt_roomid = m_RootPanel:Find("top/bg_roomId/txt_roomId"):GetComponent("Text")
    m_CommonPanel.txt_remainround = m_RootPanel:Find("top/bg_round/txt_round"):GetComponent("Text")
    m_CommonPanel.txt_remainround.text = "0局"
    GetLuaPing().RegisterText(m_CommonPanel.txt_netdelay)
    m_CommonPanel.Free = function()
        m_CommonPanel.txt_time = nil 
        m_CommonPanel.txt_netdelay = nil 
        m_CommonPanel.img_devicepower = nil 
        m_CommonPanel.txt_roomid = nil 
        m_CommonPanel.txt_remainround = nil 
    end
end 

--initial seat
m_PrivateFunc.InitialSeat = function()
    m_SeatInfo = {} 
    local trans = nil 
    local root = m_RootPanel:Find("players")
    local pos = nil
    local card = nil  
    for i=1,6 do 
        local seat = {} 
        trans = root:Find("player_" .. i)
        seat.gameObject = trans.gameObject 
        seat.img_head = trans:Find("mask/img_head"):GetComponent("Image")
        seat.txt_name = trans:Find("txt_name"):GetComponent("Text")
        seat.txt_score = trans:Find("score/txt_score"):GetComponent("Text")
        seat.img_dealer = trans:Find("img_dealer"):GetComponent("Image")
        seat.btn = trans:GetComponent("Button")
        table.insert(tb_btns, seat.btn)
        seat.img_dealer.enabled = false 
        seat.m_HandCards = {} 
        seat.m_HandCardsPos = {}  
        for t=1,5 do 
            card = trans:Find("cards/card_" .. t)
            pos = card.localPosition
            card.gameObject:SetActive(false)
            table.insert(seat.m_HandCardsPos, UnityEngine.Vector3(pos.x, pos.y, pos.z))
        end 
        seat.gameObject:SetActive(false)
        table.insert(m_SeatInfo, seat)
    end 

    m_SeatInfo.Free = function() 
        for k,v in ipairs(m_SeatInfo) do 
            if v then 
                v.btn = nil 
                v.img_dealer = nil 
                v.gameObject = nil 
                v.txt_name = nil 
                v.txt_score = nil 
                v.m_HandCardsPos = nil 
                v.m_HandCardsPos = nil 
            end 
            m_SeatInfo[k] = nil 
        end 
        m_SeatInfo = nil 
    end   
end 

--initial chat panel
m_PrivateFunc.InitialChatPanel = function() 
    m_ChatPanel = {} 

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
        LogError('[UI_Fight.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_RootPanel = transform:Find('Panel')
    
    --register callback of buttons
    m_PrivateFunc.BindCallbacks()
    m_PrivateFunc.InitialSeat()
    m_PrivateFunc.InitialCommonPanel()
    m_PrivateFunc.InitialChatPanel()
    m_PrivateFunc.InitialSharePanel()
    --register self to game manager for receiving update events
    GetLuaGameManager():GetGameMode():RegisterComponent(self, windownName)
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

local m_FreshInternal = 5
local m_FreshStartTime = 0
local curTime = nil 
local hour = 0
local min = 0 
local remain = 0
function tbclass:Update()
   
    curTime = os.time()
    if m_CommonPanel then 
        if m_FreshStartTime == 0 then 
            local s = os.date("%S", os.time())
            m_FreshInternal = 60 - s 
            m_FreshStartTime = curTime
            m_PrivateFunc.UpdateTimeAndPower(curTime)
        end 

        if m_FreshStartTime == 0 or curTime - m_FreshStartTime >= m_FreshInternal then 
            m_PrivateFunc.UpdateTimeAndPower(curTime)
            if m_FreshStartTime > 0 then 
                m_FreshInternal = 60
            end 
            m_FreshStartTime = curTime
        end 
    end 
end 

--OnClose:: called by mediator
function tbclass:OnClose()
    bOpened = false
    --remove self
    GetLuaGameManager():GetGameMode():RemoveComponent(windownName)
    self:SafeRelease()
    transform = nil
end 

--release asset reference, unbind listeners...etc
function tbclass:SafeRelease()
    if windowAsset ~= nil then 
        windowAsset:Free(1)
    end 

    GetLuaPing():RemoveText(m_CommonPanel.txt_netdelay)
    m_CommonPanel.Free()
    m_CommonPanel = nil 
    m_SharePanel.Free()
    m_SharePanel = nil 
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
    CLOSE_SELF_PARAM = nil 
    CLOSE_CAN_RESTORE_PARAM = nil 
    if gameObject ~= nil then 
        UnityEngine.GameObject.Destroy(gameObject);
    end 
    gameObject = nil 
end

--disable or enable share btn .. etc
--@param bEnabled whether controls will be render or not
function tbclass:EnableSharePanel(bEnabled, bIsOnwner)
    if m_SharePanel then 
        m_SharePanel.gameObject:SetActive(bEnabled)
        --m_SharePanel.dimiss_obj:SetActive(bIsOnwner)
    end 
end 

--fresh room information
--@param room_id
function tbclass:FreshRoomId(room_id)
    m_CommonPanel.txt_roomid.text =  string.format("%s%s", luaTool:GetLocalize("room_title"), tostring(room_id))
end 

--fresh game round 
--@param curRound current round
--@param maxRound
function tbclass:FreshRound(curRound, maxRound)
    local remain = maxRound - curRound
    if remain <= 0 then 
        remain = 0
    end 
    m_CommonPanel.txt_remainround.text = string.format("%s局", tostring(remain))
end 

--fresh player info
--@param user  user inforamtion
function tbclass:FreshPlayerInfo(users)
    if users then 
        for k,v in ipairs(users) do 
            local seat = m_SeatInfo[v.real_seat_id] 
            if seat then 
                seat.gameObject:SetActive(true)
                seat.txt_name.text = v.user_name 
                seat.txt_score.text = mediator:GetUserScore(v.real_seat_id)
                if v.head_img then 
                    GetHeadIconManager().LoadIcon(v.head_img, function(sprite) 
                        if sprite ~= nil and sprite:IsValid() == true then 
                            seat.img_head.enabled = true
                            seat.img_head.sprite = sprite:GetAsset()
                        else 
                            seat.img_head.enabled = false
                        end 
                    end)
                end 
            end 
        end 
    end 
end 

--Ntf player joined game
--@param seat_id
function tbclass:NtfPlayerJoinedGame(seat_id)
    local seat = m_SeatInfo[seat_id] 
    if seat then 
        local info = mediator:GetPlayerInfoWithRealSeatId(seat_id)
        if info then 
            seat.gameObject:SetActive(true)
            seat.txt_name.text = info.user_name
            seat.txt_score.text = mediator:GetUserScore(info.real_seat_id)
            if info.head_img then 
                GetHeadIconManager().LoadIcon(info.head_img, function(sprite) 
                    if sprite ~= nil and sprite:IsValid() == true then 
                        seat.img_head.enabled = true
                        seat.img_head.sprite = sprite:GetAsset()
                    else 
                        seat.img_head.enabled = false
                    end 
                end)
            end 
        end 
    end 
end 

--Ntf player left game 
--@param seat_id
function tbclass:NtfPlayerLeftGame(seat_id)
    local seat = m_SeatInfo[seat_id]
    if seat then 
        seat.gameObject:SetActive(false)
    end 
end 

--ntf player ready
--@param seat_id
function tbclass:NtfPlayerReady(seat_id)
end 

--ntf round over
function tbclass:NtfRoundOver()

end 

--ntf round start
function tbclass:NtfRoundStart()
end 

--ntf play game
function tbclass:NtfPlayGame(owner_seat_id, remain_time)
    local seat = m_SeatInfo[owner_seat_id]
    --if bSendDoneCmd == nil or  bSendDoneCmd == true then 
    facade:sendNotification(Common.EXECUTE_CMD_DONE)
    --end 
end 

--fresh game rule panel
function tbclass:FreshGameRule(rule)
end 

--cleanup table
function tbclass:CleanupTable()
end 

--ntf begin shuffle
function tbclass:NtfShuffle(card_info)
end 

--recieved chat msg 
--@param  seat_id  msg sender
--@param  msg  content
function tbclass:NtfRecievedMsg(seat_id, msg)
end 
--restore game 
function tbclass:PlayerReconnected(info, seat_id, bShowReady, game_state, bNotShuffle)
end 

--Don't remove all of them
return tbclass