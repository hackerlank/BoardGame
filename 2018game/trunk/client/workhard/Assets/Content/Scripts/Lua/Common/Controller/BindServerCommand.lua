--[[
 * Command:: construct the net connection between client and server
]]
local BindServerCommand = class('BindServerCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError

function BindServerCommand:ctor()
	self.executed = false
end

function BindServerCommand:execute(note)
    --construct net connection both client and server
    if note.body == nil then 
        LogError("[BindServerCommand]:: invalid parameter. will return")
        return
    end 

    ClientConn.Disconnect()
    local serverAddress = note.body:GetAddress()
    local serverPort = note.body:GetPort()
    local bAutoRetry = note.body:IsAutoRetry()
    local operation = note.body:GetOperation()
    ClientConn.Connect(serverAddress, serverPort, bAutoRetry, operation)
end

return BindServerCommand