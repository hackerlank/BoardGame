using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_SlotItemInfo_FOnValueChanged : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			SlotItemInfo.FOnValueChanged o;
			o=new SlotItemInfo.FOnValueChanged();
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
		LuaUnityEvent_System_Object.reg(l);
		getTypeTable(l,"SlotItemInfo.FOnValueChanged");
		createTypeMetatable(l,constructor, typeof(SlotItemInfo.FOnValueChanged),typeof(LuaUnityEvent_System_Object));
	}
}
