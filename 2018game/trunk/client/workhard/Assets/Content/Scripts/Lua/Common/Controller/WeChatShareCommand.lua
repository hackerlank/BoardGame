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
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)

--constructor function. do not overwrite it
function WeChatShareCommand:ctor()
    self.executed = false
end

--coding function in here
function WeChatShareCommand:execute(note)
    --UnityEngine.Debug.Log('WeChatShareCommand')
    local param = note.body
    if param == nil then 
        return 
    end 
 
    local platform = GameHelper.runtimePlatform
 
    if GameHelper.isEditor == false and ( platform == BuildPlatform.Android or platform == BuildPlatform.iOS) then 
        local m_sceneType = param:GetSceneType()
        local m_url = param:GetUrl()
        local m_imagePath = param:GetImagePath() 
        local m_title = param:GetTitle()
        local m_desc = param:GetDesc()
        local m_bIsLink = param:IsLinkMsg()
        local m_thumbImage = param:GetThumbImage() 
        local m_shareType = param:GetMsgType()
        if  m_shareType == EShareType.EST_Text then 
            if m_sceneType == EWeChatSceneType.EWCS_Friend then 
                if m_bIsLink == true then 
                    WeChatSDK.ShareLinkMsgFriend(m_title, m_desc, m_url, m_thumbImage)
                else 
                    WeChatSDK.ShareTextMsgFriend(m_title, m_desc)
                end 
            elseif m_sceneType == EWeChatSceneType.EWCS_Timeline then 
                if m_bIsLink == true then 
                    WeChatSDK.ShareLinkMsgMoments(m_title, m_desc, m_url, m_thumbImage)
                else 
                    WeChatSDK.ShareTextMsgMoments(m_title, m_desc)
                end 
            elseif m_sceneType == EWeChatSceneType.EWCS_Favorite then 
                facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.NotSupportedShare")   
            end 
        elseif m_shareType == EShareType.EST_Image then 
            WeChatSDK.WeChatShareImageMsg(m_title, m_desc, m_imagePath, m_thumbImage,  m_sceneType);
        end 
    else
        facade:sendNotification(Common.RENDER_MESSAGE_KEY, "errorcode.NotSupportedPlatform")   
    end 
end

return WeChatShareCommand