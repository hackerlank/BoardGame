--[[
* Game bundles config file. 
]]

local  GBC = GBC  or {}
local m_GameBundles = nil 

--exclude game
local DEFINED_EXCLUDE_GAMES =  {EGameType.EGT_ZhaJinHua}--, EGameType.EGT_NJMaJiang}

local function LoadGameBundleConfig()
	local asset = UnityEngine.Resources.Load("GameBundle", GameHelper.GetAssetType(GameHelper.EAssetType.EAT_TextAsset))
	if asset ~= nil then 
		local content = asset.text
		m_GameBundles = JsonTool.Decode(content)
	end 
end 


function GBC.Reload()
    m_GameBundles = {}
    LoadGameBundleConfig()
end 

--whehter has install game
--@param iGameType  defined in definition.lua file
function GBC.IsInstalledGame(iGameType)

	for k,v in ipairs(DEFINED_EXCLUDE_GAMES) do 
		if iGameType == v then 
			return false 
		end 
	end 

	if GameHelper.isEditor == true and GameHelper.isWithBundle == false then 
		return true
	end 

	local tempDir = CustomTool.FileSystem.bundleLocalPath .. "/"
	local bInstalled = true
	local tmpType = 0
	if m_GameBundles ~= nil then 
		for _,v in ipairs(m_GameBundles) do 
			tmpType = tonumber(v.gameType)
			if tmpType == iGameType then 			 
				for k,v in ipairs(v.bundles) do 
					local szFile = tempDir .. v
					if CustomTool.FileSystem.Exist(szFile) == false then 
						bInstalled = false
						break
					end 
				end 
			end 
		end 
	else 
		bInstalled = false
	end 
	if iGameType == EGameType.EGT_MAX then 
		bInstalled = false 
	end 
	return bInstalled
end 

function GBC.GetGameBundles(iGameType)
    if GameHelper.isEditor == true and GameHelper.isWithBundle == false then 
		return true
	end 

    iGameType = iGameType or GetLuaGameManager().GetGameType()
	local tempDir = CustomTool.FileSystem.bundleLocalPath .. "/"
	local tmpType = nil
	local m_assets = {}
	if iGameType == EGameType.EGT_MAX then 
        iGameType = EGameType.EGT_Common
	end 

    if m_GameBundles ~= nil then 
        for _,v in ipairs(m_GameBundles) do 
            tmpType = tonumber(v.gameType)
            if tmpType == iGameType then 	

                for i=1, #v.bundles do 
                    if iGameType == EGameType.EGT_Common and (v.bundles[i] == "lua_puremvc.u" or v.bundles[i] == "lua_common.u") then 
                    else 
                        table.insert(m_assets, v.bundles[i])
                    end 
                end 		 
            end 
        end 
    else 
        bInstalled = false
        LogError("Game manager has not been inited. please visit me later")
    end 
 
	return m_assets
end 


--get bundles of game that need to be downloaded
function GBC.GetNeedDownloadBundles(inGameType)
	if inGameType == nil or type(inGameType) ~= "number" then 
		return nil 
	end 

	local needDownloads = {}
	local name = ""
	if m_GameBundles ~= nil then 
		for _,v in ipairs(m_GameBundles) do
			local gameType = tonumber(v.gameType)
			if gameType == inGameType then 
				name = v.gameName
				for k,v in ipairs(v.bundles) do 
					if CustomTool.FileSystem.Exist(CustomTool.FileSystem.bundleLocalPath .. "/" .. v) == false then 
						needDownloads[#needDownloads + 1] = v
					end 
				end 
				break
			end 
		end
	end 

	if GameHelper.isEditor then 
		for _,v in ipairs(needDownloads) do
			Log(name .. " contains " .. v)
		end 
	end 

	return needDownloads
end 

--whether bundle can be updated 
function GBC.IsCanUpdate(inBundleName)
	local bNeedUpdate = true
	if m_GameBundles ~= nil then 
		for _,v in pairs(m_GameBundles) do
			local gameType = tonumber(v.gameType)
			if GBC.IsInstalledGame(gameType) == false then 
				bNeedUpdate = false 
				break
			end 
		end
	end 

	--this bundle is in common configuration file, just check this whether exist.
	if bNeedUpdate == false and CustomTool.FileSystem.Exist(CustomTool.FileSystem.bundleLocalPath .. "/" .. inBundleName) == true then 
		bNeedUpdate = true
	end 
	return bNeedUpdate
end 

--whether a bundle is common bundle
function GBC.isCommonBundle(bundleName)
    if m_GameBundles ~= nil then 
        if bundleName ~= nil and bundleName ~= "" then 
            for k,v in pairs(m_GameBundles) do 
                if tonumber(v.gameType) == EGameType.EGT_Common then 
                    for sk, sv in pairs(v.bundles) do 
                        if bundleName == sv then 
                            return true 
                        end 
                    end 
                end 
            end 
        end 
    end 

    return false
end 

return GBC