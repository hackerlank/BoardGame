--[[
 * WeChatShareParam configuration file.
 * code helper in here....
 *
]]
local WeChatShareParam = class('WeChatShareParam')

--constructor function 
--@param tbKey keys of configuration file
--@param tbValue values of configuration file
function WeChatShareParam:ctor(sharetype, scenetype, title, description, url, imagePath, thumbImage, bIsLinkMsg)
    self.m_scenetype = scenetype or EWeChatSceneType.EWCS_Friend
    self.m_title = title or ""
    self.m_desc = description or ""
    self.m_url = url or ""
    self.m_imagePath = imagePath or ""
    self.m_thumbImage = thumbImage or ""
    self.m_bIsLinkMsg = bIsLinkMsg or false
    self.m_sharetype = sharetype or EShareType.EST_Text
end

function WeChatShareParam:GetMsgType()
    return self.m_sharetype
end 

--get item's id
function WeChatShareParam:GetSceneType()
    return self.m_scenetype
end

function WeChatShareParam:GetTitle()
    return self.m_title
end 

function WeChatShareParam:GetDesc()
    return self.m_desc
end 

function WeChatShareParam:GetUrl()
    return self.m_url
end

function WeChatShareParam:GetImagePath()
    return self.m_imagePath
end 

function WeChatShareParam:GetThumbImage()
    return self.m_thumbImage
end 

function WeChatShareParam:IsLinkMsg()
    return self.m_bIsLinkMsg
end 

return WeChatShareParam