--[[
* bind server helper class. 
*
]]
local bsh = bsh or {}

local facade = nil 

--disconnect tip id
local DISCONNECT_TIP_ID = 8

local ELoginState = {
    ELS_Game=0,
    ELS_Gate=1,
    ELS_Disconnect=2,
    ELS_Max=3,
}
local m_State = ELoginState.ELS_Max

local m_bIsGateServer = false

local m_LinkServer = ENetConnOperation.ENCO_LoginServer

--======================= private interface begin ===================
local function _BindLoginServer()
    m_LinkServer = ENetConnOperation.ENCO_LoginServer
    facade:sendNotification(Common.OPEN_UI_COMMAND, CONNECT_MENU_OPEN_PARAM)
    facade:sendNotification(Common.UPDATE_LOGIN_MENU, luaTool:GetLocalize("bind_server"))
	local address, port = luaTool:GetServerInfo()
	port = tonumber(port)
	local param = ci.GetBindServerParam().new(address, port, false, ENetConnOperation.ENCO_LoginServer)
	facade:sendNotification(Common.BIND_TO_SERVER, param)
end 

local function _BindGateServer(bReonline)
    m_LinkServer = ENetConnOperation.ENCO_GateServer
    if UIManager.getInstance():HasOpened(Common.MENU_CONNECT) == false then
        facade:sendNotification(Common.OPEN_UI_COMMAND, CONNECT_MENU_OPEN_PARAM)
    end
    if bReonline == true then 
        facade:sendNotification(Common.UPDATE_LOGIN_MENU, luaTool:GetLocalize("re_connect"))
    else
        facade:sendNotification(Common.UPDATE_LOGIN_MENU, luaTool:GetLocalize("user_login"))
    end 

    local proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
    local gate_Address = proxy:GetGateAddress()
    if gate_Address ~= nil and gate_Address ~= "" then 
        local result = luaTool:Split(gate_Address, ":")
        local param = ci.GetBindServerParam().new(result[1], tonumber(result[2]), false, ENetConnOperation.ENCO_GateServer)
        facade:sendNotification(Common.BIND_TO_SERVER,param)
    else 
        --login game.
        _BindLoginServer()
    end 
end 


local function onClickReConnect()
	if m_bIsGateServer == true then 
		
	else 
		_BindLoginServer()
	end 
end 

local function onClickExit()
	facade:sendNotification(Common.SHUT_DOWN_APP)
end 

--======================= private interface end =====================


function bsh:Init()
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
end

function bsh:BindLoginServer()
    _BindLoginServer()
end

function bsh:BindGateServer(bReonline)

    bReonline = bReonline or false
    _BindGateServer(bReonline)
end


function bsh:ShowBindGateServerFailMenu(errmsg)
	m_bIsGateServer = true 
	facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
	local param = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil , DISCONNECT_TIP_ID, onClickReConnect, onClickExit, errmsg)
	facade:sendNotification(Common.OPEN_UI_COMMAND, param)
end 

function bsh:ShowBindGameServerFailMenu(errmsg)
	m_bIsGateServer = false
	facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
	local param = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil , DISCONNECT_TIP_ID, onClickReConnect, onClickExit, errmsg)
	facade:sendNotification(Common.OPEN_UI_COMMAND, param)
end 

function bsh:GetLinkServer()
    return m_LinkServer
end
return bsh