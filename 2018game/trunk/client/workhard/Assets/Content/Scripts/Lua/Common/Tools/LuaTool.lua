luaTool = {}

luaTool.floor = math.floor
luaTool.settingFiles = {}

function luaTool:__DoDump(vSrc, tbResult, szPrefix)
	if not szPrefix then table.insert(tbResult, "======== Lib:Dump Content ========") end;    
	local szKey = szPrefix or "";

	if type(vSrc) ~= "table" then
		table.insert(tbResult, szKey .. " : " .. tostring(vSrc));
	else
		for vKey, vValue in pairs(vSrc) do
			self:__DoDump(vValue, tbResult, szKey .. "[" .. vKey .. "]");
		end 
	end
end

function luaTool:Dump(vSrc, szPrefix)
	local tbRet = {};
	self:__DoDump(vSrc, tbRet);
	UnityEngine.Debug.Log(table.concat(tbRet, "\n"));
end

function luaTool:Split(szContent, szDelim)
	if string.len(szContent) <= 0 then return {} end;

	local tbRet = {};
	local szPat = "(.-)" .. szDelim;
	local nRead = 0;

	while nRead <= string.len(szContent) do
		local nStart, nEnd, szPart = string.find(szContent, szPat, nRead);
		if not nStart then
			table.insert(tbRet, string.sub(szContent, nRead));
			nRead = string.len(szContent) + 1;
		else
			table.insert(tbRet, szPart or "");
			nRead = nEnd + 1;
		end
	end

	return tbRet;
end


--[[
 * read all bytes of file. create struct object instance with class template.
 * @Param szFile the file will be read
 * @return string 
]]
function luaTool:ReadFile(szFile)
	if luaTool.settingFiles[szFile] ~= nil then
		return luaTool.settingFiles[szFile]
	end 
	local szContent = GetResourceManager().LoadSetting(szFile);
	if not szContent or #szContent <= 0 then
		return "";
	end

	return szContent
end 

--[[
 * read all bytes of file. create struct object instance with class template.
 * @Param szFile the file will be read
 * @Param objTemplate class instance template. such as class GeneraltipSetting .. etc
 * @return a table 
]]
function luaTool:ReadSetting(szFile, objTemplate)
	if objTemplate == nil then 
		UnityEngine.Debug.LogError("[luaTool:ReadSetting]:: Fetal error,the class instance is nil when loading " .. szFile)
		return {}
	end 

	if luaTool.settingFiles[szFile] ~= nil then
		return luaTool.settingFiles[szFile]
	end 
	local szContent = GetResourceManager().LoadSetting(szFile);
	if not szContent or #szContent <= 0 then
		return {};
	else
		szContent = string.gsub(szContent, "\r", "");
	end


	local tbLines	= self:Split(szContent, "\n");
	local tbResult	= {};
	local tbKey		= {};

	for nLine, szLine in ipairs(tbLines) do
		if nLine == 3 then
			tbKey = self:Split(szLine, "\t");
		elseif nLine > 3 then
			local tbValues	= self:Split(szLine, "\t");
			local info = objTemplate.new(tbKey, tbValues)
			local bExist = false
			for _,v in ipairs(tbResult) do
				if info:isEqual(v) then 
					UnityEngine.Debug.LogError("the key has been registered .. " .. info:ToString())
					bExist = true
					break
				end 
			end 
			if false == bExist then 
				table.insert(tbResult, info);
			end
		end
	end
    
	--only cache the common config file
	local tmp = String(szFile)
	if tmp:StartsWith("Common/") then 
		luaTool.settingFiles[szFile] = tbResult
	end
	return tbResult;
end 

--[[
 * get a instance object of GeneraltipSetting class.
 * @Param id int value. 
 * @return a valid GeneraltipSetting object
]]
function luaTool:GetGeneralTip(id)
	local szFile = "Common/GeneralTip"
	local setting = luaTool.settingFiles[szFile]
	if setting == nil then 
		setting = luaTool:ReadSetting(szFile, ci.GetGeneralTipSetting())
	end 

	for _,v in ipairs(setting) do 
		if v:GetTipID() == id then 
			return v
		end 
	end 

	return nil
end 



