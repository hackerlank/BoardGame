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
rm.SETTING_BUNDLE_NAME = "setting_common.u"

rm.bInited = false

local async_load_queue = nil

--Log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

local requestQueue = {}

--Init the resource manager
function rm.Init()

	if rm.bInited then 
		return 
	end 
	
	Log("Init lua resource manager...")

	--init all table
	rm.assetToBundleMap = {}
	rm.bundleReferenceMap = {}
	rm.encryptBundle = {}
	rm.whiteBundleList = {}
	rm.loadedBundleCache = {}

	rm.loadedLuaAsset = {}

	async_load_queue = {}
	
	local luaGameManager = GetLuaGameManager()
	luaGameManager.RegisterManager(rm, LUA_RESOURCE_MANAGER)
	
	if GameHelper.isWithBundle then 

		--register setting bundle to white list
		rm.whiteBundleList[#rm.whiteBundleList + 1 ] = rm.SETTING_BUNDLE_NAME 
		
		local downloader = GetDownloadManager()
		if downloader == nil then 
			LogError("Fatal error:: Download manager is nil. return ")
			return 
		end 
		local allBundleInfo = downloader.GetServerBuildState();
		
		if allBundleInfo ~= nil then 		 
			local loop = allBundleInfo.Count - 1
			for i=0, loop do 
				local tmpInfo = allBundleInfo:getItem(i)
				local includes = tmpInfo.includs
				local includeAmount = includes.Count - 1
				for t=0, includeAmount do 
					local tmp = includes:getItem(t)
					local bExist = false
					for k,v in pairs(rm.assetToBundleMap) do 
						if k == tmp then 
							bExist = true
							break
						end 
					end 

					
					if false == bExist then 
						if tmpInfo.sceneBundle then 
							--if bundle type is sceneBundle, just use the name as the key
							local name = GameHelper.GetFileNameWithoutExtension(tmp)
							if name ~= "" then 
								rm.assetToBundleMap[name] = tmpInfo.name
							else 
								
							end 
						else 
							rm.assetToBundleMap[tmp] = tmpInfo.name
						end 
						
					end 
				end 
				
				if tmpInfo.bEncrypt then 
					rm.encryptBundle[tmpInfo.name] = tmpInfo.bEncrypt
				end 
			end
		end
	end
	rm:LoadBundleInWhiteList();
end 

--load default bundle
function rm:LoadBundleInWhiteList()
	local whiteCoroutine = coroutine.create(function()
		local downloader = GetDownloadManager()
		if downloader ~= nil then 
			if GameHelper.isWithBundle then 
				for k,v in ipairs(rm.whiteBundleList) do 
					if downloader.IsBundleInBM(v) then 
						local bundle = rm:LoadBundleFromFile(v)	
						if bundle ~= nil then 
							rm.bundleReferenceMap[v] = 100000
						end
					end 		
					UnityEngine.Yield(nil)
				end 
			end 
		else 
			LogError("Fatal error:: Download manager is nil ")
		end 
		
		--Init Finished
		rm.bInited = true
		
		local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
		if nil ~= facade then 
			facade:sendNotification(Common.RESOURCE_INIT_FINISHED,nil)
		end 
	end 
	)
	coroutine.resume(whiteCoroutine)
end 

--load bundle from file or memory
function rm:LoadBundleFromFile(bundleName,bStatic)
	
	local downloader = GetDownloadManager();
	if downloader == nil then 
		LogError("Fatal error:: download manager is nil ")
		return nil 
	end 
	
	local dplist = downloader.GetDependList(bundleName);
	if dplist ~= nil then 
		local loop = dplist.Count - 1
		for i=0, loop do 
			rm:LoadBundleFromFile(dplist:getItem(i))
		end 
		
		local bExist = false
		for k,v in pairs(rm.loadedBundleCache) do 
			if k == bundleName then 
				return rm.loadedBundleCache[k]
			end 
		end 
		
		local tmpName = String(bundleName)
		local tmpIndex =  tmpName:LastIndexOf("/") --GameHelper.LastIndexOf(bundlename)
		if tmpIndex < 0 then 
			tmpIndex = 0
		end
		
		local persBundlePath = CustomTool.FileSystem.bundleLocalPath .. "/" .. tmpName:Substring(tmpIndex, tmpName.Length - tmpIndex)
		local newBundle = null;
		local bEncrypt = false;
		local shortName = tostring(tmpName:Substring(tmpName:LastIndexOf("/") + 1, tmpName.Length - tmpName:LastIndexOf("/") - 1));
		
		--whether bundle has been encrypt
		for bk,bv in pairs(rm.encryptBundle) do 
			if bk == shortName then 
				bEncrypt = rm.encryptBundle[shortName]
			end 
		end 
		
		local updateManger =  GetUpdateManager()
		if updateManger == nil then 
			return nil 
		end 
		
		if false == bEncrypt then 
			local updateOldState = updateManger.GetOldStates()
			local allServerBundle = downloader.GetServerBuildState()
			if allServerBundle ~= nil and allServerBundle.Count > 0 then 
				loop = allServerBundle.Count - 1
				for t = 0, loop do 
					if allServerBundle:getItem(t).name == shortName and allServerBundle:getItem(t).bEncrypt == true then 
						bEncrypt = true
						rm.encryptBundle[shortName] = bEncrypt
						break
					end 
				end 
			elseif updateOldState ~= nil and #updateOldState > 0 then
				for key,value in ipairs(updateOldState) do 
					if value.name == shortName and value.bEncrypt then 
						bEncrypt = value.bEncrypt
						rm.encryptBundle[shortName] = bEncrypt
						break
					end 
				end 
			end 
		end 
		
		if true == bEncrypt then 			
			local contents = GameHelper.Decrypt(persBundlePath, rm.desKey, rm.desIV)
			if nil == contents then 
				LogError("Failed to decrypt " .. persBundlePath)
			else 
				newBundle = UnityEngine.AssetBundle.LoadFromMemory(contents);   
			end
		else       
			newBundle = UnityEngine.AssetBundle.LoadFromFile(persBundlePath);                    
		end
	   

		if newBundle ~= nil then                
			--for unity's bug
			newBundle:GetType();
			rm.loadedBundleCache[bundleName] = newBundle;	
			return rm.loadedBundleCache[bundleName];
		
		else         
			LogError("Can not create " .. bundleName .. "  from file");
			return nil
		end 
	end 
end 

--load lua scripts
--[[
	currently only support two ways. one is directly load file from asset data base(editor only),
	the other is load from bundle file(both device and editor)
]]--
function rm.LoadScript(szFile)
	local content = nil
	local finalPath = LUA_PATH .. szFile
	local bLoadFromBundle = false;
	if GameHelper.isEditor then 	
		if GameHelper.isWithBundle then 
			finalPath = LUA_GEN_PATH .. szFile .. GameHelper.LUA_FILENAME_EXTENSION
			bLoadFromBundle = true
		else
			bLoadFromBundle = false
			content = GameHelper.LoadScript(finalPath);
		end 
	else 
		--because we never support raw res mode. so if we are on the device, indicates that we must load asset from bundle.
		--@todo should us support load from resource directory???
		bLoadFromBundle = true
		if GameHelper.isWithBundle then 
			finalPath = LUA_GEN_PATH .. szFile .. GameHelper.LUA_FILENAME_EXTENSION;
		end 		
	end
	
	if bLoadFromBundle then 	 
		--load script
		local luaName = GameHelper.GetFileName(finalPath)
		
		--load from lua common bundle first
		content = pScripter:LoadCommonLuaScript(finalPath)
		
		if content == nil then 
			if rm:isInAssetToBundleMap(finalPath) == true then 
				local bundlePath = rm.assetToBundleMap[finalPath]	
				local luaBundle = rm.loadedBundleCache[bundlePath]
				if luaBundle == nil then 
					luaBundle = rm:LoadBundleFromFile(bundlePath)
					rm.bundleReferenceMap[bundlePath] = 100000
				end 
				
				if luaBundle ~= nil then 			
					if luaBundle:Contains(luaName) then 
						local assets = GameHelper.LoadTextAsset(luaName, luaBundle);
						content = assets.bytes;		
					else 
						LogError("Can not load lua script " .. finalPath .. " from " .. bundlePath)
					end 
				else 
					LogError("Can not find " .. bundlePath)
				end
			else
				--@todo should us load from luaGenPath
				LogError("LaunchGame rm.LoadScript:: miss " .. luaName .." bundle")
			end 
		end 
	else 
		--@todo, we treat it as editor at present
		content = GameHelper.LoadScript(finalPath);
	end 
	return content;
end

--load configuration file of games, return string
function rm.LoadSetting(szFile)
	local tmpPath = "Assets/Content/Setting/" .. szFile;
	local pathOfSetting = string.gsub( tmpPath,"\\","/");
	local findStart, findEnd = string.find( pathOfSetting,".json");
	--if findStart ~= nil then
		--pathOfSetting = string.sub( pathOfSetting, 1, findStart - 1)
	--end
	if findStart == nil then
		pathOfSetting = pathOfSetting ..  GameHelper.SETTING_FILE_EXTENSION
	end
	
	local content = nil;
	if GameHelper.isEditor and GameHelper.isWithBundle == false then 
		--load from editor data assets
		local text = GameHelper.ReadFileFromDatabase(pathOfSetting);
		if text ~= nil then 
			content = text.text
		end 
		return content;	 
	end
	
	if GameHelper.isWithBundle then 
		if rm:isInAssetToBundleMap(pathOfSetting) == true then 
			local bundlePath = rm.assetToBundleMap[pathOfSetting]	
			local settingBundle = rm.loadedBundleCache[bundlePath]

			if settingBundle == nil then 
				settingBundle = rm:LoadBundleFromFile(bundlePath)
			end 
			
			if settingBundle ~= nil then
				local fileName = GameHelper.GetFileName(szFile)
				if settingBundle:Contains(fileName) then 
					content = GameHelper.LoadTextAsset(fileName, settingBundle).text
					return content;
				end
			else 
				--missed setting bundle , load file from resource directory???
				LogError("Missed setting bundle. check now....")
				return content;
			end 
		else
			LogError(pathOfSetting .. " is missed"); 
		end 
	else 
		--@TODO should us support other way on devices???
		Log("Currently only support bundle mode on devices")
	end 

	return content
end 

--whether load from bundle
function rm:isLoadFromBundle()
	local bLoadFromBundle = false
	if GameHelper.isEditor then 
		if GameHelper.isWithBundle then 
			bLoadFromBundle = true
		end 
	else 
		bLoadFromBundle = true
	end 
	
	return bLoadFromBundle
end 

--directly load asset from editor asset data base
function rm:LoadFromEditorDatabase(assetType, szFile, fnOnLoaded)


	--load from editor data base
	for _,v in ipairs(rm.loadedLuaAsset) do 
		if v:GetAssetPath() == szFile then 
			if fnOnLoaded ~= nil then 
				v:Clone()
				--fnOnLoaded(v)
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

	if GameHelper.isWithBundle == false then 
		fn_callback()
		return 
	end 

	if rm.loadedBundleCache == nil then 
		fn_callback()
		return;
	end 

	if szFiles == nil then 
		fn_callback()
		return 
	end 

	if #szFiles == 0 then 
		fn_callback()
		return 
	end 

	local m_asset = nil 

	for i=1,#szFiles do
		m_asset = szFiles[i]
		if m_asset ~= nil and m_asset ~= "" then 
			--whether this bundle has been loaded 
			if rm.loadedBundleCache[m_asset] == nil then 
				local bundle = rm:LoadBundleFromFile(m_asset)
				if bundle == nil then 
					LogError("Load asset failure " .. m_asset)
				else
					bundle:LoadAllAssets()
					rm.bundleReferenceMap[m_asset] = 1
				end
			else 
				rm.loadedBundleCache[m_asset]:LoadAllAssets()
			end 
		end 
	end 
	fn_callback();
end

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
		
			if true == rm:isLoadFromBundle() then 
				if rm:isInAssetToBundleMap(assetPath) == true then 
					local bundlePath = rm.assetToBundleMap[assetPath]
					local assetBundle = nil
					for k,v in pairs(rm.loadedBundleCache) do 
						if k == bundlePath then 
							assetBundle = rm.loadedBundleCache[bundlePath]
							break
						end 
					end 
					
					if assetBundle == nil then 
						assetBundle = rm:LoadBundleFromFile(bundlePath)
					end 

					local fileName = GameHelper.GetFileName(assetPath)
					if assetBundle ~= nil then 	
						local fileType = GameHelper.GetAssetType(assetType)
						asset = assetBundle:LoadAsset(fileName, fileType);
						if asset == nil then 
							assetBundle:LoadAllAssets()
							LogError("direct load:: missed asset " .. assetPath .. " in " .. bundlePath);
						else 
							rm:UpdateBundleReference(bundlePath,1)
						end
						
						luaAsset = LuaAsset.new(assetPath, asset)
						rm.loadedLuaAsset[#rm.loadedLuaAsset +1] = luaAsset
					else 	
						LogError("missed bundle which includes asset :: " .. assetPath)
						luaAsset = LuaAsset.new(assetPath, asset)
						rm.loadedLuaAsset[#rm.loadedLuaAsset +1] = luaAsset
					end 
					
				else 
					LogError("missed bundle which includes asset :: " .. assetPath)
					luaAsset = LuaAsset.new(assetPath, asset)
					rm.loadedLuaAsset[#rm.loadedLuaAsset +1] = luaAsset
				end 
			else 
				luaAsset =  rm:LoadFromEditorDatabase(assetType, assetPath, fnOnLoaded)		
			end
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

--[[
	async load asset from bundle. if bundle has not been loaded, will automatic load it
	we use real async load of unity engine, not coroutine
]]
function rm.LoadAssetAsync(assetType, szFile, fnOnLoaded)
	if szFile == nil or szFile == "" then 
		LogError("LoadAssetAsync:: invalid file path")
		if fnOnLoaded ~= nil then	 
			fnOnLoaded(nil)
		end 
		return
	end 
	local szFiles = {szFile}
	rm:LoadAssetAsync_s(assetType, szFiles, fnOnLoaded);
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

function rm:LoadAssetAsync_s(assetType, szFiles, fnOnLoaded)
	local count = #szFiles
	local objs = {}
	local bLoaded = false 
	local queueItem = {}
	
	local bLoadFromBundle = rm:isLoadFromBundle()
	if bLoadFromBundle then 
		queueItem.fnOnLoaded = fnOnLoaded
		queueItem.asyncReqs = {}
		queueItem.objs = {}
		queueItem.bCompleted = false
	end

	for k,v in pairs(szFiles) do 
		local szFile = v 
		local assetPath = String(szFile)
		assetPath = assetPath:Replace("\\","/");
		bLoaded = false 
		for _,v in ipairs(rm.loadedLuaAsset) do 
			if v:GetAssetPath() == assetPath then 
				if fnOnLoaded ~= nil then 
					v:Clone()
					queueItem.objs[#queueItem.objs + 1] = v
					--fnOnLoaded(v)
					bLoaded = true
					break
				end 
			end 
		end 

		if bLoaded  == false then 
		
			if true == bLoadFromBundle then 
				if rm:isInAssetToBundleMap(assetPath) == true then 
					local bundlePath = rm.assetToBundleMap[assetPath]
					local assetBundle = nil
					for k,v in pairs(rm.loadedBundleCache) do 
						if k == bundlePath then 
							assetBundle = rm.loadedBundleCache[bundlePath]
							break
						end 
					end 
					
					local asset = nil 
					if assetBundle == nil then 
						assetBundle = rm:LoadBundleFromFile(bundlePath)
					end 
					
					local asset = nil
					local fileName = GameHelper.GetFileName(assetPath)
					if assetBundle ~= nil then 			
						local fileType = GameHelper.GetAssetType(assetType)
						if fileType == nil then 
							LogError("Invalid asset type " .. tostring(assetType))
						else 
							local asyncReq = assetBundle:LoadAssetAsync(fileName,fileType);
							local tmpReq = {}
							tmpReq.asyncReq = asyncReq
							tmpReq.assetPath = assetPath
							tmpReq.bundlePath = bundlePath
							queueItem.asyncReqs[#queueItem.asyncReqs+1] = tmpReq
						end 
					end 
				end 
			else 
				local asset = GameHelper.LoadAsset_Editor(szFile, assetType);
				local luaAsset = LuaAsset.new(szFile, asset)
				objs[#objs+1] = luaAsset
				if asset ~= nil then 			
					rm.loadedLuaAsset[#rm.loadedLuaAsset + 1] = luaAsset 
				end 
			end 
		end 
	end

	if true == bLoadFromBundle then 
		if #queueItem.asyncReqs > 0 or #queueItem.objs > 0 then 
			async_load_queue[#async_load_queue+1] = queueItem 
		else 
			for _,v in ipairs(szFiles) do 
				LogError("async load:: missed asset:: " .. v)
			end
			queueItem.asyncReqs = nil 
			queueItem.objs = nil 
			queueItem = nil
		end 
	else
		if fnOnLoaded ~= nil then 
			if count == 1 then 
				fnOnLoaded(objs[1])
			else 
				fnOnLoaded(objs)
			end 
		end 
	end
	
end 

--whether assets is in asset to bundle map??
function rm:isInAssetToBundleMap(szFile)
	if rm.assetToBundleMap == nil then 
		LogError("asset to bundle map is nil " )
		return false
	end

	if rm.assetToBundleMap[szFile] ~= nil then 
		return true 
	end 
	return false
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
 
--force unload bundle
function rm.UnloadBundle(inBundle)
	if rm.loadedBundleCache == nil then 
		LogError("ResourceManager is not inited ")
		return 
	end 
	if inBundle == nil or inBundle == "" then 
		return;
	end 
	
	local bExist = false;
	for k,v in pairs(rm.loadedBundleCache) do 
		if k == inBundle then 
			bExist = true;
			break;
		end
	end 
	
	if bExist then 
		rm.bundleReferenceMap[inBundle] = 0
		rm.bundleReferenceMap[inBundle] = nil
		rm.loadedBundleCache[inBundle]:Unload(true)
		rm.loadedBundleCache[inBundle] = nil
	else 
		LogWarning("Failed to unload bundle:: " .. inBundle)
	end 
end 

function rm.UnloadAsset(szFile)
	for k,v in ipairs(rm.loadedLuaAsset) do 
		if v:GetAssetPath() == szFile then 
			v:Free()
			break
		end 
	end 
end 

--unload asset. in here we will not real unload asset. only decrease bundle reference
function rm.UpdateAssetReference(szFile,referCount,bRemove)

	if bRemove == true and rm.loadedLuaAsset ~= nil then
		 for k,v in ipairs(rm.loadedLuaAsset) do 
			if v:GetAssetPath() == szFile then 
				rm.loadedLuaAsset[k] = nil
				break
			end 
		end 
	end 

	if GameHelper.isWithBundle then 
	 	if rm.assetToBundleMap == nil then 
			return;
		end 
		if rm:isInAssetToBundleMap(szFile) == true then 
			local bundlePath = rm.assetToBundleMap[szFile]
			rm:UpdateBundleReference(bundlePath,referCount)
		end 
	end
end 

--update bundle reference
function rm:UpdateBundleReference(inBundle,referCount)
	if rm.bundleReferenceMap == nil then 
		LogError("ResourceManager is not inited ")
		return 
	end 
	
	local bExist = false;
	for k,v in pairs(rm.bundleReferenceMap) do 
		if k == inBundle then 
			bExist = true;
			break;
		end
	end 
	
	if bExist then 
		local oginalValue = rm.bundleReferenceMap[inBundle]
		oginalValue = oginalValue + referCount;
		if oginalValue <= 0 then 
			oginalValue = 0;
			
			rm.bundleReferenceMap[inBundle] = nil
			if GBC.isCommonBundle(inBundle) == false then 
				local tmpBundle = rm.loadedBundleCache[inBundle]
				--LogWarning("Unloading bundle " .. inBundle)
				tmpBundle:Unload(true)
				rm.loadedBundleCache[inBundle] = nil
			end 
			return
		end 
		rm.bundleReferenceMap[inBundle] = oginalValue
	else 
		if referCount > 0 then 
			rm.bundleReferenceMap[inBundle] = referCount;
		else 
			LogWarning("File " .. inBundle  .. " is not in reference map. Cant be decrease")
		end 
	end 
end

--FixedUpdate::we will unload bundle in here. do not remove it
function rm.FixedUpdate()
	if rm.bInited == false then 
		return
	end 
			
end 

function rm.Update()
	if rm.bInited == false then 
		return
	end 

	if async_load_queue ~= nil then 
		
		local count = 0
		local luaAsset = nil 
		local async_req = nil 
		for k,v in ipairs(async_load_queue) do 
			if v  then 
				count = #v.asyncReqs
				local bLoadedAll = true
				
				for i=1, count do 
					if v.asyncReqs[i].asyncReq.isDone == false then 
						bLoadedAll = false 
						break
					end 
				end 

				--try to create lua assset
				if bLoadedAll then 
					for kr,info in ipairs(v.asyncReqs) do 
						if info then 
							luaAsset = LuaAsset.new(info.assetPath, info.asyncReq.asset)
							
							if info.asyncReq.asset ~= nil then 					
								rm:UpdateBundleReference(info.bundlePath,1)			
								rm.loadedLuaAsset[#rm.loadedLuaAsset +1] = luaAsset
							else 
								LogError("Failed to load " .. info.assetPath)
							end
							v.objs[#v.objs+1] = luaAsset
						end 
						v.asyncReqs[kr] = nil
					end 					
				end 

				--invoke call back
				if bLoadedAll then 
					
					if v.bCompleted == false then 
						v.bCompleted = true
						if #v.objs == 1 then 
							v.fnOnLoaded(v.objs[1])
						else 
							v.fnOnLoaded(v.objs)
						end
					end 
					v.objs = nil
					v.asyncReqs = nil
					
				end
			
			else 
				v.bCompleted = true
			end 
		end 

		for i=#async_load_queue, 1, -1 do 
			local info = async_load_queue[i]
			if info and info.bCompleted then 
				table.remove(async_load_queue, i)
			end 
		end
		
	else
		--[[if #requestQueue>0 then
	
			local nextreq = requestQueue[#requestQueue]
			table.remove(requestQueue)
			rm:LoadAsset_s(nextreq.assetType, nextreq.szFile, nextreq.fnOnLoaded)
		end]]
	end
end 

function rm.OnDestroy()
	if rm.bInited == false then 
		return
	end
end 


return rm