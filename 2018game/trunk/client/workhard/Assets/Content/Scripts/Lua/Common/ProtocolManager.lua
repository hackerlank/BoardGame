
--[[
*
* loading all protocols
]]
local protocols = protocols or {}
local sproto = depends("sproto.sproto")
local spx = depends("Common.lualib.spx")
local login_sproto =  sproto.parse(loadsproto("network/sproto/login_sproto"))
local gate_sproto = sproto.parse(loadsproto("network/sproto/gate_sproto"))
local agent_sproto = sproto.parse(loadsproto("network/sproto/agent_sproto"))
local hall_sproto = sproto.parse(loadsproto("network/sproto/hall_sproto"))
local common_sproto = sproto.parse(loadsproto("network/sproto/common_sproto"))
local nn_tb_sproto = sproto.parse(loadsproto("network/sproto/nn_tb_game_sproto"))
local table_base_sproto = sproto.parse(loadsproto("network/sproto/table_base_sproto"))

--protocol:: login
protocols.GetLoginSproto = function()
    return login_sproto
end 

--protocol:: gate 
protocols.GetGateSproto = function()
    return gate_sproto
end 

--protocol:: hall
protocols.GetHallSproto = function()
    return hall_sproto
end 

--protocol:: agent
protocols.GetAgentSproto = function()
    return agent_sproto
end 

--protocol:: common
protocols.GetCommonSproto = function()
    return common_sproto
end 

--protocol:: base
protocols.GetBaseSproto = function()
    return table_base_sproto
end 

--============protocols of games begin====================
--game protocol:: nn_tb
protocols.GetGameSproto_NNTb = function()
    return nn_tb_sproto
end 

--============protocols of games end======================

return protocols