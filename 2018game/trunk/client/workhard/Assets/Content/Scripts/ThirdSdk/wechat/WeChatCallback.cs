using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[SLua.CustomLuaClass]
public class WeChatCallback 
{

    /// <summary>
    /// wechat callback delegate
    /// </summary>
    [SLua.CustomLuaClass]
    public class FWeChatCallback : UnityEvent<string> { public FWeChatCallback() { } }

    [SLua.DoNotToLua]
    private FWeChatCallback m_onWeChatShare = new FWeChatCallback();
    /// <summary>
    /// share delegate
    /// </summary>
    public FWeChatCallback onWeChatShare { get { return m_onWeChatShare; } private set { } }

    [SLua.DoNotToLua]
    private FWeChatCallback m_onWeChatPay = new FWeChatCallback();
    /// <summary>
    /// pay delegate
    /// </summary>
    public FWeChatCallback onWeChatPay { get { return m_onWeChatPay; } private set { } }


    [SLua.DoNotToLua]
    private FWeChatCallback m_onLoginWeChat = new FWeChatCallback();
    /// <summary>
    /// login wechat delegate
    /// </summary>
    public FWeChatCallback onLoginWeChat { get { return m_onLoginWeChat; } private set { } }

    [SLua.DoNotToLua]
    private FWeChatCallback m_onGetUserInfoWeChat = new FWeChatCallback();
    /// <summary>
    /// login wechat delegate
    /// </summary>
    public FWeChatCallback onGetUserInfoWeChat { get { return m_onGetUserInfoWeChat; } private set { } }


    [SLua.DoNotToLua]
    private static WeChatCallback _instance = null;
    public static WeChatCallback Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new WeChatCallback();
            }
            return _instance;
        }
    }
}
