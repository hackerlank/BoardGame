local NotificationItem = class('NotificationItem')

function NotificationItem:ctor(inMsg, inWeight)
    self:Reset(inMsg, inWeight)
end 

function NotificationItem:Reset(inMsg, inWeight)
    self.msg = inMsg or ""
    self.weight = inWeight or ENotiWeight.ENW_System
end 

function NotificationItem:GetMsg()
    return self.msg
end 

function NotificationItem:GetWeight()
    return self.weight
end 

function NotificationItem:ToString()
    local t = {"msg=", self.msg, " weight=", self.weight}
    return table.concat(t)
end 
return NotificationItem