function luaTool:LoadIniFile(szFile)
	local tbResult = {}
	if szFile == nil or szFile == "" then 
		return tbResult 
	end 

	local szContent = GetResourceManager().LoadSetting(szFile);
	if not szContent or #szContent <= 0 then
		return tbResult
	else
		szContent = string.gsub(szContent, "\r", "");
	end

	local tbLines = self:Split(szContent, "\n");

	local tmp = nil 
	local start_idx, end_idx 
	local str = "" 
	for nLine, szLine in ipairs(tbLines) do
		start_idx, end_idx = string.find(szLine, "--")
		--it indicates that its a configuration 
		if start_idx == 1 and end_idx == 0 then 
			tmp = self:Split(szLine, "=");
			str =  ""
			if #tmp >= 2 then 
				if tbResult[tmp[1]] ~= nil then 
					UnityEngine.Debug.LogError("Duplicate key " .. tmp[1])
				else

					for i=2,#tmp do 
						if i == 3 then 
							str = str .. "="
						end 
						str = str .. tmp[i]
						
					end 
					tbResult[tmp[1]] = str 
				end 
			else 
				--UnityEngine.Debug.LogError("Fetal error:: invalid ini config item:: " .. szLine)
			end 
		end
	end

	luaTool.settingFiles[szFile] = tbResult
	return tbResult
end 

function luaTool:GetServerInfo()
	local szFile = "Common/NetWork"
	local tbResult = luaTool.settingFiles[szFile]
	if tbResult == nil then 
		self:LoadIniFile(szFile)
		tbResult = luaTool.settingFiles[szFile]
	end 
	return tbResult.server_address, tbResult.server_port
end 

--[[
 * get game tip characters. from GameError.txt。 is a ini file
 * @Param inKey the unique key in config file 
 * @return a string value
]]
function luaTool:GetCharacters(sz_key)
	if sz_key == nil or sz_key == " "then 
		return ""
	end 

	local final_str = ''
	local szFile = "Common/GameError"
	local tbResult = luaTool.settingFiles[szFile]
	if tbResult == nil then 
		self:LoadIniFile(szFile)
		tbResult = luaTool.settingFiles[szFile]
	end 

	if tbResult[sz_key] ~= nil then 
		final_str = tbResult[sz_key]
	else 
		UnityEngine.Debug.LogError("can not find the ini item:: " .. sz_key)
	end 
	return final_str
end 

function luaTool:GetLocalize(sz_key)
	if sz_key == nil or sz_key == " "then 
		return ""
	end 

	local final_str = ''
	local szFile = "Common/Localize"
	local tbResult = luaTool.settingFiles[szFile]
	if tbResult == nil then 
		self:LoadIniFile(szFile)
		
		tbResult = luaTool.settingFiles[szFile]
		
	end 

	if tbResult[sz_key] ~= nil then 
		final_str = tbResult[sz_key]
	else 
		UnityEngine.Debug.LogError("can not find the ini item:: " .. sz_key)
	end 
	return final_str
end 

function luaTool:GetGameSound(id)
	local szFile = "Common/GameSound"
	local setting = luaTool.settingFiles[szFile]
	if setting == nil then 
		setting = luaTool:ReadSetting(szFile, ci.GetGameSoundInfo())
	end 

	for _,v in ipairs(setting) do 
		if v:GetSoundId() == id then 
			return v
		end 
	end 
	return nil
end 

function luaTool:GetLevelInfo(G, D, L)
	G = G or 1
	D = D or 1
	L = L or 1
	local szFile = "Common/LevelMap"
	local setting = luaTool.settingFiles[szFile]
	if setting == nil then 
		setting = luaTool:ReadSetting(szFile, ci.GetLevelInfo())
	end 

	for k,v in ipairs(setting) do 
		if v:isDGLEqual(G,D,L) then 
			return v
		end 
	end 
	return nil
end 

function luaTool:GetGamesInfos()
	local szFile = "Common/Games"
	local setting = luaTool.settingFiles[szFile]
	if setting == nil then 
		setting = luaTool:ReadSetting(szFile, ci.GetGamesInfo())
	end 
	return setting
end


function luaTool:GetSettingInfo(tbFile, szKey, valueKey)
    if tbFile == nil then 
        return nil;
    end
    for i, tbData in pairs(tbFile) do
        if tbData[szKey] == tostring(valueKey) then            
            return tbData;
        end
    end
    return nil;
end

function luaTool:GetGuid()
    return TransformLuaUtil:GetGuid();
end

function  luaTool:GetEmojis()
	local szFile = "Common/Emojis"
	local setting = luaTool.settingFiles[szFile]
	if setting == nil then 
		local content = luaTool:ReadFile(szFile) or {}
		if content == " " then
			content = "{}"
		end 
		setting = JsonTool.Decode(content)

		local s = ListObject() 
		for k,v in pairs(setting) do 
			v.list_sprites = luaTool:LoadEmojiSprite(v.tag, v.bIsStatic)
			s:Add(v)
		end 
		setting = s 
		luaTool.settingFiles[szFile] = setting
	end 
	return setting
