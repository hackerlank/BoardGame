local GameConfig = GameConfig or {}
local settingFiles = {}


function GameConfig:GetDefaultGameRule()
   
    local szFile = "nn/DefaultGameRule";
	local szContent = settingFiles[szFile];

	if szContent == nil then 
		szContent = luaTool:ReadFile(szFile);
        szContent = JsonTool.Decode(szContent)
		settingFiles[szFile] = szContent
	end

    return szContent 
end 

function GameConfig:GetLocalize(key)
	-- body
end

return GameConfig