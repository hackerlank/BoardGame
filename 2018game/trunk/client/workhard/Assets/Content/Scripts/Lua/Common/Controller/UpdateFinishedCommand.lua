--Command:: this command will be invoked after update game content 
--done
local UpdateFinishedCommand = class('UpdateFinishedCommand', pm.SimpleCommand)


function UpdateFinishedCommand:ctor()
    self.executed = false
end

function UpdateFinishedCommand:execute(note)
    --send initial resource manager command
    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    facade:sendNotification(Common.INITIAL_RESOURCE_MANAGER, nil)
end

return UpdateFinishedCommand