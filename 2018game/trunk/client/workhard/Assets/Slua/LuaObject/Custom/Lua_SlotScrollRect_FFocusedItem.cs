using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_SlotScrollRect_FFocusedItem : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			SlotScrollRect.FFocusedItem o;
			o=new SlotScrollRect.FFocusedItem();
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
		LuaUnityEvent_UnityEngine_Transform.reg(l);
		getTypeTable(l,"SlotScrollRect.FFocusedItem");
		createTypeMetatable(l,constructor, typeof(SlotScrollRect.FFocusedItem),typeof(LuaUnityEvent_UnityEngine_Transform));
	}
}
