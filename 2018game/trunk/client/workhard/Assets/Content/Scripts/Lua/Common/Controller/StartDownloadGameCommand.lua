--[[
  * COMMAND:: StartDownloadGameCommand. 
  *   used to download a game
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local StartDownloadGameCommand = class('StartDownloadGameCommand', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
--local Log = UnityEngine.Debug.Log
--local LogWarning = UnityEngine.Debug.LogWarning
--local LogError = UnityEngine.Debug.LogError

--constructor function. do not overwrite it
function StartDownloadGameCommand:ctor()
    self.executed = false
end

--coding function in here
function StartDownloadGameCommand:execute(note)
    --UnityEngine.Debug.Log('StartDownloadGameCommand')
    if note.body == nil or type(note.body) ~= "number" then
        return
    end 

    if note.body == EGameType.EGT_MAX then 
        return
    end 

    local bundles = GBC.GetNeedDownloadBundles(note.body)
    if bundles ~= nil then 
        GetDownloadManager().DownloadGame(note.body, bundles)
    end 
end

return StartDownloadGameCommand