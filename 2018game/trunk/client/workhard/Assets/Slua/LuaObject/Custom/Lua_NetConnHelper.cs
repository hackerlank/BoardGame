using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_NetConnHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Connect(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Int32 a2;
			checkType(l,3,out a2);
			var ret=self.Connect(a1,a2);
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
	static public int Disconnect(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			self.Disconnect();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ShutdownConn(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			self.ShutdownConn();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DoSendMsg(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			System.Byte[] a1;
			checkArray(l,2,out a1);
			self.DoSendMsg(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ReceiveMessage(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			System.Byte[] a1;
			self.ReceiveMessage(out a1);
			pushValue(l,true);
			pushValue(l,a1);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ThreadSleep(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.ThreadSleep(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SafeRelease(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			self.SafeRelease();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onSocketStateChanged(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onSocketStateChanged);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onFailedSendMsg(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onFailedSendMsg);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onFailedReceiveMsg(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onFailedReceiveMsg);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_socketState(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.socketState);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isConnected(IntPtr l) {
		try {
			NetConnHelper self=(NetConnHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isConnected);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_GInstance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,NetConnHelper.GInstance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"NetConnHelper");
		addMember(l,Connect);
		addMember(l,Disconnect);
		addMember(l,ShutdownConn);
		addMember(l,DoSendMsg);
		addMember(l,ReceiveMessage);
		addMember(l,ThreadSleep);
		addMember(l,SafeRelease);
		addMember(l,"onSocketStateChanged",get_onSocketStateChanged,null,true);
		addMember(l,"onFailedSendMsg",get_onFailedSendMsg,null,true);
		addMember(l,"onFailedReceiveMsg",get_onFailedReceiveMsg,null,true);
		addMember(l,"socketState",get_socketState,null,true);
		addMember(l,"isConnected",get_isConnected,null,true);
		addMember(l,"GInstance",get_GInstance,null,false);
		createTypeMetatable(l,null, typeof(NetConnHelper),typeof(UnityEngine.MonoBehaviour));
	}
}
