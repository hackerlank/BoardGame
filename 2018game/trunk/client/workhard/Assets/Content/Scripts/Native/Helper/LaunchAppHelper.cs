using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

/// <summary>
/// Lacunch app helper
/// </summary>
[SLua.CustomLuaClass]
public class LaunchAppHelper
{
    #region ios location
    #if UNITY_IPHONE
        [DllImport("__Internal")]
	    private static extern bool iPhoneLaunchApp(string url);
    #endif
    #endregion

    #region Android class
    private static string JAVA_LAUNCH_CLASS =  string.Format("{0}.LaunchAppHelper", LaunchGame.GAME_UTILITY_JAVA_PACKAGE);
    #endregion
    

    public static bool LaunchApp(string package_name, string launch_activity_name)
    {
        bool bLaunched = false;

        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_LAUNCH_CLASS))
                {
                    bLaunched = cls.CallStatic<bool>("AndroidLaunchApp", package_name, launch_activity_name);
                }
            #elif UNITY_IPHONE
                bLaunched = iPhoneLaunchApp(package_name);
            #endif
        #endif
        return bLaunched;
    }
}
