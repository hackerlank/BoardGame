--Defined all common command of games. Include login , update, etc

Common = Common or {}

--Command:: login game 
Common.LOGIN_GAME_SERVER = 'common.login_game_server'

--Command:: login gate server
Common.LOGIN_GATE_SERVER = 'common.login_gate_server'

--Command:: login gate server rsp
Common.LOGIN_GATE_SERVER_RSP = 'common.login_gate_server_rsp'

--Command:: kicked by gate servet 
Common.PLAYER_WAS_KICKED = "common.player_was_kicked"

--Command:: construct net connection between client and server
Common.BIND_TO_SERVER = "common.bind_to_server"
Common.BIND_GAME_SERVER_RSP = 'common.bind_game_server_rsp'
Common.BIND_GATE_SERVER_RSP = 'common.bind_gate_server_rsp'

--Command:: register account
Common.REGISTER_ACCOUNT = 'common.register_account'

--Command:: disconnect with server
Common.DISCONNECT = 'common.disconnect'

--Command:: logout account
Common.LOGOUT = 'common.logout'
Common.LOGOUT_RSP = 'common.logout_rsp'

--Command:: pre login game
Common.PRE_LOGIN_GAME_SERVER = 'common.pre_login_game_server'
Common.UPDATE_LOGIN_MENU = "common.update_login_menu"

--Command:: on login game response
Common.LOGIN_GAME_SERVER_RSP = 'common.login_game_server_rsp'

--Command:: update finished
Common.UPDATE_FINISHED = 'common.update_finished'

--Command:: resource manager was inited 
Common.RESOURCE_INIT_FINISHED = 'common.resource_mananger_init_finished'

--Command:: start update game content
Common.START_UPDATE = 'common.start_update'

--Command:: local disk is not enough
Common.DISK_ISNT_ENOUGH ='common.disk_isnt_enough'

--Command:: initial resource manager
Common.INITIAL_RESOURCE_MANAGER = 'common.initial_resource_manager'

--Command:: unregister extra command
Common.UNREGISTER_EXTRA_COMMAND = 'common.unregister_extra_command'

--Command:: switch level
Common.SWITCH_LEVEL_COMMAND = 'common.switch_level_command'

--Command:: exit game command
Common.EXIT_GAME_COMMAND = 'common.exit_game_command'

--Command:: End Game
Common.END_GAME_COMMAND = 'common.end_game_command'

--Command:: open ui command
Common.OPEN_UI_COMMAND = 'common.open_ui_command'

--Command:: close ui command
Common.CLOSE_UI_COMMAND = 'common.close_ui_command'

--Command:: close main menu
Common.CLOSE_UI_MAIN = 'common.close_ui_main'

--Command:: set game type
Common.SET_GAME_TYPE = 'common.set_game_type'

--Command:: close general tip menu
Common.CLOSE_GENERAL_TIP = "common.close_general_tip"

--Command:: play background music
Common.PLAY_GAME_MUSIC = "common.play_game_music"

--Command:: play sound
Common.PLAY_GAME_SOUND = "comon.play_game_sound"

--Command:: on music setting changed
Common.ON_MUSIC_SETTING_CHANGED =  "common.on_music_setting_changed"

--Command:: on sound setting changed 
Common.ON_SOUND_SETTING_CHANGED = "common.on_sound_setting_changed"

--Command:: on save gamesetting
Common.ON_SAVE_GAMESETTING = "common.on_save_gamesetting"

--Command:: reset update progress
Common.SET_UPDATE_PROGRESS = "common.set_update_progress"

--Command:: set update tip
Common.SET_UPDATE_TIPS = "common.set_update_tip"

--Command:: Game has been inited
Common.INITED_GAME_MANAGERS = "common.inited_game_managers"

--Command:: show connect tip
Common.SHOW_CONNECT_SERVER = "common.show_connect_server"

--Command:: update loading level progress
Common.ON_LOADING_LEVEL = "common.on_loading_level"

--Command::render notificaitons.(not error tips)
Common.RENDER_NOTIFICAITON = "common.render_notification"

--Command:: start download game
Common.PRE_START_DOWNLOAD_GAME = "common.pre_start_download_game"

--Command::wait download
Common.WAIT_DOWNLOAD_GAME = "common.wait_download_game"

--Command:: 
Common.STARTED_DOWNLAOD_GAME = "common.started_download_game"

--Command:: update downloading progress
Common.UPDATE_DOWNLOADING_PROG = "common.update_downloading_prog"

--Command:: downloaded game
Common.DOWNLOADED_GAME = "common.downloaded_game"

--Command:: used to help us exit game
Common.ON_TOUCHED_EXIT_BTN = "common.on_touched_exit_btn"

