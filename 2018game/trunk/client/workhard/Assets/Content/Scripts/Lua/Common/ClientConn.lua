--[[
 *class:: ClientConn
]]
local ClientConn = class('ClientConn')
local spx = nil

--Log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning


--reconnection time limit when application lost the focus
local LOST_CONNECTION_TIME_LIME = 120

--save the global helper instance
local socketHelper = nil

--self title
local NET_MANAGER_NAME = "ClientConn"

--save begin connecting to server time stamp
local m_fBeginConnectTime = 0.0

--server ip address
local m_serverAddress = ""

--server port number
local m_serverPort = 8080

--save:: bAutoRetry 
local m_bAutoRetry = false

--save the lost focus time
local m_fLostFocusTime = 0

--save server message id
local tb_ResponseCb = {}

--current net connection operation.
local connOperation = ENetConnOperation.Max

--the message has not been deal
local last = ""

local facade = nil 

local m_socketState = nil 

--socket state has changed event
local function onSocketStateChanged(iState)
    if iState == nil then 
        LogError("[ClientConn.onSocketStateChanged]:: the passed parameter is invalid")
        return
    end 
    connOperation = BindServerHelper:GetLinkServer()
    if connOperation == ENetConnOperation.ENCO_Max then 
        return
    end 

    
    local state = iState.currentState
    local desc = iState.desc
    m_socketState = state
    --print(desc .. " " .. tostring( connOperation) .. " address=" .. tostring(m_serverAddress))
    --LogError("[ClientConn.onSocketStateChanged]::state= " .. state .. " desc=" .. desc .. " " .. connOperation)
    if state == ESocketState.ESS_Disconnected then 
        facade:sendNotification(Common.DISCONNECT)
    else
        GetLuaGameManager():PostBindServer(state, connOperation, desc)
    end 

    connOperation = ENetConnOperation.Max
end

--Failed to send message event
local function onFailedSendMsg(iResult)
    if iResult == nil then 
        LogError("[ClientConn.onFailedSendMsg]:: the passed parameter is invalid")
        return
    end 

    local errorCode = iResult.errorCode
    local desc = iResult.reason

    LogError("[ClientConn.onFailedSendMsg]:: errorCode=" .. errorCode .. " reason=".. tostring(desc))
    if errorCode == -100 then 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        facade:sendNotification(Common.DISCONNECT)
    elseif errorCode == SocketError.WouldBlock or errorCode ==  SocketError.IOPending or
           errorCode == SocketError.NoBufferSpaceAvailable then 
        socketHelper:ThreadSleep(20)
    else
        socketHelper:Disconnect()
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        facade:sendNotification(Common.DISCONNECT)
    end 

end 

--Failed to receive message event
local function onFailedReceiveMsg(iResult)
    if iResult == nil then 
        LogError("[ClientConn.onFailedReceiveMsg]:: the passed parameter is invalid")
        return
    end 
    local errorCode = iResult.errorCode
    local desc = iResult.reason
    LogError("[ClientConn.onFailedSendMsg]:: errorCode=" .. errorCode .. " reason=".. tostring(desc))
    if errorCode == 1 then 
        --outof buffer size. ignore???
    elseif errorCode == SocketError.WouldBlock or errorCode ==  SocketError.IOPending or
           errorCode == SocketError.NoBufferSpaceAvailable then 
        socketHelper:ThreadSleep(10)
    else
        --socketHelper:Disconnect()
    end 
end 

--dispatch response
local function Dispatch(np)

    if tb_ResponseCb[np.service] ~= nil then 
        local cb = tb_ResponseCb[np.service]
        if type(cb) == "table" then 
            local f = cb[np.msg_id]
            if f then
                f(np.body)
            else 
                local proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
                facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
                LogError("dispatch error , unkonw msg_id=" .. tostring(np.msg_id) .. " service is="..proxy:ServiceName(np.service))
            end
        else
            cb(np.body)
        end 
    else 
        local proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        LogError("[ClientConn.Dispatch]:: there is not any callback functions with service " .. proxy:ServiceName(np.service))
    end 
end

--unpack message
local function ProcessMessage(text)
    if text == nil then 
        return
    end 

    local size = #text
    
	if size < 2 then
		return nil, text
	end

	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
end 

--receive message
local function ReceiveMessage(last)
    local result
	result, last = ProcessMessage(last)
	if result then
		return result, last
	end
	local msg = socketHelper:ReceiveMessage()
    
	if not msg then
		return nil, last
	end
    msg = Slua.ToString(msg)
    if msg ==  "" then 
        return nil, last
    end 
	return ProcessMessage(last .. msg)
end 

--Init client connection 
function ClientConn.Init()
    Log("Init client connection manager...")
    socketHelper = NetConnHelper.GInstance
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    --register to game manager
    GetLuaGameManager().RegisterManager(ClientConn, NET_MANAGER_NAME)

    --bind listener
    socketHelper.onSocketStateChanged:AddListener(onSocketStateChanged)
    socketHelper.onFailedSendMsg:AddListener(onFailedSendMsg)
    socketHelper.onFailedReceiveMsg:AddListener(onFailedReceiveMsg)
