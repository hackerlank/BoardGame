--Command:: this command will be invoked after resource mananger was 
-- successfully inited 
local SwitchLevelCommand = class('SwitchLevelCommand', pm.SimpleCommand)


function SwitchLevelCommand:ctor()
	self.executed = false
end


function SwitchLevelCommand:execute(note)
    if note.body == nil then 
        UnityEngine.Debug.LogError("Invalid parameters.. please provide a table as parameter that contains G D L")
        return 
    end
    --close all menu, before really switch map
    local level = note.body.level 
    local m_RestoreType = note.body.restoreType
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)--
    --if level.G > 0 or (level.G == 0 and level.L == 3) then
    local bShowLoading = note.body.bShowLoading or false 
    if bShowLoading == true then 
        facade:sendNotification(Common.OPEN_UI_COMMAND, ci.GetUiParameterBase().new(Common.MENU_LOADING, EMenuType.EMT_Common, nil,true, function()
             --if GameHelper.isWithBundle then 
                print("switch level with loading " .. m_RestoreType)
            UIManager.getInstance():CloseAll(m_RestoreType)
            --UnityEngine.Yield(UnityEngine.WaitForSeconds(0.1))
            if GetResourceManager().UnloadGameBundles ~= nil then 
                GetResourceManager().UnloadGameBundles(true)
            end
            print("switch level")
            -- end 
            GetLuaGameManager().SwitchLevel(level)
        end))
    else 
        print("switch level")
        --luaTool:Dump(level)
        UIManager.getInstance():CloseAll(m_RestoreType)
        GetLuaGameManager().SwitchLevel(level) 
    end
end

return SwitchLevelCommand