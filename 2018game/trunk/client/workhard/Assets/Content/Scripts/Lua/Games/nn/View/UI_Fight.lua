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
--option panel 
local m_OptPanel = nil 
--wathch game 
local m_Prestart = nil 

--cache ready btn 
local btn_ready = nil 
--cache invite btn
local btn_invite = nil 
--cache open card btn
local btn_showcard = nil 
--save useless card
local m_InstancedCards = {}
--card template
local m_cardsTemplate = nil 
--useless card parent
local m_UselessCardParent = nil 
--instanced card count
local m_CardCount = 0

local card_initial_pos = UnityEngine.Vector3(0,0,0)
--save poker asset
local m_LoadedPokerAsset = nil 
--save niu type image 
local m_LoadedNiuTypeAsset = {}
--whether is loading asset
local m_bIsLoadingAsset = false 

local ECardType={
    diamond=1,
    club=2,
    heart=3,
    spade=4,
    joker_small=5,
    joker_big=6, --王
    universal=7,
    max=8   --it means background of poker
}

--================private interface begin =====================
--callback function of exit button
m_PrivateFunc.onClickExitBtn = function()
    facade:sendNotification(nn.PLAYER_LEAVE_GAME)
    m_PrivateFunc.ShowOptionPanel(false)
end 

--dismiss room.
m_PrivateFunc.onClickDismissBtn = function()
    m_PrivateFunc.ShowOptionPanel(false)
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
    m_PrivateFunc.ShowOptionPanel(false)
end 

--show lastest round information
m_PrivateFunc.onClickReplayBtn = function()
    m_PrivateFunc.ShowOptionPanel(false)
end 

--callback function of info btn
m_PrivateFunc.onClickInfoBtn = function()
    local hand_cards = mediator:GetPlayerCards(1)
    local seat = m_SeatInfo[1]
    m_PrivateFunc.ShowPlayerCardType(1, hand_cards)
end 

--callback function of auto button
m_PrivateFunc.onClickAutoBtn = function()
end 

--callback function of invite button 
m_PrivateFunc.onClickInviteBtn = function()
end 

--callback function of start button 
m_PrivateFunc.onClickStartBtn = function()
    if facade then 
        facade:sendNotification(nn.OWNER_REQ_START_GAME)
    end 
end 

--callback function of ready button 
m_PrivateFunc.onClickReadyBtn = function()
end 

--callback function of sit button 
m_PrivateFunc.onClickSitBtn = function()
end 

--callback function of chat_msg button 
m_PrivateFunc.onClickChatMsgBtn = function()
end 

--callback function of chat_voice button 
m_PrivateFunc.onClickChatVoiceBtn = function()
end 

--req open self card
m_PrivateFunc.onClickShowCardBtn = function()
    facade:sendNotification(nn.REQ_OPEN_CARD)
end 

--render chat panel
m_PrivateFunc.ShowChatPanel = function(bShow) 
end 

