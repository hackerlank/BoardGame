using UnityEngine;
using UnityEngine.Events;
using SLua;
using System.Net.Sockets;
using System.Collections.Generic;

/// <summary>
/// socket state enum
/// </summary>
[CustomLuaClass]
public enum ESocketState
{
    /// <summary>
    /// never connect
    /// </summary>
    ESS_Invalid = 0,

    /// <summary>
    /// connecting 
    /// </summary>
    ESS_Connectting,

    /// <summary>
    /// connected
    /// </summary>
    ESS_Connected,

    /// <summary>
    /// Failed to connect to server
    /// </summary>
    ESS_ConnecttingFailed,

    /// <summary>
    /// disconnected
    /// </summary>
    ESS_Disconnected,

    /// <summary>
    /// quit
    /// </summary>
    ESS_Quit,
}


/// <summary>
/// Socket state changed data struct
/// @TODO maybe need to provide more contents.
/// </summary>
[CustomLuaClass]
public class FSocketStateChanged
{
    /// <summary>
    /// current socket state
    /// </summary>
    public ESocketState currentState = ESocketState.ESS_Invalid;

    /// <summary>
    /// what did cause socket state change?
    /// </summary>
    public string desc = "";

    public FSocketStateChanged(ESocketState iState, string iDesc )
    {
        currentState = iState;
        desc = iDesc;
    }
}

/// <summary>
/// send message result data struct
/// </summary>
[CustomLuaClass]
public class FSendMsgResult
{
    /// <summary>
    /// error code. if we meet errorcode equals 1, it means exception is a system.exception.
    /// otherwise the exception is a socket exception(socket error was defined in SocketError)
    /// </summary>
    public int errorCode = 0;

    /// <summary>
    /// exception reason
    /// </summary>
    public string reason = "";

    /// <summary>
    /// whether we can pass notification
    /// </summary>
    public bool bPassed = true;
    public FSendMsgResult(int iErrorCode, string iReason, bool iPassed = false)
    {
        errorCode = iErrorCode;
        reason = iReason;
        bPassed = iPassed;
    }
}


/// <summary>
/// Client connection helper class. this provides some interface to 
/// help lua script communicates with server, also deal exception in here.
/// </summary>

[CustomLuaClass]
public class NetConnHelper : MonoBehaviour
{

    /// <summary>
    /// socket state changed event.
    /// </summary>
    [DoNotToLua]
    private SocketStateChangedEvent _onSocketStateChanged = new SocketStateChangedEvent();

    /// <summary>
    /// get the reference of socket state changed event
    /// </summary>
    public SocketStateChangedEvent onSocketStateChanged { get { return _onSocketStateChanged; } }

    
    /// <summary>
    /// on failed to send message to server event
    /// </summary>
    [DoNotToLua]
    private FailedSendMsgEvent _onFailedSendMsg = new FailedSendMsgEvent();

    /// <summary>
    /// get reference of onFailedSendMsg
    /// </summary>
    public FailedSendMsgEvent onFailedSendMsg { get { return _onFailedSendMsg; } }

    /// <summary>
    /// on failed to received message event
    /// </summary>
    private FailedReceivedMsgEvent _onFailedReceiveMsg = new FailedReceivedMsgEvent();

    /// <summary>
    /// get reference of onFailedReceiveMsg event
    /// </summary>
    public FailedReceivedMsgEvent onFailedReceiveMsg { get { return _onFailedReceiveMsg; } }


    /// <summary>
    /// Global instance object.
    /// </summary>
    [DoNotToLua]
    private static NetConnHelper _GInstance = null;

    /// <summary>
    /// save socket state
    /// </summary>
    [DoNotToLua]
    private ESocketState m_socketState = ESocketState.ESS_Invalid;

    /// <summary>
    /// get current socket state
    /// </summary>
    public ESocketState socketState { get { return m_socketState; } }

    /// <summary>
    /// whether has connected to server
    /// </summary>
    public bool isConnected { get { return m_socket != null && m_socketState == ESocketState.ESS_Connected && m_socket.Connected; } }

    /// <summary>
    /// current socket
    /// </summary>
    [DoNotToLua]
    private Socket m_socket = null;

    /// <summary>
    /// cache received msg
    /// </summary>
    [DoNotToLua]
    private byte[] m_arrTempRecv;

    [DoNotToLua]
    private FSocketStateChanged connNoti = null;

    [DoNotToLua]
    private FSendMsgResult sendNoti = null;

    /// <summary>
    /// the max length of received message
    /// </summary>
    private const int RECV_BUF_LEN = 1024 * 64;

    [DoNotToLua]
    private int m_ConnectInternal = 10;

    [DoNotToLua]
    private float m_ConnectStartTime = 0;

    [DoNotToLua]
    private void Awake()
    {
        if(_GInstance == null)
        {
            _GInstance = this;
        }

        DontDestroyOnLoad(this.gameObject);
    }

    /// <summary>
    /// get the global helper object
    /// </summary>
    public static NetConnHelper GInstance
    {
        get
        {
            if(_GInstance == null)
            {
                _GInstance = new NetConnHelper();
            }
            return _GInstance;
        }
    }

