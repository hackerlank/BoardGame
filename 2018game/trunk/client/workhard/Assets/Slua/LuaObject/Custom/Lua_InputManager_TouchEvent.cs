using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_InputManager_TouchEvent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			InputManager.TouchEvent o;
			o=new InputManager.TouchEvent();
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
		LuaUnityEvent_UnityEngine_Vector3.reg(l);
		getTypeTable(l,"InputManager.TouchEvent");
		createTypeMetatable(l,constructor, typeof(InputManager.TouchEvent),typeof(LuaUnityEvent_UnityEngine_Vector3));
	}
}
