--[[
  * ui view class:: UI_SafeWarning
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
local MENU_OPEN_ANIM_TIME = 0.11
local CONST_PLAY_OPEN_ANIM_DELAY_TIME = 30


local rad = math.rad 
local sin = math.sin
local cos = math.cos
local abs = math.abs 

--ip warning page
local m_pages = nil 
local DEFAULT_IMG_COLOR =  UnityEngine.Color(1, 1, 1, 1)
local DEFINED_WARNING_COLOR_0 = UnityEngine.Color(0, 1, 0, 1)
local DEFINED_WARNING_COLOR_1 = UnityEngine.Color(253/255,  204/255, 0 , 255/255)
local DEFINED_WARNING_COLOR_2 = UnityEngine.Color(1,0,0,1)

local CONST_STRING_METER = luaTool:GetLocalize("meter")
local CONST_STRING_KILOMETER = luaTool:GetLocalize("kilometer")
local CONST_IP_SAME = luaTool:GetLocalize("ip_same")

--close self param
local CLOSE_SELF_PARAM = ci.GetUICloseParam().new(false, 'UI_SafeWarning') 

--============ callback of buttons begin ====================
--callback function of close button
local function onClickCloseBtn()
    if m_OpenAnimTween ~= nil then 
        DoTweenPathLuaUtil.DOPlayBackwards(m_RootPanel)
    else 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
    end 
end 

--callback function of leave btn
local function onClickLeaveBtn() 
    local command = GetLuaGameManager().GetGameName() .. ".player_leave_game"
    facade:sendNotification(command)
end 

--callabck function of ready button
local function onClickReadyBtn()
    local command = GetLuaGameManager().GetGameName() .. ".player_req_ready"
    facade:sendNotification(command)
end 
--============ callback of buttons end ======================

--================private interface begin =====================
--callback function of closeing animation has been completed
local function OnRewind()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, CLOSE_SELF_PARAM)
end 

--play the opening animation of menu
local function PlayOpenAmin()
    TransformLuaUtil.SetTransformLocalScale(m_RootPanel, 0, 0, 0)
    --play animation 
    --@todo you need to edit the animation style in here
    LuaTimer.Add(CONST_PLAY_OPEN_ANIM_DELAY_TIME,function(timer)
        LuaTimer.Delete(timer)
        m_OpenAnimTween = DoTweenPathLuaUtil.DoScale(m_RootPanel, 1, 1, 1, MENU_OPEN_ANIM_TIME)
        DoTweenPathLuaUtil.SetEaseTweener(m_OpenAnimTween, DG.Tweening.Ease.Linear)
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
        btn.onClick:AddListener(onClickLeaveBtn)
        table.insert(tb_btns, btn)
    end

    btn = m_RootPanel:Find("btns/btn_ready"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickReadyBtn)
        table.insert(tb_btns, btn)
    end 

    btn = m_RootPanel:Find("btns/btn_exit"):GetComponent("Button")
    if btn ~= nil then 
        btn.onClick:AddListener(onClickLeaveBtn)
        table.insert(tb_btns, btn)
    end 
end 

local function InitialPages()
    local root = m_RootPanel:Find("page")
    
    local trans = nil 
    m_pages = {}
    for i=2,4 do 
        trans = root:Find("page_" .. i)
        local page = {}
        page.gameObject = trans.gameObject
        page.users = {} 
        page.distane = {}

        for j=1,i do 
            table.insert(page.users, trans:Find("users/user_"..j .."/mask/head_img"):GetComponent("Image"))
        end 

        local line = nil 
        local count = i 
        if i == 2 then 
            count = i - 1
        end 
        for k=1, count do 
            local dis = {}
            line = trans:Find("lines/line"..k)
            dis.txt_dis = line:Find("txt_dis"):GetComponent("Text")
            dis.img_loc = line:GetComponent("Image")
            dis.txt_ip = line:Find("txt_ip"):GetComponent("Text")
            dis.img_line = line:Find("line"):GetComponent("Image")
           -- dis.txt_ipsame = line:Find("txt_ipsame"):GetComponent("Text")
            dis.txt_dis.text = ""
            --dis.txt_ipsame.text = ""
            dis.img_loc.color = DEFAULT_IMG_COLOR
            dis.img_line.color = DEFAULT_IMG_COLOR
            table.insert(page.distane, dis)
        end

        m_pages[i] = page
    end 
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
        LogError('[UI_SafeWarning.Init]:: missing transform')
        return
    end 
    
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    tb_btns = {}

    BindCallbacks()
    InitialPages()

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

local DEFINED_WARNING_DISTACE_LIMIT = 1
local EARTH_RADIUS = 6371393  --meter
--return km
local function CalculateDis(lat1, lng1, lat2, lng2)

    --print(lat1 .. " " .. lng1 .. "  " .. lat2 .. "  " .. lng2)

  
    local radLat1 = rad(lat1)
    local radLat2 = rad(lat2)
    local radLng1 = rad(lng1)
    local radLng2 = rad(lng2)

    if radLat1 < 0 then 
        radLat1 = math.pi / 2 + abs(radLat1) --south  
    end 
    if radLat1 > 0 then 
        radLat1 = math.pi / 2 - abs(radLat1) -- north  
    end 
    if radLng1 < 0 then 
        radLng1 = math.pi * 2 - abs(radLng1)-- west  
    end 
    if radLat2 < 0 then 
        radLat2 = math.pi / 2 + abs(radLat2) -- south  
    end 
    if radLat2 > 0 then 
        radLat2 = math.pi / 2 - abs(radLat2) -- north  
    end 
    if radLng2 < 0 then 
        radLng2 = math.pi * 2 - abs(radLng2) --west  
    end 

    local x1 = EARTH_RADIUS * cos(radLng1) * sin(radLat1);  
    local y1 = EARTH_RADIUS * sin(radLng1) * sin(radLat1);  
    local z1 = EARTH_RADIUS * cos(radLat1);  

    local x2 = EARTH_RADIUS * cos(radLng2) * sin(radLat2);  
    local y2 = EARTH_RADIUS * sin(radLng2) * sin(radLat2);  
    local z2 = EARTH_RADIUS * cos(radLat2);  

    local  d = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)+ (z1 - z2) * (z1 - z2)) 
    --余弦定理求夹角  
    local theta = math.acos((EARTH_RADIUS * EARTH_RADIUS + EARTH_RADIUS * EARTH_RADIUS - d * d) / (2 * EARTH_RADIUS * EARTH_RADIUS)) 
    local dis = theta * EARTH_RADIUS; 
    dis = dis / 1000
    return dis
