--[[
 * This UiManager implementation is a singleton, so you should not call the 
 * constructor directly, but instead call the static Factory method, 
 * passing the unique key for this instance to #getInstance. if not pass unique key, 
 * will use default key.
 *
]]
local UiManager = class('UiManager')

UiManager.instanceMap = {}

--Log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

function UiManager:ctor(key)
    self:Init()
end 

function UiManager.getInstance()

    local key = "UI_Manager"
    if UiManager.instanceMap == nil then 
        UiManager.instanceMap = {}
    end 

    if UiManager.instanceMap[key] == nil then 
        UiManager.instanceMap[key] = UiManager.new(key)
        UiManager.instanceMap[key].tb_opening = {}
        UiManager.instanceMap[key].tb_closing = {}
        if UiManager.instanceMap[key].m_Root == nil then 
            local root = UnityEngine.GameObject("UiRoot")
            UiManager.instanceMap[key].m_Root = root.transform
            UnityEngine.Object.DontDestroyOnLoad(root)
        end 
    end 
    return UiManager.instanceMap[key]
end 

--init the ui manager instance
function UiManager:Init()
    Log("Init lua ui manager...")
    self.OpenedUI = {}
    self.pushUI = {}
    self.bUnloadAsset = false
    self.facade = pm.Facade.getInstance(GAME_FACADE_NAME)
end 

--open a window
function UiManager:Open(param)

    if param == nil then 
        LogError("Open a menu with invalid param. will return")
        return
    end 

    if self.facade == nil then 
        self.facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    end
    local windowName = param:GetWindowName()
    
    local bRestore = self:IsRestore(windowName)

    if bRestore then 
        self:RestoreWindow(windowName)
        if param and param:GetCallBack() ~= nil then 
            local cb = param:GetCallBack()
            cb()
        end 
    else 
        if self.OpenedUI[windowName] ~= nil then 
            --LogWarning(windowName .. " has been opened")
            return
        else 
            self:_Open(param)
        end 
    end 
end 

--open menu. 
function UiManager:_Open(param)
    local viewPath = param:GetViewPath()
    local mediatorName = param:GetMediatorName()
    local mediatorPath = param:GetMediatorPath()
    local windowName = param:GetWindowName()
    local prefabpath = param:GetUiPrefabPath()
    local bStatic = param:IsStatic()
    if self.tb_opening[windowName] ~= nil then 
        LogWarning("the " .. windowName .. " is being opened. will return")
        return 
    end 

    self.tb_opening[windowName] = windowName
    if self.facade:hasMediator(mediatorName) then 
        self.facade:removeMediator(mediatorName)
    end
    local parent = param:GetParent()
    local mediator = depends(mediatorPath)
    local tmpState = ci.GetOpenedUI().new(mediatorName, false, parent, bStatic)
    self.OpenedUI[windowName] = tmpState
    if mediator then 
        GetResourceManager().LoadAsset(GameHelper.EAssetType.EAT_GameObject, prefabpath, function(asset)
            if asset and asset:IsValid() then
                local uiGameObject = UnityEngine.GameObject.Instantiate(asset:GetAsset());
                uiGameObject.transform:SetParent(self.m_Root)
                self:RegisterChilds(parent, windowName)
                local view = depends(viewPath)
                
                local Canvas = uiGameObject.transform:GetComponent('Canvas')
                if UnityEngine.Camera.main ~= nil then
                    if  Canvas.worldCamera == nil then
						Canvas.worldCamera = UnityEngine.Camera.main
					end
                end
                uiGameObject:SetActive(true)
                tmpState:SetWindow(uiGameObject)
                
                if view.Opened then
                    view:Opened(uiGameObject.transform, windowName, asset);
                end
                mediator = mediator.new(mediatorName,view)
                self.facade:registerMediator(mediator)
                mediator:Opened(param)
                self.tb_opening[windowName] = nil 
                if tmpState:IsDisabled() == true then 
                    uiGameObject:SetActive(false)
                end 
            else 
                LogError("Failed to open " .. windowName .. " because the asset is nil")
                self.OpenedUI[windowName] = nil
                self.tb_opening[windowName] = nil 
            end
        end);
    else 
        LogError("class " .. mediatorName .. " missed Opened function ")
    end
end 

--just hide windown. not really close
function UiManager:DisableWindow(windowName)
    local tmpWin = self.OpenedUI[windowName]
    if tmpWin ~= nil then 
        local childs = tmpWin:GetChilds()
        if childs ~= nil then 
            for _,v in ipairs(childs) do 
                self:DisableWindow(v)
            end 
        end 

        local mediator = self.facade:retrieveMediator(tmpWin:GetMediatorName())
        if mediator ~= nil and mediator.OnDisable then 
            mediator:OnDisable()
        end 
        tmpWin:SetDisable(true)
    end 
end 

-- restore one menu without any operation
function UiManager:RestoreWindow(windowName)
    local tmpWin = self.OpenedUI[windowName]
    if tmpWin ~= nil then 
        local childs = tmpWin:GetChilds()
        if childs ~= nil then 
            for _,v in ipairs(childs) do 
                self:RestoreWindow(v)
            end 
        end 

        local mediator = self.facade:retrieveMediator(tmpWin:GetMediatorName())
        if mediator ~= nil and mediator.OnRestore then 
            mediator:OnRestore()
        end 
        tmpWin:SetDisable(false)
    end 

