using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_WeChatCallback_FWeChatCallback : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			WeChatCallback.FWeChatCallback o;
			o=new WeChatCallback.FWeChatCallback();
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
		LuaUnityEvent_string.reg(l);
		getTypeTable(l,"WeChatCallback.FWeChatCallback");
		createTypeMetatable(l,constructor, typeof(WeChatCallback.FWeChatCallback),typeof(LuaUnityEvent_string));
	}
}
