--[[
  * COMMAND:: DuplicateRoomIdCommand. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local DuplicateRoomIdCommand = class('DuplicateRoomIdCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
local MENU_DUPLICATE_PARAM = ci.GetUiParameterBase().new(Common.MENU_DUPLICATE_OK, EMenuType.EMT_Common, nil, false)

--constructor function. do not overwrite it
function DuplicateRoomIdCommand:ctor()
    self.executed = false
end

--coding function in here
function DuplicateRoomIdCommand:execute(note)
    --UnityEngine.Debug.Log('DuplicateRoomIdCommand')
    local platform = GameHelper.runtimePlatform
    if platform == BuildPlatform.Android or platform == BuildPlatform.iOS then 
        
        local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

        local str_roomId = tostring(proxy:GetRoomId())

        local title = luaTool:GetLocalize("room_title") .. str_roomId

        local hall_service = proxy:GetHallService()
        local hall_type = facade:retrieveProxy(Common.LOGIN_PROXY):GetHallType(hall_service)
        local m_desc = ""
        local game_zone_name = ""
        for k,v in pairs(luaTool:GetAllGamesInfos()) do 
            if v then 
                if v:GetHallType() == hall_type then 
                    game_zone_name = v:GetGameName()
                    break
                end 
            end 
        end 
    
        local m_GameRule = proxy:GetGameRule()

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
                    if v == 1 then 
                        s = luaTool:GetLocalize("winner_pay")
                    elseif v == 2 then 
                        s = luaTool:GetLocalize("room_owner_pay")
                    elseif v == 3 then 
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
                    m_desc = string.format("%s,%s", m_desc,s)
                end 
            end 
        end 

        local fast_join = string.format(luaTool:GetLocalize("fast_join"), game_zone_name)
        local download_ps = string.format(luaTool:GetLocalize("download_title"), luaTool:GetLocalize("download_url"))

        local final_msg = string.format("%s%s%s%s%s", title, m_desc , fast_join, download_ps, luaTool:GetLocalize("dupliate_roomid_ps"))
        print(final_msg)
        --@todo copy to clipboard and show a tips
        if ClipboardHelper.PasteMsgToClipboard(final_msg) == true then 
            facade:sendNotification(Common.OPEN_UI_COMMAND, MENU_DUPLICATE_PARAM)
        else
            facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.duplicatefailure") 
        end 
    else 
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.NotSupportedPlatform") 
    end 
end

return DuplicateRoomIdCommand