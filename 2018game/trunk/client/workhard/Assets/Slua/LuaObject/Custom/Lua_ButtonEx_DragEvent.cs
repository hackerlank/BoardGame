using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ButtonEx_DragEvent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			ButtonEx.DragEvent o;
			o=new ButtonEx.DragEvent();
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
		LuaUnityEvent_ButtonEx_FDragData.reg(l);
		getTypeTable(l,"ButtonEx.DragEvent");
		createTypeMetatable(l,constructor, typeof(ButtonEx.DragEvent),typeof(LuaUnityEvent_ButtonEx_FDragData));
	}
}
