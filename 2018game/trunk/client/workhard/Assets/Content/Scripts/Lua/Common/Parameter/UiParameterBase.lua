--[[
  * CLASS UiParameterBase has defined basic parameter which used to open user interface.
  *
  * @UI_PREFAB_ROOT the root path of all ui prefabs. do not reset it
  *
  * @UI_NAME the user interface name. reset it in subclass
  *
]]
local UiParameterBase = class('UiParameterBase')

-- the root path of all ui prefabs
UiParameterBase.UI_PREFAB_ROOT = "Assets/Content/Prefabs/UI/"

-- assets suffix
UiParameterBase.PREFAB_ENDTENSION = ".prefab" 

-- the mediator file name extension of user interface
UiParameterBase.MEDIATOR_EXTENSION = "Mediator"

-- the user interface name. reset it in subclass
UiParameterBase.windowName = "UI_Main"

UiParameterBase.mediatorName = "UI_MainMediator"

UiParameterBase.parent = nil

UiParameterBase.bGeneralTip = false

UiParameterBase.bStatic = false

UiParameterBase.fn_callBack = nil 

-- the window type that will be opened.To get more, please see EMenuType in  Difination.lua file
UiParameterBase.menuType = EMenuType.EMT_MAX

function UiParameterBase:ctor(name,inMenuType, inParent, bStatic, fn_callBack, data)
    self.windowName = name
    self.menuType = inMenuType
    if name ~= nil then 
        self.mediatorName = name .. "Mediator"
    end
    self.parent = inParent
    self.bGeneralTip =  false
    self.bStatic = bStatic or false
    self.fn_callBack = fn_callBack
    self.data = data 
end 

-- Get prefab path of ui
function UiParameterBase:GetUiPrefabPath()
    local path = nil
    if self.menuType == EMenuType.EMT_Common then 
        path = self.UI_PREFAB_ROOT .. "Common/" .. self.windowName .. self.PREFAB_ENDTENSION
    elseif self.menuType == EMenuType.EMT_Games then 
        local gameManger = GetLuaGameManager()
        if gameManger ~= nil then 
            path = self.UI_PREFAB_ROOT .. gameManger.GetGameName() .. "/" .. self.windowName .. self.PREFAB_ENDTENSION
        end
    elseif self.menuType == EMenuType.EMT_RawRes then 
        path = self.windowName
    else
        UnityEngine.Debug.LogError("UiParameterBase:GetUiPrefabPath:: Invalid menu type .. " .. self.menuType)
    end 

    return path 
end 

-- Get mediator path of user interface
function UiParameterBase:GetMediatorPath()
    local strpath = nil
    if self.menuType == EMenuType.EMT_Common or self.menuType == EMenuType.EMT_RawRes then 
        strpath = "Common.Mediator." .. self.windowName .. self.MEDIATOR_EXTENSION
    elseif self.menuType == EMenuType.EMT_Games then 
        local gameManger = GetLuaGameManager()
        if gameManger ~= nil then 
            strpath = root_path.GAME_MVC_MEDIATOR_PATH .. self.windowName .. self.MEDIATOR_EXTENSION
        end 
    else 
        UnityEngine.Debug.LogError("UiParameterBase:GetMediatorPath::Invalid menu type " .. self.menuType .. " window=" ..self.windowName)
    end 
    return strpath
end 

-- Get view path of user interface
function UiParameterBase:GetViewPath()
    local strpath = nil
    if self.menuType == EMenuType.EMT_Common or self.menuType == EMenuType.EMT_RawRes then 
        strpath = "Common.View." .. self.windowName
    elseif self.menuType == EMenuType.EMT_Games then 
        local gameManger = GetLuaGameManager()
        if gameManger ~= nil then 
            strpath = root_path.GAME_MVC_VIEW_PATH .. self.windowName
        end 
    else 
        UnityEngine.Debug.LogError("UiParameterBase:GetViewPath:: Invalid menu type " .. self.menuType)
    end 
    return strpath
end 

function UiParameterBase:GetMediatorName()
    return self.mediatorName
end 

function UiParameterBase:GetWindowName()
    return self.windowName
end 

function UiParameterBase:GetParent()
    return self.parent
end 

function UiParameterBase:IsGeneralTip()
    return self.bGeneralTip
end 

function UiParameterBase:IsStatic()
    return self.bStatic
end 

function UiParameterBase:GetCallBack()
    return self.fn_callBack
    --[[if self.fn_callBack ~= nil then 
        self.fn_callBack()
        self.fn_callBack = nil 
    end ]]
end 

function  UiParameterBase:SetCallBack(cb)
    self.fn_callBack = cb
end

function UiParameterBase:GetMenuParam()
    return self.data 
end 
return UiParameterBase