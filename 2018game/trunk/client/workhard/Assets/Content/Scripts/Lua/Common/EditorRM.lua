-----------------------------------------------------------------------------
--ResourceManager:: 
--  load and unload game asset 
-- @TODO we also need to automatic release bundle according to reference
-----------------------------------------------------------------------------

local rm = rm or {}

--saved white bundle list
rm.whiteBundleList = nil

--cache loaded asset bundle :: table<string, AssetBundle>
rm.loadedBundleCache = nil

--asset with bundle map list:: table<string, string>
rm.assetToBundleMap = nil

--bundle decrypt key
rm.desKey = "12345678";
rm.desIV = "abcdefgh";

--bundle reference map. Ignore static bundle
rm.bundleReferenceMap = nil

--saved bundle encrypt state :: table<string,bool>
rm.encryptBundle = nil

--definition setting bundle name
rm.SETTING_BUNDLE_NAME = "setting.u"

rm.bInited = false

--Log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning


local TaskCacheMap = {}
local CurrentTask = nil

--Init the resource manager
function rm.Init()

	if rm.bInited then 
		return 
	end 
	
	Log("Init lua Editor resource manager...------------------")
	
	--init all table
	rm.assetToBundleMap = {}
	rm.bundleReferenceMap = {}
	rm.encryptBundle = {}
	rm.whiteBundleList = {}
	rm.loadedBundleCache = {}

	rm.loadedLuaAsset = {}
	
	local luaGameManager = GetLuaGameManager()
	luaGameManager.RegisterManager(rm, LUA_RESOURCE_MANAGER)
		
	--create coroutine
	--local cor = coroutine.create(Dotask)
	
	--coroutine.resume(cor)
	
	rm:LoadBundleInWhiteList();	
end 

function rm:LoadBundleInWhiteList()		
	--Init Finished
	rm.bInited = true
	
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	if nil ~= facade then 
		facade:sendNotification(Common.RESOURCE_INIT_FINISHED,nil)
	end 
end 


function rm.LoadScript(szFile)
	local content = nil
	local finalPath = LUA_PATH .. szFile
	local bLoadFromBundle = false;

	bLoadFromBundle = false
	content = GameHelper.LoadScript(finalPath);
	return content;
end


function rm.LoadSetting(szFile)
	local tmpPath = "Assets/Content/Setting/" .. szFile;
	local pathOfSetting = string.gsub( tmpPath,"\\","/");
	local findStart, findEnd = string.find( pathOfSetting,".json");
	--if findStart ~= nil then
		--pathOfSetting = string.sub( pathOfSetting, 1, findStart - 1)
	--end
	if findStart == nil then
		pathOfSetting = pathOfSetting .. GameHelper.SETTING_FILE_EXTENSION;
	end
	
	local content = nil;

	--load from editor data assets
	local text = GameHelper.ReadFileFromDatabase(pathOfSetting);
	if text ~= nil then 
		content = text.text
	end 
	return content;	 
end 

function Dotask()
	while 1 do
		UnityEngine.Yield(nil)
	end

end

--load single bundle
function rm.LoadBundle(szFile, fn_callback)
	local tb_files = {szFile}
	rm.LoadBundles(tb_files)
end 

--directly load bundle set
function rm.LoadBundles(szFiles, fn_callback)
	if fn_callback == nil then 
		LogError("LoadBundles function missed callback")
		return 
	end 
	fn_callback();
end

function rm.UnloadGameBundles(bExcludeCommon)
	if GameHelper.isWithBundle == false then 
		return 
	end 
	local tb_bundles = {}
	if rm.loadedBundleCache == nil then 
		return 
	end 

	for k,v in pairs(rm.loadedBundleCache) do 
		table.insert(tb_bundles, k)
	end 

	for k,v in pairs(tb_bundles) do 
		if GBC.isCommonBundle(v) == false then 
			rm.UnloadBundle(v)
		end 
	end 

	tb_bundles = nil 
end 

--directly load asset
--directly load asset
function rm.LoadAsset(assetType, szFile, fnOnLoaded)
	if szFile == nil or szFile == "" then 
		LogError("LoadAsset:: invalid file path")
		if fnOnLoaded ~= nil then	 
			fnOnLoaded(nil)
		end 
		return
	end 
	local szFiles = {szFile}
	rm:LoadAsset_s(assetType, szFiles, fnOnLoaded)
	--table.insert( requestQueue,{assetType, szFile, fnOnLoaded} )
end 

function rm.LoadAssets(assetType, szFiles, fnOnLoaded)
	-- body
	if szFiles == nil or #szFiles <= 0 then 
		LogError("LoadAsset:: invalid file path")
		if fnOnLoaded ~= nil then	 
			fnOnLoaded(nil)
		end 
		return
	end 

	rm:LoadAsset_s(assetType, szFiles, fnOnLoaded)