    [SLua.DoNotToLua]
    private NetConnHelper()
    {
        m_socketState = ESocketState.ESS_Invalid;
        _onFailedReceiveMsg.RemoveAllListeners();
        _onFailedSendMsg.RemoveAllListeners();
        _onSocketStateChanged.RemoveAllListeners();
    }

    /// <summary>
    /// connect to server
    /// </summary>
    /// <param name="szIp">ip adress of server</param>
    /// <param name="port">port number of server</param>
    /// <returns>true if connected to server, otherwise false</returns>
    public bool Connect(string szIp, int port/*, System.Action<int> fn = null, bool bAutoRetry = true, System.Action<int> fnDisconnect = null*/)
    {
        bool bSuccess = false;
        string newServerIp = "";
        AddressFamily newAddressFamily = AddressFamily.InterNetwork;

        //convert ip address
        MobileDevicesInterface.ConvertIPAddress(szIp, port.ToString(), out newServerIp, out newAddressFamily);
        if (!string.IsNullOrEmpty(newServerIp))
        {
            szIp = newServerIp;
        }
        m_socket = new Socket(newAddressFamily, SocketType.Stream, ProtocolType.Tcp);
        //Debug.Log("Converted Socket AddressFamily :" + newAddressFamily.ToString() + "ServerIp:" + szIp + " port=" + port);

        try
        {
            m_socket.BeginConnect(szIp, port, OnConnected, null);
            m_ConnectStartTime = Time.realtimeSinceStartup;
            m_socketState = ESocketState.ESS_Connectting;
            bSuccess = true;
            
        }
        catch (System.Exception e)
        {
            string tip = string.Format("Connect {0}:{1} Error, {2}", szIp, port.ToString(), e.ToString());
            m_socketState = ESocketState.ESS_ConnecttingFailed;

            FSocketStateChanged state = new FSocketStateChanged(m_socketState, tip);
            if (null != onSocketStateChanged)
            {
                onSocketStateChanged.Invoke(state);
            }
            bSuccess = false;
        }

        return bSuccess;
    }

    /// <summary>
    /// disconnect net connection. only set the socket connection state.
    /// </summary>
    public void Disconnect()
    { 
        if(m_socket != null)
        {
            if (m_socket.Connected)
            {
                m_socket.Shutdown(SocketShutdown.Both);
                m_socket.Disconnect(false);
            }
            
            m_socket.Close();
           
            m_socket = null;
        }
        m_socketState = ESocketState.ESS_Invalid;
    }

    /// <summary>
    /// close net connection. destroy socket object.
    /// </summary>
    public void ShutdownConn()
    {
        m_socketState = ESocketState.ESS_Invalid;
        if (m_socket != null)
        {
            m_socket.Close();
            m_socket = null;
        }
    }

    /// <summary>
    /// send request to server
    /// se.SocketErrorCode == SocketError.WouldBlock ||
    /// se.SocketErrorCode == SocketError.IOPending ||
    ///            se.SocketErrorCode == SocketError.NoBufferSpaceAvailable
    /// </summary>
    /// <param name="nCommand">command unique id</param>
    /// <param name="msg">message content</param>
    /// <param name="length">the length of mesage</param>
    /// <param name="bNeedRestore">whether need to be restore</param>
    public void DoSendMsg(byte[] msg)
    {
        try
        {
            //byte[] tmpMsg = System.Text.Encoding.Default.GetBytes(msg);
            if (msg != null)
            {
                m_socket.BeginSend(msg, 0, msg.Length, SocketFlags.None, new System.AsyncCallback(SendCallback), null);
            }
            else
            {
                sendNoti = new FSendMsgResult(1, "parameter can not be null", false);
            }
        }
        catch (System.Net.Sockets.SocketException se)
        {
            string tip = string.Format("Send sockect exception errorcode: {0}, errormsg: {1}", se.NativeErrorCode, se.ToString());
            FSendMsgResult state = new FSendMsgResult((int)se.SocketErrorCode, tip);
            sendNoti = new FSendMsgResult((int)se.SocketErrorCode, tip, false);
        }
        catch (System.Exception e)
        {
            sendNoti = new FSendMsgResult(-100, e.ToString(), false);
        }
    }

    /// <summary>
    /// receive message
    /// </summary>
    public void ReceiveMessage(out byte[] msg)
    {
        msg = null;
        int count = 0;
        try
        {
            if (m_socket.Available != 0)
            {
                m_arrTempRecv = new byte[512];
                count = m_socket.Receive(m_arrTempRecv);  
                if (count > 0)
                {
                   byte[] tmp = new byte[count];
                    System.Array.Copy(m_arrTempRecv, tmp, count);
                    //LaunchGame.Instance.PushLString(tmp);
                    msg = tmp;
                }
                if (count > RECV_BUF_LEN)
                {
                    //@todo cast a exception??
                    //throw new SocketException();
                    FSendMsgResult result = new FSendMsgResult(1, "the message length is lager than RECV_BUF_LEN=" + RECV_BUF_LEN.ToString());
                    if (null != onFailedReceiveMsg)
                    {
                        onFailedReceiveMsg.Invoke(result);
                    }
                }
            }
        }
        catch (SocketException e)
        {
            string reason = string.Format("Receive sockect exception errorcode: {0}, errormsg: {1}", e.SocketErrorCode, e.ToString());
            //if (e.SocketErrorCode == SocketError.WouldBlock ||
            //    e.SocketErrorCode == SocketError.IOPending ||
            //    e.SocketErrorCode == SocketError.NoBufferSpaceAvailable)
            //{
            //    System.Threading.Thread.Sleep(10);
            //}

            FSendMsgResult result = new FSendMsgResult((int)e.SocketErrorCode, reason);
            if(null != onFailedReceiveMsg)
            {
                onFailedReceiveMsg.Invoke(result);
            }
        }
    }

