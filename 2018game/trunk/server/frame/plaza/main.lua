local log = require "cc_log"

local skynet = require "skynet"

skynet.start(function()
	log.info("plaza server start")

    skynet.uniqueservice("clusternode")
    skynet.uniqueservice("plaza")
    skynet.uniqueservice("console")
end)
