local log = require "cc_log"

local skynet = require "skynet"

skynet.start(function()
	log.info("lgate server start")

	skynet.uniqueservice("clusternode")

	local usergate = skynet.uniqueservice("usergate")
	skynet.call(usergate,"lua","start")

	skynet.uniqueservice("console")
end)
