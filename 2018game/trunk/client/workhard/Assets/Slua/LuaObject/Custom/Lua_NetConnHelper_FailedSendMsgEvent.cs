using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_NetConnHelper_FailedSendMsgEvent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			NetConnHelper.FailedSendMsgEvent o;
			o=new NetConnHelper.FailedSendMsgEvent();
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
		LuaUnityEvent_FSendMsgResult.reg(l);
		getTypeTable(l,"NetConnHelper.FailedSendMsgEvent");
		createTypeMetatable(l,constructor, typeof(NetConnHelper.FailedSendMsgEvent),typeof(LuaUnityEvent_FSendMsgResult));
	}
}
