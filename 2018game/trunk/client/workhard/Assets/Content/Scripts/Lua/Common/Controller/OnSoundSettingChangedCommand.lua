--[[
  * COMMAND:: play game background music. 
  *   used to play game background music. call this by sending one notification
  *   with facade. like::
  *   facade:sendNotification(Common.PLAY_GAME_MUSIC,note)
  *   Warning:: note can not be nil 
]]

local OnSoundSettingChangedCommand = class('OnSoundSettingChangedCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError


function OnSoundSettingChangedCommand:ctor()
    self.executed = false
end

function OnSoundSettingChangedCommand:execute(note)
     if note.body == nil then 
        LogError("[OnSoundSettingChangedCommand]:: Miss play background music parameter. will return......")
        return
    end 
    local gameSetting = GameSetting.getInstance()
    local audioManager = AudioManager.getInstance()
    local bNewSetting = note.body.isOn
    local newVolume = note.body.Volume 
    local bOldSetting = gameSetting:IsEnableMusic()
    if bNewSetting ~= nil then
        gameSetting:SetEnableSound(bNewSetting)
        if bOldSetting and false == bNewSetting then 
            audioManager:StopSound()
        --elseif false == bOldSetting and bNewSetting then 
        --  audioManager:ResumeBGMusic()
        end
    end
    if newVolume ~= nil then
        gameSetting:SetSoundVolume(newVolume)
        audioManager:SetSoundVolume(newVolume)
    end
end

return OnSoundSettingChangedCommand