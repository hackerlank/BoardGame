local sproto = depends("sproto.sproto")

local t = {}

-- netpack
local spnp

-- 服务地址分解为节点和服务编号
function t.decode_address(address)
   local node_id = Luabit:_rshift(Luabit:_and(address, 0xff000000), 24)-- ( address & 0xff000000 ) >> 24
    local service_id = Luabit:_and(address, 0x00ffffff) --address & 0x00ffffff
    return node_id,service_id
end

-- 节点和服务编号合成为服务地址
function t.encode_address(node_id,service_id)
   local shiftValue = GameHelper.Bitshift(node_id, 24, false)
    return shiftValue + service_id
end

-- 把数据流解包为node_id,service_id,msg_id,body
function t.decode_pack(s)
    local np = spnp:decode("netpack",s)
    if nil==np then
        return false
    end

    return true,np
end

-- 把消息打包成数据流
function t.encode_pack2(node_id,service_id,msg_id_,msg_body)
    local address = t.encode_address(node_id,service_id)
    local np = {service=address,msg_id=msg_id_,body=msg_body}
    return spnp:encode("netpack",np)
end

-- 把消息打包成数据流
function t.encode_pack1(address,msg_id_,msg_body)
    local np = {service=address,msg_id=msg_id_,body=msg_body}
    return spnp:encode("netpack",np)
end

spnp = sproto.parse(loadsproto("Common/lualib/netpack.sproto"))

return t
