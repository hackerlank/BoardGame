--[[
  * COMMAND:: LaunchThirdAppCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local LaunchThirdAppCommand = class('LaunchThirdAppCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function LaunchThirdAppCommand:ctor()
    self.executed = false
end

--coding function in here
function LaunchThirdAppCommand:execute(note)
    --UnityEngine.Debug.Log('LaunchThirdAppCommand')
    local platform = GameHelper.runtimePlatform 
    local bLaunched = false
    if platform == BuildPlatform.iOS then 
        bLaunched = LaunchAppHelper.LaunchApp("", "")
    elseif platform == BuildPlatform.Android then 
        local param = AndroidLaunch[tostring(note.body)]
        bLaunched = LaunchAppHelper.LaunchApp(param.package_name, param.launch_activity)
    else 
        LogError("not supported")
    end 

    if bLaunched == true then 
        facade:sendNotification(Common.LAUNCH_THIRD_APP_OK)
    end
        
end

return LaunchThirdAppCommand