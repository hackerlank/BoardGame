local root="/opt/skynet/"
_G.cc_root = "../../../"
local cc_root = _G.cc_root
package.cpath = root.."luaclib/?.so"
package.path = root.."lualib/?.lua;"..root.."lualib/?/init.lua;"
				..cc_root.."lualib/?.lua;"
				.."./?.lua;"
				.."../common/?.lua;"
				.."../../common/pokerlib/?.lua"
local filex = require "filex"

local user_act = require "user_act"

local use_bit32 = ((_VERSION == "Lua 5.1") or (_VERSION == "Lua 5.2"))
local sprint_r=require("sprint_r")

print("lua version :",_VERSION)
if use_bit32 then
	print "use bit32"
	local bit32 = require "bit32"
else
	print "use string.pack"
end

local os = require "os"
local socket = require "client.socket"
local spx = require "spx"
local print_r = require "print_r"

_G.card_color = _G.card_color or require "poker_color"
_G.card_point = _G.card_point or require "poker_point"
--_G.table_mode = _G.table_mode or require "table_mode"
_G.table_state = _G.table_state or require "table_state"
--_G.phase_ack = _G.phase_ack or require "phase_ack"

math.randomseed(os.time())

--游戏规则
local rules = {
    table_mode          = 1,
    max_round           = 5,
    pay_room_card       = 5,
    pay_mode            = 1,
    base_chip		    = 10,
	start_game_mode		= 2,
    enable_flush= true,
    enable_straight          =true,
    enable_suited = true,
	enbale_five_big = true,
	enable_five_small = true,
	enable_full_house = true,
	enable_bomb = true,
}

-- 登录服务器地址
local login_server_address="127.0.0.1:3101"
--local login_server_address="192.168.50.201:3101"
--local login_server_address="139.224.187.34:3101"
-- 读取到没有处理的数据
local last = ""
-- 是否继续循环
local loop = true
-- 登录类型
local logintype = dofile(cc_root.."types/login_type.lua")
-- 用户登录消息编号
local login_msg_id = dofile(cc_root.."sproto/login.msgid.lua")
-- 用户登录消息解析
local login_sproto = spx.parse_file(cc_root.."sproto/login.sproto")
-- 玩家阶段响应
--local phase_ack = _G.phase_ack
-- 桌子状态
local table_state = _G.table_state

-- 用户登录消息处理
local login_pack = {}
-- 登录消息处理表
local login_map = {}

-- 网关消息编号
local gate_msg_id = dofile(cc_root.."sproto/gate.msgid.lua")
-- 网关消息解析
local gate_sproto = spx.parse_file(cc_root.."sproto/gate.sproto")
-- 网关服务映射
local service_pack_map = {}
-- 网关登录消息
local gate_login_pack = {}
-- 网关登录消息映射
local gate_login_map = {}
-- 网关网络地址
local gate_server_address
-- 网关登录服务地址
local gate_service

-- 广场服务地址
local agent_service
-- 广场消息编号
local agent_msg_id = dofile(cc_root.."sproto/agent.msgid.lua")
-- 广场消息解析
local agent_sproto = spx.parse_file(cc_root.. "sproto/agent.sproto")
-- 广场消息映射
local agent_pack = {}
-- 广场消息映射
local agent_map = {}

-- 大厅服务地址
local hall_service
-- 大厅消息编号
local hall_msg_id = dofile(cc_root.."sproto/hall.msgid.lua")
-- 大厅消息解析
local hall_sproto = spx.parse_file(cc_root.."sproto/hall.sproto")
-- 大厅消息映射
local hall_pack = {}
-- 大厅消息映射
local hall_map = {}

-- 桌子服务地址
local table_service
-- 桌子消息编号
local table_msg_id = dofile(cc_root.."sproto/table_base.msgid.lua")
-- 桌子消息解析
local table_sproto = spx.parse_file(cc_root.."sproto/table_base.sproto")
-- 通用消息解析
local common_sproto = spx.parse_file(cc_root.."sproto/common.sproto")
-- 游戏消息编号
local game_msg_id = dofile("../sproto/game.msgid.lua")
-- 游戏消息解析
local game_sproto = spx.parse_file("../sproto/game.sproto")
-- 桌子消息映射
local table_pack = {}
-- 桌子消息映射
local table_map = {}

--命令行参数1指明玩家信息
assert(_G.arg[1],"_G.arg[1] is nil")
print("user file is",_G.arg[1])
local user_info = require(_G.arg[1])
print("user_info")
print_r(user_info)

--大厅信息
local hall_info = {
	--大厅类型
	hall_type = "nn_tb",
}

--房间信息
local table_info = {
	table_service = 0,
	private_key = 0,
}
--不是房主，读取本地的桌子信息
if not user_info.is_owner then
	table_info = require "table_info"
	if not table_info then
		print("fault : read table_info fail")
		return
	end
end

--睡眠一定时间
local function sleep(n)
	print("sleep ",n,"seconds")
	os.execute("sleep " .. n)
	print("wake up")
end

--写入房间信息到本地文件
local function write_table_info()
	print("write_table_info")
	print_r(table_info)

    local s = string.format([[
    local table_info = {
        table_service = %d,
        private_key = %d,
    }
    return table_info
    ]],table_info.table_service,table_info.private_key)

    filex.write_string("table_info.lua",s)
end

-- 127.0.0.1:3306字符串转换成地址和端口
local function string_2_address(s)
	local xs,xe = string.find(s,":")
	return string.sub(s,1,xs-1),tonumber(string.sub(s,xe+1,-1))
end

--[[
	把数据打包成缓存加上包头发送到服务器
	fd 连接
	address 服务地址
	msg_id 消息编号
	body 使用spx打包成string的数据流
]]
-- lua5.3版本
local function send_pack53(fd,address,msg_id,body)
	print("send_pack(),address",address,"msg_id",msg_id)

	local buf = spx.encode_pack1(address,msg_id,body)
	local package = string.pack(">s2", buf)
	socket.send(fd, package)
end
-- lua5.1版本，需要执行安装clientsocket库
local function send_pack51(fd,address,msg_id,body)
	print("send_pack(),address",address,"msg_id",msg_id)

	local buf = spx.encode_pack1(address,msg_id,body)
	local sz = #buf
	local package = string.char(bit32.extract(sz,8,8))..string.char(bit32.extract(sz,0,8))..buf
	socket.send(fd, package)
