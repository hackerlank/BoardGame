local log = require "cc_log"

local skynet = require "skynet"

skynet.start(function()
    log.info("game table server start")

    skynet.uniqueservice("clusternode")

    skynet.uniqueservice("room")

    skynet.uniqueservice("console")
end)
