using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioCallbackWrapper : MonoBehaviour {

    private static AudioCallback m_AudioCallBack = null;
    private static GameObject obj;

    /// <summary>
    /// DONot modify this section
    /// </summary>
    private const string CALLBACK_COMPONENT_NAME = "AudioCallbackWrapper";

    public static void CreateAudioManager()
    {
        if (null == obj)
        {
            obj = new GameObject(CALLBACK_COMPONENT_NAME);
        }
        obj.AddComponent<AudioCallbackWrapper>();
        UnityEngine.Object.DontDestroyOnLoad(obj);
        m_AudioCallBack = AudioCallback.Instance;
    }

    protected void onSystemVolumeChanged(string volume)
    {
        int m_volume = 5;

        if(volume != null)
        {
            m_volume = int.Parse(volume);
        }

        if(m_AudioCallBack != null && m_AudioCallBack.onSystemVolumeChanged != null)
        {
            m_AudioCallBack.onSystemVolumeChanged.Invoke(m_volume / AudioHelper.maxSystemVolume);
        }
    }

    protected void onVoiceVolumeChanged(string volume)
    {
        int m_volume = 5;

        if (volume != null)
        {
            m_volume = int.Parse(volume);
        }

        if (m_AudioCallBack != null && m_AudioCallBack.onVoiceVolumeChanged != null)
        {
            m_AudioCallBack.onVoiceVolumeChanged.Invoke(m_volume / AudioHelper.maxVoiceVolume);
        }
    }

    protected void onMusicVolumeChanged(string volume)
    {
        int m_volume = 5;

        if (volume != null)
        {
            m_volume = int.Parse(volume);
        }
 

        if (m_AudioCallBack != null && m_AudioCallBack.onMusicVolumeChanged != null)
        {
            m_AudioCallBack.onMusicVolumeChanged.Invoke(m_volume / AudioHelper.maxMusicVolume);
        }
    }
}