end

-- 根据lua版本不同选择，发送封包函数
local send_pack
if use_bit32 then
	send_pack = send_pack51
else
	send_pack = send_pack53
end

-- 把接收到的数据解包
local function unpack_package(text)
	local size = #text
	if size < 2 then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
end

-- 读取封包
local function recv_package(fd,last)
	local result
	result, last = unpack_package(last)
	if result then
		return result, last
	end
	local r = socket.recv(fd)
	if not r then
		return nil, last
	end
	if r == "" then
		error "Server closed"
	end
	return unpack_package(last .. r)
end

-- 处理封包
local function on_dispatch_pack(fd_,np)
	print("on_dispatch_pack(),msg_id",np.msg_id,"service",np.service)

	local service_pack = service_pack_map[np.service]
	if not service_pack then
		print("on_dispatch_pack error : unknow service",np.service)
		return
	end

	local f = service_pack[np.msg_id]
	if not f then
		print("on_dispatch_pack error : unhook msg id",np.msg_id,"of service",np.service)
		return
	end
	f(fd_,np.body)
end
-- 读取并调度封包
local function dispatch_package(fd)
	while loop do
		local v
		v, last = recv_package(fd,last)
		if not v then
			break
		end

		local ok,np = spx.decode_pack(v)
		if not ok then
			error("dispatch_package spx.decode_pack fail")
			return
		end
		on_dispatch_pack(fd,np)
	end
end

local function send_user_login(fd)
	print("send_user_login()")

	local body = {}
	if user_info.access_token and user_info.openid then
		body.login_type = logintype.wei_xin
		body.params = {
				{name="access_token",value=user_info.access_token}, --帐号
				{name="openid",value=user_info.openid}, --密码
			}
		print("login as wei xin")
	else
			--登录类型，帐号，qq，邮箱等，这里使用帐号登录
		body.login_type = logintype.user_name
		body.params = {
				{name="user_name",value=user_info.user_name}, --帐号
				{name="user_pass",value=user_info.user_pass}, --密码
			}
		print("login as user name")
	end

	-- 发送用户登录消息
	send_pack(fd,
		0, --登录服务器只有userlogin响应玩家消息，这里填上0
		login_msg_id.user_login, --消息编号
		-- 消息内容，先用sproto打包
		login_sproto:encode("user_login",body))
end
local function send_user_logout(fd_)
	print("send_user_logout()")
	send_pack(fd_,gate_service,gate_msg_id.user_logout,nil)
end

-- 创建成功
function login_pack.on_create_user_ok(fd,buf)
	print("create user ok")
	send_user_login(fd)
end
-- 登录失败
function login_pack.on_create_user_fail(fd,buf)
	local body = login_sproto:decode("create_user_fail",buf)
	print("user login fail",body.desc)
	send_user_login(fd)
end

-- 登录成功
function login_pack.on_user_login_ok(fd,buf)
	local body = login_sproto:decode("user_login_ok",buf)
	gate_service = body.gate_service
	user_info.user_id = body.user_id
	user_info.auth_code = body.auth_code
	gate_server_address = body.gate_address
	print("user login ok")
	print("gate_address",gate_server_address)
	print("gate_service",gate_service)
	print("user_id",user_info.user_id)
	print("auth_code",user_info.auth_code)

	-- 注册网关登录服务的消息回调
	service_pack_map[gate_service] = gate_login_map

	loop = false
end
-- 登录失败
function login_pack.on_user_login_fail(fd,buf)
	local body = login_sproto:decode("user_login_fail",buf)
	print("user login fail",body.desc)
	loop = false
end

login_map[login_msg_id.user_login_ok]=login_pack.on_user_login_ok
login_map[login_msg_id.user_login_fail]=login_pack.on_user_login_fail
login_map[login_msg_id.create_user_ok]=login_pack.on_create_user_ok
login_map[login_msg_id.create_user_fail]=login_pack.on_create_user_fail

-- 注册登录服务,0代表帐号登录
service_pack_map[0] = login_map

print("login_map")
for k,v in pairs(login_map) do
	print("type",type(k),k,v)
end

-- 在login登录
print("connect to login server",login_server_address)
local fd = assert(socket.connect(string_2_address(login_server_address)))
print("done")
-- 发送用户创建消息
send_pack(fd,
	0, --登录服务器只有userlogin响应玩家消息，这里填上0
	login_msg_id.create_user, --消息编号
	-- 消息内容，先用sproto打包
	login_sproto:encode("create_user",
	{
		--登录类型，帐号，qq，邮箱等，这里使用帐号登录
		login_type = logintype.user_name,
		user_name = user_info.user_name, --帐号
		user_pass = user_info.user_pass  --密码
	}))
loop = true
while loop do
	dispatch_package(fd)
	local cmd = socket.readstdin()
	if cmd then
		if cmd == "quit" or cmd == "exit" then
			os.exit(0)
		end
	else
		socket.usleep(100)
	end
end
socket.close(fd)

local function send_req_update_gps(fd_)
	local gps_x = math.random(1,9999)+math.random(1,999)/1000
	local gps_y = math.random(1,9999)+math.random(1,999)/1000

	local body = agent_sproto:encode("req_update_gps",{gps_x=gps_x,gps_y=gps_y,gps_state=0})
	send_pack(fd_,agent_service,agent_msg_id.req_update_gps,body)
	print("send_req_update_gps(),gps_x",gps_x,"gps_y",gps_y,"gps_state",0)
end

-- 登录网关成功
function gate_login_pack.on_user_login_ok(fd_,buf)
	local body = gate_sproto:decode("user_login_ok",buf)
	agent_service = body.agent_service
	-- 注册大厅消息
	service_pack_map[agent_service] = agent_map

	print("user login ok")
	print("agent_service",agent_service)
	--查询大厅列表
	print("send get hall list")

	--更新gps位置
	send_req_update_gps(fd_)
	send_pack(fd_,agent_service,agent_msg_id.get_hall_list,nil)
end
-- 登录网关失败
function gate_login_pack.on_user_login_fail(fd_,buf)
	local body = gate_sproto:decode("user_login_fail",buf)
	print("user login fail",body.desc)
	loop = false
