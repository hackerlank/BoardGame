-----------------------------------------------------------------------------
--Defination:: 
--  define all data struct in here. base class
--     
-----------------------------------------------------------------------------
DEFINED_SCREEN_RESOLUTION = {width=1270, height=720}

--pre-define path of manager
DEFAULT_LUA_GAME_MODE = "Common.LaunchGameMode"
LUA_GAME_MODE_BASE = "Common.LuaGameModeBase"
LUA_GAME_MANAGER = "Common.LuaGameManager"
TOOL_LUA_GAME_MANAGER = "Common.ToolLuaGameManager"

LUA_RESOURCE_MANAGER = "Common.ResourceManager"

LUA_DOWNLOAD_MANAGER = "Common.DownloadManager"
LUA_UPDATE_MANAGER = "Common.UpdateManager"
LUA_TOOL            = "Common.Tools.LuaTool"
LUA_UI_MANAGER = "Common.UIManager"
LUA_GAME_SETTING="Common.GameSetting"
LUA_JSON_TOOL = "Common.Tools.JsonTool"
LUA_CLASS_INSTANCE = "Common.Tools.ClassInstance"
LUA_ASSET_CLASS = "Common.LuaAsset"
LUA_CLASS_DEFINITION = "Common.DefinitionClass"
LUA_GAME_ERROR_CODE = "Common.GameErrorCode"
LUA_SYSTEM_EVENT_MANAGER = "Common.SystemEventManager"

CONST_ERROR_MSGKEY_TITLE = "errorcode."

--pre-define update file 
DECOMPRESS_BUNDLE_FILE="DecompressBundle.txt"
BUNDLE_MANAGER_FILE="bm.data"
GAME_CONTENT_VERSION_FILE="Version.txt"

--pre-define asset path 
UI_IMAGE_PATH="Assets/Content/Artwork/ui/"

GAME_FACADE_NAME = 'game_facade'

--login and create account service id
SERVICE_ID_LOGIN = 0

--defined game path begin
root_path = root_path or {}

--mvc script path
root_path.GAME_MVC_CONTROLLER_PATH = ''
root_path.GAME_MVC_PROXY_PATH = ''
root_path.GAME_MVC_MEDIATOR_PATH = ''
root_path.GAME_MVC_VIEW_PATH = ''

--game mode path
root_path.GAME_MODE_PATH = ''

--game player path
root_path.GAME_PLAYER_PATH = ''

--defined game path end 

--defined net connection operationr
ENetConnOperation = {
    ENCO_LoginServer=1,  --bind to login server
    ENCO_GateServer=2, --bind to gate server
    ENCO_Reconn=3, --missed connection but we can reconnected to server
    ENCO_Relogin=4, --missed connection, need to relogin game
    ENCO_Max = 4,  --invalid
}



--Game update progress enum
EUpdateStatus = {
     -- Prepaer execute update operation
     EUS_Started=0,

     -- detemine something
     EUS_PreUpdate=1,

     -- updating
     EUS_Updating=2,

     -- update finished
     EUS_Finished=3,

     -- invalid status. will goto this state if meet problems when updating game
     EUS_MAX=4,
    }

--Bundle update mode
EBundleUpdateMode ={
    --off line mode
    EBUM_OffLine=0,

    --online mode
    EBUM_OnLine=1,

    --invalid mode. will be throw an exception??
    EBUM_MAX=2,
    }

--Defined Game type
EGameType = {
    EGT_Common=0, --it means common bundle. not a game
    EGT_NiuNiu=1, --poker_niuniu
	EGT_MAX=10000,  --Invalid Game
    }

ERestoreType={
    EST_None=0,--close all menu that is being rendered. exclude the disabled menu
    EST_Main=1,--restore main. only main menu
    EST_AllOpened=2, --restore all opened. cache all opened menu that has been opened and thier parent
    EST_Max=3,--invalid
    }

--menu type of game
EMenuType = {
    EMT_RawRes=1, --update or disk is not enough tip menu. this will be loaded from resource directory
    EMT_Common=2, --common menu
    EMT_Games=3,  --game menu
    EMT_MAX=4
    }

