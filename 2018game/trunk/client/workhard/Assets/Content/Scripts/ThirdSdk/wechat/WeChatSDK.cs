using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

[SLua.CustomLuaClass]
public class WeChatSDK 
{
    /// <summary>
    /// 微信授权错误码
    /// 
    /// WXSuccess           = 0,    
    /// WXErrCodeCommon     = -1,   
    /// WXErrCodeUserCancel = -2,   
    /// WXErrCodeSentFail   = -3,  
    /// WXErrCodeAuthDeny   = -4,  
    /// WXErrCodeUnsupport  = -5,  
    ///
    /// </summary>
    #region IPhone interface
#if UNITY_IPHONE
       [DllImport("__Internal")]
	    private static extern bool isWXAppSupportApi();

        [DllImport("__Internal")]
        private static extern bool isWeChatInstalled();

        [DllImport("__Internal")]
        private static extern void  LoginWeChat(string authState);

        [DllImport("__Internal")]
        private static extern void RegisterToWeChat(string appId, string appSecret);

        [DllImport("__Internal")]
        private static extern void ShareTextMsgToWeChatFriend(string desc, string content);

        [DllImport("__Internal")]
        private static extern void ShareTextMsgToWeChatMoments(string desc, string content);

        [DllImport("__Internal")]
        private static extern void ShareLinkMsgToWeChatFriend(string title, string desc, string url, string thumbImage);

        [DllImport("__Internal")]
        private static extern void ShareLinkMsgToWeChatMoments(string title, string desc, string url, string thumbImage);

        [DllImport("__Internal")]
        private static extern void ShareImageMsg(string title, string desc, string imagePath, string thumbImage, int scene);

        [DllImport("__Internal")]
        private static extern string GetAccessToken();

        [DllImport("__Internal")]
        private static extern string GetUserInfo();

        [DllImport("__Internal")]
        private static extern void BackupAccessToken(string token);

        [DllImport("__Internal")]
        private static extern void LogoutWeChat();

#endif
    #endregion

    #region Android class
    private static string JAVA_WECHAT_SDK_CLASS = "";// string.Format("{0}.WeChatHelper", LaunchGame.WECHAT_JAVA_PACKAGE);
    #endregion

