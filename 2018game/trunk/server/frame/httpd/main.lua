local log = require "cc_log"

local skynet = require "skynet"

skynet.start(function()
	log.info("httpd server start")

    skynet.uniqueservice("clusternode")
    skynet.uniqueservice("httpd_gate")
    skynet.uniqueservice("console")
end)
