--[[
  * OpenedUI class used to cache key information of all ui 
  * that has been opened.
  * use OpenedUI class like: 
  * local template = depends("Common.Parameters.OpenedUI")
  * if nil ~= template then 
  *     local tmpInfo = template.new(tbKey, tbValue). 
  * end 
  *
]]
local OpenedUI = class('OpenedUI')

OpenedUI.assetPath = ""

OpenedUI.mediatorName = ""

OpenedUI.bDisabled = false

OpenedUI.parent = nil
--whether self can be resume when player invoke UIManager.RestoreAlls()
OpenedUI.bRestore = false 

OpenedUI.m_window = nil 
function OpenedUI:ctor(inMediatorName, disabled, inParent, bStatic)
    self.childs = {}
    self.mediatorName = inMediatorName
    self.bDisabled = disabled
    self.parent = inParent
    self.bStatic = bStatic or false
    self.bRestore = false 
end

function OpenedUI:GetChilds()
    return self.childs
end 

function OpenedUI:GetMediatorName()
    return self.mediatorName
end 

function OpenedUI:GetParent()
    return self.parent
end 

function OpenedUI:RegisterChilds(child)
    if self.childs == nil then 
        return
    end 

    if child == nil or child == "" then 
        return
    end 

    for _,v in ipairs(self.childs) do 
        if v == child then 
            return
        end 
    end 
    self.childs[#self.childs + 1] = child
end 

function OpenedUI:RemoveChild(child)
    if self.childs == nil then 
        return
    end 

    if child == nil or child == "" then 
        return
    end 

    if self.childs[k] ~= nil then 
        self.childs[k] = nil
    end 
end 

function OpenedUI:SetDisable(disabled)
    self.bDisabled = disabled
end 

function OpenedUI:IsDisabled()
    return self.bDisabled
end 

function OpenedUI:SetRestore(bRestore)
    self.bRestore = bRestore
end

function OpenedUI:IsCanRestore()
    return self.bRestore
end

function OpenedUI:SetWindow(window)
    self.m_window = window
end

function  OpenedUI:GetWindow()
    return self.m_window
end

function OpenedUI:SafeRelease()
    if self.childs ~= nil then 
        for i=#self.childs, -1 , 1 do 
            self.childs[i] = nil
        end 
    end 

    self.childs = nil
    self.parent = nil
    self.m_window = nil 
end 

function OpenedUI:IsStatic()
    return self.bStatic
end 
return OpenedUI