    /// <summary>
    /// register app to wechat
    /// </summary>
    /// <param name="appId">the unique id of app</param>
    /// <param name="appSecret">the secret string</param>
    /// <param name="backMessageTitle">message title</param>
    /// <param name="backMessageContent">message content</param>
    public static void Init(string appId, string appSecret)
    {
        JAVA_WECHAT_SDK_CLASS = string.Format("{0}.WeChatHelper", LaunchGame.WECHAT_JAVA_PACKAGE);
        //create the wechat callback objects in scene
        WeChatCallbackWrapper.CreateWeChatManager();
        #if !UNITY_EDITOR
            
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("RegisterToWeChat", appId, appSecret);
                }
            #elif UNITY_IPHONE
                RegisterToWeChat(appId, appSecret);
            #endif
        #endif
    }

    /// <summary>
    /// whether has installed the wechat app
    /// </summary>
    /// <returns></returns>
    public static bool IsWeChatInstalled()
    {
        bool bIsInstalled = false;
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    bIsInstalled = cls.CallStatic<bool>("IsWeChatInstalled");
                }
            #elif UNITY_IPHONE
                bIsInstalled = isWeChatInstalled();
            #endif
        #endif
        return bIsInstalled;
    }

    public static bool IsWeChatSupportApi()
    {
        bool bSupported = false;
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    bSupported = cls.CallStatic<bool>("isWXAppSupportApi");
                }
            #elif UNITY_IPHONE
                bSupported = isWXAppSupportApi();
            #endif
        #endif
        return bSupported;
    }

    /// <summary>
    /// Login wechat
    /// </summary>
    public static void AuthWeChat(string authState)
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("LoginWeChat", authState);
                }
            #elif UNITY_IPHONE
                 LoginWeChat(authState);
            #endif
        #endif
    }

    /// <summary>
    /// share text message to friend
    /// </summary>
    /// <param name="m_desc">message description</param>
    /// <param name="m_content">messge content</param>
    public static void ShareTextMsgFriend(string m_desc, string m_content)
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("ShareTextMsgToWeChatFriend", m_desc, m_content);
                }
            #elif UNITY_IPHONE
                 ShareTextMsgToWeChatFriend(m_desc, m_content);
            #endif
        #endif
    }

    /// <summary>
    /// share text msg to time line
    /// </summary>
    /// <param name="m_desc"></param>
    /// <param name="m_content"></param>
    public static void ShareTextMsgMoments(string m_desc, string m_content)
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("ShareTextMsgToWeChatMoments", m_desc, m_content);
                }
            #elif UNITY_IPHONE
                 ShareTextMsgToWeChatMoments(m_desc, m_content);
            #endif
        #endif
    }

    /// <summary>
    /// share link msg to time line
    /// </summary>
    /// <param name="m_title">the message title</param>
    /// <param name="m_desc">the message description</param>
    /// <param name="m_urlLink">net link </param>
    /// <param name="m_thumbImage">shortcut image</param>
    public static void ShareLinkMsgFriend(string m_title, string m_desc, string m_urlLink, string m_thumbImage)
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("ShareLinkMsgToWeChatFriend", m_title, m_desc, m_urlLink, m_thumbImage);
                }
            #elif UNITY_IPHONE
                 ShareLinkMsgToWeChatFriend(m_title, m_desc, m_urlLink, m_thumbImage);
            #endif
        #endif
    }


    /// <summary>
    /// share link msg to moments
    /// </summary>
    /// <param name="m_title">the message title</param>
    /// <param name="m_desc">the message description</param>
    /// <param name="m_urlLink">net link </param>
    /// <param name="m_thumbImage">shortcut image</param>
    public static void ShareLinkMsgMoments(string m_title, string m_desc, string m_urlLink, string m_thumbImage)
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("ShareLinkMsgToWeChatMoments", m_title, m_desc, m_urlLink, m_thumbImage);
                }
            #elif UNITY_IPHONE
                 ShareLinkMsgToWeChatMoments(m_title, m_desc, m_urlLink, m_thumbImage);
            #endif
        #endif
    }

    /// <summary>
    /// if login success. use this interface to get the access token. 
    /// and real login game server with accesstoken
    /// </summary>
    /// <returns></returns>
    public static string GetWeChatAccessToken()
    {
        string token = "";
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    token = cls.CallStatic<string>("GetAccessToken");
                }
            #elif UNITY_IPHONE
                 token = GetAccessToken();
            #endif
        #endif

        return token;
    }

    /// <summary>
    /// if login success. use this interface to get the access token. 
    /// and real login game server with accesstoken
    /// </summary>
    /// <returns></returns>
    public static void GetWeChatUserInfo()
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("GetUserInfo");
                }
            #elif UNITY_IPHONE
                GetUserInfo();
            #endif
        #endif
    }

    /// <summary>
    /// backup wechat accesstoken
    /// </summary>
    public static void BackupWeChatAccessToken(string token)
    {
         #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("BackupAccessToken",token);
                }
            #elif UNITY_IPHONE
                BackupAccessToken(token);
            #endif
        #endif
    }

    public static void LogoutWeChatAuth()
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("LogoutWeChat");
                }
            #elif UNITY_IPHONE
                LogoutWeChat();
            #endif
        #endif
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="title"></param>
    /// <param name="desc"></param>
    /// <param name="imagePath"></param>
    /// <param name="thumbImage"></param>
    /// <param name="scene"></param>
    public static void WeChatShareImageMsg(string title, string desc, string imagePath, string thumbImage, int scene)
    {
        
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(JAVA_WECHAT_SDK_CLASS))
                {
                    cls.CallStatic("ShareImageMsg",title, desc, imagePath, thumbImage, scene);
                }
            #elif UNITY_IPHONE
                ShareImageMsg(title, desc, imagePath, thumbImage, scene);    
            #endif
        #endif
    }
}
