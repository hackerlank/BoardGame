--Command:: this command will be invoked after update game content 
--done
local InitialRmCommand = class('InitialRmCommand', pm.SimpleCommand)


function InitialRmCommand:ctor()
	self.executed = false
end

function InitialRmCommand:execute(note)
    local resourceManger = GetResourceManager()
    if resourceManger ~= nil then 
        resourceManger.Init()
    end 

end

return InitialRmCommand