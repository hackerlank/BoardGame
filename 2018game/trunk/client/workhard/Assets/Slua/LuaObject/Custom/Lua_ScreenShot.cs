using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ScreenShot : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int TakeShot(IntPtr l) {
		try {
			ScreenShot self=(ScreenShot)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Action<UnityEngine.Texture2D> a2;
			checkDelegate(l,3,out a2);
			System.Int32 a3;
			checkType(l,4,out a3);
			self.TakeShot(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,ScreenShot.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"ScreenShot");
		addMember(l,TakeShot);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,null, typeof(ScreenShot),typeof(UnityEngine.MonoBehaviour));
	}
}