    /// <summary>
    /// sleep 
    /// </summary>
    /// <param name="sleep"></param>
    public void ThreadSleep(int sleep)
    {
        if(sleep > 0)
        {
            System.Threading.Thread.Sleep(sleep);
        }
    }
     

    /// <summary>
    /// release memory.
    /// </summary>
    public void SafeRelease()
    {
        _onFailedReceiveMsg.RemoveAllListeners();
        _onFailedSendMsg.RemoveAllListeners();
        _onSocketStateChanged.RemoveAllListeners();
        if(null != m_socket)
        {
            m_socket.Close();
            m_socket = null;
            m_socketState = ESocketState.ESS_Invalid;
            _GInstance = null;
        }
    }

    #region callback
    [DoNotToLua]
    private void SendCallback(System.IAsyncResult ia)
    {
        try
        {
            if (m_socket.Connected)
            {
                m_socket.EndSend(ia);
            }
        }
        catch (System.Exception e)
        {
            string tip = e.ToString() + " type::" + ia.AsyncState.GetType().ToString();
            sendNoti = new FSendMsgResult(1, tip);
        }
    }
    /// <summary>
    /// on connected callback
    /// </summary>
    /// <param name="ia">the result of connection operation</param>
    [DoNotToLua]
    private void OnConnected(System.IAsyncResult ia)
    {
        try
        {
            m_socket.EndConnect(ia);
            m_socketState = ESocketState.ESS_Connected;
            m_socket.ReceiveTimeout = 10;
            m_socket.SendTimeout = 3000;
            m_socket.SendBufferSize = 8 * 1024;
            m_socket.NoDelay = true;
            connNoti = new FSocketStateChanged(m_socketState, "connected");
        }
        catch (System.Exception e)
        {
            m_socketState = ESocketState.ESS_ConnecttingFailed;
        }
    }
    #endregion


    [DoNotToLua]
    void Update()
    {
        switch (m_socketState)
        {
            case ESocketState.ESS_Connectting:
                if (Time.realtimeSinceStartup - m_ConnectStartTime >= m_ConnectInternal)
                {     
                    m_socketState = ESocketState.ESS_ConnecttingFailed;
                }
                break;
            case ESocketState.ESS_ConnecttingFailed:
                if(m_socket != null)
                {
                    Disconnect();
                    connNoti = new FSocketStateChanged(ESocketState.ESS_ConnecttingFailed, "connection out of date");
                    _onSocketStateChanged.Invoke(connNoti);
                    connNoti = null;
                }
                break;
            case ESocketState.ESS_Connected:
                if (connNoti != null)
                {
                    _onSocketStateChanged.Invoke(connNoti);
                    connNoti = null;
                }

                if (sendNoti != null)
                {
                    _onFailedSendMsg.Invoke(sendNoti);
                    sendNoti = null;
                }

                if (m_socket != null)
                {
                    if (m_socket.Connected == false)
                    {
                        m_socketState = ESocketState.ESS_Disconnected;
                    }
                    else if(m_socket.Poll(100, SelectMode.SelectRead) && m_socket.Available == 0)
                    {
                        m_socketState = ESocketState.ESS_Disconnected;
                    }
                }
                break;
            case ESocketState.ESS_Disconnected:
                if (m_socket != null)
                {
                    Disconnect();
                    connNoti = new FSocketStateChanged(ESocketState.ESS_Disconnected, "Disconnected");
                    _onSocketStateChanged.Invoke(connNoti);
                    connNoti = null;
                }
                break;
            case ESocketState.ESS_Quit:
                break;
        }
    }


    #region socket events

    /// <summary>
    /// defined socket state changed event
    /// </summary>
    [CustomLuaClass]
    public class SocketStateChangedEvent : UnityEvent<FSocketStateChanged> { public SocketStateChangedEvent() { } }

    /// <summary>
    /// defined send message event
    /// </summary>
    [CustomLuaClass]
    public class FailedSendMsgEvent : UnityEvent<FSendMsgResult> { public FailedSendMsgEvent() { } }

    /// <summary>
    /// defined receive message event
    /// </summary>
    [CustomLuaClass]
    public class FailedReceivedMsgEvent: UnityEvent<FSendMsgResult> { public FailedReceivedMsgEvent() { } }
    #endregion
}
