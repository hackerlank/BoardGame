--[[
  * COMMAND:: GotoMainSceneCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local GotoMainSceneCommand = class('GotoMainSceneCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function GotoMainSceneCommand:ctor()
    self.executed = false
end

--coding function in here
function GotoMainSceneCommand:execute(note)
    --UnityEngine.Debug.Log('GotoMainSceneCommand')
    local levelInfo =  luaTool:GetLevelInfo(0, 1, 3) 
    facade:sendNotification(Common.SWITCH_LEVEL_COMMAND,{level=levelInfo, restoreType = ERestoreType.EST_None, bShowLoading = false})
end

return GotoMainSceneCommand