-----------------------------------------------------------------------------
--GameMode:: 
-- edit helper comment in here
-----------------------------------------------------------------------------

local GameMode = class('GameMode', GameModeTemplate)

--log function reference
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = nil 

--whether game has been inited
GameMode.bInited = false

local m_mediator 
local m_mediator_name="Games.nn.Mediator.GameViewMediator"

--constructor function
function GameMode:ctor()
	self.super.ctor(self)
end 

local function LoadGameView()
	--print(" --------------------load  game  view ---------------------")
	--local tmp_mediator = depends(m_mediator_name)
	--local viewcomp = depends("Games.nn.View.GameView")
	--viewcomp:Init()
				 
    --m_mediator = tmp_mediator.new(m_mediator_name,viewcomp)
    --facade:registerMediator(m_mediator)	
    GameMode:FadeIn(0.03)
    GameMode:PlayGame()
    GameMode.bInited = true 
    facade:sendNotification(Common.EXECUTE_CMD_DONE)
end

--init function. please set the BGM
function GameMode:Init() 
	self.super.Init(self, 'GameMode', EGameSound.EGS_MAX)
    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	--start update game content
    --GetResourceManager().LoadBundles(GBC.GetGameBundles(EGameType.EGT_CDMaJiang), function() 
        --AudioManager.getInstance():PlayBGMusic(self.BACKGROUND_MUSIC)   
        
        local param = nil
        local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
        proxy:SetGameMode(self)
        if proxy:IsPlayRecord() == true then 
            param = ci.GetUiParameterBase().new(nn.GAME_PLAY_VIDEO_MENU, EMenuType.EMT_Games, nil, false, function() 
				LoadGameView()
			end)
        else 
            param = ci.GetUiParameterBase().new(nn.GAME_FIGHT_MENU, EMenuType.EMT_Games, nil, false, function()
                LoadGameView()
            end)
        end 
         
        facade:sendNotification(Common.OPEN_UI_COMMAND, param)
       
	--end)
	
end

--start playing game
function GameMode:PlayGame()
    --write your code before call super function
    self.super.PlayGame()

    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    if proxy:IsPlayRecord() == true then 
        facade:sendNotification(nn.START_PLAY_RECORD)
    end 
end 

--Update is called once per frame
function GameMode:Update()
	self.super.Update(self)
end 

--FixedUpdate. This can be deleted
function GameMode:FixedUpdate()
	self.super.FixedUpdate(self)
end 

--end game
--@param endReason kill game reason
function GameMode:EndGame(endReason)
    self.super.EndGame(endReason)
    m_bHasInited = false
    facade:sendNotification(Common.EXIT_GAME_COMMAND)
end

--safe release assets and references.
function GameMode:OnLeaveLevel()
    self.super.OnLeaveLevel(self)

    self = nil
	
	if m_mediator then 
		facade:removeMediator(m_mediator_name)
		m_mediator = nil
	end
end 

function GameMode:Disconnect()
    self:PauseGame()
end

function GameMode:Reconnected()
    facade:sendNotification(Common.PLAYER_RECONNECTED)
    self:ResumeGame()
    facade:sendNotification(Common.EXECUTE_CMD_DONE)
end



return GameMode