end 

function UiManager:RegisterChilds(parent, selfName)
    if parent == nil or parent == "" then 
        return
    end 

    for k,v in pairs(self.OpenedUI) do 
        if k == parent then 
            v:RegisterChilds(selfName)
        end 
    end 
end  
function UiManager:Close(bDisable, windowName)
    if bDisable == false then 
        if self.tb_closing[windowName] ~= nil then 
            return 
        end 
        self.tb_closing[windowName] = windowName
        self:_Close(windowName)
    else 
        self:DisableWindow(windowName)
    end 
end 

--close window
function UiManager:_Close(windowName)
    if windowName == nil or windowName == "" then 
        UnityEngine.Debug.LogError("invalid window name")
        return
    end 

    local tmpUI = self.OpenedUI[windowName]
    if tmpUI ~= nil then 
        local childs = tmpUI:GetChilds()
        if childs ~= nil then 
            for _,v in ipairs(childs) do 
                self:Close(false, v)
            end 
        end 

        local mediator = self.facade:retrieveMediator(tmpUI:GetMediatorName())
        if mediator then 
            mediator:OnClose()
        else 
            UnityEngine.Debug.LogError(" missed mediator")
        end 
        self.facade:removeMediator(tmpUI:GetMediatorName())
       
        local parent = tmpUI:GetParent()
        if parent ~= nil and parent ~= "" and self.OpenedUI[parent] ~= nil then 
            self.OpenedUI[parent]:RemoveChild(windowName)

            --show parent 
            if self:IsRestore(parent) == true then 
                self:RestoreWindow(parent)
            end 
        end 
        tmpUI:SafeRelease()
        self.OpenedUI[windowName] = nil
        self.tb_closing[windowName] = nil 
    else
        self.tb_closing[windowName] = nil
        --UnityEngine.Debug.LogError(windowName .. " has not been opened")
    end 
end

--whether window has not been closed?
function UiManager:IsRestore(windowName)
    if windowName== nil or windowName == "" then 
        return false
    end 
    
    local tmpUI = self.OpenedUI[windowName]
    if tmpUI == nil then 
        return false
    end 

    return tmpUI:IsDisabled()
end 

--close all menus, even if window has been set need to be restore
function UiManager:CloseAll(restoreType)
    for k,v in pairs(self.OpenedUI) do 
        if v:IsStatic() == false then 
            if restoreType == ERestoreType.EST_Main then 
                if v:IsCanRestore() == true then 
                    self:DisableWindow(k)
                    v:SetRestore(true)
                else 
                    self:Close(false, k)
                    self.OpenedUI[k] = nil
                end 
            elseif restoreType == ERestoreType.EST_AllOpened then 
                if v:IsDisabled() == false then 
                    self:DisableWindow(k)
                    v:SetRestore(true)
                end 
            else 
                if v:IsDisabled() == false then 
                    self:Close(false, k)
                    self.OpenedUI[k] = nil
                end 
            end 
        else 
            if restoreType ~= ERestoreType.EST_Main and restoreType ~= ERestoreType.EST_AllOpened then 
                --skip loading 
                if k ~= Common.MENU_LOADING  and k ~= Common.MENU_LOG then 
                    self:DisableWindow(k)
                end 
            end 
        end 
    end 
end 

--restore all menu that has been disabled. this function only can be invoked from main_game_mode
--used to restore the menus that need to be show as same as before swith level to play game or play record
function UiManager:RestoreAll()
    local window = nil 
    local Canvas = nil 
    local main_camera = nil 
    main_camera = UnityEngine.Camera.main
    for k,v in pairs(self.OpenedUI) do 
        if v:IsStatic() == false then 
            if v:IsCanRestore() == true then 
                window = v:GetWindow()
                if window then 
                    Canvas = window.transform:GetComponent('Canvas')
                    if main_camera ~= nil then
                        if  Canvas.worldCamera == nil then
                            Canvas.worldCamera = main_camera
                        end
                    end
                end 
                v:SetRestore(false)
                self:RestoreWindow(k)
            end 
        end 
    end 
end 

--push a window that will be opened soon
function UiManager:PushUI(param)
    if param == nil then 
        return
    end 

    for _,v in ipairs(self.pushUI) do 
        if v:GetWindowName() == param:GetWindowName() then 
            return 
        end 
    end 

    self.pushUI[#self.pushUI + 1] = param
end 

--pop a window to render
function UiManager:PopUI()
    local tmp = nil
    if #self.pushUI > 0 then 
        tmp = self.pushUI[#self.pushUI];
        self.pushUI[#self.pushUI] = nil
    end 
    return tmp
end 

--whether window has been opened
--@param iWindowName the window name
function UiManager:HasOpened(iWindowName)
    if iWindowName == nil or iWindowName == "" then 
        return false
    end 

    if self.tb_opening[iWindowName] ~= nil then 
        return true 
    end 

    if self.OpenedUI[iWindowName] == nil then 
        return false
    end 

    if self.OpenedUI[iWindowName]:IsCanRestore() == true then 
        return true
    end

    if self:IsRestore(iWindowName) == true then 
        return false 
    end 

    return true
end 

function UiManager:IsOpening(iWindowName)

    if iWindowName == nil or iWindowName == "" then 
        return false
    end 

    if self.tb_opening[iWindowName] ~= nil then 
        return true 
    end 

    return false
end 

return UiManager