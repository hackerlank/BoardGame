local log = require "cc_log"

local skynet = require "skynet"

skynet.start(function()
	log.info("agent server start")

    skynet.uniqueservice("clusternode")
    skynet.uniqueservice("agent")
    skynet.uniqueservice("console")
end)
