--Command:: this command will be invokde after update game content 
--done
local StartUpdateCommand = class('StartUpdateCommand', pm.SimpleCommand)

function StartUpdateCommand:ctor()
    self.executed = false
end

function StartUpdateCommand:execute(note)
	UnityEngine.Debug.Log("start update ...")
    local updateManager = GetUpdateManager()
    if updateManager ~= nil then 
        GetUpdateManager().StartUpdate()
    else 
        UnityEngine.Debug.LogError("Can not get update manager instance object. game will be stucked")
    end
end

return StartUpdateCommand