--[[
  * COMMAND:: PreLoginGameCommand. 
  *   edit helpful in here ......
  *
  *   with facade. like::
  *   facade:sendNotification(command-string ,note)
  *   Warning:: note can not be nil 
]]

local PreLoginGameServerCommand = class('PreLoginGameServerCommand', pm.SimpleCommand)

--constructor function. do not overwrite it
function PreLoginGameServerCommand:ctor()
    self.executed = false
end

--coding function in here
function PreLoginGameServerCommand:execute(note)
    --local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    --local param = ci.GetUiParameterBase().new(Common.MENU_LOGIN, EMenuType.EMT_Common, nil, false)
    --facade:sendNotification(Common.OPEN_UI_COMMAND,param)
    --GetLuaGameManager().GetGameMode():OpenLoginMenu()
end

return PreLoginGameServerCommand