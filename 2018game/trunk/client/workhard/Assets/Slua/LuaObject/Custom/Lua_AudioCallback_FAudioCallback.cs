using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_AudioCallback_FAudioCallback : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			AudioCallback.FAudioCallback o;
			o=new AudioCallback.FAudioCallback();
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
		getTypeTable(l,"AudioCallback.FAudioCallback");
		createTypeMetatable(l,constructor, typeof(AudioCallback.FAudioCallback),typeof(LuaUnityEvent_float));
	}
}
