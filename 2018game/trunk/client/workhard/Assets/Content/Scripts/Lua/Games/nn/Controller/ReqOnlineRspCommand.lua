--[[
  * COMMAND:: ReconnectedRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local ReqOnlineRspCommand = class('ReqOnlineRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function ReqOnlineRspCommand:ctor()
    self.executed = false
end

--coding function in here
function ReqOnlineRspCommand:execute(note)
    UnityEngine.Debug.Log('ReqOnlineRspCommand')
    local body = note.body
    if body == nil then
        UnityEngine.Debug.LogError("[LeaveHallRspCommand]:: the body is nil. will return")
        return
    end 

    local errorcode = body.errorcode
    local desc = body.desc 
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    if errorcode == EGameErrorCode.EGE_Success then 
        local GameManager = GetLuaGameManager() 
        if UIManager.getInstance():HasOpened(Common.MENU_CONNECT) == true then 
            facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
        end
        if GameManager.IsInGame() == false then 
            local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
            local gameType = GetLuaGameManager().GetGameType()
            local levelInfo = luaTool:GetLevelInfo(gameType, 1, 1) 
            facade:sendNotification(Common.SWITCH_LEVEL_COMMAND, {level=levelInfo, restoreType = ERestoreType.EST_Main, bShowLoading = false})
        else 
            GameManager.GetGameMode():Reconnected()
        end 
    else 
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
    end
    proxy:ClearCacheParam()
    facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
end

return ReqOnlineRspCommand