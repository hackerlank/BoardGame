--[[
  * COMMAND:: VoteEndCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local VoteEndCommand = class('VoteEndCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function VoteEndCommand:ctor()
    self.executed = false
end

--coding function in here
function VoteEndCommand:execute(note)
    --UnityEngine.Debug.Log('VoteEndCommand')
    local cor = coroutine.create(function() 
        if UIManager.getInstance():HasOpened(Common.MENU_VOTE_RESULT) == true then 
            UnityEngine.Yield(UnityEngine.WaitForSeconds(1))
        end
        facade:sendNotification(Common.EXECUTE_CMD_DONE)
    end )
    coroutine.resume(cor)
end

return VoteEndCommand