end 
--4 persons
local function FreshPage3(locations)
    m_pages[2].gameObject:SetActive(false)
    m_pages[3].gameObject:SetActive(true)
    m_pages[4].gameObject:SetActive(false)

    local page = m_pages[3]
   
    for k,v in ipairs(locations) do 
        if v then 
            if v.head_icon and v.head_icon ~= "" then 
                GetHeadIconManager().LoadIcon(v.head_icon, function(sprite) 
                    if sprite ~= nil and sprite:IsValid() == true then 
                        page.users[k].enabled = true
                        page.users[k].sprite = sprite:GetAsset()
                    else 
                        page.users[k].enabled = false
                    end 
                end)
            else 
                page.users[k].enabled = false
            end 
        end 
    end 

    local dis_12 = CalculateDis(locations[1].latitude,  locations[1].longitude, locations[2].latitude,  locations[2].longitude) 
    local dis_23 = CalculateDis(locations[2].latitude,  locations[2].longitude, locations[3].latitude,  locations[3].longitude)  
    local dis_31 = CalculateDis(locations[1].latitude,  locations[1].longitude, locations[3].latitude,  locations[3].longitude)  
    
    if locations[1].ip_address == locations[2].ip_address then 
        page.distane[1].txt_ip.text = CONST_IP_SAME
        page.distane[1].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_12 = 0.05
    else 
        page.distane[1].txt_ip.text = ""
    end 

    if locations[2].ip_address == locations[3].ip_address then 
        page.distane[2].txt_ip.text = CONST_IP_SAME
        page.distane[2].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_23 = 0.05
    else 
        page.distane[2].txt_ip.text = ""
    end 

    if locations[3].ip_address == locations[1].ip_address then 
        page.distane[3].txt_ip.text = CONST_IP_SAME
        page.distane[3].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_31 = 0.05
    else 
        page.distane[3].txt_ip.text = ""
    end 

    if dis_12 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_12 = math.floor(dis_12 * 1000)
        if dis_12 < 100 then 
            page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[1].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[1].txt_dis.text =  "<100m"
        else 
            page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[1].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[1].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_12))
        end 
        
        
    else 
        dis_12 = math.floor(dis_12)
        page.distane[1].txt_dis.text = dis_12 .. CONST_STRING_KILOMETER
        page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[1].img_line.color = DEFINED_WARNING_COLOR_0
        page.distane[1].txt_dis.text =  ">1000m"
    end 

    if dis_23 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_23 = math.floor(dis_23 * 1000)
        if dis_23 < 100 then 
            page.distane[2].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[2].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[2].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[2].txt_dis.text =  "<100m"
        else 
            page.distane[2].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[2].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[2].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[2].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_23))
        end     
    else 
        dis_23 = math.floor(dis_23)
        page.distane[2].txt_dis.text = dis_23 .. CONST_STRING_KILOMETER
        page.distane[2].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[2].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[2].img_line.color = DEFINED_WARNING_COLOR_0
        page.distane[2].txt_dis.text =  ">1000m"
    end 

    if dis_31 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_31 = math.floor(dis_31 * 1000)
        page.distane[3].txt_dis.text = dis_31 .. CONST_STRING_METER
        if dis_31 < 100 then 
            page.distane[3].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[3].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[3].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[3].txt_dis.text =  "<100m"
        else 
            page.distane[3].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[3].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[3].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[3].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_31))
        end 

    else 
        dis_31 = math.floor(dis_31)
        page.distane[3].txt_dis.text = dis_31 .. CONST_STRING_KILOMETER
        page.distane[3].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[3].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[3].img_line.color = DEFINED_WARNING_COLOR_0
        page.distane[3].txt_dis.text =  ">1000m"
    end 

