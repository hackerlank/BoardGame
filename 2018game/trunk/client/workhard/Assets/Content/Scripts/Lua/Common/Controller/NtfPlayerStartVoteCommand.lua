--[[
  * COMMAND:: NtfPlayerStartVoteCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local NtfPlayerStartVoteCommand = class('NtfPlayerStartVoteCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function NtfPlayerStartVoteCommand:ctor()
    self.executed = false
end

--coding function in here
function NtfPlayerStartVoteCommand:execute(note)
    --UnityEngine.Debug.Log('NtfPlayerStartVoteCommand')
    local proxy_name = GetLuaGameManager().GetGameName() .. ".game_proxy"
    local proxy = facade:retrieveProxy(proxy_name)		 
    if  note.body.isSelf == true then 
        local VOTE_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_VOTE_RESULT, EMenuType.EMT_Common, nil , false)
        facade:sendNotification(Common.OPEN_UI_COMMAND, VOTE_MENU_PARAM)
    else 
        	--check self whether has vote? 
            if proxy:IsSelfVote() == true then 
                local VOTE_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_VOTE_RESULT, EMenuType.EMT_Common, nil , false)
                facade:sendNotification(Common.OPEN_UI_COMMAND, VOTE_MENU_PARAM)
			else 
                local starter_name = proxy:GetVoteStarterName()
                local VOTE_MENU_PARAM = ci.GetUiParameterBase().new(Common.MENU_VOTE, EMenuType.EMT_Common, nil , false, nil, starter_name)
                facade:sendNotification(Common.OPEN_UI_COMMAND, VOTE_MENU_PARAM)
            end 
    end
end

return NtfPlayerStartVoteCommand