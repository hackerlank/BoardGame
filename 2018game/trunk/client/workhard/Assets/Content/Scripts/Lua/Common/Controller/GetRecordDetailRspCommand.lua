--[[
  * COMMAND:: GetRecordDetailRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local GetRecordDetailRspCommand = class('GetRecordDetailRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function GetRecordDetailRspCommand:ctor()
    self.executed = false
end

--coding function in here
function GetRecordDetailRspCommand:execute(note)
    --UnityEngine.Debug.Log('GetRecordDetailRspCommand')
    local errorcode = note.body.errorcode
    if errorcode == EGameErrorCode.EGE_Success then 
        --try to switch level
        --
        local login_proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
        local user_id = login_proxy:GetUserId()
        local game_proxy = facade:retrieveProxy(GetLuaGameManager().GetGameName()..".game_proxy")
        game_proxy:ParseRecordData(user_id)
        local gameType = GetLuaGameManager().GetGameType()
        local levelInfo = luaTool:GetLevelInfo(gameType, 1, 1) 
        facade:sendNotification(Common.SWITCH_LEVEL_COMMAND, {level=levelInfo, restoreType = ERestoreType.EST_AllOpened })
    else 
        facade:sendNotification(Common.SET_GAME_TYPE, EGameType.EGT_MAX)
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.NotFindRecordDetail")
    end 

    facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
end

return GetRecordDetailRspCommand