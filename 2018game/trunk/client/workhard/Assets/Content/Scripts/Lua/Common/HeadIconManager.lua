local HeadIconManager = HeadIconManager or {}

local COMPONENT_NAME = "head_icon_manager"
--a table used to cache the head icon of player
-- name :: hd5 value of url
-- sprite:: the sprite image
local tb_iconMap = nil 

local LogError = UnityEngine.Debug.LogError
local Log = UnityEngine.Debug.Log

--table used to save the icon which need to be load
-- urls, fn_callback
local tb_iconNeedLoad = nil 
local tb_downloading = nil 
local m_GameManager = nil 

function HeadIconManager.Init()
    tb_iconMap = {}
    tb_iconNeedLoad = {}
    tb_downloading = {}

    m_GameManager = GetLuaGameManager()
    m_GameManager.RegisterManager(HeadIconManager, COMPONENT_NAME)
    --HeadIconManager:StartLoadCor()
end 

local function _DownloadHeadIcon()
    while #tb_iconNeedLoad > 0 do 
        local tmp_set = tb_iconNeedLoad[1] 
        if tmp_set ~= nil then 
            for i=1, #tmp_set.urls do 
               
                local url = tmp_set.urls[i]
                local name = String(url):GetHashCode()
       
                tmp_set.sprites[i] = {}
                tmp_set.tb_downloader[i] = ""
                if tb_iconMap[name] ~= nil then    
                    tmp_set.sprites[i] = tb_iconMap[name]
                elseif url == "" then 
                    tb_iconMap[name] = LuaAsset.new(name, nil)
                    tmp_set.sprites[i] = tb_iconMap[name]
                else 
                    local m_downloader = nil 
                    local m_path = string.format("%s/%s",CustomTool.FileSystem.headIconPath, name)
                    local m_bIsExistLocal = false 
                    if CustomTool.FileSystem.Exist(m_path) == true then 
                        --download from local disk
                        m_bIsExistLocal = true 
                    end 
                    
                    if m_bIsExistLocal == true then 
                        m_path = "file:///" .. m_path
                        m_downloader = UnityEngine.WWW(m_path)
                    else 
                        m_downloader = UnityEngine.WWW(url)
                    end 
                    tmp_set.tb_downloader[i] = m_downloader
                end 
               
            end 
            table.insert(tb_downloading, tmp_set)
            table.remove(tb_iconNeedLoad, 1)
        end 
    end       
end 

function HeadIconManager.LoadIcon(url, fn_callback)
    local set = {urls = {url}, callback = fn_callback,sprites={}, tb_downloader = {}}
    tb_iconNeedLoad[#tb_iconNeedLoad + 1] = set
    _DownloadHeadIcon()
end 

function HeadIconManager.LoadIcons(tb_url, fn_callback)
    local set = {urls = tb_url, callback = fn_callback, sprites = {}, tb_downloader = {}}
    tb_iconNeedLoad[#tb_iconNeedLoad + 1] = set
    _DownloadHeadIcon()
end 

function HeadIconManager:FreeIcon(url)
    if url == nil or url == "" then 
        return 
    end 

    local key = String(url):GetHashCode()
    if tb_iconMap[key] ~= nil then 
        if tb_iconMap[key]:IsValid() == true then 
            UnityEngine.Destory(tb_iconMap[key]:GetAsset())
        end 
        tb_iconMap[key] = nil 
    end 
end 

function HeadIconManager:FreeIcons(urls)
    local url = nil 
    local key
    if urls ~= nil then 
        while #urls > 0 do 
            url = urls[1]
            if url ~= "" and url ~= nil then 
                key = String(url):GetHashCode()
                if tb_iconMap[key] ~= nil and tb_iconMap[key]:IsValid() == true then 
                    UnityEngine.Destory(tb_iconMap[key]:GetAsset())
                end 
                tb_iconMap[key] = nil 
            end 
            table.remove(urls,1)
        end 
    end 
end 

local m_DownloadSet = nil 
local complete_count = 0
local url = nil 
local name = nil 
local m_path = nil 
function HeadIconManager.Update()
    -- body
    if tb_downloading == nil then 
        return
    end
    if #tb_downloading > 0 then 
        m_DownloadSet = tb_downloading[1]
        complete_count = 0
        if m_DownloadSet ~= nil then 
            for k,v in ipairs(m_DownloadSet.tb_downloader) do 
                if v  and v ~= "" then 
                    url = m_DownloadSet.urls[k]
                    name = String(url):GetHashCode()
                    m_path = string.format("%s/%s",CustomTool.FileSystem.headIconPath, name)
                    if v.error == nil then 
                        if v.isDone == true then    
                            complete_count = complete_count + 1
                            local  tex2d = v.texture
                            if tex2d ~= nil then 
                                if CustomTool.FileSystem.Exist(m_path) == false then 
                                    --save img to local disk
                                    local pngData = tex2d:EncodeToPNG();                         
                                    CustomTool.FileSystem.ReplaceFileBytes(m_path, pngData)
                                end 

                                if tb_iconMap[name] == nil or  tb_iconMap[name]:IsValid() == false then 
                                    local asset = UnityEngine.Sprite.Create(tex2d, TransformLuaUtil.NewRect(0, 0, tex2d.width, tex2d.height), UnityEngine.Vector2(0, 0)); 
                                    tb_iconMap[name] = LuaAsset.new(name, asset)
                                    m_DownloadSet.sprites[k] =  tb_iconMap[name]
                                else 
                                    m_DownloadSet.sprites[k] =  tb_iconMap[name]
                                end  
                            else 
                                m_DownloadSet.sprites[k] =  LuaAsset.new(name, nil)
                                LogError("Failed to load head icon:: " .. m_DownloadSet.urls[k])
                            end 
                            v:Dispose() 
                            m_DownloadSet.tb_downloader[k] = ""
                        end 
                    else 
                        complete_count = complete_count + 1
                        v:Dispose() 
                        m_DownloadSet.tb_downloader[k] = ""
                        m_DownloadSet.sprites[k] =  LuaAsset.new(name, nil)
                        LogError("Failed to load head icon:: " .. m_DownloadSet.urls[k])
                    end 
                else 
                    complete_count = complete_count + 1
                end 
            end 
            if complete_count == #m_DownloadSet.tb_downloader and complete_count > 0  then 
                table.remove(tb_downloading, 1)
                if  m_DownloadSet.callback ~= nil then 
                    if #m_DownloadSet.urls == 1 then 
                        m_DownloadSet.callback(m_DownloadSet.sprites[1])
                    else 
                        m_DownloadSet.callback(m_DownloadSet.sprites)
                    end
                else 
                    LogError("missing callback function. it only need to be loaded??")
                end
                
            end 
        end 
    end 
end

function HeadIconManager.OnDestroy()
    -- body
    if tb_iconMap then 
        for k,v in pairs(tb_iconMap) do 
            tb_iconMap[k] = nil 
        end 
        tb_iconMap = nil 
    end 
    tb_iconNeedLoad = nil 
end

return HeadIconManager