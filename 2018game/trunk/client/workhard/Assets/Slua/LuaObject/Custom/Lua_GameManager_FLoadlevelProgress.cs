using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_GameManager_FLoadlevelProgress : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			GameManager.FLoadlevelProgress o;
			o=new GameManager.FLoadlevelProgress();
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
		LuaUnityEvent_float.reg(l);
		getTypeTable(l,"GameManager.FLoadlevelProgress");
		createTypeMetatable(l,constructor, typeof(GameManager.FLoadlevelProgress),typeof(LuaUnityEvent_float));
	}
}
