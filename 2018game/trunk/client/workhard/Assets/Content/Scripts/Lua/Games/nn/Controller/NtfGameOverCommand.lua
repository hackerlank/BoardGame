--[[
  * COMMAND:: NtfGameOverCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local NtfGameOverCommand = class('NtfGameOverCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function NtfGameOverCommand:ctor()
    self.executed = false
end

--coding function in here
function NtfGameOverCommand:execute(note)
    --UnityEngine.Debug.Log('NtfGameOverCommand')

    local game_proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    local max_player = game_proxy:GetGamePlayers() 
    local m_GameOverMenuParam  = nil 
    if max_player == 3 then 
        m_GameOverMenuParam = ci.GetUiParameterBase().new(nn.GAME_OVER_3_MENU,EMenuType.EMT_Games,nil,false)
    else
        m_GameOverMenuParam = ci.GetUiParameterBase().new(nn.GAME_OVER_MENU,EMenuType.EMT_Games,nil,false)
    end 
    facade:sendNotification(Common.OPEN_UI_COMMAND, m_GameOverMenuParam)
end

return NtfGameOverCommand