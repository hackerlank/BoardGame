--[[
  * COMMAND:: EnterHallCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local EnterHallCommand = class('EnterHallCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function EnterHallCommand:ctor()
    self.executed = false
end

--coding function in here
function EnterHallCommand:execute(note)
    UnityEngine.Debug.Log('EnterHallCommand')
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
   
    if note.body == nil then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.invalidparam")
    else 
        facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
        proxy:EnterHall(note.body)
    end 
end

return EnterHallCommand