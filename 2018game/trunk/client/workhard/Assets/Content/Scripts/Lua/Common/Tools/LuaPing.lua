local LuaPing = LuaPing or {} 

local COMPONENT_NAME = "lua_ping_manager"
--Log function reference
local Log = UnityEngine.Debug.Log 
--LogError function reference
local LogError = UnityEngine.Debug.LogError
--LogWarning function reference
local LogWarning = UnityEngine.Debug.LogWarning
--ping server
local m_ServerIp = ""
--send ping internal
local CONST_PING_INTERNAL = 1 * 1000
--ping timer
local m_SendPingTimer = nil 
--instanced object of ping
local m_ping = nil 
--ping delay
local m_DelayTime = 0

--reference of text controls
local tb_TextControl = nil 

local CONST_BEST_MAX = 50
local CONST_GOOD_MIN = 51
local CONST_GOOD_MAX = 100
local CONST_BAD_MIN = 101
--when net link is best, use this color
local NET_LINK_DELAY_COLOR_BEST = UnityEngine.Color(0,1,0,1)
--when net link is good, use this color
local NET_LINK_DELAY_COLOR_GOOD = UnityEngine.Color(255/255, 174/255, 0/255, 255/255)
--when net link is bad, use this color
local NET_LINK_DELAY_COLOR_BAD = UnityEngine.Color(1,0,0,1)

--==============private interface begin ==================
local function SendPing()
    m_ping = Ping(m_ServerIp)
end 

local function _Init()
    if tb_TextControl == nil then 
        tb_TextControl = {}
    end 
    if m_ping then 
        m_ping:DestroyPing()
        m_ping = nil 
    end 

    if m_SendPingTimer ~= nil then 
        LuaTimer.Delete(m_SendPingTimer)
        m_SendPingTimer = nil 
    end 

    --now create a new timer
    if m_ServerIp and m_ServerIp ~= "" then 
        m_SendPingTimer = LuaTimer.Add(0,CONST_PING_INTERNAL, function()
            SendPing()
        end)
    else 
        LogWarning("the server ip is nil or server ip is empty")
    end 
end 

local function UpdateDelayTime()
    local color = nil 
    if m_DelayTime <= CONST_BEST_MAX then 
        color = NET_LINK_DELAY_COLOR_BEST
    elseif m_DelayTime >= CONST_GOOD_MIN and m_DelayTime <= CONST_GOOD_MAX then 
        color = NET_LINK_DELAY_COLOR_GOOD 
    elseif m_DelayTime >= CONST_BAD_MIN then 
        color = NET_LINK_DELAY_COLOR_BAD
    end 

    local s = string.format( "%sms",tostring(m_DelayTime))
    for k,v in ipairs(tb_TextControl) do 
        if v then 
            v.text = s 
            v.color = color
        end 
    end 
end 
--==============private interface end ====================

function LuaPing.Init()
    Log("init LuaPing....")
    local luaGameManager = GetLuaGameManager()
	luaGameManager.RegisterManager(LuaPing, COMPONENT_NAME)
end

function LuaPing.RegisterText(m_text)
    if m_text and tb_TextControl then 
        local bExist = false
        for k,v in ipairs(tb_TextControl) do 
            if v == m_text then 
                bExist = true 
                break
            end 
        end 
        if bExist == false then 
            table.insert(tb_TextControl, m_text)
            UpdateDelayTime()
        end 
    end 
end 

function LuaPing.RemoveText(m_text)
    if m_text and tb_TextControl then 
        for k,v in ipairs(tb_TextControl) do 
            if v == m_text then 
                tb_TextControl[k] = nil 
                break
            end 
        end 
    end 
end 

function LuaPing.SetServerIp(server_ip)
    -- body
    m_ServerIp = server_ip
    _Init()
end

function LuaPing.Update()
    if m_ping then 
        if m_ping.isDone == true then 
            m_DelayTime = m_ping.time
            m_ping:DestroyPing()
            m_ping = nil 
            UpdateDelayTime()
        end 
    end 
end

function LuaPing.OnDestroy()
    if m_SendPingTimer ~= nil then 
        LuaTimer.Delete(m_SendPingTimer)
        m_SendPingTimer = nil 
    end 

    if m_ping then 
        m_ping:DestroyPing()
        m_ping = nil 
    end 

    if tb_TextControl then 
        for k,v in ipairs(tb_TextControl) do 
            if v == m_text then 
                tb_TextControl[k] = nil 
            end 
        end 
        tb_TextControl = nil 
    end 
end 
return LuaPing