--Command:: update player title render item
Common.FRESH_PLAYER_TITLE_ITEMS = "common.fresh_player_title_items"

--Command:: update player money 
Common.UPDATE_PLAYER_MONEY = "common.update.player_money"

--Command:: GAME_INITED_COMMAND
Common.GAME_INITED_CMD = "common.game_inited_cmd"

--Command:: render message  with a key
Common.RENDER_MESSAGE_KEY = "common.render_message_key"

--command:: render message with a value
Common.RENDER_MESSAGE_VALUE = "common.render_message_value"

--command::shut down app
Common.SHUT_DOWN_APP = "common.shut_down_app"

--command::goto main scene
Common.GOTO_MAIN_SCENE = "common.goto_main_scene"

Common.UPLOAD_GPS_LOCATION = "common.upload_gps_location"
Common.UPLOAD_GPS_LOCATION_RSP = "common.upload_gps_location_rsp"

--command:: used to query game hall of roomid
Common.PRE_JOIN_GAME = "common.pre_join_game"
Common.PRE_JOIN_GAME_RSP = "common.pre_join_game_rsp"
Common.NTF_JOIN_GAME_FAILED = "common.ntf_join_game_failed"
--command:: launch third app
Common.LAUNCH_THIRD_APP = "common.launch_third_app"
Common.LAUNCH_THIRD_APP_OK = "common.launch_third_app_ok"

--command:: get records of all games
Common.GET_RECORDS_OF_GAMES = "common.get_records_of_games"
Common.GET_RECORDS_OF_GAMES_RSP = "common.get_records_of_games_rsp"

--command:: per enter hall
Common.PRE_ENTER_HALL = "common.pre_enter_hall"

--command:: req chat 
Common.SEND_CHAT = "common.send_chat"
Common.SEND_CHAT_RSP = "common.send_chat_rsp"

Common.SEND_MAIL = "common.send_mail"

--command:: get detail of single record
Common.GET_RECORD_DETAIL = "common.get_record_detail"
Common.GET_RECORD_DETAIL_RSP = "common.get_record_detail_rsp"

Common.PLAYER_RECONNECTED = "common.player_reconnected"

--通知玩家准备好了
Common.NTF_PLAYER_READY = "common.ntf_player_ready"
--通知新的一局开始了
Common.NTF_ROUND_START = "common.ntf_round_start"
--通知玩家得到分数
Common.NTF_USER_GET_SCORE = "common.ntf_player_get_score"

--command:: notification of wechat
Common.ON_WECHAT_LOGIN = "common.on_wechat_login"
Common.ON_WECHAT_SHARE = "common.on_wechat_share"
Common.ON_WECHAT_PAY = "common.on_wechat_pay"
Common.WECHAT_LOGIN = "common.wechat_login"
Common.WECHAT_SHARE = "common.wechat_share"
Common.WECHAT_PAY = "common.wechat_pay"
Common.WECHAT_GET_USER_INFO = "common.wechat_get_user_info"

--通知玩家开始投票
Common.NTF_PLAYER_START_VOTE = "common.ntf_player_start_vote"
--通知玩家停止投票
Common.NTF_PLAYER_STOP_VOTE = "common.ntf_player_stop_vote"
--通知玩家已经投票，用于更新界面信息
Common.NTF_PLAYER_VOTED = "common.ntf_player_voted"
--通知庄家开始出牌
Common.NTF_DEALER_DISCARD = "common.ntf_dealer_discard"
--command:: NTF_PLAYER_LEFT_GAME
Common.NTF_PLAYER_LEFT_GAME = "common.ntf_player_left_game"
--command:: a new player has joined this game
Common.NTF_PLAYER_JOINED_GAME = "common.ntf_player_joined_game"
--command：：通知玩家换牌数量，是否自己换牌请求成功
Common.NTF_SWAPPED_CARD = "common.ntf_swapped_card"
--command:: 通知换牌结果(only self)
Common.NTF_SWAP_CARD_RESULT = "common.ntf_swap_card_result"
--command::通知换牌失败
Common.NTF_SWAP_CARD_FAIL = "common.ntf_swap_card_fail"
--通知玩家摸牌
Common.NTF_PLAYER_DRAW_CARD = "common.ntf_player_draw_card"
--通知其他玩家： 有人设置定缺了
Common.NTF_PLAYER_DING_QUE = "common.ntf_player_ding_que"
--通知玩家可以操作了
Common.NTF_PLAYER_ACTION = "common.ntf_player_action"
--通知游戏已经开始了
Common.NTF_GAME_START = "common.ntf_game_start"
--通知本局结束
Common.NTF_ROUND_OVER = "common.ntf_round_over"
--游戏结束通知
Common.NTF_GAME_OVER = "common.ntf_game_over"
--通知开始设置定缺
Common.NTF_SET_DING_QUE = "common.ntf_set_ding_que"
--通知开始游戏
Common.NTF_PLAY_GAME = "common.ntf_play_game"
--通知开始发牌
Common.NTF_SHUFFLE = "common.ntf_shuffle"
--通知开始换牌
Common.NTF_START_SWAP_CARD = "common.ntf_start_swap_card"
--通知玩家操作完毕
Common.NTF_PLAYER_ACT_DONE = "common.ntf_player_act_done"
--通知玩家chat
Common.NTF_PLAYER_CHAT = "common.ntf_player_chat"
--玩家请求开始round通知
Common.NTF_PLAYER_START_ROUND = "common.ntf_player_start_round"
--通知玩家上线
Common.NTF_PLAYER_ONLINE = "common.ntf_player_online"
--通知玩家离线
Common.NTF_PLAYER_OFFLINE = "common.ntf_player_offline"

