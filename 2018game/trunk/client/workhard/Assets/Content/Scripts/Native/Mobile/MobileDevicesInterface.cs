using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System.Net.Sockets;
using System;
using System.Runtime.InteropServices;


[SLua.CustomLuaClass]
public enum ENetConnectivityType
{
    ENT_Invalid = -1,//invalid type
    ENT_Mobile = 0, //mobile
    ENT_Wifi = 1,   //wifi
    ENT_MAX,
}

[SLua.CustomLuaClass]
public class MobileDevicesInterface
{
    #region IPhone interface
    #if UNITY_IPHONE
        [DllImport("__Internal")]
	    private static extern string getIPv6(string mHost, string mPort);

        [DllImport("__Internal")]
	    private static extern int IPhoneGetNetType();

        [DllImport("__Internal")]
	    private static extern string IPhoneGetAvaliableDiskSize();

        [DllImport("__Internal")]
	    private static extern string IPhoneGetDeviceUUID();

        [DllImport("__Internal")]
	    private static extern bool isSupportRecord();

        [DllImport("__Internal")]
	    private static extern void startRecording();

        [DllImport("__Internal")]
	    private static extern void stopRecording();
   
        [DllImport("__Internal")]
	    private static extern bool isSupportBroadcast();

	    [DllImport("__Internal")]
	    private static extern void startBroadcast();

	    [DllImport("__Internal")]
	    private static extern void pauseBroadcast();

	    [DllImport("__Internal")]
	    private static extern void finishBroadcast();

	    [DllImport("__Internal")]
	    private static extern void resumeBroadcast();

	    [DllImport("__Internal")]
	    private static extern bool isBroadcasting();
	
	    [DllImport("__Internal")]
	    private static extern bool isPaused();

        [DllImport("__Internal")]
	    private static extern void enableMicrophone(bool bEnable);

        [DllImport("__Internal")]
	    private static extern void enableFrontCamera(bool bEnable);
    #endif
    #endregion


    #region Android class
    private const string SDK_JAVA_DEVICE_CLASS = "com.kingsoft.devicesinfo.api.JavaDevicesInfo";
    #endregion

    /// <summary>
    /// get device unique code
    /// </summary>
    /// <returns></returns>
    public static string GetIMEI()
    {
        string string_imei = "";

        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                //if imei is not exist , should us use the android id instead of it?
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    string_imei = cls.CallStatic<string>("GetIMEI");
                }
            #elif UNITY_IPHONE
                string_imei = IPhoneGetDeviceUUID();
            #endif
        #endif

