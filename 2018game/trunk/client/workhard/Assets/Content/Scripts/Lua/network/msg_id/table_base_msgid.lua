--桌子服务基础消息编号1-1000号为框架保留，其他游戏消息从1001开始
return {
    -- s2c 有玩家进入桌子，body : user_enter_table
    user_enter_table = 1,
    -- s2c 有玩家离开桌子，body : user_left_table
    user_left_table = 2,
    -- c2s 玩家请求离开桌子,body none
    req_left_table = 11,
    -- s2c 玩家请求离开桌子失败 body common.error
    ack_left_table = 12,
    --[[
        s2c通知解散桌子,body none
        这个消息只是通知桌子即将解散，客户端应该立即锁定玩家操作，等待离开房间
    ]]
    dismiss_table = 31,
    -- c2s 玩家请求上线,body none
    req_online = 41,
    -- s2c 玩家请求上线失败,body common.error
    req_online_fail = 42,
    --s2c  玩家请求上线成功,body req_online_ok
    req_online_ok = 43,
    --s2c 向其他玩家广播玩家上线消息,body user_online
    user_online = 47,
    --s2c 向其他玩家广播玩家离线,body user_offline
    user_offline = 48,

    -- c2s 玩家请求解散房间 body none
    req_dismiss_table           = 51,
    -- s2c 玩家请求解散房间结果 body common.error code 0 成功,非零失败
    ack_dismiss_table           = 52,
    -- s2c 广播开始投票 body begin_vote_abort
    begin_vote_dismiss_table    = 53,
    -- c2s 玩家投票终止游戏 body req_vote_dismiss_table
    req_vote_dismiss_table      = 54,
    -- s2c 玩家请求投票结果 body common.error
    req_vote_dismiss_table_fail = 55,
    -- s2c 广播玩家投票终止游戏 body user_vote_dismiss_table
    user_vote_dismiss_table     = 56,
    --[[
        s2c 广播投票解散桌子结果
        body common.error
    ]]
    end_vote_dismiss_table      = 57,

    -- 请求发送聊天消息
    req_chat                    = 61,
    -- 请求聊天失败,body common.error
    req_chat_fail               = 62,
    -- 有玩家聊天
    user_chat                   = 63,
}
