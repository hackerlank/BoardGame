local log = require "cc_log"

local skynet = require "skynet"

skynet.start(function()
	log.info("login server start")

	skynet.uniqueservice("clusternode")
	skynet.uniqueservice("userlogin")

	skynet.uniqueservice("console")
end)
