--[[
  * COMMAND:: play game background music. 
  *   used to play game background music. call this by sending one notification
  *   with facade. like::
  *   facade:sendNotification(Common.PLAY_GAME_MUSIC,note)
  *   Warning:: note can not be nil 
]]

local PlayGameMusicCommand = class('PlayGameMusicCommand', pm.SimpleCommand)


function PlayGameMusicCommand:ctor()
    self.executed = false
end

function PlayGameMusicCommand:execute(note)
    if note.body == nil then 
        UnityEngine.Debug.LogError("[PlayGameMusicCommand]:: Miss play background music parameter. will return......")
        return
    end 
    AudioManager.getInstance().PlayBGMusic(note.body)
end

return PlayGameMusicCommand