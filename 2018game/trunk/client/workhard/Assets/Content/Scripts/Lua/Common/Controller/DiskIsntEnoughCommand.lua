--DiskIsntEnoughCommand:: this command is used to show local disk space is not 
--enough tip

local DiskIsntEnoughCommand = class('DiskIsntEnoughCommand', pm.SimpleCommand)


function DiskIsntEnoughCommand:ctor()
	self.executed = false
end

function DiskIsntEnoughCommand:execute(note)
	UnityEngine.Debug.Log("exeuting DiskIsntEnoughCommand ...")
end

return DiskIsntEnoughCommand