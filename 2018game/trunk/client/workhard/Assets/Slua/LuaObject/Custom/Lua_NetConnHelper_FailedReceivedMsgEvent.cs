using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_NetConnHelper_FailedReceivedMsgEvent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			NetConnHelper.FailedReceivedMsgEvent o;
			o=new NetConnHelper.FailedReceivedMsgEvent();
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
		getTypeTable(l,"NetConnHelper.FailedReceivedMsgEvent");
		createTypeMetatable(l,constructor, typeof(NetConnHelper.FailedReceivedMsgEvent),typeof(LuaUnityEvent_FSendMsgResult));
	}
}