end

function rm:LoadAsset_s(assetType, szFiles, fnOnLoaded)
	local assetPath = nil 
	local tb_loaded = {}
	local luaAsset = nil 
	local bHasLoad = false 
	local asset = nil 
	for k,v in pairs(szFiles) do 
		assetPath = String(v)
		assetPath = assetPath:Replace("\\","/");
		bHasLoad = false 
		for _,v in ipairs(rm.loadedLuaAsset) do 
			if v:GetAssetPath() == assetPath then 
				if fnOnLoaded ~= nil then 
					v:Clone()
					table.insert(tb_loaded,v)
					bHasLoad = true 
					break
				end 
			end 
		end 

		if bHasLoad == false then 
			luaAsset =  rm:LoadFromEditorDatabase(assetType, assetPath, fnOnLoaded)		
			table.insert( tb_loaded, luaAsset)
		end 
	end 

	if fnOnLoaded then 
		if #szFiles == 1 then 
			fnOnLoaded(tb_loaded[1])
		else 
			fnOnLoaded(tb_loaded)
		end 
	end 
end 


function rm.LoadAssetAsync(assetType, szFile, fnOnLoaded)
	if szFile == nil or szFile == "" then 
		LogError("LoadAssetAsync:: invalid file path")
		if fnOnLoaded ~= nil then	 
			fnOnLoaded(nil)
		end 
		return
	end 
	local szFiles = {szFile}
	local tmpc = coroutine.create(function()
		UnityEngine.Yield(UnityEngine.WaitForSeconds(0.1))
	rm:LoadAssetAsync_s(assetType, szFiles, fnOnLoaded);
	
	end)
	coroutine.resume(tmpc)
end 

function rm:LoadFromEditorDatabase(assetType, szFile, fnOnLoaded)
	if szFile == nil or szFile == "" then 
		LogError("LoadFromEditorDatabase:: invalid file path")
		if fnOnLoaded ~= nil then	 
			fnOnLoaded(nil)
		end 
		return
	end 

	--load from editor data base
	for _,v in ipairs(rm.loadedLuaAsset) do 
		if v:GetAssetPath() == szFile then 
			if fnOnLoaded ~= nil then 
				v:Clone()
				return v 
			end 
		end 
	end 

	local asset = GameHelper.LoadAsset_Editor(szFile, assetType);
	if asset == nil then 
		LogError("Failed to load asset " .. szFile)
	end 
 
	local luaAsset = LuaAsset.new(szFile, asset)
	rm.loadedLuaAsset[#rm.loadedLuaAsset + 1] = luaAsset 
	return luaAsset
end

function rm:LoadAssetAsync_s(assetType, szFiles, fnOnLoaded)
	local count = #szFiles
	local objs = {}
	local bLoaded = false 
	
	for k,v in pairs(szFiles) do 
		local szFile = v 
		local assetPath = String(szFile)
		assetPath = assetPath:Replace("\\","/");
		bLoaded = false 
		for _,v in ipairs(rm.loadedLuaAsset) do 
			if v:GetAssetPath() == assetPath then 
				if fnOnLoaded ~= nil then 
					v:Clone()
					objs[#objs + 1] = v
					--fnOnLoaded(v)
					bLoaded = true
					break
				end 
			end 
		end 

		if bLoaded  == false then 		
			local asset = GameHelper.LoadAsset_Editor(szFile, assetType);
			if asset == nil then 
				LogError("Failed to load asset " .. szFile)
				objs[#objs + 1] = ""
			else 
				local luaAsset = LuaAsset.new(szFile, asset)
				rm.loadedLuaAsset[#rm.loadedLuaAsset + 1] = luaAsset 
				objs[#objs+1] = luaAsset
			end 
			
		end 
	end 

	if fnOnLoaded ~= nil then 
		if count == 1 then 
			fnOnLoaded(objs[1])
		else 
			fnOnLoaded(objs)
		end 
	end 
	
end 

function rm.UpdateAssetReference(szFile,referCount,bRemove)
	if bRemove == true and rm.loadedLuaAsset ~= nil then
		 for k,v in ipairs(rm.loadedLuaAsset) do 
			if v:GetAssetPath() == szFile then 
				rm.loadedLuaAsset[k] = nil
				break
			end 
		end 
	end 

end 

function rm.LoadAssetsAsync(assetType, szFiles, fnOnLoaded)
	if type(szFiles) ~= "table" then 
		LogError("LoadAssetsAsync:: invalid file set")
		if fnOnLoaded ~= nil then	 
			fnOnLoaded(nil)
		end 
		return
	end 
	rm:LoadAssetAsync_s(assetType, szFiles, fnOnLoaded);
end 

return rm