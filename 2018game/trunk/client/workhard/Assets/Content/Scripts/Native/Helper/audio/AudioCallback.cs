using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[SLua.CustomLuaClass]
public class AudioCallback{

    /// <summary>
    /// wechat callback delegate
    /// </summary>
    [SLua.CustomLuaClass]
    public class FAudioCallback : UnityEvent<float> { public FAudioCallback() { } }

    [SLua.DoNotToLua]
    private FAudioCallback m_onSystemVolumeChanged = new FAudioCallback();
    /// <summary>
    /// share delegate
    /// </summary>
    public FAudioCallback onSystemVolumeChanged { get { return m_onSystemVolumeChanged; } private set { } }

    [SLua.DoNotToLua]
    private FAudioCallback m_onVoiceVolumeChanged = new FAudioCallback();
    /// <summary>
    /// share delegate
    /// </summary>
    public FAudioCallback onVoiceVolumeChanged { get { return m_onVoiceVolumeChanged; } private set { } }

    [SLua.DoNotToLua]
    private FAudioCallback m_onMusicVolumeChanged = new FAudioCallback();
    /// <summary>
    /// share delegate
    /// </summary>
    public FAudioCallback onMusicVolumeChanged { get { return m_onMusicVolumeChanged; } private set { } }


    private static AudioCallback _inst = null;

    public static AudioCallback Instance
    {
        get
        {
            if(_inst == null)
            {
                _inst = new AudioCallback();
            }
            return _inst;
        }
    }
}