--玩家请求投票解散房间
Common.PLAYER_VOTE_DISMISS = "common.player_vote_dismiss"
Common.PLAYER_VOTE_DISMISS_RSP = "common.player_vote_dismiss_rsp"
--command:: player dismiss table
Common.PLAYER_DISMISS_TABLE = "common.player_dismiss_table"
Common.PLAYER_DISMISS_TABLE_RSP = "common.player_dismiss_table_rsp"


Common.GAME_SHUFFLED = "common.game_shuffled"
Common.EXECUTE_CMD_DONE = "common.execute_cmd_done"


--the first part of common command. 
--common command must be registered with two parts. because, the second part
-- depends some files which was packed into other bundles.
Common.tb_cmdUpdate = Common.tb_cmdUpdate or {}
if #Common.tb_cmdUpdate == 0 then 
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.START_UPDATE, script='Common.Controller.StartUpdateCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.UPDATE_FINISHED, script='Common.Controller.UpdateFinishedCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.RESOURCE_INIT_FINISHED, script='Common.Controller.InitedRmCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.DISK_ISNT_ENOUGH, script='Common.Controller.DiskIsntEnoughCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.INITIAL_RESOURCE_MANAGER, script='Common.Controller.InitialRmCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.OPEN_UI_COMMAND, script='Common.Controller.OpenUICommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.SWITCH_LEVEL_COMMAND, script='Common.Controller.SwitchLevelCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.CLOSE_UI_COMMAND, script='Common.Controller.CloseUICommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.END_GAME_COMMAND, script='Common.Controller.EndGameCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.INITED_GAME_MANAGERS, script='Common.Controller.GameManagersInitedCommand'}
    Common.tb_cmdUpdate[#Common.tb_cmdUpdate+1] = {name=Common.GAME_INITED_CMD, script='Common.Controller.GameInitedCommand'}
end

--table:: command and script path
Common.tb_commands = Common.tb_commands or {}
if #Common.tb_commands == 0 then  
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.LOGIN_GAME_SERVER, script='Common.Controller.LoginGameServerCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PLAYER_WAS_KICKED, script='Common.Controller.PlayerWasKickedCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.BIND_TO_SERVER, script='Common.Controller.BindServerCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.BIND_GAME_SERVER_RSP, script='Common.Controller.BindGameServerRspCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.BIND_GATE_SERVER_RSP, script='Common.Controller.BindGateServerRspCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.UNREGISTER_EXTRA_COMMAND, script='Common.Controller.UnregisterExtraCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.SET_GAME_TYPE, script='Common.Controller.SetGameTypeCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.EXIT_GAME_COMMAND, script='Common.Controller.ExitGameCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.REGISTER_ACCOUNT, script='Common.Controller.RegisterAccountCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.LOGIN_GAME_SERVER_RSP, script='Common.Controller.LoginGameServerRspCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PLAY_GAME_MUSIC, script='Common.Controller.PlayGameMusicCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PLAY_GAME_SOUND, script='Common.Controller.PlayGameSoundCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.ON_MUSIC_SETTING_CHANGED, script='Common.Controller.OnMusicSettingChangedCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.ON_SOUND_SETTING_CHANGED, script='Common.Controller.OnSoundSettingChangedCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.ON_SAVE_GAMESETTING, script='Common.Controller.OnSaveGameSettingCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PRE_LOGIN_GAME_SERVER, script='Common.Controller.PreLoginGameServerCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.LOGIN_GATE_SERVER, script='Common.Controller.LoginGateServerCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.LOGIN_GATE_SERVER_RSP, script='Common.Controller.LoginGateServerRspCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PRE_START_DOWNLOAD_GAME, script='Common.Controller.StartDownloadGameCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.WECHAT_LOGIN, script='Common.Controller.WeChatLoginCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.WECHAT_SHARE, script='Common.Controller.WeChatShareCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.WECHAT_PAY, script='Common.Controller.WeChatPayCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.WECHAT_GET_USER_INFO, script='Common.Controller.WeChatGetUserInfoCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.LOGOUT, script='Common.Controller.LogoutCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.LOGOUT_RSP, script='Common.Controller.LogoutRspCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.DISCONNECT, script='Common.Controller.DisconnectCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.SHUT_DOWN_APP, script='Common.Controller.ShutdownAppCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.GOTO_MAIN_SCENE, script='Common.Controller.GotoMainSceneCommand'}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.NTF_PLAYER_START_VOTE, script="Common.Controller.NtfPlayerStartVoteCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PLAYER_VOTE_DISMISS, script="Common.Controller.VoteCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PLAYER_DISMISS_TABLE, script="Common.Controller.DismissTableCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.UPLOAD_GPS_LOCATION, script="Common.Controller.UploadGPSLocationCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.UPLOAD_GPS_LOCATION_RSP, script="Common.Controller.UploadGPSLocationRspCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PRE_JOIN_GAME, script="Common.Controller.PreJoinGameCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PRE_JOIN_GAME_RSP, script="Common.Controller.PreJoinGameRspCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.LAUNCH_THIRD_APP, script="Common.Controller.LaunchThirdAppCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.SEND_MAIL, script="Common.Controller.SendMailCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.PRE_ENTER_HALL, script="Common.Controller.PreEnterHallCommand"}

    Common.tb_commands[#Common.tb_commands+1] = {name=Common.GET_RECORD_DETAIL, script="Common.Controller.GetRecordDetailCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.GET_RECORD_DETAIL_RSP, script="Common.Controller.GetRecordDetailRspCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.GET_RECORDS_OF_GAMES, script="Common.Controller.GetGameRecordsCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.SEND_CHAT, script="Common.Controller.SendChatCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.SEND_CHAT_RSP, script="Common.Controller.SendChatRspCommand"}
    Common.tb_commands[#Common.tb_commands+1] = {name=Common.GAME_SHUFFLED, script="Common.Controller.GameShuffledCommand"}
end

--PROXY'S NAME:: login proxy name
Common.LOGIN_PROXY = 'common.login_proxy'

--table:: proxy and script path
Common.tb_proxy = Common.tb_proxy or {}
if #Common.tb_proxy == 0 then 
    Common.tb_proxy[#Common.tb_proxy+1] = {name=Common.LOGIN_PROXY, script="Common.Proxy.LoginProxy"}
end


--Define common menu name 
Common.MENU_MAIN = "UI_Main"
Common.MENU_LOGIN = "UI_Login"
Common.MENU_GENERAL_TIP = "UI_GeneralTip"
Common.MENU_SETTING = "UI_GameSetting"
Common.MENU_SETTING_RUNTIME = "UI_GameSetting_Runtime"
Common.MENU_LOADING = "UI_Loading"
Common.MENU_NOTIFICATION = "UI_Notification"
Common.MENU_MSGBOX = "UI_MsgBox"
Common.MENU_MJ_CDXZ_RULES = "UI_CreateCDMJTable"
Common.MENU_MJ_CDXZ_JOIN = "UI_HallJoinView"
Common.MENU_MAIL = "UI_Mail"
Common.MENU_GM = "UI_GM"
Common.MENU_HELP = "UI_Help"
Common.MENU_ACHIEVE = "UI_Achieve"
Common.MENU_ACHIEVE_DETAIL = "UI_AchieveDetail"
Common.MENU_PURCHASE = "UI_Purchase"
Common.MENU_USER_DETAIL = "UI_UserDetail"
Common.MENU_WECHAT_SHARE = "UI_WeChatShare"
Common.MENU_VOTE = "UI_Vote"
Common.MENU_VOTE_RESULT = "UI_VoteResult"
Common.MENU_JOIN_ROOM = "UI_JoinRoom"
Common.MENU_SAFE_WARNINIG = "UI_SafeWarning"
Common.MENU_DUPLICATE_OK = "UI_DuplicateOk"
Common.MENU_CHAT = "UI_Chat"
Common.MENU_USER_AGGREMENT = "UI_UserAggrements"
Common.MENU_OCCLUSION = "UI_Occlusion"
Common.MENU_LOG = "UI_Log"
Common.MENU_CONNECT = "UI_Connect"


