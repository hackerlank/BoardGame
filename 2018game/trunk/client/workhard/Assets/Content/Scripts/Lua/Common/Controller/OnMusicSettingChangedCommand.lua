--[[
  * COMMAND:: play game background music. 
  *   used to play game background music. call this by sending one notification
  *   with facade. like::
  *   facade:sendNotification(Common.PLAY_GAME_MUSIC,note)
  *   Warning:: note can not be nil 
]]

local OnMusicSettingChangedCommand = class('OnMusicSettingChangedCommand', pm.SimpleCommand)
local LogError = UnityEngine.Debug.LogError

function OnMusicSettingChangedCommand:ctor()
    self.executed = false
end

function OnMusicSettingChangedCommand:execute(note)
    if note.body == nil then 
        LogError("[OnMusicSettingChangedCommand]:: Miss play background music parameter. will return......")
        return
    end 
    local gameSetting = GameSetting.getInstance()
    local audioManager = AudioManager.getInstance()
    local bNewSetting = note.body.isOn
    local newVolume = note.body.Volume
    local bOldSetting = gameSetting:IsEnableMusic()
    if bNewSetting ~= nil then
        gameSetting:SetEnableMusic(bNewSetting)
        if bOldSetting and false == bNewSetting then 
            audioManager:PauseBGMusic()
        elseif false == bOldSetting and bNewSetting then 
            if audioManager:HasPlayedBG() then 
                audioManager:ResumeBGMusic()
            else 
               -- audioManager:PlayBGMusic(GetLuaGameManager().GetGameMode():GetBGMusic())
            end 
        end
    end
    if newVolume ~= nil then
        gameSetting:SetMusicVolume(newVolume)
        audioManager:SetBGMusicVolume(newVolume)
    end
end

return OnMusicSettingChangedCommand