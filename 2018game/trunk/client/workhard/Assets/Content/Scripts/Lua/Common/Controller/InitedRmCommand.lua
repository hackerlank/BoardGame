--Command:: this command will be invoked after resource mananger was 
-- successfully inited 
local InitedRmCommand = class('InitedRmCommand', pm.SimpleCommand)


function InitedRmCommand:ctor()
	self.executed = false
end

function InitedRmCommand:execute(note)

    depends('Common.ProtocolManager')
    local commonExtraCommand = depends('Common.Controller.RegisterExtraCommand')
	local executeCmd = commonExtraCommand.new()
	executeCmd:execute(nil)


    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    --initial the third sdk manager
    ThirdSdkManager.Init()

    --load common bundle of games
    GetResourceManager().LoadBundles(GBC.GetGameBundles(EGameType.EGT_Common), function() 

	end)
    
    --open msg box 
    if UIManager.getInstance():HasOpened(Common.MENU_MSGBOX) == false then
        local param = ci.GetUiParameterBase().new(Common.MENU_MSGBOX, EMenuType.EMT_Common, nil, true)
        facade:sendNotification(Common.OPEN_UI_COMMAND,param)
    end 

    if GameHelper.isDistribution == false then 
        if UIManager.getInstance():HasOpened(Common.MENU_LOG) == false then 
            local param = ci.GetUiParameterBase().new(Common.MENU_LOG, EMenuType.EMT_Common, nil, true)
            facade:sendNotification(Common.OPEN_UI_COMMAND,param)
        end 
    end 

    --load emoji asset
    luaTool:LoadEmojiSprite(nil,false)
   -- luaTool:LoadEmojiSprite(nil,true)

    luaTool:GetUiAnimation()
    --build global menu param
    if _G.OCCLUSION_MENU_OPEN_PARAM == nil then 
		_G.OCCLUSION_MENU_OPEN_PARAM = ci.GetUiParameterBase().new(Common.MENU_OCCLUSION, EMenuType.EMT_Common,nil,true)
        _G.OCCLUSION_MENU_CLOSE_PARAM = ci.GetUICloseParam().new(true, Common.MENU_OCCLUSION)
        _G.CONNECT_MENU_OPEN_PARAM = ci.GetUiParameterBase().new(Common.MENU_CONNECT, EMenuType.EMT_Common,nil,true)
        _G.CONNECT_MENU_CLOSE_PARAM = ci.GetUICloseParam().new(true, Common.MENU_CONNECT)
	end 

    local cor = coroutine.create(function()
        UnityEngine.Yield(UnityEngine.WaitForSeconds(0.2)) 
        _G.ELoginType = depends("network.types.login_type")
        _G.EChatType = depends("network.types.chat_type")
        _G.EVoteType = depends("network.types.vote_ack")
        _G.BindServerHelper = depends("Common.BindServerHelper")
        BindServerHelper:Init()
        facade:sendNotification(Common.END_GAME_COMMAND, Reason.SUCCESS)
        local levelInfo =  luaTool:GetLevelInfo(0, 1, 2) 
        facade:sendNotification(Common.SWITCH_LEVEL_COMMAND,{level=levelInfo, restoreType = ERestoreType.EST_None })
    end)
    coroutine.resume(cor)
   
end

return InitedRmCommand