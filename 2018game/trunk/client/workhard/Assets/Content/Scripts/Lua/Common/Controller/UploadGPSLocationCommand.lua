--[[
  * COMMAND:: UploadGPSLocationCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local UploadGPSLocationCommand = class('UploadGPSLocationCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local MAX_WAIT_TIME = 20

--constructor function. do not overwrite it
function UploadGPSLocationCommand:ctor()
    self.executed = false
end

--coding function in here
function UploadGPSLocationCommand:execute(note)
    --UnityEngine.Debug.Log('UploadGPSLocationCommand')
    local m_instance = UnityEngine.Input.location
   -- return
 
    MAX_WAIT_TIME = 20 
    local lat =  0
    local lng = 0
    if GameHelper.isEditor == false then 
        m_instance:Start(1,1)
        local cor =  coroutine.create(function() 
            
            while m_instance.status == UnityEngine.LocationServiceStatus.Initializing and MAX_WAIT_TIME > 0 do 
                UnityEngine.Yield(UnityEngine.WaitForSeconds(1))
                MAX_WAIT_TIME = MAX_WAIT_TIME - 1
            end 

            if MAX_WAIT_TIME <= 0 then 
                LogError("start location service time out")
            else 
                if m_instance.status == UnityEngine.LocationServiceStatus.Failed then 
                    LogError("User denied access to device location")
                else 
                    local location = m_instance.lastData
                    lat = location.latitude
                    lng = location.longitude
                end 
            end 
            
            local login_proxy = facade:retrieveProxy(Common.LOGIN_PROXY)
            login_proxy:UploadGPS(tostring(lat), tostring(lng))
            LogWarning("uploaded gps position latitude=" .. lat .. " longitude=" .. lng)
            m_instance:Stop()


        end)
        coroutine.resume(cor)
    else 
        local login_proxy = pm.Facade.getInstance(GAME_FACADE_NAME):retrieveProxy(Common.LOGIN_PROXY)
        login_proxy:UploadGPS(tostring(lat), tostring(lng))
        LogWarning("not support editor mode")
    end  

    --should us use the third sdk????
    local worldLocationCor = coroutine.create(function() 
        lat = 30.57265663147 
        lng = 104.06225585938
        local s = "http://apis.map.qq.com/jsapi?qt=rgeoc&lnglat=%s%s%s"
        s = string.format(s, tostring(lng), "%2C", tostring(lat))
        Log(s)
        local worldLocWWW = UnityEngine.WWW(s);
        UnityEngine.Yield(worldLocWWW)

        local t = UnityEngine.Time.time 
        while worldLocWWW.isDone == false do 
            if UnityEngine.Time.time - t >= 15 then 
                worldLocWWW:Dispose()
                break
            end 
        end 

        local string_json = worldLocWWW.text 
     

        local m_worldLoc = JsonTool.Decode(string_json)

        if m_worldLoc.info ~= nil then 
            if m_worldLoc.info.error == 0 then 
                if m_worldLoc.detail ~= nil then 
                    local info = m_worldLoc.detail.poilist[1]

                    LogError("your location:: " .. info.addr_info.p .. info.addr_info.c .. info.addr_info.d)
                end 
            else 
                facade:sendNotification(Common.RENDER_MESSAGE_VALUE, "Failed to get world location information " .. m_worldLoc.info.error)
                LogError("Failed to get world location information " .. m_worldLoc.info.error)
            end 
        end
        --10-11 12:36:01.789: W/Unity(2495): uploaded gps position latitude=30.57265663147 longitude=104.06225585938

    end)
    coroutine.resume(worldLocationCor)
end

return UploadGPSLocationCommand