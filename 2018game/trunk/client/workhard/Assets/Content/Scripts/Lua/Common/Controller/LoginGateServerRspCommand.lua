
--[[
  * COMMAND:: LoginGateServerRspCommand. 
  *   edit helpful in here ......
  *
  *   with facade. like::
  *   facade:sendNotification(command-string ,note)
  *   Warning:: note can not be nil 
]]

local LoginGateServerRspCommand = class('LoginGateServerRspCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError
local m_GameManager = GetLuaGameManager()
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function LoginGateServerRspCommand:ctor()
    self.executed = false
end

local function onClickReConnect()
    --goto login scene
    local cor = coroutine.create(function()
        if m_GameManager.IsLoginScene() == false then 
            facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
        end 
    end)
    coroutine.resume(cor)
end 

local function onClickExit()
    facade:sendNotification(Common.SHUT_DOWN_APP)
end 

--coding function in here
function LoginGateServerRspCommand:execute(note)
  if note.body == nil then 
        return 
    end 
    
    local proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
    if EGameErrorCode.EGE_Success == note.body.errorcode then 
        local gate_Address = proxy:GetGateAddress()
        if gate_Address then 
            local result = luaTool:Split(gate_Address, ":")
            address = result[1]
            GetLuaPing().SetServerIp(address)
        end 

        if proxy:HasJoinedGame() == true then 
            local cor = coroutine.create(function()
                local hall_type = proxy:GetHallType(proxy:GetJoinedHall())
                local games = luaTool:GetAllGamesInfos()
                local game_type = nil 
                local game_name = ""
                for k,v in pairs(games) do 
                    if v and v:GetHallType() == hall_type then 
                        game_type = v:GetGameType()
                        break;
                    end 
                end 

                if game_type ~= nil then  
                    facade:sendNotification(Common.SET_GAME_TYPE, game_type)
                    local  t = {root_path.GAME_MVC_CONTROLLER_PATH, "RegisterExtraCommand"}
                    local command = depends(table.concat(t))
                    if command ~= nil then 
                        command:execute(nil)
                    end  
                    UnityEngine.Yield(UnityEngine.WaitForSeconds(0.06))
                    game_name = m_GameManager.GetGameName()
                    command = game_name .. ".player_req_online"
                    facade:sendNotification(command)
                end 
            end)
            coroutine.resume(cor)
        else 
            if m_GameManager.IsLoginScene() == true then 
                facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
                facade:sendNotification(Common.GOTO_MAIN_SCENE)
            else 
                facade:sendNotification(Common.CLOSE_UI_COMMAND, CONNECT_MENU_CLOSE_PARAM)
            end 
        end
        facade:sendNotification(Common.UPLOAD_GPS_LOCATION)
    else 
        --the body is the failure login game reason
        --@todo should us reconnect to game server????
        local param = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil, 14, onClickReConnect, onClickExit)
        facade:sendNotification(Common.OPEN_UI_COMMAND, param) 
        --facade:sendNotification(Common.RENDER_MESSAGE_VALUE, note.body.desc)
    end 
    facade:sendNotification(Common.CLOSE_UI_COMMAND, OCCLUSION_MENU_CLOSE_PARAM)
end

return LoginGateServerRspCommand