local log = require "cc_log"
local skynet = require "skynet"

skynet.start(function()
	log.info("writer server start")

	skynet.uniqueservice("writer")

	skynet.newservice("console")
end)
