--[[
  * COMMAND:: DisconnectCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local DisconnectCommand = class('DisconnectCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
local m_GameManager = GetLuaGameManager()

--constructor function. do not overwrite it
function DisconnectCommand:ctor()
    self.executed = false
end

local function onClickReConnect()
    if m_GameManager.IsLoginScene() == true then 
        local gameMode = m_GameManager.GetGameMode()
        if gameMode then 
            if gameMode.BindLoginServer then 
                gameMode:BindLoginServer()
            end 
        end 
    else 
        facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
    end 
end 

local function onClickExit()
    facade:sendNotification(Common.SHUT_DOWN_APP)
end 

--coding function in here
function DisconnectCommand:execute(note)
    --UnityEngine.Debug.Log('DisconnectCommand')  
    proxy:Disconnect()

    if m_GameManager.IsLoginScene() == true then 
        print("is login scene")
        local param = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil, 7, onClickReConnect, onClickExit)
        facade:sendNotification(Common.OPEN_UI_COMMAND, param)    
    else
        --bind gate server if not in login scene
        if m_GameManager.IsInGame() == true then 
            m_GameManager.GetGameMode():Disconnect()
        end 
        BindServerHelper:BindGateServer(true)
    end 
   
end

return DisconnectCommand