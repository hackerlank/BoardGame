--[[
  * COMMAND:: PlayerWasKickedCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local PlayerWasKickedCommand = class('PlayerWasKickedCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local m_GameManager = GetLuaGameManager()

--constructor function. do not overwrite it
function PlayerWasKickedCommand:ctor()
    self.executed = false
end

local function onClickReConnect()
    --goto login scene
    if m_GameManager.IsLoginScene() == false then 
        facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
    end 
end 

local function onClickExit()
    facade:sendNotification(Common.SHUT_DOWN_APP)
end 

--coding function in here
function PlayerWasKickedCommand:execute(note)
    --UnityEngine.Debug.Log('PlayerWasKickedCommand')
    local param = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil, 13, onClickReConnect, onClickExit)
    facade:sendNotification(Common.OPEN_UI_COMMAND, param)   
end

return PlayerWasKickedCommand