        Debug.Log("string_imei=" + string_imei);
        return string_imei;
    }

    /// <summary>
    /// get the serial number of sim card
    /// </summary>
    /// <returns>string</returns>
    public static string GetICCID()
    {
        string string_iccid = "";
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    string_iccid = cls.CallStatic<string>("GetICCID");
                }
            #elif UNITY_IPHONE

            #endif
        #endif

        Debug.Log("string_iccid=" + string_iccid);
        return string_iccid;
    }

    /// <summary>
    /// get imsi number
    /// </summary>
    /// <returns></returns>
    public static string GetIMSI()
    {
        string string_imsi = "";
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
            using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
            {
                string_imsi = cls.CallStatic<string>("GetIMSI");
            }
            #elif UNITY_IPHONE

            #endif
        #endif
        Debug.Log("string_imsi=" + string_imsi);
        return string_imsi;
    }

    /// <summary>
    /// Get phone number 
    /// </summary>
    /// <returns>string</returns>
    public static string GetPHoneNumber()
    {
        string string_phonenumber = "";
        #if !UNITY_EDITOR
            #if UNITY_ANDROID

            using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
            {
                string_phonenumber = cls.CallStatic<string>("GetCellPhoneNumber");       
            }
            #elif UNITY_IPHONE

            #endif
        #endif
        Debug.Log("string_phonenumber=" + string_phonenumber);
        return string_phonenumber;
    }


    /// <summary>
    /// Get mac address
    /// </summary>
    /// <returns>string</returns>
    public static string GetMacAddress()
    {
        string string_macaddress = "";
        #if !UNITY_EDITOR
            #if UNITY_ANDROID

                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    string_macaddress = cls.CallStatic<string>("GetMacAddress");
                }
            #elif UNITY_IPHONE

            #endif
        #endif
        Debug.Log("string_macadress=" + string_macaddress);
        return string_macaddress;
    }

    /// <summary>
    /// Get available disk size of device
    /// </summary>
    /// <returns>available disk size</returns>
    public static ulong AvailableDiskSize()
    {
        ulong availableSize = 0;

        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    availableSize = (ulong)cls.CallStatic<long>("GetAvailableSize");
                }
            #elif UNITY_IPHONE
                string tmp = IPhoneGetAvaliableDiskSize();
                if(tmp != null)
                    availableSize =  ulong.Parse(tmp);
            #else
                availableSize = 1000000000000;
            #endif
        #endif

        Debug.Log("avaliable size:: " + availableSize);
        return availableSize;
    }

    /// <summary>
    /// get current net connectivity type
    /// </summary>
    /// <returns></returns>
    public static ENetConnectivityType GetNetConnectivityType()
    {
        ENetConnectivityType currentType = ENetConnectivityType.ENT_Invalid;
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    currentType = (ENetConnectivityType)cls.CallStatic<int>("GetNetLinkType");
                }
            #elif UNITY_IPHONE
                currentType = (ENetConnectivityType)IPhoneGetNetType();
            #endif
        #else 
            currentType = ENetConnectivityType.ENT_Wifi;
        #endif
        return currentType;
    }

    /// <summary>
    /// open the wireless settings window 
    /// </summary>
    public static void OpenSystemWirelessSettings()
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {			
                    cls.CallStatic("OpenSystemWirelessSettings", new object[] { });
                }
            #elif UNITY_IPHONE
                 Debug.LogError("Currently never support on ios platform");
            #endif
        #endif
    }

    public static bool IsEmulator()
    {
        bool b = false;

        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    b = cls.CallStatic<bool>("IsEmulator");
                }
            #elif UNITY_IPHONE

            #endif
        #endif

        return b;
    }

    // attention!!! avoid call this function in update
    public static bool IsAndroidDevice()
    {
        if (Application.platform == RuntimePlatform.Android && !IsEmulator())
        {
            return true;
        }

        return false;
    }

    /// <summary>
    /// get the available memory of device
    /// </summary>
    /// <returns></returns>
    public static int GetAvailMemory()
    {
        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    return cls.CallStatic<int>("GetAvailMemory");
                }
            #elif UNITY_IPHONE
            #endif
        #endif
        return 0;
    }

    //自定义登录 设备信息 日志
    public static string GetDeviceInfo()
    {
        return string.Format("{0};{1}", GetDeviceModel(), GetAvailMemory());
    }

    /// <summary>
    /// return the device model title
    /// </summary>
    /// <returns></returns>
    public static string GetDeviceModel()
    {
        string device_model = "NULL";

        #if !UNITY_EDITOR
            #if UNITY_ANDROID
                using (AndroidJavaClass cls = new AndroidJavaClass(SDK_JAVA_DEVICE_CLASS))
                {
                    device_model = cls.CallStatic<string>("GetDeviceModel");
                }
            #elif UNITY_IPHONE
               device_model =  UnityEngine.iOS.Device.generation.ToString();;
            #endif
        #endif
        return device_model;
    }

    /// <summary>
    /// Get IPv6 address
    /// </summary>
    /// <param name="mHost"></param>
    /// <param name="mPort"></param>
    /// <returns></returns>
    public static string GetIPv6(string mHost, string mPort)
    {
        #if UNITY_IPHONE && !UNITY_EDITOR
		    string mIPv6 = getIPv6(mHost, mPort);
            Debug.Log("convert ip address " + mIPv6);
		    return mIPv6;
        #else
            return mHost + "&&ipv4";
        #endif
    }

    /// <summary>
    /// Get ip type. will calculate the ipv6 address
    /// </summary>
    /// <param name="serverIp"></param>
    /// <param name="serverPorts"></param>
    /// <param name="newServerIp"></param>
    /// <param name="mIPType"></param>
    public static void ConvertIPAddress(string serverIp, string serverPorts, out string newServerIp, out AddressFamily mIPType)
    {
        mIPType = AddressFamily.InterNetwork;
        newServerIp = serverIp;
        try
        {
            string mIPv6 = GetIPv6(serverIp, serverPorts);
            if (!string.IsNullOrEmpty(mIPv6))
            {
                string[] m_StrTemp = System.Text.RegularExpressions.Regex.Split(mIPv6, "&&");
                if (m_StrTemp != null && m_StrTemp.Length >= 2)
                {
                    string IPType = m_StrTemp[1];
                    if (IPType == "ipv6")
                    {
                        newServerIp = m_StrTemp[0];
                        mIPType = AddressFamily.InterNetworkV6;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.Log("GetIPv6 error:" + e);
        }

    }

    /// <summary>
    /// does the os support replay?
    /// </summary>
    /// <returns>return true if os supports, otherwise false</returns>
    public static bool hasSupportReplay()
    {
        bool bSupport = false;
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
                bSupport = isSupportRecord();
            #else
                //do not support
            #endif
        #endif

        return bSupport;
    }

    /// <summary>
    /// start recording
    /// </summary>
    public static void StartRecording()
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
                startRecording();
            #else
                Debug.Log("do not support");
            #endif
        #endif
    }

    /// <summary>
    /// stop recording
    /// </summary>
    public static void StopRecording()
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
                stopRecording();
            #else
                Debug.Log("do not support");
            #endif
        #endif
    }

    /// <summary>
    ///  whehter this device support broadcast
    /// </summary>
    /// <returns>return ture if os support it, otherwise return false</returns>
    public static bool HasSupportBroadcast()
    {
        bool bSupport = false;
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				bSupport = isSupportBroadcast();
            #else
				//do not support
            #endif
        #endif

        return bSupport;
    }

    /// <summary>
    /// whether player is broadcasting
    /// </summary>
    public static bool isPlayerBroadcasting()
    {
        bool bBroadcasting = false;
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				bBroadcasting = isBroadcasting();
            #else   
				//do not support
            #endif
        #endif
        return bBroadcasting;
    }

    /// <summary>
    ///  whether player paused broadcast
    /// </summary>
    public static bool isPlayerPaused()
    {
        bool bPaused = false;
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				bPaused = isPaused();
            #else
				//do not support
            #endif
        #endif

        return bPaused;
    }

    /// <summary>
    /// start broadcast
    /// </summary>
    public static void StartBroadcast()
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				startBroadcast();
            #else
				//do not support
            #endif
        #endif
    }

    /// <summary>
    /// pause broadcast
    /// </summary>
    public static void PauseBroadcast()
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				pauseBroadcast();
            #else
				//do not support
            #endif
        #endif
    }

    /// <summary>
    /// resume broadcast
    /// </summary>
    public static void ResumeBroadcast()
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				resumeBroadcast();
            #else
				//do not support
            #endif
        #endif
    }

    /// <summary>
    /// finish broadcast
    /// </summary>
    public static void FinishBroadcast()
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				finishBroadcast();
            #else
				//do not support
            #endif
        #endif
    }

    /// <summary>
    /// show front camera contents
    /// </summary>
    /// <param name="bStart">render or disable</param>
    public static void StartFrontCamera(bool bStart)
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				enableFrontCamera(bStart);
            #else
				 //do not support
            #endif
        #endif
    }

    /// <summary>
    /// enable or disable the microphone 
    /// but it doesnt work at present
    /// </summary>
    /// <param name="bStart"></param>
    public static void StartMicrophone(bool bStart)
    {
        #if !UNITY_EDITOR
            #if UNITY_IPHONE
				enableMicrophone(bStart);
            #else
				//do not support
            #endif
        #endif
    }
}
