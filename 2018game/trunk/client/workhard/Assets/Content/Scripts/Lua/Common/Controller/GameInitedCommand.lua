--[[
  * COMMAND:: GameInitedCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local GameInitedCommand = class('GameInitedCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local param = ci.GetUICloseParam().new(false, Common.MENU_LOADING)

--constructor function. do not overwrite it
function GameInitedCommand:ctor()
    self.executed = false
end

--coding function in here
function GameInitedCommand:execute(note)
    --UnityEngine.Debug.Log('GameInitedCommand')
    if UIManager.getInstance():HasOpened(Common.MENU_LOADING) then 
        facade:sendNotification(Common.CLOSE_UI_COMMAND, param)
    end
end

return GameInitedCommand