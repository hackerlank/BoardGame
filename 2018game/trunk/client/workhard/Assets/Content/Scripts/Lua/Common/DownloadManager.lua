-----------------------------------------------------------------------------
--DownloadManager:: 
--  download bundles
-----------------------------------------------------------------------------
local DownloadManager = DownloadManager or {}

--bundle manager url instance object
DownloadManager.bmUrl = nil

--manual url
DownloadManager.manualUrl = ""

--cache download root url
DownloadManager.downloadRootUrl = nil

--whether inited the root url
DownloadManager.bInitUrl = false

--download dependency file max times
DownloadManager.RETRY_DOWNLOAD_MAX = 20

--download dependency file times
DownloadManager.retryCount = 0

--download bundle retry limit
DownloadManager.downloadRetryTime = 10

--download thread count
DownloadManager.downloadThreadsCount = 1

-- saved all requests 
--requests which has completed:: table<string, WWWRequest>
DownloadManager.successRequest = nil

--requests which is being deal:: table<string, WWWRequest>
DownloadManager.processingRequest = {}

--failure requests:: table<string, WWWRequest>
DownloadManager.failureRequest = nil

--waiting requests:: List<WWWRequest>
DownloadManager.waitingRequest = ListWWWRequest()

--request before inited download manager:: List<WWWRequest>
DownloadManager.requestedBeforeInit = nil

--save downloaded bundles  table<name,bundle>
DownloadManager.bundleDic = nil

--save all bundle build state
DownloadManager.allBundles = nil

--bundle manager configuration file title
DownloadManager.BUNDLE_MANAGER_CONFIG_FILE="bm.data"

DownloadManager.bInited = false

local tb_downloading_game = nil 
local cor_download_game = nil
local size_mb = 1024 * 1024

--Log functions
local Log = UnityEngine.Debug.Log
local LogError = UnityEngine.Debug.LogError
local LogWarning = UnityEngine.Debug.LogWarning

local facade = nil 

--component main entrance
function DownloadManager.Init()
	if DownloadManager.bInited then 
		return 
	end
	
	Log("Init lua download manager...")

	if DownloadManager.bmUrl == nil then 
		DownloadManager.bmUrl = DownloadHelper.Instance.bmUrl;
		DownloadManager.downloadRootUrl = DownloadHelper.Instance.downloadRootUrl;
	end 
	facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	
	local luaGameManager = GetLuaGameManager()
	luaGameManager.RegisterManager(DownloadManager, LUA_DOWNLOAD_MANAGER)
	
	DownloadManager.failureRequest = nil 
	DownloadManager.failureRequest = {}
	
	DownloadManager.successRequest = nil 
	DownloadManager.successRequest = {}
	
	DownloadManager.processingRequest = nil
	DownloadManager.processingRequest = {}
	tb_downloading_game = {}
	DownloadManager.bInited = true
	DownloadManager:LoadBundleConfiguration();
end 

