--[[
 * Class:: nn ClassInstance. managed all parameter class instance of Games
 *   use these interface to get class instance.
]]
local ci = ci or {}

--get bet parameter class instance
ci.GetBetParameter = function()
    return depends("Games.Baccarat.Parameter.BetParameter")
end 

return ci