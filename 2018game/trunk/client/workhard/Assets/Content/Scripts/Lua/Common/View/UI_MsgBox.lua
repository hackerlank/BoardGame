--[[
  * ui view class:: UI_MsgBox
  * @Opened
  *   this function will be invoked after menu object has been created.each of menu view class
  *   must contains it.
  * @Init
  *   this function will be automatic called by Opened
  * @OnDisable
  *   this function will be invoked when player is hiding window. each of menu 
  *   menu view class must contains it.  called by mediator
  * @OnRestore
  *   this function will be invoked when player wants to re-render self. called by mediator
  * @OnClose
  *   this function will be called when player is closing self. called by mediator. 
  *   will call SafeRelease function to safely free assets .. etc
  * @SafeRelease
  *   unbind listeners, free asset references, destroy windown object ... etc. if self is not be called 
  *   will cause memory leak.
  * @NOTE
  *  if self want to revice unity events such as Update , FixedUpdate.please register self to lua game mode.
  *  Generally OnDestory function is useless for menu, so you should not implement OnDestory function.
]]
local tbclass = tbclass or {} 

--log function reference. remove these if needed
local LogError = UnityEngine.Debug.LogError

--cache the window object
local transform = nil

--window name
local windownName = nil

--loaded lua asset. custom definition data type
local windowAsset = nil

--whether self has been opened
local bOpened = false

--save the mediator
local mediator = nil

--save game facade
local facade = nil

--cache all msg item
local tb_msg =  nil 

local template_msg = nil 
local initial_pos = nil 
local msg_parent = nil 
local endPos = nil 

local ANIM_TWEEN_TIME = 1.0

local Canvas = nil 


--opened events. called by uiManager
function tbclass:Opened(inTrans, inName, luaAsset)
    transform = inTrans
    windownName = inName
    windowAsset = luaAsset
    self:Init()
    bOpened = true
end 

--bind listeners, ...etc
function tbclass:Init()
    if transform == nil then 
        LogError('[UI_MsgBox.Init]:: missing transform')
        return
    end 
    tb_msg = {}
    local trans = transform:Find("Panel/msg_tree/template_msg")
    initial_pos = trans.localPosition
    template_msg = trans.gameObject
    msg_parent = transform:Find("Panel/msg_tree")

    Canvas = transform:GetComponent('Canvas')
    if UnityEngine.Camera.main ~= nil then
        Canvas.worldCamera = UnityEngine.Camera.main
    end

    endPos = UnityEngine.Vector3(initial_pos.x, initial_pos.y + 80, initial_pos.z)

    template_msg:SetActive(false)

    facade = pm.Facade.getInstance(GAME_FACADE_NAME)
end 

--set the mediator
--@param inMediator 
function tbclass:SetMediator(inMediator)
    mediator = inMediator
end 

--OnDisable:: called by mediator
function tbclass:OnDisable()

end 

--OnRestore:: called by mediator
function tbclass:OnRestore()

end 

--OnClose:: called by mediator
function tbclass:OnClose()
    bOpened = false
    self:SafeRelease()
    transform = nil
end 

--release asset reference, unbind listeners...etc
function tbclass:SafeRelease()
    if windowAsset ~= nil then 
        windowAsset:Free(1)
    end 
    initial_pos = nil 
    template_msg = nil 
    msg_parent = nil 

    if tb_msg ~= nil then 
        for k,v in ipairs(tb_msg) do 
            if v then 
                v.gameObject = nil 
                if v.anim_tween ~= nil then 
                    DoTweenPathLuaUtil.Kill(v.anim_tween, false)
                    v.anim_tween = nil 
                end 
                v.text_content = nil 
            end 

            tb_msg[k] = nil 
        end 
    end 
    tb_msg = nil 
    windowAsset = nil   
    facade = nil
    if transform ~= nil then 
        UnityEngine.GameObject.Destroy(transform.gameObject);
    end 
end

local function CreateNewMsg(sz_value)
    local tmp_msg = nil 
    if template_msg ~= nil and msg_parent ~= nil then 
        local go = UnityEngine.GameObject.Instantiate(template_msg)
        if go ~= nil then 
            tmp_msg = {}
            tmp_msg.trans = go.transform
            tmp_msg.gameObject = go 
            go.name = string.format("msg_%s", #tb_msg + 1)
            tmp_msg.text_content = tmp_msg.trans:Find("content"):GetComponent("Text")
            tmp_msg.text_content.text = sz_value
            tmp_msg.trans:SetParent(msg_parent)
            TransformLuaUtil.SetTransformLocalScale(tmp_msg.trans, 1, 1, 1)
            TransformLuaUtil.SetTransformPos(tmp_msg.trans, initial_pos.x, initial_pos.y, initial_pos.z)
            go:SetActive(true)

            tmp_msg.anim_tween = DoTweenPathLuaUtil.DOLocalMoveY(tmp_msg.trans, endPos.y, ANIM_TWEEN_TIME)--  DoTweenPathLuaUtil.DOMove(tmp_msg.trans, endPos, ANIM_TWEEN_TIME);
            tmp_msg.bUsing = true 
            DoTweenPathLuaUtil.SetEaseTweener(tmp_msg.anim_tween, DG.Tweening.Ease.OutExpo)
            DoTweenPathLuaUtil.SetAutoKill(tmp_msg.anim_tween, false)
            DoTweenPathLuaUtil.OnComplete(tmp_msg.anim_tween, function() 
                tmp_msg.gameObject:SetActive(false)
                DoTweenPathLuaUtil.DOPlayBackwards(tmp_msg.trans)
            end)

            DoTweenPathLuaUtil.OnRewind(tmp_msg.anim_tween, function() 
                tmp_msg.bUsing = false       
            end)
            table.insert(tb_msg, tmp_msg)
        end 
    end 
end 

local function FindValidMsgItem()
    for k,v in ipairs(tb_msg) do 
        if v ~= nil and v.bUsing == false then 
            return v 
        end 
    end 

    return nil
end 

--show a message with key. will loading content from ini configuration file.
--@param sz_key the unique key
function tbclass:ShowMsgWithKey(sz_key)
    if sz_key == nil or sz_key == "" then 
        return 
    end 

    local sz_content = luaTool:GetCharacters(sz_key)
    if sz_content == nil or sz_content == "" then 
        return 
    end 

    local active_msg = FindValidMsgItem()
    if active_msg == nil then 
        active_msg = CreateNewMsg(sz_content)
    else 
        active_msg.text_content.text = sz_content
        if active_msg.anim_tween ~= nil then 
            active_msg.gameObject:SetActive(true)
            active_msg.bUsing = true 
            DoTweenPathLuaUtil.DORestart(active_msg.trans)
        end 
    end 
end 

--show a message with content.
--@param sz_content 
function tbclass:ShowMsgWithContent(sz_content)
     if sz_content == nil or sz_content == "" then 
        return 
    end 
    local active_msg = FindValidMsgItem()
    if active_msg == nil then 
        active_msg = CreateNewMsg(sz_content)
    else 
        active_msg.text_content.text = sz_content
        if active_msg.anim_tween ~= nil then 
            active_msg.gameObject:SetActive(true)
            active_msg.bUsing = true 
            DoTweenPathLuaUtil.DORestart(active_msg.trans)
        end 
    end 
end 

--Don't remove all of them
return tbclass