-- 重新加载版本文件
local skynet = require("skynet")

--所有变量都必须在函数内部声明，禁止引用外部变量
local f = function ()
    print("reload version.txt of plaza")
    _G.command.reload_version()
end

skynet.start(function ()
    --通知房间服务关闭
    skynet.send("userlogin","lua","hotfix_function",string.dump(f))
end)
