-----------------------------------------------------------------------------
--LaunchGameMode:: 
-- the default map game mode
-----------------------------------------------------------------------------

local launchGameMode = class('LaunchGameMode', GameModeTemplate)

launchGameMode.bInited = false

--update menu name
local windowName = "UI_Update"

--update menu logic path
local logicPath = "Common.View." .. windowName

--update menu mediator path
local mediatorPath = "Common.Mediator." .. windowName .. "Mediator"

--update menu mediator name
local mediatorName = windowName .. "Mediator"

local LogError = UnityEngine.Debug.LogError

local window = nil 

local facade = nil 

function launchGameMode:ctor()
	self.super.ctor(self)
end 

function launchGameMode:Init()
	self.super.Init(self, DEFAULT_LUA_GAME_MODE)
	--start update game content
	self:PlayGame()

	--@TODO maybe we also need to show some items in this scene
	--send game manager has been inited notification
	facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	if facade ~= nil then 
		facade:sendNotification(Common.INITED_GAME_MANAGERS)
	end
end

function launchGameMode:EndGame()
    self.super.EndGame(self)
end 
return launchGameMode