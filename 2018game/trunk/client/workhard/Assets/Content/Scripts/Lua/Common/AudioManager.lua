--[[
 * This AudioManager implementation is a singleton, so you should not call the 
 * constructor directly, but instead call the static Factory method, 
 *
]]

local AudioManager = class('AudioManager')

AudioManager._instance = nil

function AudioManager:ctor()
    self:Init()
end 

function AudioManager.getInstance()
    if AudioManager._instance == nil then 
        AudioManager._instance = AudioManager.new()
    end 
    return AudioManager._instance
end 

--initial this instance. privacy function
--called by constructor
function AudioManager:Init()
    UnityEngine.Debug.Log("Init lua audio manager...")
    self.musicLuaAsset = nil

    AudioHelper.Init()
    local volume = AudioHelper.GetMusicVolume()
    UnityEngine.Debug.Log("system volume " .. volume)

    self.AudioPool = UnityEngine.GameObject.Find("AudioPool")
    if self.AudioPool == nil then 
        self.AudioPool = UnityEngine.GameObject("AudioPool")
        UnityEngine.Object.DontDestroyOnLoad(self.AudioPool)

        self.sound = UnityEngine.GameObject("soundPool")
        self.sound.transform.parent = self.AudioPool.transform
        self.musicSource = self.AudioPool:AddComponent("UnityEngine.AudioSource")
        self.musicVlome = volume
        self.oldMusicVlome = 1.0

        --register listener
        self.AudioPool:AddComponent("UnityEngine.AudioListener")
    end 

    local gameSetting = GameSetting.getInstance()
    gameSetting:SetMusicVolume(volume)
    gameSetting:SetSoundVolume(volume)
    self.bgMusicVolume = volume
    self.soundVolume = volume
    self.soundElements = {}

    --bind delegate 
    local inst = AudioCallback.Instance 
    if inst then 
        inst.onMusicVolumeChanged:RemoveAllListeners()
        inst.onMusicVolumeChanged:AddListener(function(vol)
            self.soundVolume = vol 
            self.bgMusicVolume = vol 
            gameSetting:SetMusicVolume(vol)
            gameSetting:SetSoundVolume(vol)
            self:SetBGMusicVolume(vol)
            self:SetSoundVolume(vol)
        end)
    end 
end 

function AudioManager:SetBGMusicVolume(volume)
    self.bgMusicVolume = volume
    self.musicVlome = self.oldMusicVlome * volume
    if self:HasPlayedBG() and self.musicSource.isPlaying then
        self.musicSource.volume = self.musicVlome 
    end
end

function AudioManager:SetSoundVolume(volume)
    self.soundVolume = volume
end

function AudioManager:HasPlayedBG()
    return self.musicSource.clip ~= nil
end 

--play background music 
--@param eSound a enum data. see definition in definition.lua file
function AudioManager:PlayBGMusic(eSound)
    if GameSetting.getInstance():IsEnableMusic() == false then 
        return
    end 

    local soundPath = self:GetSoundPath(eSound)

    if soundPath == "" or soundPath == nil then 
        UnityEngine.Debug.LogError("the sound path is nil . check the GameSound.txt configuration file. id is " .. tostring(eSound))
        return
    end 

    if self.musicLuaAsset ~= nil then 
        self.musicLuaAsset:Free(1)
    end 

    self.musicLuaAsset = nil
    if self.musicSource ~= nil then 
        self.musicSource:Stop()
    end 
    self.musicSource.clip = nil

    GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_GameObject, soundPath, function(asset) 
        if asset ~= nil then 
            --cache the loaded asset
            self.musicLuaAsset = asset

            if asset ~= nil and asset:IsValid() then              
                local audio = asset:GetAsset():GetComponent("AudioSource")
                if audio ~= nil then 
                    self.musicSource.clip = audio.clip
                    self.musicSource.volume = 0
                    self.musicSource.loop = true
                    if self.musicSource.enabled == false then 
                        self.musicSource.enabled = true
                    end 
                    local bgVolume = audio.volume * self.bgMusicVolume
                    self.oldMusicVlome = audio.volume
                    self.musicVlome = bgVolume
                    self:FadeIn(self.musicSource, bgVolume, bgVolume * 1)
                    self.musicSource:Play()
                end 
            end 
        end   
    end)
end 

