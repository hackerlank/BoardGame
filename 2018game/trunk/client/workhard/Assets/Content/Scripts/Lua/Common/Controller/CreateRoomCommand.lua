--[[
  * COMMAND:: CreateRoomCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local CreateRoomCommand = class('CreateRoomCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function CreateRoomCommand:ctor()
    self.executed = false
end

--coding function in here
function CreateRoomCommand:execute(note)
    --UnityEngine.Debug.Log('CreateRoomCommand')
end

return CreateRoomCommand