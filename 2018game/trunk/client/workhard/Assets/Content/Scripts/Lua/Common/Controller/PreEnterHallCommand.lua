--[[
  * COMMAND:: PreEnterHallCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local PreEnterHallCommand = class('PreEnterHallCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local timer = nil 

--constructor function. do not overwrite it
function PreEnterHallCommand:ctor()
    self.executed = false
end

--coding function in here
function PreEnterHallCommand:execute(note)
    UnityEngine.Debug.Log('PreEnterHallCommand')
    if note.body ~= nil then 
        local game_type = note.body.game_type 
        local game_rule = note.body.game_rule 
        local opt = note.body.operation 

        if game_type then 
            facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
            facade:sendNotification(Common.SET_GAME_TYPE, game_type)
            local  t = {root_path.GAME_MVC_CONTROLLER_PATH, "RegisterExtraCommand"}
            local command = depends(table.concat(t))
            if command ~= nil then 
                command:execute(nil)
            end 

            timer = LuaTimer.Add(200, function()
                if timer then 
                    LuaTimer.Delete(timer)
                end 
                command = GetLuaGameManager().GetGameName() .. ".player_enter_hall"
                facade:sendNotification(command, {param = game_rule, operation = opt })
            end)
        end 
    end 
end

return PreEnterHallCommand