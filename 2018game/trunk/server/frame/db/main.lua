local log = require "cc_log"
local skynet = require "skynet"

skynet.start(function()
    log.info("db server start")
    skynet.uniqueservice("clusternode")

    skynet.uniqueservice("mysqld")
    skynet.uniqueservice("userdb")
    skynet.uniqueservice("mall")
    skynet.uniqueservice("auth_username")
    skynet.uniqueservice("auth_weixin")

    skynet.uniqueservice("console")
end)
