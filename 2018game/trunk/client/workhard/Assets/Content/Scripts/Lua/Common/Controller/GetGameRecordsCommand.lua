--[[
  * COMMAND:: GetGameRecordsCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local GetGameRecordsCommand = class('GetGameRecordsCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local login_proxy = facade:retrieveProxy(Common.LOGIN_PROXY)

--constructor function. do not overwrite it
function GetGameRecordsCommand:ctor()
    self.executed = false
end

--coding function in here
function GetGameRecordsCommand:execute(note)
    --UnityEngine.Debug.Log('GetGameRecordsCommand')
    local hall_list = login_proxy:GetHallList()

    if hall_list ~= nil then 
        for k,v in ipairs(hall_list) do 
            print(v.hall_service)
            login_proxy:QueryGameRecords(v.hall_service)
        end 
    end 
end

return GetGameRecordsCommand