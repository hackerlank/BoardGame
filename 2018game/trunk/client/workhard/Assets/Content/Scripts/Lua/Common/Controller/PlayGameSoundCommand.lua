--[[
  * COMMAND:: play game sound. 
  *   used to play game background music. call this by sending one notification
  *   with facade. like::
  *   facade:sendNotification(Common.PLAY_GAME_MUSIC,note)
  *   Warning:: note can not be nil 
]]

local PlayGameSoundCommand = class('PlayGameSoundCommand', pm.SimpleCommand)


function PlayGameSoundCommand:ctor()
    self.executed = false
end

function PlayGameSoundCommand:execute(note)
    if note.body == nil then 
        UnityEngine.Debug.LogError("[PlayGameSoundCommand]:: Miss play background music parameter. will return......")
        return
    end 
    AudioManager.getInstance().PlaySound(note.body)
end

return PlayGameSoundCommand