--[[
  * COMMAND:: EnterHallRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local EnterHallRspCommand = class('EnterHallRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function EnterHallRspCommand:ctor()
    self.executed = false
end

--coding function in here
function EnterHallRspCommand:execute(note)
    UnityEngine.Debug.Log('EnterHallRspCommand')
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
 
    if note.body == nil then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.invalidparam")
        facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
    else 
        local errorcode = note.body.errorcode
        local desc = note.body.desc 
        local m_currentOperation = note.body.operation
        local param = note.body.param 
        if errorcode == EGameErrorCode.EGE_Success then 
            
            if m_currentOperation == EOperation.EO_CreateGame then 
                facade:sendNotification(nn.PLAYER_CREATE_GAME, param)
            elseif m_currentOperation == EOperation.EO_JoinGame then 
                facade:sendNotification(nn.PLAYER_JOIN_GAME, param)
            else 
                Log("EnterHallRspCommand m_currentOperation nil")
            end 
            proxy:ClearCacheParam()
        else 
            if m_currentOperation == EOperation.EO_JoinGame then  
                facade:sendNotification(Common.NTF_JOIN_GAME_FAILED)
            end 
            facade:sendNotification(Common.RENDER_MESSAGE_VALUE, desc)
            facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
        end 
    end 

    
end

return EnterHallRspCommand