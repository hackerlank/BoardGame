--[[
  * COMMAND:: RoundOverCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local RoundOverCommand = class('RoundOverCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function RoundOverCommand:ctor()
    self.executed = false
end

local function act_after_open ()
		local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	--facade:sendNotification(Common.OPEN_UI_COMMAND, m_RoundOverMenuParam)
end


--coding function in here
function RoundOverCommand:execute(note)
    --UnityEngine.Debug.Log('RoundOverCommand')
	

    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    
    local timer = nil 
    timer = LuaTimer.Add(1000,function()

        if proxy:IsPlayRecord()  then 
            local m_RoundOverMenuParam = ci.GetUiParameterBase().new(nn.GAME_RECORD_ROUND_OVER_MENU,EMenuType.EMT_Games,nil,false,nil,note.body)
            facade:sendNotification(Common.OPEN_UI_COMMAND, m_RoundOverMenuParam)		
        else
            local m_RoundOverMenuParam = ci.GetUiParameterBase().new(nn.GAME_ROUND_OVER_MENU,EMenuType.EMT_Games,nil,false,nil,note.body)
            facade:sendNotification(Common.OPEN_UI_COMMAND, m_RoundOverMenuParam)
        end	
        if timer then 
            LuaTimer.Delete(timer)
        end 
    end)
 
end

return RoundOverCommand