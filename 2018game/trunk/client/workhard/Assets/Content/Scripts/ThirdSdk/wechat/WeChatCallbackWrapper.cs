using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LitJson;

public class WeChatCallbackWrapper : MonoBehaviour {


    private static WeChatCallback m_WeChatCallBack = null;
    private static GameObject obj;

    /// <summary>
    /// DONot modify this section
    /// </summary>
    private const string CALLBACK_COMPONENT_NAME = "WeChatCallbackWrapper";

    #region Unity
    private void Awake()
    {
     
    }

    private void Start()
    {
        
    }
    #endregion

    #region  interface
    public static void CreateWeChatManager()
    {
        if (null == obj)
        {
            obj = new GameObject(CALLBACK_COMPONENT_NAME);
        }
        obj.AddComponent<WeChatCallbackWrapper>();
        UnityEngine.Object.DontDestroyOnLoad(obj);
        m_WeChatCallBack = WeChatCallback.Instance;
    }
    #endregion

    #region callbacks
    /// <summary>
    /// callback:: unity to c-sharp
    /// </summary>
    /// <param name="result">the operation result. a json string that contains errorcdoe, msg. 
    /// for more errorcode information. please view https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318634&token=&lang=zh_CN</param>
    protected void onLoginWeChat(string result)
    {
        if (m_WeChatCallBack.onLoginWeChat != null)
        {
            m_WeChatCallBack.onLoginWeChat.Invoke(result);
        }
    }

    /// <summary>
    /// callback:: unity to c-sharp
    /// </summary>
    /// <param name="result">the operation result. a json string that contains errorcdoe, msg. 
    /// for more errorcode information. please view https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318634&token=&lang=zh_CN</param>
    protected void onWeChatShare(string result)
    {
       if(m_WeChatCallBack.onWeChatShare != null)
        {
            m_WeChatCallBack.onWeChatShare.Invoke(result);
        }
    }

    /// <summary>
    /// callback:: unity to c-sharp
    /// </summary>
    /// <param name="result">the operation result. a json string that contains errorcdoe, msg. 
    /// for more errorcode information. please view https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318634&token=&lang=zh_CN</param>
    protected void onWeChatPay(string result)
    {
        if (m_WeChatCallBack.onWeChatPay != null)
        {
            m_WeChatCallBack.onWeChatPay.Invoke(result);
        }
    }

    /// <summary>
    /// callback:: native to unity
    /// </summary>
    /// <param name="result">user info</param>
    protected void onWeChatGetUserInfo(string result)
    {
        if(m_WeChatCallBack.onGetUserInfoWeChat != null)
        {
            m_WeChatCallBack.onGetUserInfoWeChat.Invoke(result);
        }
    }
    #endregion

}
