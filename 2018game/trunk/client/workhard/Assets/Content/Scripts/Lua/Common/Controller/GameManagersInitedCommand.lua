
--[[
  * COMMAND:: GameManagersInitedCommand. 
  *   edit helpful in here ......
  *
  *   with facade. like::
  *   facade:sendNotification(command-string ,note)
  *   Warning:: note can not be nil 
]]

local GameManagersInitedCommand = class('GameManagersInitedCommand', pm.SimpleCommand)

--constructor function. do not overwrite it
function GameManagersInitedCommand:ctor()
    self.executed = false
end

--coding function in here
function GameManagersInitedCommand:execute(note)
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    if facade then 
        --goto login scene
        UnityEngine.Debug.LogWarning("ready loading update scene " .. UnityEngine.Time.time)
        facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
        local levelInfo =  ci.GetLevelInfo().new(nil,nil) --luaTool:GetLevelInfo(0, 1, 1)
        levelInfo:SetValues('Update', 0, 1, 1, 'Common.UpdateGameMode')
        UnityEngine.Debug.LogWarning("created update level info " .. UnityEngine.Time.time)
        facade:sendNotification(Common.SWITCH_LEVEL_COMMAND,{level=levelInfo, restoreType = ERestoreType.EST_None })
    end
end

return GameManagersInitedCommand