local MusicSoundChangedParam = class('MusicSoundChangedParam')

MusicSoundChangedParam.isOn = nil;
MusicSoundChangedParam.Volume = nil;


function MusicSoundChangedParam:ctor(isOn, Volume)
	MusicSoundChangedParam.isOn = isOn
	MusicSoundChangedParam.Volume = Volume 

end

function MusicSoundChangedParam:SafeRelease()
    MusicSoundChangedParam.isOn = nil;
    MusicSoundChangedParam.Volume = nil;
end 

return MusicSoundChangedParam