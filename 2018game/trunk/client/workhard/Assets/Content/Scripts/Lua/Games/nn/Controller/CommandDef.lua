--[[
*
*Defined all mvc command of game. Global class
*
]]
nn = nn or {}

local GameName = GetLuaGameManager().GetGameName()
nn.REGISTER_EXTRA_COMMANDS = "nn.register_extra_commands"

--command:: remove all controllers, views, mediators, etc....
nn.UNREGISTER_EXTRA_COMMANDS = GameName .. ".unregister_extra_commands"

--command:: player enter hall 
nn.PLAYER_ENTER_HALL = GameName ..".player_enter_hall"
nn.PLAYER_ENTER_HALL_RSP = "nn.player_enter_hall_rsp"

--command:: player leave hall 
nn.PLAYER_LEAVE_HALL = "nn.player_leave_hall"
nn.PLAYER_LEAVE_HALL_RSP = "nn.player_leave_hall_rsp"

--command:: playe joined fish game
nn.PLAYER_CREATE_GAME = GameName .. ".player_create_game"
nn.PLAYER_CREATE_GAME_RSP = "nn.player_create_game_rsp"

--command:: playe joined fish game
nn.PLAYER_JOIN_GAME = GameName .. ".player_join_game"
nn.PLAYER_JOIN_GAME_RSP = "nn.player_join_game_rsp"

--command:: player reconnected
nn.PLAYER_REQ_ONLINE = "nn.player_req_online"
nn.PLAYER_REQ_ONLINE_RSP = "nn.player_req_online_rsp"

--command:: player pull table info
nn.PLAYER_PULL_TABLE_INFO = "nn.pull_table_info"
nn.PLAYER_PULL_TABLE_INFO_RSP = "nn.pull_table_info_rsp"

--command:: player leave fish game
nn.PLAYER_LEAVE_GAME = "nn.player_leave_game"
nn.PLAYER_LEAVE_GAME_RSP = "nn.player_leave_game_rsp"

--command:: player req act
nn.PLAYER_REQ_ACT = "nn.player_req_act"
nn.PLAYER_REQ_ACT_RSP = "nn.player_req_act_rsp"

--command:: player ready
nn.PLAYER_REQ_READY = "nn.player_req_ready"
nn.PLAYER_REQ_READY_RSP = "nn.player_req_ready_rsp"

--command:: player req start new game
nn.PLAYER_REQ_START_GAME = "nn.player_req_start_game"
nn.PLAYER_REQ_START_GAME_RSP = "nn.player_req_start_game_rsp"

--command:: player req start new game
nn.PLAYER_REQ_START_ROUND = "nn.player_req_start_round"
nn.PLAYER_REQ_START_ROUND_RSP = "nn.player_req_start_round_rsp"

--command:: 退出播放录像
nn.EXIT_PLAY_RECORD = "nn.exit_play_record"
nn.START_PLAY_RECORD = "nn.start_play_record"
nn.PAUSE_PLAY_RECORD = "nn.pause_play_record"
nn.RESUME_PLAY_RECORD = "nn.resume_play_record"
nn.PLAY_RECORD_NEXT_STEP = "nn.play_record_next_step"
nn.PLAY_RECORD_PREV_STEP = "nn.play_record_prev_step"
nn.RESTART_PLAY_RECORD = "nn.restart_play_record"

nn.NTF_RESET_PLAYER_INFOS = "nn.ntf_reset_player_infos"

--command::send message to we chat
nn.SEND_MSG_WECHAT = "nn.send_msg_wechat"

--command:: duplicate message to clipboard
nn.DUPLICATE_ROOM_ID = "nn.duplicate_room_id"

