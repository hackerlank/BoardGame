local LeaveGameCommand = class('LeaveGameCommand', pm.SimpleCommand)

local facade =  pm.Facade.getInstance(GAME_FACADE_NAME)
local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

local function onClickDismissBtn()
	facade:sendNotification(Common.OPEN_UI_COMMAND, OCCLUSION_MENU_OPEN_PARAM)
	--query table state first
	proxy:PullTableInfo(EOperation.EO_LeaveGame)
	--proxy:LeaveGame()
end 

local function onClickCancelBtn()

end 
local GAME_PLAYING_TIP_PARAM = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil , 11, onClickDismissBtn, onClickCancelBtn)
local GAME_IDLE_TIP_PARAM = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil , 10, onClickDismissBtn, onClickCancelBtn)
local GAME_IDLE_PLAYER_TIP_PARAM = ci.GetGeneralTipParameter().new(Common.MENU_GENERAL_TIP, EMenuType.EMT_Common, nil , 12, onClickDismissBtn, onClickCancelBtn)


function LeaveGameCommand:ctor()
	self.executed = false
end

function LeaveGameCommand:execute(note)
	local state = proxy:GetGameState()
	if state == nn.ETableState.idle then 
		if proxy:IsOwner() == true then 
			facade:sendNotification(Common.OPEN_UI_COMMAND, GAME_IDLE_TIP_PARAM)
		else 
			facade:sendNotification(Common.OPEN_UI_COMMAND, GAME_IDLE_PLAYER_TIP_PARAM)
		end 
	elseif state == nn.ETableState.game_over or state == nn.ETableState.dismissed then 
		onClickDismissBtn()
	else 
		local vote_stater, bIsSelf = proxy:IsInVote()
		if vote_stater > 0 then 
			facade:sendNotification(Common.NTF_PLAYER_START_VOTE, {isSelf = bIsSelf})
		else 
			facade:sendNotification(Common.OPEN_UI_COMMAND, GAME_PLAYING_TIP_PARAM)
		end 
	end
end

return LeaveGameCommand