print("cc db server start")

local skynet = require "skynet"

skynet.start(function()
    skynet.uniqueservice("clusternode")

    skynet.uniqueservice("hall")

    skynet.uniqueservice("console")
end)
