--[[
  * COMMAND:: WeChatShareCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local WeChatShareCommand = class('WeChatShareCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function WeChatShareCommand:ctor()
    self.executed = false
end

--coding function in here
function WeChatShareCommand:execute(note)
    --UnityEngine.Debug.Log('WeChatShareCommand')
    if note.body == nil then 
        return 
    end 

    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
    local m_bIsLink = note.body.bIsLink 
    local m_scene = note.body.scene 
    local roomId = proxy:GetRoomId()
    local m_GameRule = proxy:GetGameRule()
    local m_sharetype = note.body.share_type
    local m_desc = ""

    if m_GameRule == nil then 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.missgamerule")
    else 
        local m_title = string.format("%s %s%s", UnityEngine.Application.productName, luaTool:GetLocalize("room_title"), tostring(roomId))

        local hall_service = proxy:GetHallService()
        local hall_type = facade:retrieveProxy(Common.LOGIN_PROXY):GetHallType(hall_service)

        local game_zone_name = ""
        for k,v in pairs(luaTool:GetAllGamesInfos()) do 
            if v then 
                if v:GetHallType() == hall_type then 
                    game_zone_name = v:GetGameName()
                    break
                end 
            end 
        end

        m_desc = string.format( " %s%d%s%s",game_zone_name,m_GameRule.max_player, luaTool:GetLocalize("person"), luaTool:GetLocalize("chang"))

        local s = ""
        if m_GameRule then 
            for k,v in pairs(m_GameRule) do 
                s = ""
                if k == "max_round" then 
                    s = v .. luaTool:GetLocalize("round")
                elseif k == "zi_mo_mode" then 
                    if v == 1 then
                        s = luaTool:GetLocalize("zi_mo_jia_di") 
                    elseif v == 2 then 
                        s = luaTool:GetLocalize("zi_mo_jia_fan")
                    end  
                elseif k == "pay_mode" then 
                    if v == ERoomCardPayMode.ERCY_Winner then 
                        s = luaTool:GetLocalize("winner_pay")
                    elseif v == ERoomCardPayMode.ERCY_Owner then 
                        s = luaTool:GetLocalize("room_owner_pay")
                    elseif v == ERoomCardPayMode.ERCY_AA then 
                        s = luaTool:GetLocalize("aa_pay")
                    end 
                elseif k == "max_fan" then 
                    if v == 0 then 
                        s = luaTool:GetLocalize("fan_none_limit")
                    else 
                        s = string.format(luaTool:GetLocalize("max_fan"), tostring(v))
                    end 
                elseif k == "piao_mode" then 
                    if v == nn.EPiaoType.none then 
                        s = luaTool:GetLocalize("piao_no")
                    elseif v == nn.EPiaoType.piao then 
                        s = luaTool:GetLocalize("piao")
                    elseif v == nn.EPiaoType.ding_xiang_piao then 
                        s = luaTool:GetLocalize("piao_ding")
                    elseif v == nn.EPiaoType.zhuang_piao then 
                        s = luaTool:GetLocalize("piao_zhuang")
                    end 
                elseif k == "enable_yi_pai_duo_yong" then 
                    if v == true then 
                        s = luaTool:GetLocalize("yi_pai_duo_yong")
                    end 
                elseif k == "bao_zi_mode" then 
                    if v == nn.EBaoZiMode.none then 
                        s = luaTool:GetLocalize("bao_zi_none")
                    elseif v == nn.EBaoZiMode.pair then 
                        s = luaTool:GetLocalize("bao_zi_pair")
                    elseif v == nn.EBaoZiMode.even then 
                        s = luaTool:GetLocalize("bao_zi_even")
                    end 
                elseif k == "enable_bao_jiao_du_zi_mo" then 
                    if v == true then 
                        s = luaTool:GetLocalize("bao_jiao_du_zi_mo")
                    end 
                end 
                if s ~= "" then 
                    m_desc = string.format("%s,%s", m_desc, s)
                end 
            end 
        end 

        local fast_join = string.format(luaTool:GetLocalize("fast_join"), game_zone_name)

        --ios or android 
        if GameHelper.runtimePlatform == BuildPlatform.IOS then 
            m_url = luaTool:GetLocalize("download_url")
        elseif GameHelper.runtimePlatform == BuildPlatform.Android then 
            --try to tap this link to go to game. for get more detail please see the soruce code of each platform. 
            --currently we just only support this both android and ios platform
            m_url = string.format("zhaduizi://com.unity3d.player.UnityPlayerActivity?Game=%s&roomId=%s&HallService=%s", GetLuaGameManager().GetGameType(), roomId, "")
        end 

        local m_ImagePath = ""
        local m_thumbImage = ""

        --type, title, description, url, imagePath, m_bIsLinkMsg)
        local m_shareParam = ci.GetWeChatShareParam().new(m_sharetype, m_scene, m_title,m_desc, m_url, m_ImagePath, m_thumbImage, m_bIsLink)
        facade:sendNotification(Common.WECHAT_SHARE, m_shareParam)
    end 
end

return WeChatShareCommand