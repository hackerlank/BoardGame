--[[
 * LuaAsset: smart asset reference counter
 * function will return a instance of this class if we called resource manager loadAsset function.
 * it contains three sections. 
 *
 * @assetPath the whole path of asset. it help us load asset and update asset reference. visit it by
 *            call GetAssetPath() function
 * @asset the asset object. visit it by call GetAsset()
 * @reference reference count of asset. private variable. do not visit it directly
 *
 * @interfaces::
 * Clone
 * normally, if we own one instance object of this class,and  we want to use asset of its to instead of 
 * another object or contoller's value. we will directly assign value with asset of LuaAsset objects in
 * other smart language. But we must invoke Clone function to explicit increase asset reference before 
 * really execute assign operation in lua.
 * because, if we never do this, system will force release all assets when unload one bundle, this will 
 * causes the game or user interface looks like badly.
 * @return this function will return asset object
 * usage like:: luaAsset:Clone()
 *
 * Free 
 * this function is used to decrease asset reference count. you can pass one int value to tell system 
 * asset reference must be decrease with pointed number. not -1. also if you never pass one valid parameter
 * we will decrease 1. After decreased the reference section, if we checked that its value equals to 0, system 
 * will clear assets. 
 * Also, if you only has the whole path of asset, not a valid LuaAsset object; but wanner decrease asset reference count
 * please update asset reference by call GetResourceManager().UnloadAsset(szFile)
 * usage like:: luaAsset:Free() or  luaAsset:Free(1)
 *
 * FreeAll 
 * will forece clear all asset reference. the reference section will be reset with 0. also the asset will be clear.
 * system removes the asset object. carefully
 * usage like:: luaAsset:Free()
]]
local LuaAsset = class('LuaAsset')

function LuaAsset:ctor(assetPath, asset)
    self.assetPath = assetPath
    self.asset = asset
    self.reference = 1
end 

function LuaAsset:GetAssetPath()
    return self.assetPath
end 

function LuaAsset:GetAsset() 
    return self.asset
end 

function LuaAsset:Clone()
    self.reference = self.reference + 1
    GetResourceManager().UpdateAssetReference(self.assetPath, 1)
    return self.asset
end 

function LuaAsset:Free(amount)

    local freeCount = -1
    if amount ~= nil then 
        freeCount = amount * -1
    else 
        self:FreeAll()
        return
    end 
    
    self.reference = self.reference + freeCount
    GetResourceManager().UpdateAssetReference(self.assetPath, freeCount, self.reference <= 0)
    --UnityEngine.Debug.LogWarning("Remove " .. self.assetPath .. " clear cache=" .. tostring(self.reference == 0))
    if self.reference <= 0 then 
        self.asset = nil
        self = nil
    end 
end 

function LuaAsset:FreeAll()
     local freeCount = self.reference * -1

     self.reference = self.reference + freeCount

     GetResourceManager().UpdateAssetReference(self.assetPath, freeCount, self.reference == 0)
     self.asset = nil
     self = nil
end 

--whether this is a valid asset object
function LuaAsset:IsValid()
    return self.reference > 0 and self.asset ~= nil 
end 

return LuaAsset