--table:: command with script file
nn.tb_commands = nn.tb_commands or {}
--avoid commands repeat
if #nn.tb_commands == 0 then 
    --common command for each game 
    nn.tb_commands[#nn.tb_commands+1] = {name=Common.NTF_ROUND_OVER, script="RoundOverCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=Common.NTF_PLAYER_STOP_VOTE, script="VoteEndCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=Common.EXECUTE_CMD_DONE, script="ExecuteDoneCommand"}  
    nn.tb_commands[#nn.tb_commands+1] = {name=Common.NTF_GAME_OVER, script="NtfGameOverCommand"}  

    --especial command of game
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.UNREGISTER_EXTRA_COMMANDS, script="UnregisterExtraCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_JOIN_GAME, script="JoinGameCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_JOIN_GAME_RSP, script="JoinGameRspCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_LEAVE_GAME, script="LeaveGameCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_LEAVE_GAME_RSP, script="LeaveGameRspCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_CREATE_GAME, script="CreateGameCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_CREATE_GAME_RSP, script="CreateGameRspCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_REQ_ONLINE, script="ReqOnlineCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_REQ_ONLINE_RSP, script="ReqOnlineRspCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_ENTER_HALL, script="EnterHallCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_ENTER_HALL_RSP, script="EnterHallRspCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_LEAVE_HALL, script="LeaveHallCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_LEAVE_HALL_RSP, script="LeaveHallRspCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_PULL_TABLE_INFO, script="PullTableInfoCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_PULL_TABLE_INFO_RSP, script="PullTableInfoRspCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.SEND_MSG_WECHAT, script="WeChatShareCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.DUPLICATE_ROOM_ID, script="DuplicateRoomIdCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_REQ_START_GAME, script="StartGameCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_REQ_START_ROUND, script="StartRoundCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.EXIT_PLAY_RECORD, script="ExitPlayRecordCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.START_PLAY_RECORD, script="StartPlayRecordCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PAUSE_PLAY_RECORD, script="PauseRecordCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.RESUME_PLAY_RECORD, script="ResumeRecordCommand"} 
	nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAY_RECORD_NEXT_STEP, script="PlayRecordNextStepCommand"}
	nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAY_RECORD_PREV_STEP, script="PlayRecordPrevStepCommand"}
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.RESTART_PLAY_RECORD, script="RestartPlayRecordCommand"}  
    nn.tb_commands[#nn.tb_commands+1] = {name=nn.PLAYER_REQ_READY, script="PlayerReadyCommand"}
    
end

--proxy
nn.GAME_PROXY_NAME = 'nn.game_proxy'

--table:: proxy with script file
nn.tb_proxy = nn.tb_proxy or {}
if #nn.tb_proxy == 0 then 
    nn.tb_proxy[#nn.tb_proxy+1] = {name=nn.GAME_PROXY_NAME, script="GameProxy"}
end

nn.ERecordGameStep={
    EGS_Idle=0,
    EGS_SetPiao=1,
    EGS_SetDingPiao=2,
    EGS_Ready=3,
    EGS_Shuffle=4,
    EGS_BaoJiao=5,
    EGS_Playing=6,
    EGS_Over=7,
    EGS_Max=8
}


nn.EParticleSystymType = {
		PS_PENG = 1,
		PS_GANG = 2,
		PS_GUAFENG = 3,
		PS_ZIMO =4,
		PS_HU =5,
		PS_XIAYU = 6,
		PS_GANGSHANGHUA = 7,
		PS_GANGSHANGPAO = 8,
		PS_ZHIGANG = 9,
		PS_WANGANG =10,
		PS_ZIGANG =11,
		PS_DIHU =12,
		PS_TIANHU = 13,
		PS_QIANGGANG=14,
		
}

nn.ETableMode = depends("Games.nn.GameLib.table_mode")
nn.EScoreType = depends("Games.nn.GameLib.score_type")
nn.ETableState = depends("Games.nn.GameLib.table_state")
nn.EUserAct = depends("Games.nn.GameLib.user_act")
nn.EUserGameState = depends("Games.nn.GameLib.user_game_state")
nn.EHandCardState = depends("Games.nn.GameLib.user_hand_cards_state")
nn.ECardColor = depends("Games.nn.GameLib.poker_color")
nn.ECardPoint = depends("Games.nn.GameLib.poker_point")
nn.game_logic = depends("Games.nn.GameLib.niuniu_logic")
nn.ENiuStyle = depends("Games.nn.GameLib.niu_style")

--defined game menus
nn.GAME_VIEW = "Game"
nn.GAME_FIGHT_MENU = "UI_Fight"
nn.GAME_ROUND_OVER_MENU = "UI_RoundOver"
nn.GAME_RECORD_ROUND_OVER_MENU = "UI_RecordRoundOver"
nn.GAME_OVER_MENU = "UI_GameOver"
nn.GAME_OVER_3_MENU = "UI_GameOver_3"
nn.GAME_PLAY_VIDEO_MENU = "UI_PlayVideo"
nn.GAME_ROUND_OVER_DETAIL_MENU = "UI_RoundOverDetail"