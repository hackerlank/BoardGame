--[[
  * COMMAND:: Save Game Setting
  *   used to Save Game Setting. call this by sending one notification
  *   with facade. like::
  *   facade:sendNotification(Common.PLAY_GAME_MUSIC,note)
  *   Warning:: note can not be nil 
]]

local OnSaveGameSettingCommand = class('OnSaveGameSettingCommand', pm.SimpleCommand)


function OnSaveGameSettingCommand:ctor()
    self.executed = false
end

function OnSaveGameSettingCommand:execute(note)

    local gameSetting = GameSetting.getInstance()
    gameSetting:FlushGameSetting()
end

return OnSaveGameSettingCommand