--Defined Game Name
GameNames = GameNames or {}
GameNames[tostring(EGameType.EGT_NiuNiu)] = "nn"
GameNames[tostring(EGameType.EGT_MAX)] = "Invalid"

--fish particle type
EFishParticleType = {
    EFPT_Coin = 1, --fish death
    EFPT_BulletExplode = 2, -- bullet explode
    EFPT_Fish2dFire = 3 ,
}

--definition game sound 
EGameSound = {
    --for background music(1-100)
    EGS_BG_General=1, --general background. login scene.

    --defined general ui sound(100-199)
    EGS_Btn_Choose=101, --button sound of ui
    EGS_Btn_Back=102, --button sound of ui
    EGS_Notice=103, --notice sound of ui


    EGS_MAX=1000,
}

--defined poker type
EPokerType = {
    EPT_Spade=0,  --黑桃
    EPT_Heart=1,  --红桃
    EPT_Club=2,   --梅花
    EPT_Diamond=3 --方块
}

--defined share type of wechat
EWeChatSceneType ={
    EWCS_Friend=0,
    EWCS_Timeline=1,
    EWCS_Favorite=2,
    EWCS_Mxa=3
}

EShareType={
    EST_Text=0,
    EST_Image=1,
    EST_Max=2
}

EPlayRecordState={
    ERS_Playing=0,
    ERS_Paused=1,
    ERS_END=2,
    ERS_Max=3,
}

CMD_FAILED_PARAM_NIL = "parameter is nil"
CMD_FAILED_PARAM_NOT_MATCH = "parameter is not match"

--Defined End Game Reason
Reason = Reason or {}
Reason.FAILURE = 'reason.failure'
Reason.PLAYER_GIVE_UP = 'reason.giveup'
Reason.SUCCESS = 'reason.success'
Reason.LOST_CONNECT = "reason.lost_connect"

--Defined notification weight
ENotiWeight = {
    ENW_System = 1, --this will always be render first
    ENW_Max = 10000, --invalid
}

ESeatDir = {
    ESD_East=1,
    ESD_South=2,
    ESD_West=3,
    ESD_North=4,
    ESD_Max=5
}

ERoomMode = {
    ERM_xzdd=1, --血战到底
    ERM_xlch=2, --血流成河
    ERM_njmj=3, --内江派奖
    ERM_zhajinhua=4, --焖鸡
    ERM_Max=10
}

EOperation = {
    EO_CreateGame=0,
    EO_JoinGame=1,
    EO_ReqOnline=2,
    EO_LeaveGame=3,
    EO_Max=4
}


DEFINED_KEY_AGGREMENT="user_aggrements"
DEFINED_KEY_LOGIN_TYPE = "login_type"
DEFINED_KEY_USER_NAME = "user_name"
DEFINED_KEY_PASSWROD = "password"
WECHAT_SHARE_SPLIT_CHAR = ","
--defined roomd id length
MAX_ROOM_ID_LEN = 6

--supported launch third app
ELaunchApp = {
    ELA_WeChat=1,
    ELA_QQ=2,
    ELA_Alipay=3
}

ERoomCardPayMode={
    ERCY_Winner=1,
    ERCY_Owner=2,
    ERCY_AA=3
}

AndroidLaunch = AndroidLaunch or {}
AndroidLaunch[tostring(ELaunchApp.ELA_WeChat)] = {package_name = "com.tencent.mm", launch_activity = "com.tencent.mm.ui.LauncherUI"}
AndroidLaunch[tostring(ELaunchApp.ELA_QQ)] = {package_name = "com.tencent.mobileqq", launch_activity = "com.tencent.mobileqq.activity.HomeActivity"}
AndroidLaunch[tostring(ELaunchApp.ELA_Alipay)] = {package_name = "com.tencent.mm", launch_activity = "com.tencent.mm.ui.LauncherUI"}
--Defined screenshot file name 
SCREEN_SHOT_FILE_NAME = "screenshot.png"