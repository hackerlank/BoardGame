--[[
  * COMMAND:: GetRecordDetailCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local GetRecordDetailCommand = class('GetRecordDetailCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local login_proxy = facade:retrieveProxy(Common.LOGIN_PROXY)

--constructor function. do not overwrite it
function GetRecordDetailCommand:ctor()
    self.executed = false
end

--coding function in here
function GetRecordDetailCommand:execute(note)
    UnityEngine.Debug.Log('GetRecordDetailCommand')
    local bFind = false 
    if note.body == nil or note.body.round_id == nil or note.body.round_id == 0 then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.invalidprameter")
    else
        facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
        local hall_service = note.body.service_id 
        local hall_type = login_proxy:GetHallType(hall_service)
        if hall_type ~= nil then 
            local games = luaTool:GetGamesInfos()
            for k,v in pairs(games) do 
                if v:GetHallType() == hall_type then 
                    local game_type = v:GetGameType()
                    facade:sendNotification(Common.SET_GAME_TYPE, game_type)
                    local game_name = GetLuaGameManager().GetGameName() 
                    local proxy_name = game_name .. ".game_proxy"
                    local game_proxy = facade:retrieveProxy(proxy_name)
                    if game_proxy == nil then 
                        local  t = {root_path.GAME_MVC_CONTROLLER_PATH, "RegisterExtraCommand"}
                        local command = depends(table.concat(t))
                        if command ~= nil then 
                            command:execute(nil)
                        end  
                        LuaTimer.Add(30,function(timer)
                            if timer then 
                                LuaTimer.Delete(timer)
                            end 
                            game_proxy = facade:retrieveProxy(proxy_name)
                            game_proxy:GetRecordDetail(note.body.record_id, note.body.round_id, note.body.rules)
                        end)
                        
                    else
                        game_proxy:GetRecordDetail(note.body.record_id, note.body.round_id)
                    end 
                    bFind = true 
                    break
                end 
            end 
        else 
            facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.misshall")
        end  
    end 

    if bFind == false then 
        facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
    end 
    
end

return GetRecordDetailCommand