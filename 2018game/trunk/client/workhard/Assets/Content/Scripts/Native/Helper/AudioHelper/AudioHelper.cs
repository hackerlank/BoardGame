using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[SLua.CustomLuaClass]
public class AudioHelper{

    [SLua.DoNotToLua]
    private static int MAX_MUSIC_VOLUME = 5;
    [SLua.DoNotToLua]
    private static int MAX_SYSTEM_VOLUME = 5;
    [SLua.DoNotToLua]
    private static int MAX_VOICE_VOLUME = 5;
    public static readonly float MIN_VOLUME = 0;
    public static float maxMusicVolume { get { return MAX_MUSIC_VOLUME; } }
    public static float maxSystemVolume { get { return MAX_SYSTEM_VOLUME; } }
    public static float maxVoiceVolume { get { return MAX_VOICE_VOLUME; } }


    #region ios clipboard
#if UNITY_IPHONE
     //   [DllImport("__Internal")]
	    //private static extern bool SetMsgToClipboard(string msg);

     //   [DllImport("__Internal")]
     //   private static extern string GetMsgFromClipboard();
#endif
    #endregion

    #region Android class
    private static string JAVA_AUDIO_CLASS = string.Format("{0}.AudioHelper", LaunchGame.GAME_UTILITY_JAVA_PACKAGE);
    #endregion
    
    public static void Init()
    {
        AudioCallbackWrapper.CreateAudioManager();
        #if !UNITY_EDITOR 
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_AUDIO_CLASS))
                {
                    cls.CallStatic("Init");
                    MAX_SYSTEM_VOLUME = cls.CallStatic<int>("AndroidGetMaxSystemStreamVolume");
                    MAX_VOICE_VOLUME = cls.CallStatic<int>("AndroidGetMaxVoiceStreamVolume");
                    MAX_MUSIC_VOLUME = cls.CallStatic<int>("AndroidGetMaxMusicStreamVolume");
                }
            #elif UNITY_IPHONE
                //Init();
            #endif
        #else 
            MAX_MUSIC_VOLUME = 100;
            MAX_SYSTEM_VOLUME = 100;
            MAX_VOICE_VOLUME = 100;
        #endif
    }

    /// <summary>
    /// get current volume of system
    /// </summary>
    /// <returns></returns>
    public static float GetSystemVolume()
    {
        int volume = 2;
        #if !UNITY_EDITOR  
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_AUDIO_CLASS))
                {
                    volume = cls.CallStatic<int>("AndroidGetSystemStreamVolume");
                }
            #elif UNITY_IPHONE
                //Init();
            #endif
        #else 
            volume = 50;
        #endif

        return volume / maxSystemVolume;
    }

    
    /// <summary>
    /// set system volume
    /// </summary>
    /// <param name="volume">new volume</param>
    public static void SetSystemVolume(float volume)
    {
        volume = volume * MAX_SYSTEM_VOLUME;
        int tmp = (int)volume;
        #if !UNITY_EDITOR 
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_AUDIO_CLASS))
                {
                    cls.CallStatic("AndroidSetSystemStreamVolume", tmp);
                }
            #elif UNITY_IPHONE
                //Init();
            #endif
        #endif

    }

    /// <summary>
    /// get voice volume of microphone
    /// </summary>
    /// <returns></returns>
    public static float GetVoiceVolume()
    {
        int volume = 2;
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_AUDIO_CLASS))
                {
                    volume = cls.CallStatic<int>("AndroidGetVoiceStreamVolume");
                }
            #elif UNITY_IPHONE
                //Init();
            #endif
        #else 
            volume = 50;
        #endif

        return volume / maxVoiceVolume;
    }

    /// <summary>
    /// set voice volume of microphone?
    /// </summary>
    /// <param name="volume">new volume</param>
    public static void SetVoiceVolume(float volume)
    {
        volume = volume * MAX_VOICE_VOLUME;
        int tmp = (int)volume;
        #if !UNITY_EDITOR 
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_AUDIO_CLASS))
                {
                    cls.CallStatic("AndroidSetVoiceStreamVolume", tmp);
                }
            #elif UNITY_IPHONE
                //Init();
            #endif
        #endif

    }


    /// <summary>
    /// get voice volume of music
    /// </summary>
    /// <returns></returns>
    public static float GetMusicVolume()
    {
        int volume = 2;
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_AUDIO_CLASS))
                {
                    volume = cls.CallStatic<int>("AndroidGetMusicStreamVolume");
                }
            #elif UNITY_IPHONE
                //Init();
            #endif
        #else 
            volume = 50;
        #endif

        return volume / maxMusicVolume;
    }

    /// <summary>
    /// set voice volume of music
    /// </summary>
    /// <param name="volume">new volume(0-1)</param>
    public static void SetMusicVolume(float volume)
    {
        volume = volume * MAX_VOICE_VOLUME;
        int tmp = (int)volume;
        #if !UNITY_EDITOR 
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_AUDIO_CLASS))
                {
                    cls.CallStatic("AndroidSetMusicStreamVolume", tmp);
                }
            #elif UNITY_IPHONE
                //Init();
            #endif
        #endif

    }


}
