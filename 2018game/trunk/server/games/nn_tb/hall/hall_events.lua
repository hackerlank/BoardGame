--[[
    nn_tb 大厅事件
]]
_G.hall_events = _G.hall_events or {}

-- 对玩家评分，将按照评分进行排序
function _G.hall_events.get_user_mark(user)
    return user.money
end
