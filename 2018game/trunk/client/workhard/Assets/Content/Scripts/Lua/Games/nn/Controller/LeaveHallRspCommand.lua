--[[
  * COMMAND:: LeaveHallRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local LeaveHallRspCommand = class('LeaveHallRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function LeaveHallRspCommand:ctor()
    self.executed = false
end

--coding function in here
function LeaveHallRspCommand:execute(note)
    local body = note.body
    if body == nil then
        UnityEngine.Debug.LogError("[LeaveHallRspCommand]:: the body is nil. will return")
        return
    end 

    local errorcode = body.errorcode
    local desc = body.desc 
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    if errorcode == EGameErrorCode.EGE_Success then 
        Log("left hall success")
        local gameManager = GetLuaGameManager()         
        if gameManager.IsLoginScene() == true then  
            facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)  
            facade:sendNotification(Common.GOTO_MAIN_SCENE) 
        elseif gameManager.IsMainScene() == true then 
        else 
            facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)   
        end 
    else 
        if desc ~= "您的帐号忙，请稍后重试"  then 
            facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
        end 
    end
    facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
end

return LeaveHallRspCommand