--[[
  * COMMAND:: SendChatCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local SendChatCommand = class('SendChatCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function SendChatCommand:ctor()
    self.executed = false
end

--coding function in here
function SendChatCommand:execute(note)
    --UnityEngine.Debug.Log('SendChatCommand')
    local proxy_name = GetLuaGameManager().GetGameName().. ".game_proxy"
    local proxy = facade:retrieveProxy(proxy_name)
    if note.body == nil then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.invalidparameter")
        return 
    end 
    if proxy then 
        facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
        proxy:SendChat(note.body.type, note.body.msg)
    end 
end

return SendChatCommand