--[[
 * This SystemEventManager implementation is a singleton, so you should not call the 
 * constructor directly, but instead call the static Factory method, 
 * passing the unique key for this instance to #getInstance. if not pass unique key, 
 * will use default key.
 *
]]
local sem = class('SystemEventManager')

sem.instanceMap = {}

--Log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError

local runtimePlatform = nil 

local Input = UnityEngine.Input

local EKeyCode = UnityEngine.KeyCode

function sem:ctor(key)
    self:Init()
end 

function sem.getInstance()

    local key = "SystemEventManager"
    if sem.instanceMap == nil then 
        sem.instanceMap = {}
    end 

    if sem.instanceMap[key] == nil then 
        sem.instanceMap[key] = sem.new(key)
    end 
    return sem.instanceMap[key]
end 

function sem:Init()
    Log("Init lua system event manager...")
    self.facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local luaGameManager = GetLuaGameManager()
	luaGameManager.RegisterManager(selflu, LUA_SYSTEM_EVENT_MANAGER)
    runtimePlatform = GameHelper.runtimePlatform
end 

function sem:Update()
    -- body
    if runtimePlatform == BuildPlatform.Android then 
        if Input.GetKeyUp(EKeyCode.Escape) == true then 
            --@todo 
        end
    elseif runtimePlatform == BuildPlatform.IOS then 
    end 
end

function sem:SafeRelease()
end 

return sem