end 

--Connect to server
--@param iAddress string value, the server ip address
--@param iPort int value, the server port
--@param bAutoRetry boolean, whether we need retry unitl successfully connected to server
--@param fnDisconnCb the call back function when failed to connect to server
--@param fnCb the call back function when successfully bind with server
function ClientConn.Connect(iAddress, iPort, bAutoRetry, iConnOperation)
    if socketHelper == nil then 
        LogError("[ClientConn]:: ClientConn has not been inited.")
        return
    end 

    m_serverAddress = iAddress or ""
    m_serverPort = iPort or 8080
    m_bAutoRetry = bAutoRetry
    connOperation = iConnOperation

    local bSuccess = socketHelper:Connect(m_serverAddress, m_serverPort)

    if bSuccess == false then 
        LogError("[ClientConn]:: failed to connect to server")
    end 

    return bSuccess
end 

--disconnect current connection
function ClientConn.Disconnect()
    socketHelper:Disconnect()
end

--send message
function ClientConn.SendMessage(address, msg_id, body)
    if socketHelper == nil then 
        LogError("[ClientConn.SendMessage]:: socketHelper is nil")
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        return
    end 

    if socketHelper.isConnected == false then 
        LogError("[ClientConn.SendMessage]:: lost connection")
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        facade:sendNotification(Common.DISCONNECT)
        return
    end 

    if spx == nil then 
        spx = depends("Common.lualib.spx")
    end 
    local np = spx.encode_pack1(address, msg_id, body)
    
    local size = #np
	local msg = string.char(Luabit:LoadBits(size,8,15)) .. string.char(Luabit:LoadBits(size,0,7)) .. np

    msg = Slua.ToBytes(msg)
    socketHelper:DoSendMsg(msg)

end 

--register callbacks
function ClientConn.RegisterRspPack(iKey, iCallbacks)
    if iKey ~= nil then 
        if tb_ResponseCb[iKey] ~= nil  and iCallbacks ~= tb_ResponseCb[iKey] then 
            --do not overwrite login_service
            if iKey == 0 then 
                return 
            end 
            LogWarning("has registered table with key " .. iKey .. ". will force replace the old with new one")
            tb_ResponseCb[iKey] = iCallbacks
        end 
        if tb_ResponseCb[iKey] == nil then 
            tb_ResponseCb[iKey] = iCallbacks
        end 
    end 
end 

--unregister callbacks
function ClientConn.RemoveRspPack(iKey)
    if iKey ~= nil then 
        if tb_ResponseCb[iKey] ~= nil then 
            tb_ResponseCb[iKey] = nil
        end 
    end  
end 

--Update is called once per frame
function ClientConn.Update()
    if socketHelper == nil then 
        return
    end 

    if socketHelper.isConnected == false then 
        return
    end 

    local v
    v, last = ReceiveMessage(last)
    if nil ~= v then
        if spx == nil then 
            spx = depends("Common.lualib.spx")
        end 
        local result, np = spx.decode_pack(v)
        if np then 
            Dispatch(np)
        end
    end
end 



--this will be invoked when game has been killed
function ClientConn.OnDestroy()
    if socketHelper ~= nil then 
        socketHelper:SafeRelease()
    end 
end

local function GetIpAddress()
    local address= nil 
    local port = nil 
    if GetLuaGameManager().IsInGame() == true then 
        local proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
        if proxy then 
            local gate_Address = proxy:GetGateAddress()
            if gate_Address then 
                local result = luaTool:Split(gate_Address, ":")
                address = result[1]
                port = tonumber(result[2])
            end 
        end 
    elseif GetLuaGameManager().IsLoginScene() == true then 
        local address, port = luaTool:GetServerInfo()
        port = tonumber(port)
    end 

    return address, port
end 
--this will be called when application lost focus or focused again
--@todo maybe we need to deal this situation by passing a command. not in here
function ClientConn.OnApplicationFocus(bFocus)
    --should us use these address??--
    if GameHelper.isEditor == false then 
        local server_add, port = GetIpAddress()
        if bFocus == true then 
            if UnityEngine.Time.realtimeSinceStartup - m_fLostFocusTime > LOST_CONNECTION_TIME_LIME then                    
                LogWarning("lost focus reconnect, connection is out of date");
                facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
                facade:sendNotification(Common.DISCONNECT)
            elseif false == socketHelper.isConnected then            
                --如果Connected 为false 也断开然后自动重连，其余情况游戏游戏逻辑处理网络连接问题
                --@todo should us unregister all proxy, commands, mediator...etc
                LogWarning("lost focus reconnect, Connected = false ");
                facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
                facade:sendNotification(Common.DISCONNECT)  
            end                                 
        else 
            m_fLostFocusTime = UnityEngine.Time.realtimeSinceStartup
        end 
    end 
end 

return ClientConn 