end 

--3 persons
local function FreshPage2(locations)
    m_pages[2].gameObject:SetActive(true)
    m_pages[3].gameObject:SetActive(false)
    m_pages[4].gameObject:SetActive(false)


    local page = m_pages[2]
   
    for k,v in ipairs(locations) do 
        if v then 
            if v.head_icon then 
                GetHeadIconManager().LoadIcon(v.head_icon, function(sprite) 
                    if sprite ~= nil and sprite:IsValid() == true then 
                        page.users[k].sprite = sprite:GetAsset()
                        page.users[k].enabled = true
                    else 
                        page.users[k].enabled = false
                    end 
                end)
            else 
                page.users[k].enabled = false
            end 
        end 
    end 

    local dis_12 = CalculateDis(locations[1].latitude,  locations[1].longitude, locations[2].latitude,  locations[2].longitude) 

    if locations[1].ip_address == locations[2].ip_address then 
        page.distane[1].txt_ip.text = CONST_IP_SAME
        page.distane[1].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_12 = 0.05
    else 
        page.distane[1].txt_ip.text = ""
    end 

    if dis_12 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_12 = math.floor(dis_12 * 1000)
        page.distane[1].txt_dis.text = dis_12 .. CONST_STRING_METER
        if dis_12 < 100 then 
            page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[1].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[1].txt_dis.text =  "<100m"    
        else 
            page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[1].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[1].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_12))
        end 
    else 
        dis_12 = math.floor(dis_12)
        page.distane[1].txt_dis.text = dis_12 .. CONST_STRING_KILOMETER
        page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[1].img_line.color = DEFINED_WARNING_COLOR_0
        page.distane[1].txt_dis.text =  ">1000m"
    end 

end 

