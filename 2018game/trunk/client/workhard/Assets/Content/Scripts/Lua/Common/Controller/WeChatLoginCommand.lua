--[[
  * COMMAND:: WeChatLoginCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local WeChatLoginCommand = class('WeChatLoginCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--constructor function. do not overwrite it
function WeChatLoginCommand:ctor()
    self.executed = false
end

--coding function in here
function WeChatLoginCommand:execute(note)
    if WeChatSDK.IsWeChatInstalled() == true then 
        --user product name as the auth state. parhaps we need rand a  auth state 
        facade:sendNotification(Common.OPEN_UI_COMMANDM, OCCLUSION_MENU_OPEN_PARAM)
        WeChatSDK.AuthWeChat(UnityEngine.Application.productName)
    else 
        --show a message to player
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.notinstalled")
    end
end

return WeChatLoginCommand