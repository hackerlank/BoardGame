--Command:: this command will be invokde after update game content 
--done
local SetGameTypeCommand = class('SetGameTypeCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError


function SetGameTypeCommand:ctor()
    self.executed = false
end

function SetGameTypeCommand:execute(note)

    if note.body == nil then 
        return
    end 

    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local gameManager = GetLuaGameManager()
    if nil == gameManager then 
       return
    end 

    --if gameType is not been changed, return
    local oldType = gameManager.GetGameType()
    if oldType == note.body then 
        return
    end 

    local command = nil 
    local t = nil 
    if oldType ~= EGameType.EGT_MAX and oldType ~= EGameType.EGT_Common then 
        --try to unregister extracommand
        command = gameManager.GetGameName() .. ".unregister_extra_commands"
        if facade:hasCommand(command) == true then 
            facade:sendNotification(command)
        else 
            t = {root_path.GAME_MVC_CONTROLLER_PATH, "UnregisterExtraCommand"}
            t = table.concat(t)
            local command = depends(t)
            if command ~= nil then 
                command:execute(nil)
            else 
                LogError("failed to load ungreister command " .. t )
            end 
           
        end 
    end 

    --update game type
    gameManager.SetGameType(note.body) 
    --[[if note.body ~= EGameType.EGT_MAX then
        --register extra command of game
        --t = {root_path.GAME_MVC_CONTROLLER_PATH, "RegisterExtraCommand"}
        command = depends(table.concat(t))
        if command ~= nil then 
            command:execute(nil)
        end 
    end ]]
end

return SetGameTypeCommand