--5 persons
local function FreshPage4(locations)
    m_pages[2].gameObject:SetActive(false)
    m_pages[3].gameObject:SetActive(false)
    m_pages[4].gameObject:SetActive(true)

    local page = m_pages[4]
   
    for k,v in ipairs(locations) do 
        if v then 
            if v.head_icon then 
                GetHeadIconManager().LoadIcon(v.head_icon, function(sprite) 
                    if sprite ~= nil and sprite:IsValid() == true then 
                        page.users[k].sprite = sprite:GetAsset()
                        page.users[k].enabled = true
                    else 
                        page.users[k].enabled = false
                    end 
                end)
            else 
                page.users[k].enabled = false
               -- page.users[k].sprite =  nil 
            end 
        end 
    end 

    local dis_12 = CalculateDis(locations[1].latitude,  locations[1].longitude, locations[2].latitude,  locations[2].longitude) 
    local dis_23 = CalculateDis(locations[2].latitude,  locations[2].longitude, locations[3].latitude,  locations[3].longitude)  
    local dis_34 = CalculateDis(locations[3].latitude,  locations[3].longitude, locations[4].latitude,  locations[4].longitude) 
    local dis_41 = CalculateDis(locations[1].latitude,  locations[1].longitude, locations[4].latitude,  locations[4].longitude)  

    if locations[1].ip_address == locations[2].ip_address then 
        page.distane[1].txt_ip.text = CONST_IP_SAME
        page.distane[1].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_12 = 0.05
    else 
        page.distane[1].txt_ip.text = ""
    end 

    if locations[2].ip_address == locations[3].ip_address then 
        page.distane[2].txt_ip.text = CONST_IP_SAME
        page.distane[2].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_23 = 0.05
    else 
        page.distane[2].txt_ip.text = ""
    end 

    if locations[3].ip_address == locations[4].ip_address then 
        page.distane[3].txt_ip.text = CONST_IP_SAME
        page.distane[3].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_34 = 0.05
    else 
        page.distane[3].txt_ip.text = ""
    end 

    if locations[4].ip_address == locations[1].ip_address then 
        page.distane[4].txt_ip.text = CONST_IP_SAME
        page.distane[4].txt_ip.color = DEFINED_WARNING_COLOR_2
        dis_41 = 0.05
    else 
        page.distane[4].txt_ip.text = ""
    end 

    if dis_12 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_12 = math.floor( dis_12 * 1000)
        if dis_12 < 100 then 
            page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[1].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[1].txt_dis.text =  "<100m"
        else 
            page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[1].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[1].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_12))
        end 
    else 
        dis_12 = math.floor(dis_12)
        page.distane[1].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[1].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[1].img_line.color = DEFINED_WARNING_COLOR_0
        page.distane[1].txt_dis.text =  ">1000m"
    end 

    if dis_23 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_23 = math.floor(dis_23 * 1000)
        if dis_23 < 100 then 
            page.distane[2].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[2].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[2].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[2].txt_dis.text =  "<100m"
        else 
            page.distane[2].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[2].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[2].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[2].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_23))
        end 
    else 
        dis_23 = math.floor(dis_23)
        page.distane[2].txt_dis.text =  ">1000m"
        page.distane[2].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[2].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[2].img_line.color = DEFINED_WARNING_COLOR_0
    end 

    if dis_34 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_34 = math.floor(dis_34 * 1000)
        if dis_34 < 100 then 
            page.distane[3].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[3].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[3].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[3].txt_dis.text =  "<100m"
        else 
            page.distane[3].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[3].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[3].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[3].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_34))
        end 
    else 
        dis_34 = math.floor(dis_34)
        page.distane[3].txt_dis.text =  ">1000m"
        page.distane[3].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[3].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[3].img_line.color = DEFINED_WARNING_COLOR_0
    end 

    if dis_41 < DEFINED_WARNING_DISTACE_LIMIT then 
        dis_41 = math.floor(dis_41 * 1000)
        if dis_41 < 100 then 
            page.distane[4].txt_dis.color = DEFINED_WARNING_COLOR_2
            page.distane[4].img_loc.color = DEFINED_WARNING_COLOR_2
            page.distane[4].img_line.color = DEFINED_WARNING_COLOR_2
            page.distane[4].txt_dis.text =  "<100m"
        else
            page.distane[4].txt_dis.color = DEFINED_WARNING_COLOR_1
            page.distane[4].img_loc.color = DEFINED_WARNING_COLOR_1
            page.distane[4].img_line.color = DEFINED_WARNING_COLOR_1
            page.distane[4].txt_dis.text =  string.format("100m<%s<1000m",tostring(dis_41))
        end 
    else 
        dis_41 = math.floor(dis_41)
        page.distane[4].txt_dis.text =  ">1000m"
        page.distane[4].txt_dis.color = DEFINED_WARNING_COLOR_0
        page.distane[4].img_loc.color = DEFINED_WARNING_COLOR_0
        page.distane[4].img_line.color = DEFINED_WARNING_COLOR_0
    end 
end 

function tbclass:FreshWindow(locations)
    if locations == nil then 
        LogError("invalid locations")
    end 

    local len = #locations
    if len == 2 then 
        FreshPage2(locations)
    elseif len == 3 then 
        FreshPage3(locations)
    elseif len == 4 then 
        FreshPage4(locations)
    else 
        --LogError("not supported " .. len )
    end 

end 

function tbclass:NtfCloseSelf()
    onClickCloseBtn()
end 

--Don't remove all of them
return tbclass