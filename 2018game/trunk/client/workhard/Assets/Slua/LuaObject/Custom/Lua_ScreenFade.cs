using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ScreenFade : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int EnableFade(IntPtr l) {
		try {
			ScreenFade self=(ScreenFade)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.EnableFade(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DisableFade(IntPtr l) {
		try {
			ScreenFade self=(ScreenFade)checkSelf(l);
			self.DisableFade();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get__texture(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,ScreenFade._texture);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set__texture(IntPtr l) {
		try {
			UnityEngine.Texture2D v;
			checkType(l,2,out v);
			ScreenFade._texture=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"ScreenFade");
		addMember(l,EnableFade);
		addMember(l,DisableFade);
		addMember(l,"_texture",get__texture,set__texture,false);
		createTypeMetatable(l,null, typeof(ScreenFade),typeof(UnityEngine.MonoBehaviour));
	}
}