end

--load magic emoji item or config .
--if id is nil, then return whole config. otherwise return single item 
function luaTool:GetMagicEmoji(id)
	local szFile = "Common/Magic_Emoji"
	local setting = luaTool.settingFiles[szFile]
	if setting == nil then 
		local content = luaTool:ReadFile(szFile) or {}
		if content == " " then
			content = "{}"
		end 
		setting = JsonTool.Decode(content)
		luaTool.settingFiles[szFile] = setting
	end 

	if id ~= nil then 
		for k,v in pairs(setting) do 
			if v.id == id then 
				return v 
			end 
		end 
	else 
		return setting 
	end 
	return nil
end 


function luaTool:GetUiAnimation()
	local szFile = "Common/UiAnimation"
	local setting = luaTool.settingFiles[szFile]
	if setting == nil then 
		local content = luaTool:ReadFile(szFile) or {}
		if content == " " then
			content = "{}"
		end 
		setting = JsonTool.Decode(content)
		luaTool.settingFiles[szFile] = setting
	end 
	return setting
end

--call unity capture function.also we have provide a function for capture texture with a camera in native(GameHelper.cs)
--we also can support multiple camera
--@return filepath
function  luaTool:ScreenShot(name)
	if name == nil then 
		LogError("Failed to capture screen")
		return nil
	end 

	local filename = nil
	local start_idx, end_idx = string.find(name, ".")
	if start_idx == nil and end_idx == nil then 
		name = name .. ".png"
		filename = string.format("%s/%s.png",CustomTool.FileSystem.directoryPath, name )
	else 
		filename = string.format("%s/%s",CustomTool.FileSystem.directoryPath, name )
	end 

	UnityEngine.Application.CaptureScreenshot(name)
	--CustomTool.FileSystem.CopyFile(CustomTool.FileSystem.directoryPath .. "/" .. name , filename)
	UnityEngine.Debug.Log("screenshot has been saved into " .. filename)
	return filename
end

--read game record from disk
function luaTool:GetGameRecord(hall_service_id, record_id)
	-- body
	
	local record_key = "record"
	if luaTool.settingFiles[record_key] == nil then 
		return nil 
	end 
	
	local records = luaTool.settingFiles[record_key][hall_service_id]
	if records == nil then 
		return nil
	end 

	for k,v in pairs(records) do 
		if v then 
			if v.record_id == record_id then 
				return v.detail
			end 
		end 
	end 
	return nil
end

--save game record to disk
function luaTool:SaveGameRecord(hall_service_id, record_id, detail)
	-- body
	
	local record_key = "record"
	if luaTool.settingFiles[record_key] == nil then
		luaTool.settingFiles[record_key] = {}
	end 

	local records = luaTool.settingFiles[record_key][hall_service_id]
	if records == nil then
		records = {}
		luaTool.settingFiles[record_key][hall_service_id] = records
	end 

	local value = nil 
	for k,v in pairs(records) do 
		if v then 
			if v.record_id == record_id then 
				value = v 
				break
			end 
		end 
	end 
	if value == nil then 
		table.insert(records, {record_id = record_id, detail = detail})
	end 
	
end

function luaTool:LoadEmojiSprite(tag, bIsStatic)
	local szFile = ""
	if bIsStatic == false then 
		szFile = "Assets/Content/ArtWork/UI/Common/emoji/biaoqing1.asset"
	else 
		szFile = "Assets/Content/ArtWork/UI/Common/emoji/emoji_static.asset"
	end 
	local emoji = luaTool.settingFiles[szFile] 
	if emoji == nil then 
		GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_SpriteAsset, szFile, function(asset)
			if asset then
				luaTool.settingFiles[szFile] = asset:GetAsset()   
				emoji = luaTool.settingFiles[szFile]
			end 
		end)
	end 

	if tag == nil then 
		return nil 
	end 
	local list_sprites = ListObject()
	local len = emoji.listSpriteGroup.Count 
	local item = nil 
	for i=1, len do 
		item = emoji.listSpriteGroup[i-1]
		if item.tag == tag then 
			for j=1,item.listSpriteInfor.Count do 
				list_sprites:Add(item.listSpriteInfor[j-1].sprite)
			end 
			break
		end 
	end 

	return list_sprites

end