--Fade in background music
--@iMusicSource the music source that will be faded in
--@iVolume the music volume
--@iSmoothTime fade in last time
function AudioManager:FadeIn(iMusicSource, iVolume, iSmoothTime)
    local smoothTime = iSmoothTime or 1
    local volume = iVolume or 1

    local startTime = UnityEngine.Time.time
    local cor = coroutine.create(function() 
        while UnityEngine.Time.time <= startTime + smoothTime do 
            local tmp = ( UnityEngine.Time.time - startTime) / smoothTime * volume
            if tmp >= volume then 
                tmp = volume
            end 

            iMusicSource.volume = tmp

            UnityEngine.Yield(UnityEngine.WaitForSeconds(0.03))
        end 
    end)
    coroutine.resume(cor)
end 

--Fade out background music
--@iMusicSource the music source that will be faded out
--@iSmoothTime fade out last time
function AudioManager:FadeOut(iMusicSource, iSmoothTime, bPause)
    local smoothTime = iSmoothTime or 1
    local volume = iMusicSource.volume or 1

    local startTime = UnityEngine.Time.time
    local cor = coroutine.create(function() 
        while UnityEngine.Time.time <= startTime + smoothTime do 
            local tmp = volume * (1 - ( UnityEngine.Time.time - startTime) / smoothTime )
            if tmp <= 0 then 
                tmp = 0
            end 

            iMusicSource.volume = tmp

            UnityEngine.Yield(UnityEngine.WaitForSeconds(0.03))
        end 
        if bPause then 
            iMusicSource:Pause()
        else 
            iMusicSource:Stop()
        end 
    end)
    coroutine.resume(cor)
end 

--resume backgroud music of game
function AudioManager:ResumeBGMusic()
    if self.musicSource ~= nil then 
        self.musicSource:UnPause()
        self:FadeIn(self.musicSource, self.musicVlome)
    end 
end 

--pause background music of game
function AudioManager:PauseBGMusic()
    if self.musicSource ~= nil then 
        self:FadeOut(self.musicSource, 0.5, true)
    end 
end 

--stop background music of game
function AudioManager:StopBGMusic()
    if self.musicSource ~= nil then 
        self.musicSource:Stop()
    end 
end 

--play sound
function AudioManager:PlaySound(eSound)
  
    if GameSetting.getInstance():IsEnableSound() == false then 
        return
    end
    eSound = nil 
    if self.soundVolume == 0 or eSound == nil  then
        return
    end
    
    local element = nil
    for k,v in ipairs(self.soundElements) do 
        if v and v:IsEqual(eSound) then 
            if v:IsBusy() == false then 
                element = v
                break;
            end 
        end 
    end 

    if element ~= nil then 
        element:Play()
    else 
        local soundPath = self:GetSoundPath(eSound)
        if soundPath == "" or soundPath == nil then 
            UnityEngine.Debug.LogError("the sound path is nil . check the GameSound.txt configuration file. id is " .. tostring(eSound))
            return
        end 
        GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_GameObject, soundPath, function(asset) 
            if asset ~= nil and asset:IsValid() then
                
                local audio = asset:GetAsset():GetComponent("AudioSource")
                local ar = self.sound:AddComponent("UnityEngine.AudioSource")
                ar.playOnAwake = false
                ar.loop = false

                if audio ~= nil then 
                    ar.clip = audio.clip
                    ar.volume = audio.volume * self.soundVolume
                end 

                element = ci:GetSoundElement().new(eSound, asset, ar)
                self.soundElements[#self.soundElements + 1 ] = element
                element:Play()
            end   
        end)
    end 

end 

--stop all sound. sound never support resume
function AudioManager:StopSound()
end 

--get asset path. privacy function
function AudioManager:GetSoundPath(eSound)
    local sound = luaTool:GetGameSound(eSound)
    if sound then 
       return sound:GetSoundPath()
    end
    return nil
end 

--safe release. this function will be called when player wants to leave current level.
--in here we will fade out the background music if it is being played. and free asset reference
function AudioManager:SafeRelease(onReleased)
    local cor = coroutine.create(function() 
        if self.musicSource.isPlaying then 
            self:FadeOut(self.musicSource, self.musicVlome * 1)  
        end  

        for k,v in ipairs(self.soundElements) do 
            if v then 
                v:SafeRelease()
                self.soundElements[k] = nil
            end 
        end 

        while self.musicSource.isPlaying do 
            UnityEngine.Yield(UnityEngine.WaitForSeconds(0.03))
        end 

        if self.musicLuaAsset ~= nil then 
            self.musicLuaAsset:Free(1)
        end
        self.musicSource.clip = nil
        self.musicLuaAsset = nil
        if onReleased then 
            onReleased()
        end
    end)
    coroutine.resume(cor)
end 

return AudioManager