local skynet = require "skynet"
require "skynet.manager"	-- import skynet.abort

local patch_file = ...
print("apply",patch_file,"to userdb")

skynet.start(function ()
    skynet.send("userdb","lua","hotfix_file",patch_file)
    skynet.exit()
end)
