--[[
  * COMMAND:: PreJoinGameRspCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local PreJoinGameRspCommand = class('PreJoinGameRspCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local login_proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
local timer = nil 

--constructor function. do not overwrite it
function PreJoinGameRspCommand:ctor()
    self.executed = false
end

--coding function in here
function PreJoinGameRspCommand:execute(note)
    --UnityEngine.Debug.Log('PreJoinGameRspCommand')
    local roomId = note.body.roomId 
    local hall_service_id = note.body.hall_service_id or 0 --房间号过期为0

    if hall_service_id == 0 then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.RoomIdOutOfData")
        facade:sendNotification(Common.NTF_JOIN_GAME_FAILED)
    else     
        local hall_type = login_proxy:GetHallType(hall_service_id)
        if hall_type == nil then 
            facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.NotFindHall")
        else 

            local game_type = nil 
                local games = luaTool:GetAllGamesInfos()
                if games then 
                    for k,v in ipairs(games) do 
                        if v then 
                            if v:GetHallType() == hall_type then 
                                game_type = v:GetGameType()
                                break
                            end 
                        end 
                    end 
                end 

                if game_type then 
                    facade:sendNotification(Common.SET_GAME_TYPE, game_type)
                    local  t = {root_path.GAME_MVC_CONTROLLER_PATH, "RegisterExtraCommand"}
                    local command = depends(table.concat(t))
                    if command ~= nil then 
                        command:execute(nil)
                        timer = LuaTimer.Add(200, function()
                            -- body
                            if timer then 
                                LuaTimer.Delete(timer)
                                timer = nil 
                            end 
                            command = GetLuaGameManager().GetGameName() .. ".player_enter_hall"
                            --facade send join game request
                            facade:sendNotification(command, {param=roomId, operation=EOperation.EO_JoinGame})
                        end)
                    else
                        LogError("Missed register_extra_command of game") 
                    end 
                else 
                    facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.InvalidRoomId")  
                end 
        end 
    end 
end

return PreJoinGameRspCommand