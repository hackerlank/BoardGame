using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_FSocketStateChanged : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			FSocketStateChanged o;
			ESocketState a1;
			checkEnum(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			o=new FSocketStateChanged(a1,a2);
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
	static public int get_currentState(IntPtr l) {
		try {
			FSocketStateChanged self=(FSocketStateChanged)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.currentState);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_currentState(IntPtr l) {
		try {
			FSocketStateChanged self=(FSocketStateChanged)checkSelf(l);
			ESocketState v;
			checkEnum(l,2,out v);
			self.currentState=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_desc(IntPtr l) {
		try {
			FSocketStateChanged self=(FSocketStateChanged)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.desc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_desc(IntPtr l) {
		try {
			FSocketStateChanged self=(FSocketStateChanged)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.desc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"FSocketStateChanged");
		addMember(l,"currentState",get_currentState,set_currentState,true);
		addMember(l,"desc",get_desc,set_desc,true);
		createTypeMetatable(l,constructor, typeof(FSocketStateChanged));
	}
}
