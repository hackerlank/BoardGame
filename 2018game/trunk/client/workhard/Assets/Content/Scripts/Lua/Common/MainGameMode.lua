-----------------------------------------------------------------------------
--MainGameMode:: 
-- edit helper comment in here
-----------------------------------------------------------------------------

local MainGameMode = class('MainGameMode', GameModeTemplate)

--log function reference
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError


--whether game has been inited
MainGameMode.bInited = false

--constructor function
function MainGameMode:ctor()
	self.super.ctor(self)
end 

local function onMenuOpened()
    MainGameMode:PlayGame()
end 

--init function. please set the BGM
function MainGameMode:Init()
	self.super.Init(self, 'MainGameMode', EGameSound.EGS_MAX)

    --always render the first one 
    --@todo maybe we need to show all in the stack
    local cor = coroutine.create( function()
        MainGameMode:FadeIn(0)
        local param = UIManager.getInstance():PopUI()
        local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
        local bOpened = false
        if param then 
            if param:GetWindowName() == Common.MENU_MAIN then
                if UIManager.getInstance():HasOpened(Common.MENU_MAIN) == false then
                    param:SetCallBack(onMenuOpened)
                    facade:sendNotification(Common.OPEN_UI_COMMAND,param)
                    bOpened = true
                end 
            end
        end 
        UIManager.getInstance():RestoreAll()
        UnityEngine.Yield(UnityEngine.WaitForSeconds(0.06))
        UnityEngine.Yield(UnityEngine.WaitForEndOfFrame())
       
        if bOpened == false then 
            self:PlayGame()
        end 
         
    end)
    coroutine.resume(cor)

 
end

--start playing game
function MainGameMode:PlayGame()
    --write your code before call super function
    self.super.PlayGame()
end 

--Update is called once per frame
function MainGameMode:Update()
	self.super.Update(self)
end 

--FixedUpdate. This can be deleted
function MainGameMode:FixedUpdate()
	self.super.FixedUpdate(self)
end 

--end game
--@param endReason kill game reason
function MainGameMode:EndGame(endReason)
    self.super.EndGame(endReason)
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    facade:sendNotification(Common.EXIT_GAME_COMMAND)
end

--safe release assets and references.
function MainGameMode:OnLeaveLevel()
    self.super.OnLeaveLevel(self)

    self = nil
end 

return MainGameMode