using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_SlotScrollRect_FResetShowItem : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			SlotScrollRect.FResetShowItem o;
			o=new SlotScrollRect.FResetShowItem();
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
		LuaUnityEvent_bool.reg(l);
		getTypeTable(l,"SlotScrollRect.FResetShowItem");
		createTypeMetatable(l,constructor, typeof(SlotScrollRect.FResetShowItem),typeof(LuaUnityEvent_bool));
	}
}
