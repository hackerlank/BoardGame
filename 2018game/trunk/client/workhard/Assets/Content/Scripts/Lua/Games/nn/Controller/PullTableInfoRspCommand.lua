--[[
  * COMMAND:: PullTableInfoRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local PullTableInfoRspCommand = class('PullTableInfoRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function PullTableInfoRspCommand:ctor()
    self.executed = false
end

--coding function in here
function PullTableInfoRspCommand:execute(note)
    --UnityEngine.Debug.Log('PullTableInfoRspCommand')
    local body = note.body
    if body == nil then
        UnityEngine.Debug.LogError("[LeaveHallRspCommand]:: the body is nil. will return")
        return
    end 

    local errorcode = body.errorcode
    local desc = body.desc 
    local operation = body.operation
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    if errorcode == EGameErrorCode.EGE_Success then 
        if operation == EOperation.EO_ReqOnline then         
            facade:sendNotification(nn.PLAYER_REQ_ONLINE)
        elseif operation == EOperation.EO_LeaveGame then 
            proxy:LeaveGame()
        end 
        proxy:ClearCacheParam()
    else 
        if errorcode == EGameErrorCode.EGE_TableDismissed then 
            if operation == EOperation.EO_ReqOnline or operation == EOperation.EO_LeaveGame  then 
                facade:sendNotification(nn.PLAYER_LEAVE_HALL)
                proxy:ClearCacheParam()
            end 
        else 
            facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
            facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        end 
    end
end

return PullTableInfoRspCommand