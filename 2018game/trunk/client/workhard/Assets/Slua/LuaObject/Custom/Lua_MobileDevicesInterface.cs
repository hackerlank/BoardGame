using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_MobileDevicesInterface : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			MobileDevicesInterface o;
			o=new MobileDevicesInterface();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetIMEI_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetIMEI();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetICCID_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetICCID();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetIMSI_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetIMSI();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetPHoneNumber_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetPHoneNumber();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetMacAddress_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetMacAddress();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int AvailableDiskSize_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.AvailableDiskSize();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetNetConnectivityType_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetNetConnectivityType();
			pushValue(l,true);
			pushEnum(l,(int)ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OpenSystemWirelessSettings_s(IntPtr l) {
		try {
			MobileDevicesInterface.OpenSystemWirelessSettings();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsEmulator_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.IsEmulator();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsAndroidDevice_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.IsAndroidDevice();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetAvailMemory_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetAvailMemory();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetDeviceInfo_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetDeviceInfo();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetDeviceModel_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.GetDeviceModel();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetIPv6_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=MobileDevicesInterface.GetIPv6(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ConvertIPAddress_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.String a3;
			System.Net.Sockets.AddressFamily a4;
			MobileDevicesInterface.ConvertIPAddress(a1,a2,out a3,out a4);
			pushValue(l,true);
			pushValue(l,a3);
			pushValue(l,a4);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int hasSupportReplay_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.hasSupportReplay();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StartRecording_s(IntPtr l) {
		try {
			MobileDevicesInterface.StartRecording();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StopRecording_s(IntPtr l) {
		try {
			MobileDevicesInterface.StopRecording();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int HasSupportBroadcast_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.HasSupportBroadcast();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int isPlayerBroadcasting_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.isPlayerBroadcasting();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int isPlayerPaused_s(IntPtr l) {
		try {
			var ret=MobileDevicesInterface.isPlayerPaused();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StartBroadcast_s(IntPtr l) {
		try {
			MobileDevicesInterface.StartBroadcast();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int PauseBroadcast_s(IntPtr l) {
		try {
			MobileDevicesInterface.PauseBroadcast();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ResumeBroadcast_s(IntPtr l) {
		try {
			MobileDevicesInterface.ResumeBroadcast();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int FinishBroadcast_s(IntPtr l) {
		try {
			MobileDevicesInterface.FinishBroadcast();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StartFrontCamera_s(IntPtr l) {
		try {
			System.Boolean a1;
			checkType(l,1,out a1);
			MobileDevicesInterface.StartFrontCamera(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StartMicrophone_s(IntPtr l) {
		try {
			System.Boolean a1;
			checkType(l,1,out a1);
			MobileDevicesInterface.StartMicrophone(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"MobileDevicesInterface");
		addMember(l,GetIMEI_s);
		addMember(l,GetICCID_s);
		addMember(l,GetIMSI_s);
		addMember(l,GetPHoneNumber_s);
		addMember(l,GetMacAddress_s);
		addMember(l,AvailableDiskSize_s);
		addMember(l,GetNetConnectivityType_s);
		addMember(l,OpenSystemWirelessSettings_s);
		addMember(l,IsEmulator_s);
		addMember(l,IsAndroidDevice_s);
		addMember(l,GetAvailMemory_s);
		addMember(l,GetDeviceInfo_s);
		addMember(l,GetDeviceModel_s);
		addMember(l,GetIPv6_s);
		addMember(l,ConvertIPAddress_s);
		addMember(l,hasSupportReplay_s);
		addMember(l,StartRecording_s);
		addMember(l,StopRecording_s);
		addMember(l,HasSupportBroadcast_s);
		addMember(l,isPlayerBroadcasting_s);
		addMember(l,isPlayerPaused_s);
		addMember(l,StartBroadcast_s);
		addMember(l,PauseBroadcast_s);
		addMember(l,ResumeBroadcast_s);
		addMember(l,FinishBroadcast_s);
		addMember(l,StartFrontCamera_s);
		addMember(l,StartMicrophone_s);
		createTypeMetatable(l,constructor, typeof(MobileDevicesInterface));
	}
}
