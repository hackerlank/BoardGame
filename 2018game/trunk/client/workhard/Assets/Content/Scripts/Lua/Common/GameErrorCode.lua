--游戏错误码定义
EGameErrorCode={
	--操作成功
	EGE_Success=0,
	--错误的scoreid
	EGE_InvalidScoreId=1,
	--游戏正在运行中
	EGE_GamePlaying=2,
	--无效的密码或者账户名
	EGE_LoginFailed=3,
	--缺少钱钱
	EGE_LackMoney=4,
	--无下注记录
	EGE_NoBetRecord=5,
	--游戏已经开始或者结束了
	EGE_NotStart=6,
	--庄闲不能同时下注
	EGE_NotBetBankAndPlayer=7,
	--玩家已经下注
	EGE_PlayerBeted=8,
	EGE_JoinGameFail=9,
	EGE_CreateGameFail=10,
	EGE_LeaveGameFail=11,
	EGE_ReqOnlineFail=12,
	EGE_PullTableFail=13,
	EGE_LogoutFail=14,
	--请求得到record detail
	EGE_GetRecordDetailFail=15,
	--请求action
	EGE_ReqActFail=16,
	EGE_TableDismissed = 17,
	--无效错误码
	EGE_Max=10000,
}