--反注册房间服务
local skynet = require("skynet")

local hall_name = ...

skynet.start(function ()
    --通知房间服务关闭
    skynet.send("center","lua","unregister_node",hall_name)
    skynet.exit()
end)
