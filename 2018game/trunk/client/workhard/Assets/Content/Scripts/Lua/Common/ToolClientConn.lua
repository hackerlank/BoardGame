local CC =  depends("Common.ClientConn")

local tCC = {}

setmetatable(tCC, {__index =CC})


return tCC