--[[
  * COMMAND:: CreateGameCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local CreateGameCommand = class('CreateGameCommand', pm.SimpleCommand)

--constructor function. do not overwrite it
function CreateGameCommand:ctor()
    self.executed = false
end

--coding function in here
function CreateGameCommand:execute(note)
    UnityEngine.Debug.Log('CreateGameCommand')
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    
    if note.body == nil then 
        facade:sendNotification(Common.RENDER_MESSAGE_VALUE, "errorcode.invalidparam")
    else 
        if proxy:IsEnterHall() == true then 
	        proxy:CreateGame(note.body)
        else 
            facade:sendNotification(nn.PLAYER_ENTER_HALL, {operation=EOperation.EO_CreateGame, param = note.body})
        end 
    end 
end

return CreateGameCommand