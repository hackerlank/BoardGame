local BindServerParam = class('BindServerParam')


function BindServerParam:ctor(address, port, bAutoRetry, connOperation)
    self.address = address or ""
    self.port = port or "8080"
    self.bAutoRetry = bAutoRetry or false
    self.connOperation = connOperation or ENetConnOperation.ENCO_Max
end 

function BindServerParam:GetAddress()
    return self.address
end 

function BindServerParam:GetPort()
    return self.port
end 

function BindServerParam:IsAutoRetry()
    return self.bAutoRetry
end 

function BindServerParam:GetOperation()
    return self.connOperation
end

function BindServerParam:ToString()
    local t={"address=", self.address, " port=", self.port, " bAutoRetry=", self.bAutoRetry, " connOperation=", self.connOperation}
    return table.concat(t)
end 

return BindServerParam