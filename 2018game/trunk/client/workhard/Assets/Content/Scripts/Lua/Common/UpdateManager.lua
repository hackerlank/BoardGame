-----------------------------------------------------------------------------
--UpdateManager:: 
--  update all contents of game, include the all game logic.
-----------------------------------------------------------------------------

local UpdateManager = UpdateManager or {}

--record update progress
UpdateManager.state = EUpdateStatus.EUS_Started

--which bundle is downloading
UpdateManager.currentDownload = nil

--cache all downloaded bundles
UpdateManager.successDownload = ListBundleSmallData()

--cache all bundle that will be downloaded
UpdateManager.allNeedDownload = ListBundleSmallData()

--Whether need to check apk update state. Defualt:: do not check apk
UpdateManager.bCheckAPKState=false

--current update mode. Default:: online
UpdateManager.updateMode=EBundleUpdateMode.EBUM_OnLine

--save the compressed amount of all bundle files which will be updated at once
UpdateManager.totalFileSize=0.0

--save the uncompress amount of all bundle files which will be updated at once
UpdateManager.totalUncompressSize=0.0

--save the avaliable disk space of devices
UpdateManager.avaliableDiskSpace=0.0

--save net state
UpdateManager.netType = ENetConnectivityType.ENT_Invalid

--save update starting time 
UpdateManager.updateStartTime=0.0

--whether failed to update game 
UpdateManager.bUpdateFailure=false

--update time limit
UpdateManager.UPDATE_TIME_OUT=200.0

--whether nerver uncompress bundle
UpdateManager.bIsDecompressing=true

--cache the download progress
UpdateManager.progressCache = 0.0

--save update status file path
UpdateManager.backupStatus=""

--save old state
UpdateManager.oldState = nil

UpdateManager.bInited = false

local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

local DEFINED_DECOMPRESS_TIP = "解压资源："
local DEFINED_CHECKING_TIP = "检查更新..."
local DEFINED_DOWNLOADING_TIP = "下载更新包："
local DEFINED_INSTALLING_TIP = "安装更新包"
local DEFINED_UPDATED = "更新完成"
--component main entrance
function UpdateManager.Init()
	
	if UpdateManager.bInited then 
		return
	end 
	
	UpdateManager.bInited = true
	Log("Init lua update manager...")
	
	local downloader = GetDownloadManager()
	if downloader == nil then 
		LogError("Whether we have missed DownloadManager lua scirpt?")
	end
	
	--save the download manager instance object
	UpdateManager.downloader = downloader
	
	local luaGameManager = GetLuaGameManager()
	luaGameManager.RegisterManager(UpdateManager, LUA_UPDATE_MANAGER)
	
	--init update environment begin
	--init update state
	UpdateManager.state = EUpdateStatus.EUS_Started

    if GameHelper.isWithBundle then
        UpdateManager.updateStartTime = UnityEngine.Time.time
    else
        
    end 

    UpdateManager.bUpdateFailure = false
    UpdateManager.allNeedDownload:Clear()
    UpdateManager.successDownload:Clear()
    UpdateManager.totalFileSize=0.0
    UpdateManager.totalUncompressSize=0.0
    UpdateManager.bIsDecompressing = true
    UpdateManager.backupStatus = CustomTool.FileSystem.bundleLocalPath ..  "/UpdateBackup.txt"
	UpdateManager.facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    --init update environment end
end 

--start update manager.
function UpdateManager.StartUpdate() 
	--show update ui
	if nil ~= ui_update then 
		ui_update.gameObject:SetActive(true)
	end 

	UpdateManager.avaliableDiskSpace = MobileDevicesInterface.AvailableDiskSize()

    if GameHelper.runtimePlatform == BuildPlatform.Standalones then 		 
        UpdateManager.PreUpdate()
    else
        UpdateManager.netType = MobileDevicesInterface.GetNetConnectivityType()
        if UpdateManager.netType == ENetConnectivityType.ENT_Invalid then 
            --show tip content
           LogError("invalid net connection. please check it");
        else
           UpdateManager.PreUpdate()
        end 
    end

end 

