using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DrawLineHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DrawLineHelper o;
			o=new DrawLineHelper();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetPositions_s(IntPtr l) {
		try {
			UnityEngine.LineRenderer a1;
			checkType(l,1,out a1);
			System.Collections.Generic.List<UnityEngine.Vector3> a2;
			checkType(l,2,out a2);
			DrawLineHelper.SetPositions(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DrawLineHelper");
		addMember(l,SetPositions_s);
		createTypeMetatable(l,constructor, typeof(DrawLineHelper));
	}
}
