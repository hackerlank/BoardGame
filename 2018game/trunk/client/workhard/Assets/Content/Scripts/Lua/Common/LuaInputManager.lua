local LuaInputManager = class('LuaInputManager')

LuaInputManager.instanceMap = {}


function LuaInputManager:ctor(key)
    self:Init()
end 

function LuaInputManager.getInstance()
    local key = "Input_Manager"
    if LuaInputManager.instanceMap == nil then 
        LuaInputManager.instanceMap = {}
    end 

    if LuaInputManager.instanceMap[key] == nil then 
        LuaInputManager.instanceMap[key] = LuaInputManager.new(key)
    end 
    return LuaInputManager.instanceMap[key]
end 

function LuaInputManager:Init()
    self.GInstance = InputManager.GInstance;
    UnityEngine.Debug.Log("Init lua input manager...")
end 

function LuaInputManager:RegisterTouchBegan(inFunc)
    if self.GInstance and inFunc then
        self.GInstance.onTouchBegan:AddListener(inFunc)
    end 
end 

function LuaInputManager:RegisterTouchEnded(inFunc)
    if self.GInstance and inFunc then
        self.GInstance.onTouchEnded:AddListener(inFunc)
    end 
end 

function LuaInputManager:RegisterTouchMoved(inFunc)
    if self.GInstance and inFunc then
        self.GInstance.onTouchMoved:AddListener(inFunc)
    end 
end 

function LuaInputManager:RegisterTouchCancel(inFunc)
    if self.GInstance and inFunc then 
        self.GInstance.onTouchCancel:AddListener(inFunc)
    end 
end 


function LuaInputManager:RemoveTouchBegan(inFunc)
     if self.GInstance then
        if inFunc then  
            self.GInstance.onTouchBegan:RemoveListener(inFunc)
        else 
            self.GInstance.onTouchBegan:RemoveAllListeners(inFunc)
        end 
    end 
end 

function LuaInputManager:RemoveTouchEnded(inFunc)
     if self.GInstance then
        if inFunc then  
            self.GInstance.onTouchEnded:RemoveListener(inFunc)
        else 
            self.GInstance.onTouchEnded:RemoveAllListeners(inFunc)
        end 
    end 
end 

function LuaInputManager:RemoveTouchMoved(inFunc)
    if self.GInstance then
        if inFunc then  
            self.GInstance.onTouchMoved:RemoveListener(inFunc)
        else 
            self.GInstance.onTouchMoved:RemoveAllListeners(inFunc)
        end 
    end 
end 

function LuaInputManager:RemoveTouchCancel(inFunc)

    if self.GInstance then
        if inFunc then  
            self.GInstance.onTouchMoved:RemoveListener(inFunc)
        else 
            self.GInstance.onTouchCancel:RemoveAllListeners(inFunc)
        end 
    end 
end

function LuaInputManager:SafeRelease()
    if self.GInstance ~= nil then 
       self.GInstance:ClearAll()
       self.GInstance = nil
    end 
    self = nil
end 

function LuaInputManager.Clear()
    for k,v in pairs(LuaInputManager.instanceMap) do 
        v:SafeRelease()
        LuaInputManager.instanceMap[k] = nil
    end 
end
return LuaInputManager
