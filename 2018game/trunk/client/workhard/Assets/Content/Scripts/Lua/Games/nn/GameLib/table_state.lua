--[[
    桌子状态
    closed          桌子已经关闭
    idle            空闲，等待玩家进入
    decide_dealer   抢庄
    round_start     回合开始
    bet             下底注
    deal            发牌
    round_over      一轮游戏结束
    game_over       游戏全部结束
    dismissed       桌子解散
]]
return {
    closed = 0,
    idle = 1,
    game_start = 11,
    round_start = 30,
  --  bet = 31,
    deal = 41,
    round_over = 51,
    game_over = 61,
    dismissed = 99,
}