end
-- 登出成功
function gate_login_pack.on_user_logout_ok(fd_,buf)
	print("user logout ok")
	loop = false
end
-- 登出失败
function gate_login_pack.on_user_logout_fail(fd_,buf)
	local body = gate_sproto:decode("user_login_fail",buf)
	print("user logout fail",body.desc)
end

gate_login_map[gate_msg_id.user_login_ok]=gate_login_pack.on_user_login_ok
gate_login_map[gate_msg_id.user_login_fail]=gate_login_pack.on_user_login_fail
gate_login_map[gate_msg_id.user_logout_ok]=gate_login_pack.on_user_logout_ok
gate_login_map[gate_msg_id.user_logout_fail]=gate_login_pack.on_user_logout_fail


-- 读取玩家信息
function agent_pack.on_user_info(fd_,buf)
	local body = agent_sproto:decode("user_info",buf)
	print("on_user_info",body.desc)
end

-- 广场消息
function agent_pack.send_get_hall_info(fd_,hall_service_)
	print("query hall info")
	send_pack(fd_,agent_service,agent_msg_id.get_hall_info,
		agent_sproto:encode("get_hall_info",{hall_service=hall_service_}))
end
function agent_pack.on_hall_list(fd_,buf)
	print("on_hall_list")
	local body = agent_sproto:decode("hall_list",buf)
	print("hall count ",#body.hall)

	for _,hall_ in pairs(body.hall) do
		print_r(hall_)

		--查找本游戏的大厅
		if hall_.hall_type==hall_info.hall_type then
			print("found zhaduizi hall,req enter")

			hall_info.hall_service = hall_.hall_service
			hall_info.hall_name = hall_.hall_name
			hall_info.hall_desc = hall_.hall_desc
			hall_info.hall_version = hall_.hall_version
			hall_info.client_version = hall_.client_version
			hall_info.is_expired = hall_.is_expired
			hall_info.user_num = hall_.user_num

			hall_service = hall_info.hall_service
			-- 注册网关登录服务的消息回调
			service_pack_map[hall_service] = hall_map

			print("hall_service",hall_service)

			agent_pack.send_get_hall_info(fd_,hall_service)
		end
	end

	--print("send logout")
	--send_pack(fd_,gate_service,gate_msg_id.user_logout,nil)
end
-- 大厅信息
function agent_pack.on_hall_info(fd_,buf)
	print("on_hall_info")
	local body = agent_sproto:decode("hall_info",buf)
	print_r(body)

	if body.hall_service==hall_service then
		print("send req enter hall")
		hall_pack.send_req_enter_hall(fd_)
	end
end
function agent_pack.ack_update_gps(fd_,buf)
	print("agent_pack.ack_update_gps()")
	local body = common_sproto:decode("error",buf)
	print_r(body)
end

agent_map[agent_msg_id.hall_list]=agent_pack.on_hall_list
agent_map[agent_msg_id.hall_info]=agent_pack.on_hall_info
agent_map[agent_msg_id.user_info]=agent_pack.on_user_info
agent_map[agent_msg_id.ack_update_gps]			= agent_pack.ack_update_gps

--发送函数
function hall_pack.send_req_enter_hall(fd_)
	print("hall_pack.send_req_enter_hall")
	send_pack(fd_,hall_service,hall_msg_id.req_enter_hall,nil)
end
function hall_pack.send_req_left_hall(fd_)
	print("hall_pack.send_req_left_hall")
	send_pack(fd_,hall_service,hall_msg_id.req_left_hall,nil)
end
function hall_pack.send_get_table_info(fd_)
	print("hall_pack.send_get_table_info")
	send_pack(fd_,hall_service,hall_msg_id.get_table_info,nil)
end
function hall_pack.send_req_create_private_table(fd_)
	print("hall_pack.send_req_create_private_table")
	local t = {
		rules = {
{name="table_mode",value=tostring(rules.table_mode)},
			{name="max_round",value=rules.max_round},
{name="max_round",value=tostring(rules.max_round)},
{name="pay_room_card",value=tostring(rules.pay_room_card)},

			{name="pay_mode",value=tostring(rules.pay_mode)},
{name="base_chip",value=tostring(rules.base_chip)},
{name="start_game_mode",value=tostring(rules.start_game_mode)},
{name="enable_flush",value=tostring(rules.enable_flush)},
{name="enable_straight",value= tostring(rules.enable_straight)},
{name="enable_suited",value=tostring(rules.enable_suited) },
{name="enable_five_small",value=tostring(rules.enable_five_small) },
{name="enbale_five_big",value=tostring(rules.enbale_five_big) },
{name="enable_full_house",value=tostring(rules.enable_full_house) },
{name="enable_bomb",value=tostring(rules.enable_bomb) },
		}
	}
	send_pack(fd_,hall_service,hall_msg_id.req_create_private_table,
		hall_sproto:encode("req_create_private_table",t))
end
function hall_pack.send_req_join_private_table(fd_)
	print("hall_pack.send_req_join_private_table")
	local t = {
		private_key = table_info.private_key,
	}
	send_pack(fd_,hall_service,hall_msg_id.req_join_private_table,
		hall_sproto:encode("req_join_private_table",t))
end
--进入离开大厅
function hall_pack.req_enter_hall_fail(fd_,buf)
	print("hall_pack.req_enter_hall_fail")

	local body = hall_sproto:decode("req_enter_hall_fail",buf)
	print(body.desc)

	send_user_logout(fd_)
end
function hall_pack.req_enter_hall_ok(fd_,buf)
	print("hall_pack.req_enter_hall_ok")

	hall_pack.send_get_table_info(fd_)
end
function hall_pack.req_left_hall_fail(fd_,buf)
	print("hall_pack.req_left_hall_fail")

	local body = hall_sproto:decode("req_enter_hall_fail",buf)
	print(body.desc)
end
function hall_pack.req_left_hall_ok(fd_,buf)
	print("hall_pack.req_left_hall_ok")

	send_user_logout(fd_)
end

--查询桌子信息
function hall_pack.get_table_info_fail(fd_,buf)
	print("hall_pack.get_table_info_fail")

	local body = hall_sproto:decode("req_enter_hall_fail",buf)
	print(body.desc)

	hall_pack.send_req_left_hall(fd_)
end
function hall_pack.your_table_info(fd_,buf)
	print("hall_pack.your_table_info")

	local body = hall_sproto:decode("your_table_info",buf)
	print_r(body)

	table_service = body.table_service
	if table_service >0 then
		service_pack_map[table_service] = table_map

		table_info.table_service = body.table_service
		--table_info.private_key = body.private_key
		table_info.private_key = "616939"
		write_table_info()

		table_pack.send_req_online(fd_)
	else
		if user_info.is_owner then
			hall_pack.send_req_create_private_table(fd_)
		else
			hall_pack.send_req_join_private_table(fd_)
		end
	end
end
--进入离开桌子
function hall_pack.you_enter_table(fd_,buf)
	print("hall_pack.you_enter_table")
	

	local body = hall_sproto:decode("you_enter_table",buf)
	print_r(body)
	table_service = body.table_service
	if table_service >0 then
		service_pack_map[table_service] = table_map

		table_info.table_service = body.table_service
		table_info.private_key = body.private_key

		write_table_info()

		table_pack.send_req_online(fd_)
	else
		print("fault : table_service is ",body.table_service)
	end
end
function hall_pack.you_left_table(fd_,buf)
	print("hall_pack.you_left_table")
	hall_pack.send_req_left_hall(fd_)
end
--创建私有桌子失败
function hall_pack.req_create_private_table_fail(fd_,buf)
	print("hall_pack.req_create_private_table_fail")

	local body = hall_sproto:decode("req_create_private_table_fail",buf)
	print(body.desc)

	hall_pack.send_req_left_hall(fd_)
end
--创建私有桌子成功
function hall_pack.req_create_private_table_ok(fd_,buf)
	print("hall_pack.req_create_private_table_ok")

	local body = hall_sproto:decode("req_create_private_table_ok",buf)
	print(body.desc)
end
function hall_pack.req_join_private_table_fail(fd_,buf)
	print("hall_pack.req_join_private_table_fail")

	local body = hall_sproto:decode("req_create_private_table_fail",buf)
	print(body.desc)

	hall_pack.send_req_left_hall(fd_)
end

hall_map[hall_msg_id.req_enter_hall_fail]				=hall_pack.req_enter_hall_fail
hall_map[hall_msg_id.req_enter_hall_ok]					=hall_pack.req_enter_hall_ok
hall_map[hall_msg_id.req_left_hall_fail]				=hall_pack.req_left_hall_fail
hall_map[hall_msg_id.req_left_hall_ok]					=hall_pack.req_left_hall_ok
hall_map[hall_msg_id.get_table_info_fail]				=hall_pack.get_table_info_fail
hall_map[hall_msg_id.your_table_info]					=hall_pack.your_table_info
hall_map[hall_msg_id.you_enter_table]					=hall_pack.you_enter_table
hall_map[hall_msg_id.you_left_table]					=hall_pack.you_left_table
hall_map[hall_msg_id.req_create_private_table_fail]		=hall_pack.req_create_private_table_fail
hall_map[hall_msg_id.req_create_private_table_ok]		=hall_pack.req_create_private_table_ok
hall_map[hall_msg_id.req_join_private_table_fail]		=hall_pack.req_join_private_table_fail

--游戏桌子处理
--发送消息
function table_pack.send_req_left_table(fd_)
	print("hall_pack.send_req_left_table")
	send_pack(fd_,table_service,table_msg_id.req_left_table,nil)
end
function table_pack.send_req_dismiss_table(fd_)
	print("hall_pack.send_req_dismiss_table")
	send_pack(fd_,table_service,table_msg_id.req_dismiss_table,nil)
end
function table_pack.send_req_online(fd_)
	print("table_pack.send_req_online")
	send_pack(fd_,table_service,table_msg_id.req_online,nil)
end
function table_pack.send_i_am_ready(fd_)
	print("table_pack.send_i_am_ready")
	send_pack(fd_,table_service,game_msg_id.req_ready,nil)
end
function table_pack.send_start_round(fd_)
	print("table_pack.send_start_round")
	send_pack(fd_,table_service,game_msg_id.req_start_round,nil)
end
function table_pack.send_req_start_game(fd_)
	print("table_pack.req_start_game")
	send_pack(fd_,table_service,game_msg_id.req_start_game,nil)
end
function table_pack.send_i_pass(fd_)
	print("table_pack.send_i_pass")
	send_pack(fd_,table_service,game_msg_id.i_pass,nil)
end
function table_pack.send_req_bet(fd_)
	print("table_pack.send_req_bet")

	local stake
	if user_info.chip>100 then
		stake = 100
	else
		stake = user_info.chip
	end

	print("send_req_bet,stake",stake)
	send_pack(fd_,table_service,game_msg_id.req_bet,
	game_sproto:encode("req_bet",{stake=stake}))
end
function table_pack.send_req_add_chip(fd_)
	print("table_pack.send_req_add_chip")
	send_pack(fd_,table_service,game_msg_id.req_add_chip,nil)
end
function table_pack.send_agree_add_chip(fd_,seat_id)
	print("table_pack.send_agree_add_chip",seat_id)
	send_pack(fd_,table_service,game_msg_id.agree_add_chip,
		game_sproto:encode("agree_add_chip",{seat_id=seat_id}))
end
function table_pack.send_refuse_add_chip(fd_,seat_id)
	print("table_pack.send_refuse_add_chip",seat_id)
	send_pack(fd_,table_service,game_msg_id.refuse_add_chip,
		game_sproto:encode("refuse_add_chip",{seat_id=seat_id}))
end
function table_pack.send_req_vote_dismiss_table(fd_,agree)
	print("table_pack.send_req_vote_dismiss_table,agree",agree)
	send_pack(fd_,table_service,table_msg_id.req_vote_dismiss_table,
		table_sproto:encode("req_vote_dismiss_table",{agree=agree}))
end

--处理接受到的桌子封包
function table_pack.user_enter_table(fd_,buf)
	print("table_pack.user_enter_table")
	local body = table_sproto:decode("user_enter_table",buf)
	print_r(body)


end
--玩家离开桌子
function table_pack.user_left_table(fd_,buf)
	print("table_pack.user_left_table")
	local body = table_sproto:decode("user_left_table",buf)
	print_r(body)
	if body.seat_id==user_info.seat_id then
		print("i left table,req left hall")
		hall_pack.send_req_left_hall(fd_)
	end
end
function table_pack.dismiss_table(fd_,buf)
	print("table_pack.dismiss_table")
	table_info.state = table_state.dismissed

	local body = table_sproto:decode("dismiss_table",buf)
	print_r(body)
end
function table_pack.begin_vote_dismiss_table(fd_,buf)
	print("table_pack.begin_vote_dismiss_table")
	local body = table_sproto:decode("begin_vote_dismiss_table",buf)
	print_r(body)

	if body.seat_id==user_info.seat_id then
		return
	end
	sleep(1)

	table_pack.send_req_vote_dismiss_table(fd_,true)
end
function table_pack.req_vote_dismiss_table_fail(fd_,buf)
	print("table_pack.req_vote_dismiss_table_fail")
	local body = common_sproto:decode("error",buf)
	print_r(body)
end
function table_pack.user_vote_dismiss_table(fd_,buf)
	print("table_pack.user_vote_dismiss_table")
	local body = table_sproto:decode("user_vote_dismiss_table",buf)
	print_r(body)
end
function table_pack.end_vote_dismiss_table(fd_,buf)
	print("table_pack.end_vote_dismiss_table")
	local body = table_sproto:decode("end_vote_dismiss_table",buf)
	print_r(body)
end
function table_pack.ack_left_table(fd_,buf)
	print("table_pack.ack_left_table")
	local body = common_sproto:decode("error",buf)
	print_r(body)
end
function table_pack.ack_dismiss_table(fd_,buf)
	print("table_pack.ack_dismiss_table")
	local body = common_sproto:decode("error",buf)
	print_r(body)
end
function table_pack.req_online_ok(fd_,buf)
	print("table_pack.req_online_ok")
	local body = table_sproto:decode("req_online_ok",buf)
	print_r(body)
	print("i am online")
	user_info.seat_id = body.seat_id
end
function table_pack.user_online(fd_,buf)
	local body = table_sproto:decode("user_online",buf)
	print_r(body)
	print("user online seat_id",body.seat_id)
end
function table_pack.user_offline(fd_,buf)
	print("table_pack.user_offline")
	local body = table_sproto:decode("user_offline",buf)
	print_r(body)
end

--从网络同步数据包
local function copy_table_info(body)
	table_info.owner = body.owner
	table_info.round = body.round
	table_info.state = body.state
	table_info.dices = body.dices
	table_info.dealer_id = body.dealer_id

	for _,user in pairs(body.users) do
		if user.seat_id==user_info.seat_id then
			user_info.stake = user.stake
			user_info.chip = user.chip
			--user_info.phase_ack = user.phase_ack
			print("my new user_info")
			print_r(user_info)
		end
	end
end
--执行玩家行动策略
local function do_act(fd_)
--	print("do_act,table_info.state",table_info.state,"user_info.phase_ack",user_info.phase_ack)
	print("my user info:")
	print_r(user_info)

	--玩家已经行动过了
	--if user_info.phase_ack~=phase_ack.none then
	--	return
	--end

	local policy = {
		[table_state.idle] = function()
			--if user_info.seat_id==1 then
				--table_pack.send_req_left_table(fd_)
			--end
			table_pack.send_i_am_ready(fd_)
		end,

		[table_state.deal] = function()
			table_pack.send_i_am_ready(fd_)
		end,
		[table_state.round_over] = function()
			--table_pack.send_i_am_ready(fd_)

			table_pack.send_start_round(fd_)
		end,
		[table_state.game_over] = function()
			table_pack.send_req_left_table(fd_)
		end,
	}
	local f=policy[table_info.state]
	if f then
		f()
	end
end
function table_pack.table_info(fd_,buf)
	print("table_pack.table_info")
	local body = game_sproto:decode("table_info",buf)
	print_r(body)

	copy_table_info(body)

	do_act(fd_)
end
function table_pack.req_online_fail(fd_,buf)
	print("table_pack.req_online_fail")
	local body = common_sproto:decode("error",buf)
	print_r(body)
	os.exit()
end
function table_pack.ack_left_table(fd_,buf)
	print("table_pack.ack_left_table")
	local body = common_sproto:decode("error",buf)
	print_r(body)
end

function table_pack.game_start(fd_,buf)
	print("table_pack.game_start")
	local body = game_sproto:decode("table_info",buf)
	print_r(body)

	copy_table_info(body)
end
function table_pack.begin_decide_dealer(fd_,buf)
	print("table_pack.begin_decide_dealer")
	sleep(3)

	table_pack.send_i_pass(fd_)
	--[[
	if math.random(0,1)>0 then
		table_pack.send_i_am_ready(fd_)
	else
		table_pack.send_i_pass(fd_)
	end
	]]
end
function table_pack.round_start(fd_,buf)
	print("table_pack.round_start")
	--user_info.phase_ack = phase_ack.none
	table_info.state = table_state.round_start
end
function table_pack.begin_bet(fd_,buf)
	print("table_pack.begin_bet")
	table_info.state = table_state.bet
	sleep(3)
	do_act(fd_)
end
function table_pack.begin_deal(fd_,buf)
	print("table_pack.begin_deal")
	table_info.state = table_state.deal
	local body = game_sproto:decode("begin_deal",buf)
	print_r(body)

	for _,user in pairs(body.users) do
		if user.seat_id==user_info.seat_id then
			user_info.hand_cards = user.hand_cards
			user_info.peng_cards = {}
			
		end
	end
end
function table_pack.round_over(fd_,buf)
	print("table_pack.round_over")
local body = game_sproto:decode("round_over",buf)
	print_r(body)
	table_info.state = table_state.round_over

	sleep(3)

	table_pack.send_start_round(fd_)
end
function table_pack.game_over(fd_,buf)
	print("table_pack.game_over")
	table_info.state = table_state.game_over

	sleep(3)

	if table_info.is_replay then
		table_pack.send_req_left_table(fd_)
	else
		table_info.is_replay = true
		table_pack.send_req_start_game(fd_)
	end
end
function table_pack.user_is_ready(fd_,buf)
	print("table_pack.user_is_ready")
	local body = game_sproto:decode("user_ready",buf)
	print_r(body)

	--if body.seat_id==user_info.seat_id then
	--	user_info.phase_ack=phase_ack.ready
	--end
		--req start
	if body.seat_id~=user_info.seat_id then 

		print("req .owner_req_start_game")

			send_pack(fd_,table_service,game_msg_id.owner_req_start_game,
		nil)	

	end
end
function table_pack.user_pass(fd_,buf)
	print("table_pack.user_pass")
	local body = game_sproto:decode("user_pass",buf)
	print_r(body)

	--if body.seat_id==user_info.seat_id then
	--	user_info.phase_ack=phase_ack.pass
	--end
end
function table_pack.user_is_dealer(fd_,buf)
	print("table_pack.user_is_dealer")
	local body = game_sproto:decode("user_is_dealer",buf)
	print_r(body)
	table_info.dealer_id = body.seat_id
end
function table_pack.req_bet_fail(fd_,buf)
	print("table_pack.req_bet_fail")
	local body = common_sproto:decode("error",buf)
	print_r(body)
end
function table_pack.user_bet(fd_,buf)
	print("table_pack.user_bet")
	local body = game_sproto:decode("user_bet",buf)
	print_r(body)

	if user_info.seat_id==body.seat_id then
		user_info.stake = body.stake
		user_info.chip = body.chip
	end
end
function table_pack.player_req_add_chip(fd_,buf)
	print("table_pack.player_req_add_chip")
	local body = game_sproto:decode("player_req_add_chip",buf)
	print_r(body)

	sleep(3)
	if math.random(0,1)>0 then
		table_pack.send_agree_add_chip(fd_,body.seat_id)
	else
		table_pack.send_refuse_add_chip(fd_,body.seat_id)
	end
end
function table_pack.req_add_chip_fail(fd_,buf)
	print("table_pack.req_add_chip_fail")
	local body = common_sproto:decode("error",buf)
	print_r(body)
end
function table_pack.player_add_chip(fd_,buf)
	print("table_pack.player_add_chip")
	local body = game_sproto:decode("player_add_chip",buf)
	print_r(body)

	if body.seat_id==user_info.seat_id then
		print("i add chip",body.chip,"rebet")
		user_info.chip = body.chip
		sleep(3)
		do_act(fd_)
	end
end

local function smart_get_que_color()

	local tmp_card_count = {0,0,0}
	for i,v in ipairs(user_info.hand_cards) do 
		tmp_card_count[mj_logic.card_color(v)] = tmp_card_count[mj_logic.card_color(v)] +1
	end 

	local tmp_less = 20
	local tmp_que_color 
	for k,v in pairs(tmp_card_count) do
			if v< tmp_less then 
					--return k
					tmp_less = v
					tmp_que_color = k
			end
	end 
	if tmp_que_color then 
		return tmp_que_color
	else 
		print("unkown error when choose que card color")
	end	
end

function table_pack.begin_ding_que(fd_,buf)
			print("table_pack.begin_ding_que")
	 local req_que_color = smart_get_que_color()

		send_pack(fd_,table_service,game_msg_id.req_ding_que,
	game_sproto:encode("req_ding_que",{card_color=req_que_color}))
	
end

function table_pack.user_ding_que(fd_,buf)
			print("table_pack.user_ding_que")
			local body = game_sproto:decode("user_ding_que",buf)
			print_r(body)	
	 
	 		if body.seat_id ==user_info.seat_id then 
					user_info.que_card_color =body.card_color
			 end
end

local function smart_choose_act()
	local bcan_follow = false
	local bcan_add = false
	local bcan_see = false
	
	local choose_act =  user_act.none
	--print_r(user_info.allow_acts)
	
	
	for _,v in ipairs(user_info.allow_acts) do
			if v.act_type == user_act.follow then 
				bcan_follow = true
				

			elseif user_act.add_chip == v.act_type then
					bcan_add = true
					
			elseif user_act.see_card == v.act_type then 
				bcan_see = true
				
			end

					
	end

	
	


	--if  bcan_follow then 
		--choose_act = user_act.follow
	--end		
	choose_act = user_act.give_up

	print("choose_act are :"..choose_act)

	return choose_act

	
end

function table_pack.you_can_act(fd_,buf)
			--sleep(1)
			print("table_pack.you_can_act")
			local body = game_sproto:decode("you_can_act",buf)
			print_r(body)	
	 		user_info.allow_acts = body.action_infos
			user_info.action_num =body.action_num
			--user_info.allow_card = body.card
			local tmp_act = smart_choose_act() 

			local req_body = {act_type = tmp_act}
		send_pack(fd_,table_service,game_msg_id.req_user_act,
	game_sproto:encode("req_user_act",req_body))				
	 		
end


local function smart_choose_swap_card()
	local tmp_choose_swap_cards = {}
    local cards = {}
    --不同花色计数器
    local color_counter = {[1]=0,[2]=0,[3]=0}
	local tmp_hand_cards_count  =# user_info.hand_cards
    for i=1, tmp_hand_cards_count do
        local card = user_info.hand_cards[i]
        table.insert(cards,card)
		local tmp_color = mj_logic.card_color(card)
        color_counter[tmp_color]=color_counter[tmp_color]+1
    end

    table.sort(cards,function (l,r)
		local tmp_color_l = mj_logic.card_color(l)
		local tmp_color_r = mj_logic.card_color(r)
		local tmp_point_l = mj_logic.card_point(l)
		local tmp_point_r = mj_logic.card_point(r)
        if color_counter[tmp_color_l]<color_counter[tmp_color_r] then
            return true
		elseif color_counter[tmp_color_l] == color_counter[tmp_color_r] then
			if tmp_color_l < tmp_color_r then 
					return true
			elseif 		tmp_color_l == tmp_color_r then
				return tmp_point_l<tmp_point_r
			else 
				return false	
			end
		else
			return false

        end
        
    end)

	print("sort  swap card result is ")
	print(sprint_r(color_counter))
	print(sprint_r(cards))

    for i=13,11,-1 do
        local card = cards[i]
        table.insert(tmp_choose_swap_cards,card)
        
    end	

	return tmp_choose_swap_cards
end

function table_pack.begin_swap_cards(fd_)
			print("table_pack.user_swap_card")
			local tmp_choose_card = smart_choose_swap_card() 

		send_pack(fd_,table_service,game_msg_id.req_swap_cards,
	game_sproto:encode("req_swap_cards",{cards=tmp_choose_card}))	
			
end


function table_pack.req_swap_cards_fail(fd_,buf)
			print("table_pack.req_swap_cards_fail")
			local body = game_sproto:decode("req_swap_cards_fail",buf)

			print_r(body)
end

function table_pack.swap_cards_results(fd_,buf)
			print("table_pack.swap_cards_results")
			local body = game_sproto:decode("swap_cards_results",buf)
			print_r(body)	

			user_info.hand_cards = body.hand_cards

			print("hand cards now...")
			print_r(user_info.hand_cards)
	 		
end


local function  smart_choos_discard()
	--first discard dingque color
	local tmp_card 
	for i,v in ipairs(user_info.hand_cards) do	
		if mj_logic.card_color(v) == user_info.que_card_color then 
			tmp_card = v
			break
		end
	end

	--discard count == 1 
	local tmp_count_info
	if not tmp_card then
		 tmp_count_info = mj_logic.count_cards(user_info.hand_cards)
		for k,v in pairs (tmp_count_info) do
			if v == 1 then 
				tmp_card = k
			end	
		end
	end	

	if not tmp_card then		

		 tmp_card = user_info.hand_cards[1]
	end
	
	if not tmp_card then 
		print("unkown error when choose discard ,tmp_card is :"..tostring(tmp_card))
		print_r(tmp_count_info)
		print("ding_que_color is :"..tostring(user_info.ding_que_color))
		print("first card is :"..tostring(user_info.hand_cards[1]))
		
		return nil 
	else	

		return tmp_card 
	end		
end

function table_pack.user_can_discard(fd_,buf)
			print("table_pack.user_can_discard")
			local body = game_sproto:decode("user_can_discard",buf)

			if body.seat_id~=user_info.seat_id then return end

	
		local req_card = smart_choos_discard()
		if not req_card then 
			print("nil card for discard !!!!!!!!!! hand_cards is :")
			print_r(user_info.hand_cards)
		end

		send_pack(fd_,table_service,game_msg_id.req_discard,
	game_sproto:encode("req_discard",{card=req_card}))	
	 		
end

function table_pack.req_discard_fail(fd_,buf)
			print("table_pack.req_discard_fail")
	
			local body = game_sproto:decode("req_discard_fail",buf)
			print_r(body)	
	 		
end


function table_pack.user_discard(seat_id,card)
			--print("table_pack.user_discard")
			--local body = game_sproto:decode("user_discard",buf)
			--print_r(body)	

			user_info.latest_discard = card

			if seat_id == user_info.seat_id then 
					print_r(user_info.hand_cards)
					mj_logic.remove_card(user_info.hand_cards,card)	
					print_r(user_info.hand_cards)			
			end
end

function table_pack.user_draw_card(fd_,buf)
			print("table_pack.user_draw_card")
			local body = game_sproto:decode("user_draw_card",buf)

			print_r(body)

			if body.seat_id == user_info.seat_id then 
				table.insert(user_info.hand_cards,body.card)
				print_r(user_info.hand_cards)	
			end

end



function table_pack.user_act_done(fd_,buf)
			print("table_pack.user_act_done")
			local body = game_sproto:decode("user_act_done",buf)

			print_r(body)

			for i,v in ipairs(body.act_done_infos ) do 

				if v.seat_id == user_info.seat_id then 
						--if body.user_act == user_act.gang then 
								if  v.user_act == user_act.wan_gang then
													print("remove not an_gang card")
										for i2,v2 in ipairs(user_info.hand_cards) do 
											if v2 == v.card then 
													table.remove(user_info.hand_cards ,i) 
													break
											end	
										end		
										
								elseif v.user_act == user_act.an_gang then
											print("remove an_gang card")
										user_info.hand_cards = mj_logic.remove_cards(user_info.hand_cards,{v.card,v.card,v.card,v.card})
										print_r(user_info.hand_cards )

								elseif v.user_act == user_act.zhi_gang  then
											print("remove zhi_gang card")
										user_info.hand_cards = mj_logic.remove_cards(user_info.hand_cards,{v.card,v.card,v.card})
										print_r(user_info.hand_cards )

								--else
								--	print("unkown gang_type :"..v.act_type)

							--	end
						elseif v.user_act == user_act.peng then 
								user_info.hand_cards = mj_logic.remove_cards( user_info.hand_cards,{v.card,v.card})
								if not  user_info.peng_cards then 
									user_info.peng_cards = {}
								end	
								table.insert(user_info.peng_cards,v.card)
						elseif v.user_act == user_act.hu then 
							print("wo hu le !!!!")															
							user_info.is_hu = true
						elseif v.user_act == user_act.discard then 

								table_pack.user_discard(v.seat_id,v.card)
						else
							print("wrong act type :"..v.user_act)

						end	
					print_r(user_info.hand_cards)
				
				else
					print("current seat id is: "..user_info.seat_id)

				end

			end

end


function table_pack.user_get_score(fd_,buf)
			print("table_pack.user_get_score")
			local body = game_sproto:decode("user_get_score",buf)

			print_r(body)
end

function table_pack.ding_que_result(fd_,buf)
			print("table_pack.ding_que_result")
			local body = game_sproto:decode("ding_que_result",buf)

			print_r(body)

			
			for i,v in ipairs(  body.que_infos) do 
				if v. seat_id == user_info.seat_id then
					user_info.que_card_color =v.que_card_color
				end
			end		

			
end

function table_pack.ding_que_result(fd_,buf)
			print("table_pack.ding_que_result")
			local body = game_sproto:decode("ding_que_result",buf)

			print_r(body)

			
			for i,v in ipairs(  body.que_infos) do 
				if v. seat_id == user_info.seat_id then
					user_info.que_card_color =v.que_card_color
				end
			end		

			
end

function table_pack.begin_piao(fd_,buf)
			print("table_pack.begin_piao")

					send_pack(fd_,table_service,game_msg_id.req_piao,
	game_sproto:encode("req_piao",{piao_state=1}))
		
end

function table_pack.user_piao(fd_,buf)
			print("table_pack.user_piao")
			local body = game_sproto:decode("user_piao",buf)

			print_r(body)

			if body.seat_id == user_info.seat_id then 

				user_info.is_piao = body.is_piao

			end
end


function table_pack.begin_ding_piao(fd_,buf)
			print("table_pack.begin_ding_piao")

					send_pack(fd_,table_service,game_msg_id.req_ding_piao,
	game_sproto:encode("req_ding_piao",{piao_state=1}))
		
end

function table_pack.user_ding_piao(fd_,buf)
			print("table_pack.user_ding_piao")
			local body = game_sproto:decode("user_ding_piao",buf)

			print_r(body)

			if body.seat_id == user_info.seat_id then 

				user_info.piao_state = body.piao_state

			end
end

function table_pack.user_start_game(fd_,buf)
			print("table_pack.user_start_game")
			local body = game_sproto:decode("user_start_game",buf)

			print_r(body)
end


function table_pack.req_piao_fail(fd_,buf)
			print("table_pack.req_piao_fail")
			local body = game_sproto:decode("req_piao_fail",buf)

			print_r(body)
end

function table_pack.req_ding_piao_fail(fd_,buf)
			print("table_pack.req_ding_piao_fail")
			local body = game_sproto:decode("req_ding_piao_fail",buf)

			print_r(body)
end

function table_pack.begin_bao_jiao(fd_,buf)
			print("table_pack.begin_bao_jiao")
			--local body = game_sproto:decode("req_piao_fail",buf)

			--print_r(body)
end

function table_pack.you_can_bao_jiao(fd_,buf)
			print("table_pack.you_can_bao_jiao")
			local body = game_sproto:decode("you_can_bao_jiao",buf)

			print_r(body)

			-- bao jiao 
					send_pack(fd_,table_service,game_msg_id.req_bao_jiao,
	game_sproto:encode("req_bao_jiao",{bao_jiao_type = 1}))			
end

function table_pack.user_bao_jiao(fd_,buf)
			print("table_pack.user_bao_jiao")
			local body = game_sproto:decode("user_bao_jiao",buf)

			print_r(body)
end

function table_pack.req_bao_jiao_fail(fd_,buf)
			print("table_pack.req_bao_jiao_fail")
			local body = game_sproto:decode("req_bao_jiao_fail",buf)

			print_r(body)
end

function table_pack.begin_play(fd_,buf)
			print("table_pack.begin_play")

		sleep(1)
				send_pack(fd_,table_service,game_msg_id.req_open_cards,	nil)		

end

function table_pack.req_open_cards_ok(fd_,buf)
			print("table_pack.req_open_cards_ok")

end

function table_pack.user_open_cards(fd_,buf)
			print("table_pack.user_open_cards")
			local body = game_sproto:decode("user_open_cards",buf)

			print_r(body)
end
--消息映射
table_map[game_msg_id.req_open_cards_ok]		=table_pack.req_open_cards_ok
table_map[game_msg_id.user_open_cards]			=table_pack.user_open_cards
table_map[table_msg_id.user_enter_table]		=table_pack.user_enter_table
table_map[table_msg_id.user_left_table]			=table_pack.user_left_table
table_map[table_msg_id.dismiss_table]			=table_pack.dismiss_table
table_map[table_msg_id.ack_left_table]			=table_pack.ack_left_table
table_map[table_msg_id.ack_dismiss_table]		=table_pack.ack_dismiss_table
table_map[table_msg_id.req_online_ok]			=table_pack.req_online_ok
table_map[table_msg_id.user_online]				=table_pack.user_online
table_map[table_msg_id.user_offline]			=table_pack.user_offline
table_map[table_msg_id.req_online_fail]			=table_pack.req_online_fail
table_map[table_msg_id.begin_vote_dismiss_table]			=table_pack.begin_vote_dismiss_table
table_map[table_msg_id.req_vote_dismiss_table_fail]			=table_pack.req_vote_dismiss_table_fail
table_map[table_msg_id.user_vote_dismiss_table]				=table_pack.user_vote_dismiss_table
table_map[table_msg_id.end_vote_dismiss_table]				=table_pack.end_vote_dismiss_table


table_map[game_msg_id.table_info]				=table_pack.table_info

table_map[game_msg_id.game_start]				=table_pack.game_start
--table_map[game_msg_id.begin_ding_que]		=table_pack.begin_ding_que
table_map[game_msg_id.round_start]				=table_pack.round_start
--table_map[game_msg_id.user_ding_que]			=	table_pack.user_ding_que
table_map[game_msg_id.begin_deal]				=table_pack.begin_deal
table_map[game_msg_id.begin_play]				=table_pack.begin_play
table_map[game_msg_id.round_over]				=table_pack.round_over
table_map[game_msg_id.game_over]				=table_pack.game_over
table_map[game_msg_id.user_ready]				=table_pack.user_is_ready
--table_map[game_msg_id.user_pass]				=table_pack.user_pass
--table_map[game_msg_id.user_is_dealer]			=table_pack.user_is_dealer
--table_map[game_msg_id.you_can_act]			=table_pack.you_can_act

--table_map[game_msg_id.user_act_done]			=table_pack.user_act_done

--table_map[game_msg_id.ding_que_result]			=table_pack.ding_que_result
table_map[game_msg_id.user_start_round]			=table_pack.user_start_round
table_map[game_msg_id.user_start_game]			=table_pack.user_start_game



-- 在gate登录
last = ""
print("connet to gate server",gate_server_address)
fd = assert(socket.connect(string_2_address(gate_server_address)))
print("done")
print("send login gate service",gate_service)
-- 发送用户登录消息
send_pack(fd,
	gate_service, --登录服务器只有userlogin响应玩家消息，这里填上0
	gate_msg_id.user_login, --消息编号
	-- 消息内容，先用sproto打包
	gate_sproto:encode("user_login",
	{
		user_id = user_info.user_id, --帐号
		auth_code = user_info.auth_code
	}))

loop = true
while loop do
	dispatch_package(fd)
	local cmd = socket.readstdin()
	if cmd then
		if cmd == "quit" or cmd == "exit" then
			os.exit(0)
		end
	else
		socket.usleep(100)
	end
end
socket.close(fd)
