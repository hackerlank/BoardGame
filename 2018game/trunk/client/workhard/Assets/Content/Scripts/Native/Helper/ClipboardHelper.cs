using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

/// <summary>
/// clipboard helper class. provide two interfaces at present.
/// </summary>
[SLua.CustomLuaClass]
public class ClipboardHelper
{

    #region ios clipboard
#if UNITY_IPHONE
        [DllImport("__Internal")]
	    private static extern bool SetMsgToClipboard(string msg);

        [DllImport("__Internal")]
        private static extern string GetMsgFromClipboard();
#endif
    #endregion

    #region Android class
    private static string JAVA_WECHAT_SDK_CLASS = string.Format("{0}.ClipboardHelper", LaunchGame.GAME_UTILITY_JAVA_PACKAGE);
    #endregion

    /// <summary>
    /// paste message to clipboard of system
    /// </summary>
    /// <param name="msg">the message that need to be assign to clipboard of system</param>
    /// <returns></returns>
    public static bool PasteMsgToClipboard(string msg)
    {
        bool bSuccess = false;
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    bSuccess = cls.CallStatic<bool>("SetMsgToClipboard", msg);
                }
            #elif UNITY_IPHONE
                bSuccess = SetMsgToClipboard(msg);
            #endif
        #endif
        return bSuccess;
    }

    /// <summary>
    /// read message from system clipboard
    /// </summary>
    /// <returns> message of clipboard</returns>
    public static string GetClipboardMsg()
    {
        string m_msg = "";
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    m_msg = cls.CallStatic<string>("GetMsgFromClipboard");
                }
            #elif UNITY_IPHONE
                m_msg = GetMsgFromClipboard();
            #endif
        #endif
        return m_msg;
    }
   

}