--Load bundle configuration file from update server or local disk space
--@TODO need do more operation in here. such as check bundle version, apk etc.
function DownloadManager:LoadBundleConfiguration()
	if GameHelper.isWithBundle then 
		
		local initCoroutine = coroutine.create(function()

			local bmDataUrl = "";
			if GameHelper.isSkipUpdate == true then 
				bmDataUrl = CustomTool.FileSystem.GetStreamingPath()  .. DownloadManager.BUNDLE_MANAGER_CONFIG_FILE
			else
				bmDataUrl =  DownloadManager:FormatUrl(DownloadManager.BUNDLE_MANAGER_CONFIG_FILE);
			end 
			--current download from server directly
			local bmWWW = nil;
			while DownloadManager.retryCount < DownloadManager.RETRY_DOWNLOAD_MAX do 
				bmWWW = UnityEngine.WWW(bmDataUrl);
				UnityEngine.Yield(bmWWW);

				if  bmWWW.error == nil then 		 
					break;
				else
					LogError("Download BMData failed.\nError: " .. bmWWW.error);
					DownloadManager.retryCount = DownloadManager.retryCount + 1;
					UnityEngine.Yield(UnityEngine.WaitForSeconds(2.0))
				end 
			end 
			
			if DownloadManager.retryCount >= DownloadManager.RETRY_DOWNLOAD_MAX then 
				LogError("Failed to download bmdata file from server");
			else 
				local path = CustomTool.FileSystem.bundleLocalPath .. "/" .. DownloadManager.BUNDLE_MANAGER_CONFIG_FILE
				if true == GameHelper.isCompressedBundle then 
					GameHelper.Decompress(DownloadManager.BUNDLE_MANAGER_CONFIG_FILE, bmWWW)
				else 
					CustomTool.FileSystem.ReplaceFileBytes(path,bmWWW.bytes)
				end 
				DownloadManager.allBundles = GameHelper.GetBundleBuildStates(path)
				if DownloadManager.allBundles == nil then 
					LogError("invalid " .. path)
				else 
					DownloadManager.bundleDic = nil 
					DownloadManager.bundleDic = {}
					for idx=1, DownloadManager.allBundles.Count do 
						local tmp = DownloadManager.allBundles:getItem(idx-1)
						DownloadManager.bundleDic[tmp.name] = tmp
						--Log("Registered " .. tmp.name)
					end 
					
					if bmWWW ~= nil then 
						bmWWW:Dispose();
						bmWWW = null;
					end
					
					--Start download for requests before init
					if DownloadManager.requestedBeforeInit ~= nil then 
						for key,request in pairs(DownloadManager.requestedBeforeInit) do 
							DownloadManager:RealDownload(request)
						end 
					end 
				end 
			end 
		end
		)
		coroutine.resume(initCoroutine)
	else 
		LogWarning("[DownloadManager]::APP without bundle macro")
	end 

end 

--Whether has download bundle configuration file from update server
function DownloadManager.ConfigLoaded()
	if DownloadManager.allBundles ~= nil  then 
		return true
	end 
	return false
end

--dispose all 
function DownloadManager.DisposeAll()
	DownloadManager.requestedBeforeInit = nil
	DownloadManager.waitingRequest:Clear()
	
	if DownloadManager.processingRequest ~= nil then 
		for k,v in pairs(DownloadManager.processingRequest) do  
			v.www:Dispose();
		end
	end
			
	DownloadManager.processingRequest=nil;
	
	Log("DisposeAll")
	
	if DownloadManager.successRequest ~= nil then 
		for k,v in pairs(DownloadManager.successRequest) do
			if v.www.assetBundle ~= nil then 
				v.www.assetBundle:Unload(true)
			else
				--LogWarning("No Bundle When Unload..." .. v.url);
			end 
			
			v.www:Dispose()
		end
	end 
	
	--free memory
	DownloadManager.successRequest = nil
end 

--Whether bundle was included in configuration file
function DownloadManager.IsBundleInBM(bundleName)
	for k,v in pairs(DownloadManager.bundleDic) do 
		if k == bundleName then 
			return true
		end 
	end 
	return false
end

--wait download with url as parameter
function DownloadManager.WaitDownload(url)
	local wait = coroutine.create(function()
		local result =  DownloadManager.WaitDownload_s(url,-1)
		UnityEngine.Yield(result)
	end
	)
	
	coroutine.resume(wait)
end 

--wait download with url and priority as parameters
function DownloadManager.WaitDownload_s(url, priority)
	local wait = coroutine.create(function() 
		while DownloadManager.ConfigLoaded == false do 
			UnityEngine.Yield(nil)
		end 
		
		local request = WWWRequest();
		request.requestString = url;
		local formatedUrl = DownloadManager:FormatUrl(url);
		request.url = formatedUrl;
		request.priority = priority;
		DownloadManager:RealDownload(request);
		
		while DownloadManager:IsDownloading(formatedUrl) == true do
			UnityEngine.Yield( UnityEngine.WaitForSeconds(0.03))
		end 
	end
	)
	coroutine.resume(wait)
end 

