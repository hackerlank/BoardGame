-----------------------------------------------------------------------------
--LaunchGameMode:: 
-- the default map game mode
-----------------------------------------------------------------------------

local LoginGameMode = class('LoginGameMode', GameModeTemplate)

LoginGameMode.bInited = false

--login menu name
local windowName = "UI_Login"

--login menu logic path
local logicPath = "Common.View." .. windowName

--login menu mediator path
local mediatorPath = "Common.Mediator." .. windowName .. "Mediator"

--login menu mediator name
local mediatorName = windowName .. "Mediator"

local LogError = UnityEngine.Debug.LogError

local m_bOpenedMenu = false

local m_bIsGateServer = false

local facade = nil 

function LoginGameMode:ctor()
	self.super.ctor(self)
end 

function LoginGameMode:Init()
	self.super.Init(self, "LoginGameMode", EGameSound.EGS_BG_General)
	facade = pm.Facade.getInstance(GAME_FACADE_NAME)	
	UIManager.getInstance():CloseAll(ERestoreType.EST_None)
	
	local loginProxy = facade:retrieveProxy(Common.LOGIN_PROXY)
	m_bOpenedMenu = false
	self:OpenLoginMenu()
	self:PlayGame()

	--bind to server
	local timer = LuaTimer.Add(200, function()
		BindServerHelper:BindLoginServer()
		if timer then 
			LuaTimer.Delete(timer)
			timer = nil 
		end 
	end)

end

function LoginGameMode:BindLoginServer()
	-- body
	BindServerHelper:BindLoginServer()
end

function LoginGameMode:PlayGame()
	self.super.PlayGame()
end 

function LoginGameMode:OpenLoginMenu()
	if m_bOpenedMenu == true then 
		return 
	end 
    --open ui update 
	m_bOpenedMenu = true 
    local window = UnityEngine.GameObject.Find(windowName)
    if window == nil then 
        LogError("[LoginGameMode]:: missed UI_Login window in scene. will return")
        return
    end 

    local view = depends(logicPath)
    local mediator = depends(mediatorPath)
    if view == nil or mediator == nil then 
        LogError("[LoginGameMode]:: missed lua script")
        return
    end 

    view:Opened(window.transform, windowName, nil)
    if facade ~= nil then 
        local viewMediator = mediator.new(mediatorName,view)
        facade:registerMediator(viewMediator)
        viewMediator:Opened(nil)
    else 
        LogError("[LoginGameMode]:: mvc is not been inited")
    end 
end 

function LoginGameMode:CloseLoginMenu()
    local mediator = facade:retrieveMediator(mediatorName)
	if mediator ~= nil then 
		mediator:OnClose()
		facade:removeMediator(mediatorName)
	end 
end 

--Update is called once per frame
function LoginGameMode:Update()
	self.super.Update(self)
end 

function LoginGameMode:FixedUpdate()
	self.super.FixedUpdate(self)
end 

function LoginGameMode:EndGame()
	self:CloseLoginMenu()
	local param_main = ci.GetUiParameterBase().new(Common.MENU_MAIN, EMenuType.EMT_Common)
	UIManager.getInstance():PushUI(param_main)
	facade = nil 
    self.super.EndGame(self)
end 

return LoginGameMode