using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_NetConnHelper_SocketStateChangedEvent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			NetConnHelper.SocketStateChangedEvent o;
			o=new NetConnHelper.SocketStateChangedEvent();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		LuaUnityEvent_FSocketStateChanged.reg(l);
		getTypeTable(l,"NetConnHelper.SocketStateChangedEvent");
		createTypeMetatable(l,constructor, typeof(NetConnHelper.SocketStateChangedEvent),typeof(LuaUnityEvent_FSocketStateChanged));
	}
}
