print("cc test start")

local skynet = require "skynet"
require "skynet.manager"

skynet.start(function()
    print("main service is ",skynet.self())

    skynet.uniqueservice("console")

    skynet.uniqueservice("mysqld")
    print("call newservice testmysql")
    local sid=skynet.newservice("testmysql")
    print("done,sid",sid)
end)
