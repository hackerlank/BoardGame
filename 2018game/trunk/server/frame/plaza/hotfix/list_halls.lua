-- 显示所有大厅信息
local skynet = require("skynet")

--所有变量都必须在函数内部声明，禁止引用外部变量
local f = function ()
    print("list all hall")
    local i = 1
    for _,hall in pairs(_G.hall_list) do
        print("hall ",i)
        i=i+1
        for k,v in pairs(hall) do
            print(k,":",v)
        end
    end
end

skynet.start(function ()
    --通知房间服务关闭
    skynet.send("plaza","lua","hotfix_function",string.dump(f))
end)
