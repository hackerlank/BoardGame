local GameSetting = class('GameSetting')

GameSetting.instanceMap = {}

function GameSetting:ctor()
    local fileName = "GameSetting.txt"
    self.path = "Assets/Content/Setting/Common/" ..  fileName
    self.bLoadFromEditor = true

    if GameHelper.isEditor == false then 
        self.path = CustomTool.FileSystem.bundleLocalPath .. "/" .. fileName
        self.bLoadFromEditor = false
    else 
        if GameHelper.isWithBundle then
            self.path = CustomTool.FileSystem.bundleLocalPath .. "/" .. fileName
            self.bLoadFromEditor = false
        end 
    end 
    self:Init()
end 

function GameSetting:Init()
    UnityEngine.Debug.Log("Init game setting...")
    local content = ""
    if self.bLoadFromEditor then 
        content =  tostring(GameHelper.ReadFileFromDatabase(self.path))
    else 
        content = GameHelper.ReadFile(self.path)
    end 
    AudioHelper.Init()
    
    if content == nil or content == "" then 
        self.setting = {bEnableMusic=true, bEnableSound=true, musicVolume=1, soundVolume=1, bRecieveMsg=true}
        self:FlushGameSetting()
    else   
        local json = JsonTool.Decode(content)

        if json ~= nil then 
            self.setting = json
        else 
            self.setting = {bEnableMusic=true, bEnableSound=true, musicVolume=1, soundVolume=1, bRecieveMsg=true}
            --flush setting file to local disk
            self:FlushGameSetting()
        end
    end 
end 

function GameSetting.getInstance()
    local key = "GameSetting"  
    if GameSetting.instanceMap[key] == nil then 
        GameSetting.instanceMap[key] = GameSetting.new(key)
    end 

    return GameSetting.instanceMap[key]
end 

function GameSetting:IsEnableMusic()
    if self.setting then 
        return self.setting.bEnableMusic
    end 
end 

function GameSetting:IsEnableSound()
     if self.setting then 
        return self.setting.bEnableSound
    end 
end 

function GameSetting:GetMusicVolume()
    if self.setting then
        return self.setting.musicVolume
    else
        return 0.5
    end
end

function GameSetting:GetSoundVolume()
    if self.setting then
        return self.setting.soundVolume
    else
        return 0.5
    end
end


function GameSetting:IsReceiveMsg()
     if self.setting then 
        return self.setting.bRecieveMsg
    end 
end 

function GameSetting:SetMusicVolume(volume)
    if self.setting then 
        self.setting.musicVolume = volume
    end
end

function GameSetting:SetSoundVolume(volume)
    if self.setting then 
        self.setting.soundVolume = volume
    end
end

function GameSetting:SetEnableMusic(bEnable)
    if self.setting then 
        self.setting.bEnableMusic = bEnable
        --self:FlushGameSetting()
    end 
end 

function GameSetting:SetEnableSound(bEnable)
     if self.setting then 
        self.setting.bEnableSound = bEnable
        --self:FlushGameSetting()
    end 
end 

function GameSetting:SetReceiveMsg(bEnable)
     if self.setting then 
        self.setting.bRecieveMsg = bEnable
        self:FlushGameSetting()
    end 
end

function GameSetting:FlushGameSetting()
   
    if self.setting ~= nil then 
         local str = JsonTool.Encode(self.setting)
         CustomTool.FileSystem.ReplaceFile(self.path, str)
         --if with editor, import this file now
         if GameHelper.isEditor then 
            GameHelper.ImportAsset(self.path)
         end 
    else 
        UnityEngine.Debug.LogError("[GameSetting]:: failed to save game setting file. because can not find the valid setting table")
    end 
end 
return GameSetting