--render option panel 
m_PrivateFunc.ShowOptionPanel = function(bShow)
    if m_OptPanel then 
        m_OptPanel.gameObject:SetActive(bShow)
    end 
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
    btn = m_RootPanel:Find('top/btn_optpanel'):GetComponent('Button')
    if btn ~= nil then
        btn.onClick:AddListener(function() m_PrivateFunc.ShowOptionPanel(true)  end)
        table.insert(tb_btns, btn)
    end

    --tuo guan
    btn = m_RootPanel:Find("top/btn_auto"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(m_PrivateFunc.onClickAutoBtn)
        table.insert(tb_btns, btn)
    end 

    --info
    btn = m_RootPanel:Find("top/btn_info"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(m_PrivateFunc.onClickInfoBtn)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("bottom/btn_invite"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickInviteBtn)
        table.insert(tb_btns, btn)
        btn_invite = btn 
    end 

    btn = m_RootPanel:Find("prestart/start_set/btn_sit"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickSitBtn)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("prestart/start_set/btn_start"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickStartBtn)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("bottom/btn_ready"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickReadyBtn)
        table.insert(tb_btns, btn)
        btn_ready = btn 
        btn_ready.gameObject:SetActive(false)
    end 

    btn = m_RootPanel:Find("bottom/btn_chat_msg"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickChatMsgBtn)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("bottom/btn_chat_voice"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickChatVoiceBtn)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("bottom/btn_showcard"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickShowCardBtn)
        btn_showcard = btn 
        btn_showcard.gameObject:SetActive(false)
    end 

end 

--initial option panel
m_PrivateFunc.InitialOptionPanel = function()
    m_OptPanel = {} 
    local root = m_RootPanel:Find("panel_opt")
    m_OptPanel.gameObject = root.gameObject

    local btn = root:GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(function() m_PrivateFunc.ShowOptionPanel(false) end)
        table.insert(tb_btns, btn)
    end 
    
    btn = root:Find("btn_back"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickExitBtn)
        table.insert(tb_btns, btn)
    end 

    btn = root:Find("btn_dismiss"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickDismissBtn)
        table.insert(tb_btns, btn)
    end 

    btn = root:Find("btn_setting"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickSettingBtn)
        table.insert(tb_btns, btn)
    end 

    btn = root:Find("btn_replay"):GetComponent("Button")
    if btn then 
        btn.onClick:AddListener(m_PrivateFunc.onClickReplayBtn)
        table.insert(tb_btns, btn)
    end 
    m_OptPanel.gameObject:SetActive(false)
end 

--initial share panel 
m_PrivateFunc.InitialSharePanel = function()
    m_SharePanel = {} 
    local trans = m_RootPanel:Find("share")
    m_SharePanel.gameObject = trans.gameObject 
    local btn = trans:Find("btn_share"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(m_PrivateFunc.onClickShareBtn)
    end 
    table.insert(tb_btns, btn)

    btn = trans:Find("btn_duplicate"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(m_PrivateFunc.onClickDuplicateBtn)
    end 
    table.insert(tb_btns, btn)
    --interface
    m_SharePanel.ShowPanel = function(game_state)
        if game_state ~= nn.ETableState.idle then 
            m_SharePanel.gameObject:SetActive(false)
        else 
            m_SharePanel.gameObject:SetActive(true)
        end 
    end 

    m_SharePanel.Free = function()
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
    m_CommonPanel.txt_roomid = m_RootPanel:Find("top/txt_roomId"):GetComponent("Text")
    m_CommonPanel.txt_remainround = m_RootPanel:Find("top/txt_round"):GetComponent("Text")
    m_CommonPanel.txt_remainround.text = ""
    m_CommonPanel.txt_dealerrule = m_RootPanel:Find("top/txt_dealerrule"):GetComponent("Text")
    m_CommonPanel.txt_tuizhu = m_RootPanel:Find("top/txt_tuizhu"):GetComponent("Text")

    --GetLuaPing().RegisterText(m_CommonPanel.txt_netdelay)
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
        seat.txt_score = trans:Find("txt_score"):GetComponent("Text")
        seat.img_dealer = trans:Find("img_dealer"):GetComponent("Image")
        seat.txt_result = trans:Find("txt_result"):GetComponent("Text")
        seat.txt_multbei = trans:Find("txt_mult"):GetComponent("Text")
        seat.img_ready = trans:Find("img_ready"):GetComponent("Image")
        seat.img_bq = trans:Find("img_buqiang"):GetComponent("Image")
        seat.img_qz = trans:Find("qz"):GetComponent("Image")
        seat.txt_qz_num = trans:Find("qz/txt_num"):GetComponent("Text")
        seat.img_niutype = trans:Find("img_niutype"):GetComponent("Image")
        --interface
        seat.Cleanup = function()
            seat.img_niutype.enabled = false
            seat.img_qz.enabled = false 
            seat.img_bq.enabled = false
            seat.img_ready.enabled = false 
            seat.txt_multbei.text = ""
            seat.txt_result.text = ""
            seat.txt_qz_num.text = ""

            for k,v in ipairs(seat.m_HandCards) do 
                if v then 
                    v.img.enabled = false 
                    v.card_point = nil 
                    table.insert(m_InstancedCards, v)
                    seat.m_HandCards[k] = nil 
                end 
            end 
        end 
        --seat.btn = trans:GetComponent("Button")
        --table.insert(tb_btns, seat.btn)
        seat.img_dealer.enabled = false 
        seat.m_HandCards = {} 
        seat.m_HandCardsPos = {}  
        seat.m_HandCardParent = trans:Find("cards")
        for t=1,5 do 
            card = trans:Find("cards/card_" .. t)
            pos = card.localPosition
            card.gameObject:SetActive(false)
            table.insert(seat.m_HandCardsPos, UnityEngine.Vector3(pos.x, pos.y, pos.z))
        end 
        seat.Cleanup()
        seat.gameObject:SetActive(false)
        table.insert(m_SeatInfo, seat)
    end 

    m_SeatInfo.Free = function() 
        for k,v in ipairs(m_SeatInfo) do 
            if v then 
                --v.btn = nil 
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

--initial watch game panel 
m_PrivateFunc.InitialPrestartGamePanel = function() 
    m_Prestart = {} 
    local root = m_RootPanel:Find("prestart")
    m_Prestart.img_watch = root:Find("img_watch"):GetComponent("Image")
    m_Prestart.obj_sitcost = root:Find("cost").gameObject
    m_Prestart.txt_cost = root:Find("cost/txt_cost"):GetComponent("Text")
    m_Prestart.obj_startgame = root:Find("start_set/btn_start").gameObject
    m_Prestart.obj_sit = root:Find("start_set/btn_sit").gameObject

    m_Prestart.ShowPanel = function(game_state,start_mode)
        local cost = 20
        if start_mode == nn.EStartMode.owner then 
            local bShow = false 
            if game_state == nn.ETableState.idle or game_state == nn.ETableState.round_over then 
                bShow = true 
            end 
            if mediator:IsOwner() == true then 
                m_Prestart.obj_startgame:SetActive(bShow)
                m_Prestart.obj_sit:SetActive(false)
                m_Prestart.obj_sitcost:SetActive(false)
            else
                --@todo check if self has sit down?
                m_Prestart.obj_startgame:SetActive(false)
                m_Prestart.obj_sit:SetActive(true)
                m_Prestart.obj_sitcost:SetActive(true)
                m_Prestart.txt_cost.text = tostring(cost)
            end 
        else 
            m_Prestart.obj_sitcost:SetActive(false)
            m_Prestart.obj_startgame:SetActive(false)
            m_Prestart.obj_sit:SetActive(false)
        end 
        m_Prestart.img_watch.enabled = true
    end 
end 

--initial chat panel
m_PrivateFunc.InitialChatPanel = function() 
    m_ChatPanel = {} 

end 

--load  poker image
m_PrivateFunc.LoadPokerImage = function()
    m_bIsLoadingAsset = true
    local tb_path = {} 
    m_LoadedPokerAsset = {} 

    poker_card_asset = {}
    local strs = { "diamond", "club", "heart",  "spade" }
    local id = 1
    local path = "Assets/Content/Artwork/ui/poker/"
    local t = {}
    local index = 1
    local paths = {}
    for k,v in pairs(strs) do 
        for i=1, 13 do 
            local s = {id=id}
            paths[#paths + 1 ] = string.format("%s%s_%d.png", path, v, i)
            t[#t +1] = s
        end 
        id = id + 1
    end 

    --load bg 
    table.insert(paths, string.format("%s%s", path, "bg_puke02.png"))
    table.insert(t, {id = ECardType.max})
    --joker_small
    table.insert(paths, string.format("%s%s", path, "joker_small.png"))
    table.insert(t, {id = ECardType.joker_small})
    --joker_big
    table.insert(paths, string.format("%s%s", path, "joker_big.png"))
    table.insert(t, {id = ECardType.joker_big})

    --@todo if has other poker , add it in bellow
    GetResourceManager().LoadAssetsAsync(GameHelper.EAssetType.EAT_Sprite, paths, function(assets) 
        for k,v in ipairs(assets) do 
            local key = t[k].id
            if m_LoadedPokerAsset[key] == nil then 
                m_LoadedPokerAsset[key] = {} 
            end 

            local len = #m_LoadedPokerAsset[key] + 1
            m_LoadedPokerAsset[key][len] = v
        end 
        
        m_bIsLoadingAssetAsset = false 
    end)
end 

--get card image asset.
--@param initial_point
m_PrivateFunc.GetCardAsset = function(card_color, card_point)
    if not card_point and not card_color then 
        return m_LoadedPokerAsset[ECardType.max][1]:GetAsset()
    elseif card_color == 0 then 
        if card_point == ECardPoint.point_joker_big then 
            return m_LoadedPokerAsset[ECardType.joker_big][1]:GetAsset()
        elseif card_point == point_joker_small then 
            return m_LoadedPokerAsset[ECardType.joker_small][1]:GetAsset()
        end 
    elseif card_color > 0 and card_point > 0 then 
        return m_LoadedPokerAsset[card_color][card_point]:GetAsset()
    end 
end 

--create new card
--@param seat_id 
m_PrivateFunc.CreateNewCard = function(seat_id, point, bskipanim)
    local card = nil 
    local seat = m_SeatInfo[seat_id]
    if not seat then 
        return card 
    end 

    if m_cardsTemplate == nil then 
        LogError("missed card template")
        return card 
    end 

    if #m_InstancedCards > 0 then 
        card = m_InstancedCards[1]
        table.remove(m_InstancedCards,1)
    else
        local obj = UnityEngine.GameObject.Instantiate(m_cardsTemplate)
        card = {} 
        m_CardCount = m_CardCount + 1
        obj.name = string.format("card_nn_%d", m_CardCount)
        card.trans = obj.transform 
        card.gameObject = obj 
        card.img = card.trans:GetComponent("Image")
        table.insert(seat.m_HandCards, card)
        obj:SetActive(true)
        card.trans:SetParent(m_UselessCardParent)
    end 
    TransformLuaUtil.SetTransformPos(card.trans, card_initial_pos.x, card_initial_pos.y, card_initial_pos.z)
    card.trans:SetParent(seat.m_HandCardParent)
    TransformLuaUtil.SetTransformLocalScale(card.trans, 1,1,1)
    card.card_point = point 
    card.img.enabled = true 
    local card_color = nil 
    local card_point = nil 
    if point then 
        card_color, card_point = nn.game_logic.parse_card(point)
    end 
    card.img.sprite = m_PrivateFunc.GetCardAsset(card_color, card_point)
    local pos = seat.m_HandCardsPos[#seat.m_HandCards]
    if bskipanim ==  false then 
        card.shuffle_tween = DoTweenPathLuaUtil.DOLocalMove(card.trans, pos, 0.15)
        DoTweenPathLuaUtil.SetEaseTweener(card.shuffle_tween, DG.Tweening.Ease.Linear)
        DoTweenPathLuaUtil.SetAutoKill(card.shuffle_tween, true)
        DoTweenPathLuaUtil.SetRecyclable(card.shuffle_tween,true)
        DoTweenPathLuaUtil.OnComplete(card.shuffle_tween,function()  card.shuffle_tween = nil end)
        DoTweenPathLuaUtil.DOPlay(card.trans)
    else 
        TransformLuaUtil.SetTransformLocalPos(card.trans, pos.x, pos.y, pos.z)
    end 
    return card
end 

--show player card type
m_PrivateFunc.ShowPlayerCardType = function(seat_id, hand_cards)
    local seat = m_SeatInfo[seat_id]
    if seat and hand_cards then 
        local niu_point,split_cards = m_PrivateFunc.SplitCards(hand_cards) 

        for k,v in ipairs(split_cards) do 
            seat.m_HandCards[k].img.sprite = m_PrivateFunc.GetCardAsset(v.color, v.point)
        end 

        local rule = mediator:GetGameRule()
        --check ex_niu_type 
        local ex_niu_type = nil
        if niu_point > 0 then
            if rule.enable_flush == true and nn.game_logic.is_flush(split_cards) == true then 
                ex_niu_type = nn.ENiuStyle.flush
            elseif rule.enable_five_small == true and nn.game_logic.is_five_small(split_cards) == true then 
                ex_niu_type = nn.ENiuStyle.five_small
            elseif rule.enable_bomb == true and nn.game_logic.is_bomb(split_cards) == true then 
                ex_niu_type = nn.ENiuStyle.bomb          
            elseif rule.enable_five_big == true and nn.game_logic.is_five_big(split_cards) == true then 
                ex_niu_type = nn.ENiuStyle.five_big
            elseif rule.enable_full_house == true and  nn.game_logic.is_full_house(split_cards) == true then 
                ex_niu_type = nn.ENiuStyle.full_house
            elseif rule.enable_suited == true and nn.game_logic.is_suited(split_cards) == true then 
                ex_niu_type = nn.ENiuStyle.suited
            elseif rule.enable_straight == true and nn.game_logic.is_straight(split_cards) == true then 
                ex_niu_type = nn.ENiuStyle.straight
            else 
                ex_niu_type = nn.ENiuStyle.niuniu
            end
        else 
            ex_niu_type = nn.ENiuStyle.none 
        end  
        m_PrivateFunc.UpdateNiuType(1,niu_point, ex_niu_type)  
    end 
end 

--update niu type image 
m_PrivateFunc.UpdateNiuType = function(seat_id, niu_point, ex_niu_type)
    local seat = m_SeatInfo[seat_id]
    if seat then 
        local str_path = ""
        if ex_niu_type == nn.ENiuStyle.none then 
            --无牛
            str_path = "" 
        elseif ex_niu_type == nn.ENiuStyle.niuniu then 
            str_path = string.format("%scommon/nn/nnhx_lbl_n%d.png",UI_IMAGE_PATH,niu_point)
        elseif ex_niu_type == nn.ENiuStyle.straight then 
            --顺子牛
            str_path = string.format("%scommon/nn/%s.png",UI_IMAGE_PATH,"nnhx_lbl_szn")
        elseif ex_niu_type == nn.ENiuStyle.suited then 
            --同花牛
            str_path = string.format("%scommon/nn/%s.png",UI_IMAGE_PATH,"nnhx_lbl_thn")
        elseif ex_niu_type == nn.ENiuStyle.full_house then 
            --葫芦牛
            str_path = string.format("%scommon/nn/%s.png",UI_IMAGE_PATH,"nnhx_lbl_hln")
        elseif ex_niu_type == nn.ENiuStyle.five_big then
            --五花牛
            str_path = string.format("%scommon/nn/%s.png",UI_IMAGE_PATH,"nnhx_lbl_whn")
        elseif ex_niu_type == nn.ENiuStyle.five_small then 
            --五小牛
            str_path = string.format("%scommon/nn/%s.png",UI_IMAGE_PATH,"nnhx_lbl_wxn")
        elseif ex_niu_type == nn.ENiuStyle.bomb then
            --犇牛
            str_path = string.format("%scommon/nn/%s.png",UI_IMAGE_PATH,"nnhx_lbl_nnn")
        elseif ex_niu_type == nn.ENiuStyle.flush then 
            --同花顺牛
            str_path = string.format("%scommon/nn/%s.png",UI_IMAGE_PATH,"nnhx_lbl_szn")
        end 

        local asset = m_LoadedNiuTypeAsset[str_path]
        if str_path ~= "" then 
            if asset == nil or asset:IsValid() == false then 
                GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_Sprite, str_path, function(tmp_asset) 
                    if tmp_asset and tmp_asset:IsValid() == true then 
                        seat.img_niutype.sprite = tmp_asset:GetAsset()
                        m_LoadedNiuTypeAsset[str_path] = tmp_asset
                    end 
                end)
            else 
                seat.img_niutype.sprite = asset:GetAsset()
            end 
        else
            seat.img_niutype.sprite = nil  
        end 
        seat.img_niutype.enabled = true
    end 
end 

--split cards.sorted
m_PrivateFunc.SplitCards = function(hand_cards)
    local tmp_result = {} 
    local t = {} 
    local tmp = {} 
    for k,v in ipairs(hand_cards) do 
        local s = {}
        s.color,s.point = nn.game_logic.parse_card(v)
        table.insert(tmp, s)
    end 
    local niu_point, results = nn.game_logic.splitNiuCards(tmp)
    
    local func_sort = function(left, right)
        if left.point ~= right.point then
            return left.point<right.point
        else
            return left.color<right.color
        end
    end 
    local tb_three = results[1]
    local tb_two = results[2]
    table.sort(tb_three, func_sort)
    table.sort(tb_two, func_sort)

    for _,tt in ipairs(tb_three) do 
        table.insert(tmp_result, tt)
    end 

    for _,tt in ipairs(tb_two) do 
        table.insert(tmp_result, tt)
    end 
    return niu_point, tmp_result
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
    
    m_PrivateFunc.LoadPokerImage() 

    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}
    m_RootPanel = transform:Find('Panel')
    m_cardsTemplate = m_RootPanel:Find("card_template").gameObject
    m_UselessCardParent = m_RootPanel:Find("card_tree")
    
    --register callback of buttons
    m_PrivateFunc.BindCallbacks()
    m_PrivateFunc.InitialSeat()
    m_PrivateFunc.InitialCommonPanel()
    m_PrivateFunc.InitialChatPanel()
    m_PrivateFunc.InitialSharePanel()
    m_PrivateFunc.InitialOptionPanel()
    m_PrivateFunc.InitialPrestartGamePanel()
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

    --GetLuaPing():RemoveText(m_CommonPanel.txt_netdelay)
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

    btn_invite = nil 
    btn_ready = nil 
    btn_showcard = nil 

    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.Kill(m_OpenAnimTween, true)
        m_OpenAnimTween = nil 
    end 
    m_RootPanel = nil 

    if m_LoadedNiuTypeAsset then 
        for k,v in pairs(m_LoadedNiuTypeAsset) do 
            if v then 
                v:Free()
            end 
            m_LoadedNiuTypeAsset[k] = nil 
        end 
        m_LoadedNiuTypeAsset = nil 
    end 

    if m_LoadedPokerAsset then 
        for k,v in ipairs(m_LoadedPokerAsset) do 
            if v then 
                for _k,_v in ipairs(v) do 
                    _v:Free()
                    v[_k] = nil 
                end 
            end 
            m_LoadedPokerAsset[k] = nil 
        end 
    end 
    m_LoadedPokerAsset = nil 

    windowAsset = nil   
    facade = nil
    CLOSE_SELF_PARAM = nil 
    CLOSE_CAN_RESTORE_PARAM = nil 
    if gameObject ~= nil then 
        UnityEngine.GameObject.Destroy(gameObject);
    end 
    gameObject = nil 
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
    m_CommonPanel.txt_remainround.text = string.format(luaTool:GetLocalize("remain_round"), curRound, maxRound)
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
                seat.img_ready.enabled = false 
                seat.img_bq.enabled = false 
                seat.img_qz.enabled = false 
                seat.txt_qz_num.text = ""
                seat.txt_result.text = ""
                seat.txt_multbei.text = ""
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
function tbclass:NtfPlayerReady(seat_id, bSendDoneCmd)
    local seat = m_SeatInfo[seat_id]
    if seat then 
        seat.img_ready.enabled = true 
    end 
    if bSendDoneCmd == true or bSendDoneCmd == nil then 
        facade:sendNotification(Common.EXECUTE_CMD_DONE)
    end 
end 

--ntf round over
function tbclass:NtfRoundOver()
    btn_showcard.gameObject:SetActive(false)
    facade:sendNotification(Common.EXECUTE_CMD_DONE)
end 

--ntf round start
function tbclass:NtfRoundStart()
    facade:sendNotification(Common.EXECUTE_CMD_DONE)
end 

--ntf play game
function tbclass:NtfPlayGame(game_state, start_mode, bSendDoneCmd)
    if m_Prestart then 
        m_Prestart.ShowPanel(game_state, start_mode)
    end 

    if m_SharePanel then 
        m_SharePanel.ShowPanel(game_state)
    end 
    if bSendDoneCmd == nil or  bSendDoneCmd == true then 
        facade:sendNotification(Common.EXECUTE_CMD_DONE)
    end 
end 

--ntf player open the cards
function tbclass:NtfPlayerOpenCards(seat_id, hand_cards)
    if hand_cards then 
        m_PrivateFunc.ShowPlayerCardType(seat_id, hand_cards)
    end 

    if mediator:IsSelfRealSeatId(seat_id) == true then 
        btn_showcard.gameObject:SetActive(false)
    end 
    facade:sendNotification(Common.EXECUTE_CMD_DONE)
end 

--fresh game rule panel
function tbclass:FreshGameRule(rule)
end 

--cleanup table
function tbclass:CleanupTable()
    for k,v in ipairs(m_SeatInfo) do 
        if v then 
            if v.gameObject.activeSelf == true then 
                v.Cleanup()
            end 
        end 
    end 
end 

--ntf begin shuffle
--@param card_info  player cards_info
function tbclass:NtfShuffle(card_info)
    if card_info then 
        local dealer =  card_info[1]
        local seat = m_SeatInfo[dealer.real_seat_id]
        if seat then 
            seat.img_dealer.enabled = true 
        end 
        local len = #card_info 
        local info = nil 
        local card = nil 
        local shuffle_cor = coroutine.create(function() 
            for i=1, 5 do
                for t=1, len do 
                    info = card_info[t]
                    if info.hand_cards then 
                        card = m_PrivateFunc.CreateNewCard(info.real_seat_id, info.hand_cards[i],false)
                    else 
                        card = m_PrivateFunc.CreateNewCard(info.real_seat_id, nil, false)
                    end 

                    UnityEngine.Yield(UnityEngine.WaitForSeconds(0.06))
                end  
            end 

            --should us sort card of self?
            facade:sendNotification(Common.EXECUTE_CMD_DONE)
        end)
        coroutine.resume(shuffle_cor)    
        btn_showcard.gameObject:SetActive(true)
    end 

end 

--recieved chat msg 
--@param  seat_id  msg sender
--@param  msg  content
function tbclass:NtfRecievedMsg(seat_id, msg)
end 
--restore game 
function tbclass:PlayerReconnected(info, seat_id, bShowReady, game_state, bNotShuffle)
    local bIsSelf = mediator:IsSelfRealSeatId(seat_id)
    local seat = m_SeatInfo[seat_id]
    if seat == nil then 
        return 
    end 

    if bShowReady then 
		seat.img_ready.enabled = true
	else
		seat.img_ready.enabled = false
    end
    
    local is_dealer = mediator:IsDealer(seat_id)
    seat.img_dealer.enabled = is_dealer

    if bNotShuffle == true then 
        return 
    end 

    if info.is_online == true then 
        --seat.img_offline.enabled = false 
    else 
       -- seat.img_offline.enabled = true 
    end 
    if info.hand_card_num and  info.hand_card_num > 0 then 
        count = info.hand_card_num
        for i=1, count do 
            if bIsSelf == true or info.hand_cards_state == nn.EHandCardState.open then 
                m_PrivateFunc.CreateNewCard(seat_id, info.hand_cards[i], true)
            else 
                m_PrivateFunc.CreateNewCard(seat_id, nil, true)
            end 
        end 
    end 

    --show other falg or active animation according to hand_card_state
    if info.hand_cards_state == nn.EHandCardState.open and info.hand_cards and info.hand_card_num > 0 then 
        --show niu type
        m_PrivateFunc.ShowPlayerCardType(seat_id, info.hand_cards)
    end 
end 

function tbclass:IsLoadingAsset()
    return m_bIsLoadingAsset
end 

--Don't remove all of them
return tbclass