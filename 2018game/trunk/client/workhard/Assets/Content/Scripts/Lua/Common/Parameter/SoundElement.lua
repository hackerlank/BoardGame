local SoundElement = class('SoundElement')

function SoundElement:ctor(eSound, luaAsset, audioResource)
    self.sound = eSound
    self.luaAsset = luaAsset
    self.ar = audioResource
end 

function SoundElement:IsEqual(inSound)
    return self.sound == inSound
end 

function SoundElement:Play()
    self.ar:Play()
end 

function SoundElement:Stop()
    self.ar:Stop()
end 

function SoundElement:IsBusy()  
    return self.ar.isPlaying
end 

function SoundElement:SafeRelease()
    self.luaAsset:Free(1)
    self.luaAsset = nil
    self.ar:Stop();
    self.ar.clip = nil 
    UnityEngine.GameObject.Destroy(self.ar)
    self.ar = nil
    self = nil
end 

return SoundElement
