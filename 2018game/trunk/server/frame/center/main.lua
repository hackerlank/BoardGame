local log = require "cc_log"
local skynet = require "skynet"

skynet.start(function()
	log.info("center server start")

	skynet.uniqueservice("center")

	skynet.newservice("console")
end)
