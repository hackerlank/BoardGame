-----------------------------------------------------------------------------
--LaunchGame:: 
--  start lua logic 
--     
-----------------------------------------------------------------------------

local base = _G

base.pScripter=LaunchGame.Instance

--save file has been loaded
base.tbRequired = {}

--save sproto file that has been loaded
base.tbLoadedSproto = {}

--lua directory
base.LUA_PATH=base.pScripter.luaPath .. "/"
base.LUA_GEN_PATH=base.pScripter.luaGenPath .. "/"
base.LUA_FILE_EXTENSION=".lua"

--load common lua scripts.
local function LoadCommonLuaScripts(szFile)
	local tmpFile = String(szFile)
	tmpFile = tmpFile:Replace(".","/");
	szFile = tostring(tmpFile) .. LUA_FILE_EXTENSION
	tmpFile = nil
	local extension = ""
	if GameHelper.isEditor then 
		if GameHelper.isWithBundle then 
			extension = ".txt"
			if GameHelper.isWithLuajit then 
				extension = ".bytes"
			end 
		end 
	else
		extension = ".txt"
		if GameHelper.isWithLuajit then 
			extension = ".bytes"
		end 
	end 
	
	local content = nil
	if extension ~= "" then 
		szFile = szFile .. extension
		content = pScripter:LoadCommonLuaScript(szFile)
	else 
		local path = LUA_PATH .. szFile;
		content = GameHelper.LoadScript(path)
	end 
	
	if content ~= nil then 
		base.tbRequired[szFile] = GameHelper.DoBuffer(content, szFile)
	else
		UnityEngine.Debug.LogError("Failed to load " .. szFile);
	end

	return base.tbRequired[szFile]
end 

--load definition
LoadCommonLuaScripts("Common.Defination")
LoadCommonLuaScripts(LUA_CLASS_DEFINITION)
LoadCommonLuaScripts(LUA_CLASS_INSTANCE)
LoadCommonLuaScripts(LUA_JSON_TOOL)
LoadCommonLuaScripts(LUA_TOOL)
LoadCommonLuaScripts(LUA_GAME_ERROR_CODE)
base.LuaAsset = LoadCommonLuaScripts(LUA_ASSET_CLASS)

--load resource manager
local resourcemanager = LoadCommonLuaScripts(LUA_RESOURCE_MANAGER)

--CallGlobal
function base:CallGlobal( szFunction, ... )
    if not base[szFunction] then 
        UnityEngine.Debug.Log("CallGlobal Failed: ", szFunction);
        return
    end 
    return base[szFunction]( ... );
end

--Global function.load lua script
base.depends = function(szFile)
	if resourcemanager == nil then 
		return nil;
	end 	
	szFile = string.gsub( szFile,"%.","/");
	szFile = szFile .. LUA_FILE_EXTENSION

	local tmp = String(szFile)
	local bCache = false

	if tmp:StartsWith("Common") or tmp:StartsWith("Puremvc") then 
		bCache = true
	end 

	if bCache == false and tmp:Contains("Parameter") then 
		bCache = true
	end 

	

	local result = nil
	local scriptContent = nil 
	if (not base.tbRequired[szFile]) then 
		scriptContent = resourcemanager.LoadScript(szFile)
		result = GameHelper.DoBuffer(scriptContent, szFile)		
	else 
		return base.tbRequired[szFile]
	end
	if bCache then 
		base.tbRequired[szFile] = result
	end 
	return result
end 

base.loadsproto = function(szFile)
	if resourcemanager == nil then 
		return nil;
	end 	

	szFile = szFile .. LUA_FILE_EXTENSION

	if (not base.tbLoadedSproto[szFile]) then 
		local content = resourcemanager.LoadScript(szFile)
		--local tostring(content:ToString())
		base.tbLoadedSproto[szFile] = GameHelper.GetString(content)	
	end
	return base.tbLoadedSproto[szFile]
end 

base.DoScript = function(szFile)
	if resourcemanager == nil then 
		return nil;
	end 
	szFile = string.gsub( szFile,"%.","/");
	szFile = szFile .. LUA_FILE_EXTENSION
	local scriptContent = resourcemanager.LoadScript(szFile)
	return GameHelper.DoBuffer(scriptContent, szFile)	
end


--load lua game manager
base.AudioManager = LoadCommonLuaScripts("Common/AudioManager") 
local luaGameManager = LoadCommonLuaScripts(TOOL_LUA_GAME_MANAGER)
local downloadManger = LoadCommonLuaScripts(LUA_DOWNLOAD_MANAGER)
local updateManager = LoadCommonLuaScripts(LUA_UPDATE_MANAGER)
base.GameSetting = LoadCommonLuaScripts(LUA_GAME_SETTING)
base.UIManager = LoadCommonLuaScripts(LUA_UI_MANAGER)
base.GameModeTemplate = LoadCommonLuaScripts(LUA_GAME_MODE_BASE)
base.LuaInputManager = LoadCommonLuaScripts("Common/LuaInputManager")
base.ClientConn = LoadCommonLuaScripts("Common.toolClientConn")
base.Luabit = LoadCommonLuaScripts("Common.Tools.Luabit")

local GameConfig = nil
local GameCi = nil

--get lua game manager
base.GetLuaGameManager = function()
	return luaGameManager
end 

--get resource manager
base.GetResourceManager = function()
	return resourcemanager
end 

--get download manager
base.GetDownloadManager = function()
	return downloadManger
end 

--get update manager
base.GetUpdateManager = function()
	return updateManager
end 

--set game config class instance
--called by game manager
base.SetGameConfig = function(iConfig)
	GameConfig = iConfig
end 

--set the instanced game object of 'xxxClassInstance' class
--called by game manager
base.SetGameCI = function(iGameCi)
	GameCi = iGameCi
end 

--Get Game Config class instance object
base.GetGameConfig = function()
	return GameConfig
end 

--Get instance object of xxxClassInstance  class
base.GetGameCI = function()
	return GameCi
end 

-- get time of system
base.GetTime = function()
	return os.time()
end 

--convert time to date
base.GetDate = function(iTime)
	return os.date("*t", iTime)
end 

base.GetPreciseDecimal = function(nNum, n)
	if type(nNum) ~= "number" then
        return nNum;
    end
    
    n = n or 0;
    n = math.floor(n)
    local fmt = '%.' .. n .. 'f'
    local nRet = tonumber(string.format(fmt, nNum))

    return nRet;
end 


--depends("Common.simplegame")
--real launch game

if GameManager.Instance ~= nil and GameManager.Instance.isCanBind and resourcemanager ~= nil then 

	GameManager.Instance:BindGameManager(luaGameManager, LUA_GAME_MANAGER)
	luaGameManager.Init()
	

else 
	UnityEngine.Debug.LogError("Failed to launch game")
end 