function DownloadManager.isDownloading(url)
	local tmpurl = DownloadManager:FormatUrl(url)
	return DownloadManager:IsDownloading(tmpurl)
end 

--stop download
function DownloadManager.StopDownload(url)
	if DownloadManager.ConfigLoaded == false then 
		for k, v in pairs(DownloadManager.requestedBeforeInit) do 
			if k == url then 
				DownloadManager.requestedBeforeInit[k] = nil 
			end
		end 
				
	else 
		url = DownloadManager:FormatUrl(url)
		
		for i=DownloadManager.waitingRequest.Count, 1, -1 do 
			local tmp = DownloadManager.waitingRequest:getItem(i-1)
			if tmp.url == url then 
				DownloadManager.waitingRequest:RemoveAt(i-1)
			end 
		end 

		for k,v in pairs(DownloadManager.processingRequest) do 
			if k == url then 
				DownloadManager.processingRequest[k].www:Dispose()
				DownloadManager.processingRequest[k] = nil 
			end 
		end 
	end 
end 

--DisposeWWW
function DownloadManager.DisposeWWW(url)
	url = DownloadManager:FormatUrl(url);
	DownloadManager.StopDownload(url);
	
	for k,v in pairs(DownloadManager.successRequest) do 
		if k == url then 
			DownloadManager.successRequest[k].www:Dispose()
			DownloadManager.successRequest[k] = nil 
		end 
	end 
	
	for k,v in pairs(DownloadManager.failureRequest) do 
		if k == url then 
			DownloadManager.failureRequest[k].www:Dispose()
			DownloadManager.failedRequest[k] = nil
		end 
	end 
end 

--dispose www and unload bundle asset
function  DownloadManager.DisposeWWWAndUnloadBundle(url)
	url = DownloadManager:FormatUrl(url);
	DownloadManager.StopDownload(url);
	
	for k,v in pairs(DownloadManager.successRequest) do 
		if k == url then 
			if DownloadManager.successRequest[k].www.assetBundle ~= nil then 
				DownloadManager.successRequest[k].www.assetBundle:Unload(false)
			end 
			DownloadManager.successRequest[k].www:Dispose()
			DownloadManager.successRequest[k] = nil 
		end 
	end 
	
	for k,v in pairs(DownloadManager.failureRequest) do 
		if k == url then 
			DownloadManager.failureRequest[k].www:Dispose()
			DownloadManager.failedRequest[k] = nil
		end 
	end 
end 

--download bundle 
function DownloadManager.StartDownload(url)
	--default priority is -1
	DownloadManager.StartDownload_s(url, -1)
end 

--download bundles with 2 parameters
function DownloadManager.StartDownload_s(url,priority)	
	local request = WWWRequest();
	request.requestString = url;
	request.url = url;
	request.priority = priority;

	if DownloadManager.ConfigLoaded() == false then 	 
		if IsInBeforeInitList(url) == false then 
			if DownloadManager.requestedBeforeInit == nil then 
				DownloadManager.requestedBeforeInit = {}
			end 		
			local idx = #DownloadManager.requestedBeforeInit + 1
			DownloadManager.requestedBeforeInit[idx] = request
		end 	 
	else
		DownloadManager:RealDownload(request);
	end 
end 

--get downloading www 
function DownloadManager.GetWWW(url)
	if DownloadManager.ConfigLoaded == false then 
		return nil
	end 
	
	url =  DownloadManager:FormatUrl(url);
	
	if DownloadManager.successRequest ~= nil then 
		for k,v in pairs(DownloadManager.successRequest) do 
			if k == url then 
				return v.www;
			end 
		end
	end
	return nil
end 

