--[[
  * COMMAND:: exit game command. 
]]
local ExitGameCommand = class('ExitGameCommand', pm.SimpleCommand)

local param_main = ci.GetUiParameterBase().new(Common.MENU_MAIN, EMenuType.EMT_Common)

function ExitGameCommand:ctor()
    self.executed = false
end

function ExitGameCommand:execute(note)
    local gameManager = GetLuaGameManager()

    if gameManager == nil then 
        UnityEngine.Debug.LogError("ExitGameCommand:: missing lua game manager")
        return
    end 
 
    --close all menu
    --UIManager.getInstance():CloseAll()


    --get menu that need to be opened
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local gameType = gameManager.GetGameType()
    local GameName = gameManager.GetGameName()

    local command = GameName .. ".unregister_extra_commands"
    facade:sendNotification(command)
    UIManager.getInstance():PushUI(param_main)
    gameManager.SetGameType(EGameType.EGT_MAX)
    --switch level

    local loginPorxy = facade:retrieveProxy(Common.LOGIN_PROXY)
    if loginPorxy:IsOnline() == true then 
        local levelInfo = luaTool:GetLevelInfo(0, 1, 3)
        facade:sendNotification(Common.SWITCH_LEVEL_COMMAND, {level=levelInfo, restoreType = ERestoreType.EST_None })
    else 
        local levelInfo =  luaTool:GetLevelInfo(0, 1, 2) 
        facade:sendNotification(Common.SWITCH_LEVEL_COMMAND,{level=levelInfo, restoreType = ERestoreType.EST_None })
    end 
end

return ExitGameCommand