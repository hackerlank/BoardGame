-----------------------------------------------------------------------------
--UpdateGameMode:: 
-- the update map game mode
-----------------------------------------------------------------------------

local updateGameMode = class('UpdateGameMode', GameModeTemplate)

updateGameMode.bInited = false

function updateGameMode:ctor()
	self.super.ctor(self)
end 

--update menu name
local windowName = "UI_Update"

--update menu logic path
local logicPath = "Common.View." .. windowName

--update menu mediator path
local mediatorPath = "Common.Mediator." .. windowName .. "Mediator"

--update menu mediator name
local mediatorName = windowName .. "Mediator"

local LogError = UnityEngine.Debug.LogError

function updateGameMode:Init()

	self.super.Init(self, "UpdateGameMode")
    self.facade = pm.Facade.getInstance(GAME_FACADE_NAME)
   -- local param = ci.GetUiParameterBase().new(Common.MENU_MSGBOX, EMenuType.EMT_Common, nil, true)
    --self.facade:sendNotification(Common.OPEN_UI_COMMAND,param)
    UnityEngine.Debug.LogWarning("end loading update scene " .. UnityEngine.Time.time)
	--start update game content
	self:PlayGame()
end

function updateGameMode:PlayGame()
    self.super.PlayGame()
    
    self:OpenUpdateMenu()
    
    if self.facade ~= nil then 
        self.facade:sendNotification(Common.START_UPDATE)
    else 
        LogError("[UpdateGameMode]:: mvc is not been inited")
    end
   
end 

function updateGameMode:OpenUpdateMenu()
    --open ui update 
    local window = UnityEngine.GameObject.Find(windowName)
    if window == nil then 
        LogError("[UpdateGameMode]:: missed UI_Update window in scene. will return")
        return
    end 

    local view = depends(logicPath)
    local mediator = depends(mediatorPath)
    if view == nil or mediator == nil then 
        LogError("[UpdateGameMode]:: missed lua script")
        return
    end 

    view:Opened(window.transform, windowName, nil)
    if self.facade ~= nil then 
        local viewMediator = mediator.new(mediatorName,view)
        self.facade:registerMediator(viewMediator)
        viewMediator:Opened(nil)
    else 
        LogError("[UpdateGameMode]:: mvc is not been inited")
    end 
end 

--Update is called once per frame
function updateGameMode:Update()
	self.super.Update(self)
end 

function updateGameMode:FixedUpdate()
	self.super.FixedUpdate(self)
end 

function updateGameMode:CloseUpdateMenu()
    local mediator = self.facade:retrieveMediator(mediatorName)
    mediator:OnClose()
    self.facade:removeMediator(mediatorName)
end 


function updateGameMode:EndGame()
    self:CloseUpdateMenu()
    self.super.EndGame(self)
    self.facade = nil
end 

return updateGameMode