--get download progress of bundles. parameter type is lua table,
function DownloadManager.ProgressOfBundles(bundlefiles)
	if DownloadManager.ConfigLoaded == false then 
		return 0.0
	end 

	local bundles = {}
	for k,v in ipairs(bundlefiles) do
		if  GameHelper.EndsWith(v, GameHelper.BUNDLE_FILENAME_EXTENSION) == true then 
			local bundlename = DownloadHelper.Instance:StripBundleSuffix(v)
			
			local bExist = false
			for key,value in ipairs(bundles) do 
				if bundles[key] == bundlename then 
					bExist = true 
					break
				end 
			end 
			
			--ensure only register it once
			if bExist == false then 
				bundles[#bundles + 1] = bundlename
			end 
		end 
	end 
	
	 
	local currentSize = 0;
	local totalSize = 0;
	local bCompressedBundle = GameHelper.isCompressedBundle
	for i=1, #bundles do 
		local tmpBundle = nil 
		for k,v in pairs(DownloadManager.bundleDic) do 
			if k == bundles[i] then 
				tmpBundle = DownloadManager.bundleDic[k]
				break
			end 
		end 
		
		if tmpBundle ~= nil then
			local tmpSize = 0
			if true == bCompressedBundle then 
				tmpSize = tmpBundle.compressedSize
			else 
				tmpSize = tmpBundle.size
			end 
			totalSize = totalSize + tmpSize
			
			local url = DownloadManager:FormatUrl(bundles[i])
			
			for k,v in pairs(DownloadManager.processingRequest) do 
				if k == url then 
					currentSize = currentSize + DownloadManager.processingRequest[k].www.progress * tmpSize
					break
				end 
			end 
			
			for k,v in pairs(DownloadManager.successRequest) do 
				if k == url then 
					currentSize = currentSize + tmpSize
				end 
			end 
			
			
		end 
	end 

	if totalSize == 0 then 
		return currentSize,totalSize,0
	else 
		return currentSize, totalSize, currentSize/totalSize
	end 

end

--
function DownloadManager.GetServerBuildState()
	return DownloadManager.allBundles;
end 

--really start downloading bundle
function DownloadManager:RealDownload(inRequest)
	inRequest.url = DownloadManager:FormatUrl(inRequest.url)
	
	--is downloading???
	if DownloadManager:IsDownloading(inRequest) == true then 
		return
	end 
	
	--has completed???
	for k,v in pairs(DownloadManager.successRequest) do 
		if k == inRequest.url then 
			return 
		end 
	end 
	
	--whether download bundle
	if DownloadHelper.Instance:IsBundleUrl(inRequest.url, "u") == true then 
		local bundleName = inRequest.requestString
		
		local bExists = false
		for key, value in pairs(DownloadManager.bundleDic) do 
			if key == bundleName then 
				bExists = true
				break
			end 
		end 
		
		if false == bExists then 
			LogError("Can not download " .. bundleName .. " configuration doesnt include it")
		else
			inRequest.bundleData = DownloadManager.bundleDic[bundleName]
			DownloadManager:RegisterIntoDownloadList(inRequest)
		end 
	else
		if inRequest.priority == -1 then 
			inRequest.priority = 0
		end 
		DownloadManager:RegisterIntoDownloadList(inRequest)
	end 
end 

--whether request has been registered into download list
function DownloadManager:IsInWaitingList(url)
	for i=1, DownloadManager.waitingRequest.Count do 
		local item = DownloadManager.waitingRequest:getItem(i-1)
		if item.url == url then 
			return true
		end 
	end 
	return false
end 



--register request
function DownloadManager:RegisterIntoDownloadList(req)
	for k,v in pairs(DownloadManager.successRequest) do 
		if k == req.url then 
			return
		end 
	end 
	
	if true == DownloadManager:IsInWaitingList(req.url)  then 
		return 
	end 
 
	--register it
	local insertPos=-1
	for i=1, DownloadManager.waitingRequest.Count do 
		local item = DownloadManager.waitingRequest:getItem(i-1)
		if item.priority < req.priority then 
			break
		end 	
		insertPos=i-1
	end 
	
	if insertPos == -1 then 
		insertPos = DownloadManager.waitingRequest.Count
	end 
	DownloadManager.waitingRequest:Insert(insertPos, req);
end 

--whether the request has been registered in cache list
function DownloadManager:IsInBeforeInitList(url)
	if DownloadManager.requestedBeforeInit == nil then 
		return false
	end 
	
	for i=1, #DownloadManager.requestedBeforeInit do 
		if DownloadManager.requestedBeforeInit[i].url == url then 
			return true
		end 
	end 
	return false	
end 

--whether is downloading 
function DownloadManager:IsDownloading(formatedUrl)
	if DownloadManager:IsInWaitingList(formatedUrl) == true then 
		return true
	end 
	
	if DownloadManager.processingRequest ~= nil then 
		for k,v in pairs(DownloadManager.processingRequest) do 
			if k == formatedUrl then 
				return true
			end 
		end 
	end
	
	return false
end 

--try to use backup update server
function DownloadManager:UseBackupDownloadUrls()
	DownloadHelper.Instance:UseBackupDownloadUrls()
	
	DownloadManager.downloadRootUrl = DownloadHelper.Instance.downloadRootUrl;
end 

--create url
function DownloadManager:FormatUrl(urlstr)
	return DownloadHelper.Instance:FormatUrl(urlstr);
end	

--get dependency bundles
function DownloadManager.GetDependList(bundle)

	if false == DownloadManager.ConfigLoaded then 	 
		LogError("getDependList() should be call after download manger inited");
		return nil;
	end 
	
	local tmpBundle = DownloadManager.bundleDic[bundle];
	if tmpBundle ~= nil then 
		return tmpBundle.parents;
	else 
		return nil
	end 
end 

--Update is called once per frame
function DownloadManager.Update()
	
	if DownloadManager.bInited == false or DownloadManager.ConfigLoaded == false then 
		return
	end 
	
	
	
	-- Check if any WWW is finished or errored
	local newFinished = {}
	local newFailure = {}
	if DownloadManager.processingRequest ~= nil then 
		for k,v in pairs(DownloadManager.processingRequest) do 
			if v.www.error ~= nil then 
				if (v.triedTimes - 1) < DownloadManager.downloadRetryTime then 
					v:CreatWWW()
				else 
					newFailure[#newFailure] = v.url
					LogError("Failed to download " .. v.url .. " after 10 times")
				end 			
			else 
				if v.www.isDone then 
					newFinished[#newFinished+1] = v.url
				end
			end 
		end
	end     
	
	-- Move complete bundles out of downloading list
	for k,v in ipairs(newFinished) do
		DownloadManager.successRequest[v] = DownloadManager.processingRequest[v]
		DownloadManager.processingRequest[v] = nil
	end 
	
	-- Move failed bundles out of downloading list
	for k,v in ipairs(newFailure) do 
		local bExist = false
		for fk,fv in pairs(DownloadManager.failureRequest) do 
			if v == fk then 
				bExist = true
				break
			end 
		end 
		if false == bExist then 
			DownloadManager.failureRequest[v] = DownloadManager.processingRequest[v]
		end 
		DownloadManager.processingRequest[v] = nil
	end 
	 
	
	-- Start download new bundles
	local idx = 0;
	while (DownloadManager.processingRequest == nil or #DownloadManager.processingRequest < DownloadManager.downloadThreadsCount) and
		   idx < DownloadManager.waitingRequest.Count do 
	 
		if DownloadManager.processingRequest == nil then 
			DownloadManager.processingRequest = {}
		end 
		
		local curRequest = DownloadManager.waitingRequest:getItem(idx)
		DownloadManager.waitingRequest:RemoveAt(idx);
		curRequest:CreatWWW();
		DownloadManager.processingRequest[curRequest.url] = curRequest			 
	end 

end 

--OnDestroy is called once when player switch map
function DownloadManager.OnDestroy()
	DownloadManager.bInited = false

end 

--FixedUpdate is called 
function DownloadManager.FixedUpdate()
	if DownloadManager.bInited == false then 
		return 
	end
end 

--update downloading progress of games
local function UpdateDownloadGameProg()
	local curSize, totalSize, progress = DownloadManager.ProgressOfBundles(tb_downloading_game[1].bundles)
	
	local curMB = GetPreciseDecimal( curSize / size_mb, 2)			
	local totalMB = GetPreciseDecimal( totalSize / size_mb, 2)

	facade:sendNotification(Common.UPDATE_DOWNLOADING_PROG,{gameType = tb_downloading_game[1].gameType, cur = curMB, max = totalMB})
end 

--real download game
local function _DownloadGame()
	cor_download_game = coroutine.create(function() 
		local downloading = nil
		local target_bundle = nil 
		local serverBuildState = DownloadManager.GetServerBuildState()
		local serverBundle = nil
		local backupStatus = CustomTool.FileSystem.bundleLocalPath ..  "/UpdateBackup.txt"
		local localState = GameHelper.GetBundleBuildStates(backupStatus)
		local successCount = 0
		while #tb_downloading_game > 0 do 
			downloading = tb_downloading_game[1]
			count = #downloading.bundles
			if DownloadManager.processingRequest == nil then 
				DownloadManager.processingRequest = {}
				DownloadManager.successRequest = {}
			end
			successCount = 0
			--start downloading
			facade:sendNotification(Common.STARTED_DOWNLAOD_GAME, downloading.gameType)
			for i=1, count do 
				target_bundle = downloading.bundles[i]
				--notify downloadManger download bundle
				UnityEngine.Debug.Log("downloading " .. target_bundle)
				DownloadManager.WaitDownload(target_bundle)
				
				UpdateDownloadGameProg()
				--force wait one frame
				UnityEngine.Yield(0.06)
				local bDownloading = DownloadManager.isDownloading(target_bundle)		
				while bDownloading do  
					UpdateDownloadGameProg()
					UnityEngine.Yield(UnityEngine.WaitForSeconds(0.03))
					bDownloading = DownloadManager.isDownloading(target_bundle)	
				end 

				local content = DownloadManager.GetWWW(target_bundle)
				
				if content == nil then
					LogError("Failed to download:: " .. target_bundle)
					break
				end 
				UpdateDownloadGameProg()
				if content.error ~= nil then 
					LogError("Failed to download:: " .. target_bundle)
					break
				else 
					local serverBundle = nil
					for t=1, serverBuildState.Count do
						serverBundle = serverBuildState:getItem(t-1)
						if serverBundle.name == target_bundle then 
							localState:Add(serverBundle)
							break
						end
					end
					successCount = successCount + 1
					local bCompressedBundle = GameHelper.isCompressedBundle
					if true == bCompressedBundle then 
						GameHelper.Decompress(target_bundle, content);
					else
						CustomTool.FileSystem.ReplaceFileBytes(CustomTool.FileSystem.bundleLocalPath .. "/" .. target_bundle, content.bytes)
					end 
					GameHelper.SaveUpdateState(backupStatus, localState)
				end 
				
				if content ~= null and content.assetBundle ~= nil then
					content.assetBundle:Unload(true) 
				end 
			end

			if successCount == count then 
				facade:sendNotification(Common.DOWNLOADED_GAME,downloading.gameType)
				downloading.bundles = nil 
				table.remove(tb_downloading_game, 1)
				GameHelper.SaveUpdateState(backupStatus, localState)
			end

			DownloadManager.DisposeAll()
			UnityEngine.Yield(0.06)
		end
		GameHelper.SaveUpdateState(backupStatus, localState)
		localState:Clear()
		cor_download_game = nil
	end)
	coroutine.resume(cor_download_game)
end 

--public interface. download game
--@param iGameType  the type of games
--@param bundles   the all bundle of games
function DownloadManager.DownloadGame(iGameType, bundles)
	local bExist = false 
	for k,v in ipairs(tb_downloading_game) do 
		if v.gameType == iGameType then 	
			bExist = true
			break;
		end 
	end 
	if false == bExist then 
		local tmp = {}
		tmp.gameType = iGameType
		tmp.bundles = bundles 
		tmp.bCompleted = false 
		tb_downloading_game[#tb_downloading_game + 1] = tmp

		facade:sendNotification(Common.WAIT_DOWNLOAD_GAME, iGameType)
		if cor_download_game == nil then 
			_DownloadGame()
		end 
	end 
end 

return DownloadManager