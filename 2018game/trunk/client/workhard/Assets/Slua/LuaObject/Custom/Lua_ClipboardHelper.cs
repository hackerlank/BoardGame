using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ClipboardHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			ClipboardHelper o;
			o=new ClipboardHelper();
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
	static public int PasteMsgToClipboard_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=ClipboardHelper.PasteMsgToClipboard(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetClipboardMsg_s(IntPtr l) {
		try {
			var ret=ClipboardHelper.GetClipboardMsg();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"ClipboardHelper");
		addMember(l,PasteMsgToClipboard_s);
		addMember(l,GetClipboardMsg_s);
		createTypeMetatable(l,constructor, typeof(ClipboardHelper));
	}
}