--determine all contents that will be updated before really execution updating operation
function UpdateManager.PreUpdate()
	local preUpdateCoroutine = coroutine.create(function()
		local filePath = ""
		local bNeedDecompress = true

		--download the decompress file from update server if cooked game with USE_BUNDLE macro
		if GameHelper.isWithBundle then 
			local streamingPath =  CustomTool.FileSystem.GetStreamingPath() 
			filePath = streamingPath .. DECOMPRESS_BUNDLE_FILE
			local www = UnityEngine.WWW(filePath)
			local bundleDecompress = nil
			UnityEngine.Yield(www)
			if(www.error == nil) then
				bundleDecompress = www.text;
				if bundleDecompress ~= nil then 
					if UnityEngine.PlayerPrefs.HasKey("BundleDecompress") then 
						if bundleDecompress == UnityEngine.PlayerPrefs.GetString("BundleDecompress") then 
							bNeedDecompress = false
						end 
					end 
				end 
			else
				bNeedDecompress = false
			end

			if bNeedDecompress then 
				--decompress bundle manager file
				Log("Decompress bundles...............")
				local bCompressedBundle = GameHelper.isCompressedBundle
				if UpdateManager.facade ~= nil then 
					UpdateManager.facade:sendNotification(Common.SET_UPDATE_TIPS, DEFINED_DECOMPRESS_TIP)
					UpdateManager.facade:sendNotification(Common.SET_UPDATE_PROGRESS, {cur=0, max=1} )
				end 
				local BuildStates = ListBundleSmallData()
				local success_decompress = ListBundleSmallData()
				filePath = streamingPath .. BUNDLE_MANAGER_FILE
				www = UnityEngine.WWW(filePath)
				UnityEngine.Yield(www)
				if www.error ~= nil then 
					LogError("can not find the bm.data file. test version??")
				else 
					if bCompressedBundle then 
						GameHelper.Decompress(BUNDLE_MANAGER_FILE, www);
					else 
						CustomTool.FileSystem.ReplaceFileBytes(CustomTool.FileSystem.bundleLocalPath .. "/" .. BUNDLE_MANAGER_FILE, www.bytes)
					end
					--read bundle manager file
					BuildStates = GameHelper.GetBundleBuildStates(CustomTool.FileSystem.bundleLocalPath .. "/" .. BUNDLE_MANAGER_FILE)
					www:Dispose()
					www = nil
				end 
				
				--count uncompress size of bundles
				for i = 1, BuildStates.Count do
					local item = BuildStates:getItem(i-1)
					if item.name ~= "lua_common.u" and item.name ~= "lua_puremvc.u" then 
						UpdateManager.totalFileSize = UpdateManager.totalFileSize + item.compressedSize
						UpdateManager.totalUncompressSize = UpdateManager.totalUncompressSize + item.size
					else 
						--LogWarning("skip decompress " .. item.name)
					end
				end 
				
				--real uncompress all bundles
				local bCanDecompress = GameHelper.isEditor or (GameHelper.isEditor == false and UpdateManager.totalUncompressSize <= UpdateManager.avaliableDiskSpace)
				local decompressFileSize = 0
				if bCanDecompress then 
					--@todo need to fresh ui
					local path = nil
					local item = nil 
					local bundleName = nil 
					if BuildStates ~= nil then
						for i=1, BuildStates.Count do
							item = BuildStates:getItem(i-1)
							bundleName = item.name
							if bundleName ~= "lua_common.u" and bundleName ~= "lua_puremvc.u" then 
								local realUrl = streamingPath .. bundleName
								local tmpBundle = UnityEngine.WWW(realUrl)
								UnityEngine.Yield(tmpBundle)

								if true == bCompressedBundle then
									decompressFileSize = decompressFileSize + item.compressedSize
								else
									decompressFileSize = decompressFileSize + item.size
								end 

								if tmpBundle.error ~= nil then 
									--LogError("can not load bundle from local::" .. realUrl)							
								else 	
									if true == bCompressedBundle then
										GameHelper.Decompress(bundleName, tmpBundle);
									else
										path = CustomTool.FileSystem.bundleLocalPath .. "/" .. bundleName
										CustomTool.FileSystem.ReplaceFileBytes(path, tmpBundle.bytes)
									end 								
									UpdateManager.facade:sendNotification(Common.SET_UPDATE_TIPS, DEFINED_DECOMPRESS_TIP .. bundleName)
									success_decompress:Add(item)
									tmpBundle:Dispose();
									tmpBundle = null;
								end 
								if true == bCompressedBundle then 
									UpdateManager.facade:sendNotification(Common.SET_UPDATE_PROGRESS, {cur = decompressFileSize, max = UpdateManager.totalFileSize} )
								else 
									UpdateManager.facade:sendNotification(Common.SET_UPDATE_PROGRESS, {cur = decompressFileSize, max = UpdateManager.totalUncompressSize} )
								end 
							else 
								success_decompress:Add(item)
							end

							UnityEngine.Yield(nil)
						end 
					end
					
					--save update state to local disk
					GameHelper.SaveUpdateState(UpdateManager.backupStatus, success_decompress)
					UpdateManager.bFirstUncompressing = false;
					UpdateManager.successDownload:Clear();
					UpdateManager.currentDownload = nil;   

					--record decompress state
					if bundleDecompress ~= nil then 
						UnityEngine.PlayerPrefs.SetString("BundleDecompress", bundleDecompress)
					end 
					UnityEngine.Yield(UnityEngine.WaitForSeconds(0.2)) 
				end 

				--@todo shut down update program, show disk space is not enough tips
				if GameHelper.isEditor == false and bCanDecompress == false then 
				end
			end --end bNeedDecompress
			
			--collect latest bundle info in local disk space
			local tmpState = ListBundleSmallData()
			UpdateManager.oldState = {}
			tmpState = GameHelper.GetBundleBuildStates(UpdateManager.backupStatus)
			
			for i=1, tmpState.Count do
				local bExists = false
				for k,v in ipairs(UpdateManager.oldState) do 
					if v.name == tmpState:getItem(i-1) then 
						bExists = true
						break
					end 
				end 

				if bExists == false then 
					UpdateManager.oldState[#UpdateManager.oldState + 1] = tmpState:getItem(i-1)
				end 
			end 

			if UpdateManager.updateStartTime == 0.0 then 
				UpdateManager.updateStartTime = UnityEngine.Time.time
			end

			if UpdateManager.facade ~= nil then 
				UpdateManager.facade:sendNotification(Common.SET_UPDATE_TIPS, DEFINED_CHECKING_TIP)
				UpdateManager.facade:sendNotification(Common.SET_UPDATE_PROGRESS, {cur=0, max=1} )
			end 

			while UpdateManager.downloader.ConfigLoaded() == false do       
				if UnityEngine.Time.time - UpdateManager.updateStartTime >= UpdateManager.UPDATE_TIME_OUT then 
					--ApplicationFacade.Instance.SendNotification(ApplicationCommandDef.OPEN_CHECK_TIP_MENU, 3);   
					UnityEngine.Yield(nil)  --should us break 
					LogError("Failed to download bundel info from server")
				end 
				UnityEngine.Yield(UnityEngine.WaitForSeconds(0.2)) 
			end

			--count all bundle that need to be updated at moment
			local serverBuildState = UpdateManager.downloader.GetServerBuildState()
			UpdateManager.totalFileSize = 0
			UpdateManager.totalUncompressSize = 0;
			local bClientHasOldVersion = true
			local max_count = 1
			local checked_count = 0
			if GameHelper.isSkipUpdate == false then 
				if serverBuildState ~= nil then 
					max_count = serverBuildState.Count
					for i=1, serverBuildState.Count do
						local serverBundle = serverBuildState:getItem(i-1)
						--skip lua_common.u
						--Log("serverBundle.name=" .. serverBundle.name)
						bClientHasOldVersion = GBC.IsCanUpdate(serverBundle.name)
				 
						if serverBundle.name ~= "lua_common.u" and serverBundle.name ~= "lua_puremvc.u" and bClientHasOldVersion == true then 
							local localBundle = nil
							for k,v in ipairs(UpdateManager.oldState) do 
								if v.name == serverBundle.name then 
									localBundle = v
									break
								end  
							end  

							
							local bUpdate = false
							if localBundle == nil then 
								bUpdate = true
							else
								--Log("localBundle.bundleHashCode=" .. localBundle.bundleHashCode .. " serverBundle.bundleHashCode=" .. serverBundle.bundleHashCode)
								if localBundle.bEncrypt ~= serverBundle.bEncrypt or localBundle.bundleHashCode ~= serverBundle.bundleHashCode then 
									bUpdate = true
								end 
							end 
							
							if bUpdate then 
								UpdateManager.totalFileSize = UpdateManager.totalFileSize + serverBundle.compressedSize
								UpdateManager.totalUncompressSize = UpdateManager.totalUncompressSize + serverBundle.size
								UpdateManager.allNeedDownload:Add(serverBundle)
								--Log("need update:: " .. serverBundle.name)
							else 
								UpdateManager.successDownload:Add(serverBundle)
								--LogWarning("Skip update:: " .. serverBundle.name)
							end 
							checked_count = checked_count + 1 
						else 
							max_count = max_count - 1		 	
						end 
						UpdateManager.facade:sendNotification(Common.SET_UPDATE_PROGRESS, {cur=checked_count, max=max_count} )
						UnityEngine.Yield(UnityEngine.WaitForSeconds(0.06))	
					end 
				end --count end
			else 
				for i=1,10 do 
					UpdateManager.facade:sendNotification(Common.SET_UPDATE_PROGRESS, {cur=i, max=10} )
					UnityEngine.Yield(UnityEngine.WaitForSeconds(0.03))
				end 
			end 

		end --end isWithBundle
		
		UpdateManager.bIsDecompressing = false
		GameHelper.GC();
		local doUpdateWWW = nil;
		if GameHelper.isEditor then 
			UpdateManager.DoUpdate()
		else 
			if GameHelper.runtimePlatform == BuildPlatform.IOS or GameHelper.runtimePlatform == BuildPlatform.Android then 
				UpdateManager.DoUpdate()
			else 
				UpdateManager.DoUpdate()
			end 
		end 
	end
	)
	
	coroutine.resume(preUpdateCoroutine)
end

--real update game content
function UpdateManager.DoUpdate()

	local need_download = 1
	local downloaded = 0
	local doUpdateCoroutine = coroutine.create(function()
	
		UpdateManager.state = EUpdateStatus.EUS_Updating
		for i=1, UpdateManager.allNeedDownload.Count do 
			local item = UpdateManager.allNeedDownload:getItem(i-1)
			local updateBundle = item.name
			UpdateManager.currentDownload = item
			--notify downloadManger download bundle
			UpdateManager.downloader.WaitDownload(updateBundle)
			
			--force wait one frame
			UnityEngine.Yield(0.06)
			local bDownloading = UpdateManager.downloader.isDownloading(updateBundle)		
			while bDownloading do  
				UnityEngine.Yield(UnityEngine.WaitForSeconds(0.03))
				bDownloading = UpdateManager.downloader.isDownloading(updateBundle)	
			end 

			local content = UpdateManager.downloader.GetWWW(updateBundle)
			
			if content == nil then
				UpdateManager.bUpdateFailure = true
				LogError("Failed to download:: " .. updateBundle)
				break
			end 
			
			if content.error ~= nil then 
				UpdateManager.bUpdateFailure = true
				LogError("Failed to download:: " .. updateBundle)
				break
			else 
				UpdateManager.successDownload:Add(item);
				local bCompressedBundle = GameHelper.isCompressedBundle
				if true == bCompressedBundle then 
					GameHelper.Decompress(updateBundle, content);
				else
					CustomTool.FileSystem.ReplaceFileBytes(CustomTool.FileSystem.bundleLocalPath .. "/" .. updateBundle, content.bytes)
				end 
				GameHelper.SaveUpdateState(UpdateManager.backupStatus, UpdateManager.successDownload)
			end 
			
			if content ~= null and content.assetBundle ~= nil then  content.assetBundle:Unload(true) end 
			--UpdateManager.downloader.DisposeWWW(updateBundle);
		end 
		
		UpdateManager.currentDownload = nil
		GameHelper.SaveUpdateState(UpdateManager.backupStatus, UpdateManager.successDownload)
		
		if UpdateManager.bUpdateFailure then 
			--@todo show tips
		else 
			UpdateManager.OnUpdateFinshed();
		end 
	end
	)
	coroutine.resume(doUpdateCoroutine)
end 

--Get backup bundle build state
function UpdateManager.GetOldStates()
	return UpdateManager.oldState
end 

--Update Finished 
function UpdateManager.OnUpdateFinshed()
 
	UpdateManager.downloader.DisposeAll();
	Log("Update Finished")
	if ui_update ~= nil then 
		ui_update:SetUpdateState("Launching game, please wait")
	end
	UpdateManager.facade:sendNotification(Common.SET_UPDATE_TIPS, DEFINED_UPDATED)
	UpdateManager.successDownload:Clear()
	UpdateManager.successDownload = nil
	UpdateManager.allNeedDownload:Clear()
	UpdateManager.allNeedDownload = nil
	GameHelper.GC();
	UpdateManager.state = EUpdateStatus.EUS_Finished;	
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	if nil ~= facade then 
		facade:sendNotification(Common.UPDATE_FINISHED)
	end
end

--Update is called once per frame
function UpdateManager.Update()
	if UpdateManager.bIsDecompressing == false then 
		if UpdateManager.netType ~= ENetConnectivityType.ENT_Invalid and UpdateManager.netType ~= ENetConnectivityType.ENT_MAX then 
			if UpdateManager.currentDownload == nil then return end 
			
			local tmpBundles = {}

			for i=1, UpdateManager.allNeedDownload.Count do 
				tmpBundles[#tmpBundles+1] = UpdateManager.allNeedDownload:getItem(i-1).name .. GameHelper.BUNDLE_FILENAME_EXTENSION
			end 
	
			local curSize, totalSize, progress = UpdateManager.downloader.ProgressOfBundles(tmpBundles);--table as parameter
			
			if UpdateManager.facade == nil then return end 

			local size_mb = 1024 * 1024
			local curMB = GetPreciseDecimal( curSize / size_mb, 2)			
			local totalMB = GetPreciseDecimal( totalSize / size_mb, 2)
			UpdateManager.facade:sendNotification(Common.SET_UPDATE_TIPS, DEFINED_DOWNLOADING_TIP .. curMB .. " / " .. totalMB .. " MB")
			UpdateManager.facade:sendNotification(Common.SET_UPDATE_PROGRESS, {cur = curMB, max = totalMB} )
		end 
		
	end 
end 



--free memory in OnDestroy function
function UpdateManager.OnDestroy()
	UpdateManager.bInited = false
end 

return UpdateManager