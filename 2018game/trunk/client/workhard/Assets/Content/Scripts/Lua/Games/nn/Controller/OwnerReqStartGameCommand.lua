--[[
  * COMMAND:: OwnerReqStartGameCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local OwnerReqStartGameCommand = class('OwnerReqStartGameCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local game_proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

--constructor function. do not overwrite it
function OwnerReqStartGameCommand:ctor()
    self.executed = false
end

--coding function in here
function OwnerReqStartGameCommand:execute(note)
    --UnityEngine.Debug.Log('OwnerReqStartGameCommand')
    if game_proxy then 
        facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
        game_proxy:OwnerReqStartGame()
    end 
end

return OwnerReqStartGameCommand