--[[
 * Class:: UIAnim_Notification
 * animation controller of notification ui. 
]]
local tbclass = tbclass or {}
local transform = nil 

--used to changed notification start position
local addedWidth = -595

--animation speed
local speed = 70

--the first content container:: text component
local trans_1 = nil 
local trans_2 = nil 
local text_1 = nil
local text_2 = nil
local text_Rect1 = nil 
local text_Rect2 = nil 
local initial_pos1 = nil
local initial_pos2 = nil 

local height = 0

local bUseFirst = false 
local tweener_1 = nil 
local tweener_2 = nil 

--whether has been inited
local bInited = false 
local owner = nil 

local abs = math.abs

function tbclass:Init(inTrans, inOwner)
    if false == bInited then 
        transform = inTrans
        bInited = true

        trans_1 = transform:Find("Panel/bg/Image/text")
        trans_2 = transform:Find("Panel/bg/Image/text2")

        text_1 = trans_1:GetComponent("Text")
        text_2 = trans_2:GetComponent("Text")

        text_Rect1 = trans_1:GetComponent("RectTransform")
        text_Rect2 = trans_2:GetComponent("RectTransform")

        initial_pos1 = text_Rect1.anchoredPosition
        initial_pos2 = text_Rect2.anchoredPosition

        height = initial_pos1.y - initial_pos2.y
        bUseFirst = true
        tweener_1 = nil 
        tweener_2 = nil 

        owner = inOwner
    end 
end 

local function GetText()
    if true == bUseFirst then 
        return text_1;
    else
        return text_2;
    end 
end 

local function GetNextText()
    if true == bUseFirst then 
        return text_2;
    else
        return text_1;
    end 
end 

local function GetRect()
    if true == bUseFirst then 
        return text_Rect1;
    else
        return text_Rect2;
    end 
    
end 

local function GetNextRect()
     if true == bUseFirst then 
        return text_Rect2;
    else
        return text_Rect1;
    end 
end 

--safe realease
local function SafeRealease()
    trans_1 = nil 
    trans_2 = nil 
    text_1 = nil 
    text_2 = nil 
    text_Rect1 = nil 
    text_Rect2 = nil 
    initial_pos1 = nil 
    initial_pos2 = nil 
end 

function tbclass:ShowNotification(msg, bIsMain)
    if true == bIsMain then 
        GetText().text = msg
        GetRect().anchoredPosition = initial_pos1
    else 
        GetNextText().text = msg
        GetNextRect().anchoredPosition = initial_pos2
    end 
end 

local function StopAnimation()
    if tweener_1 ~= nil then 
        tweener_1:Kill()
        tweener_1 = nil
    end

    if tweener_2 ~= nil then 
        tweener_2:Kill()
        tweener_2 = nil
    end 
end 

local function PlayUpAnimation(duration)
    local cor = coroutine.create(function() 
         UnityEngine.Yield(nil)
         local rect = GetRect()
         tweener_1 = DoTweenPathLuaUtil.DOLocalMoveY(rect, height, duration)  
         if tweener_1 ~= nil then 
            DoTweenPathLuaUtil.SetRelative()
            DoTweenPathLuaUtil.SetAutoKill(tweener_1, true)
            DoTweenPathLuaUtil.OnComplete(tweener_1, function() 
                tweener_1 = nil 
            end)
         end 
         rect = GetNextRect()
         tweener_2 = DoTweenPathLuaUtil.DOLocalMoveY(rect, height, duration)  
         
         if tweener_2 ~= nil then 
            DoTweenPathLuaUtil.SetRelative()
            DoTweenPathLuaUtil.SetAutoKill(tweener_2, true)
            DoTweenPathLuaUtil.OnComplete(tweener_2, function() 
                if bUseFirst then 
                    bUseFirst = false 
                else 
                    bUseFirst = true 
                end 
                if owner.OnAnimCompleted then 
                    owner:OnAnimCompleted()
                end 
                tweener_2 = nil 
            end)
         end 
    end)
    coroutine.resume(cor)
end 

local function PlayAnimation()
    local cor = coroutine.create(function() 
        UnityEngine.Yield(nil)

        local tmp = GetRect()
        if tmp ~= nil then 
            local offsetX = -(addedWidth + tmp.rect.width);

            --不往右移动
            if offsetX > 0 then 
                UnityEngine.Yield(UnityEngine.WaitForSeconds(1.5))
                if owner.OnCompeleted then 
                    owner:OnCompeleted()
                end 
    
            else
            
                local duration = abs(offsetX) / speed;
                tweener_1 = DoTweenPathLuaUtil.DOLocalMoveX(tmp,offsetX, duration) 
                DoTweenPathLuaUtil.SetRelative()
                DoTweenPathLuaUtil.SetAutoKill(tweener_1, true)
                DoTweenPathLuaUtil.OnComplete(tweener_1, function() 
                    tweener_1 = nil 
                    if owner.OnAnimCompleted then 
                        owner:OnAnimCompleted()
                    end 
                end)
            end 
        end
    end)
    coroutine.resume(cor)
end 

function tbclass:Skip()
    if tweener_1 ~= nil then 
    end 

    if tweener_2 ~= nil then 
    end 
end 

function tbclass:StartAnimation(bIsUp, duration)
    StopAnimation();
    if true == bIsUp then 
        PlayUpAnimation(duration);
    else   
        PlayAnimation();
    end         
end 

function tbclass:OnClose()

    SafeRealease()

    transform = nil 
    
    bInited = false 
end 



return tbclass