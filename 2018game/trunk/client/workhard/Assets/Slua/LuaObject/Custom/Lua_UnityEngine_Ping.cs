using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_UnityEngine_Ping : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			UnityEngine.Ping o;
			System.String a1;
			checkType(l,2,out a1);
			o=new UnityEngine.Ping(a1);
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
	static public int DestroyPing(IntPtr l) {
		try {
			UnityEngine.Ping self=(UnityEngine.Ping)checkSelf(l);
			self.DestroyPing();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isDone(IntPtr l) {
		try {
			UnityEngine.Ping self=(UnityEngine.Ping)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isDone);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_time(IntPtr l) {
		try {
			UnityEngine.Ping self=(UnityEngine.Ping)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.time);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_ip(IntPtr l) {
		try {
			UnityEngine.Ping self=(UnityEngine.Ping)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ip);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"Ping");
		addMember(l,DestroyPing);
		addMember(l,"isDone",get_isDone,null,true);
		addMember(l,"time",get_time,null,true);
		addMember(l,"ip",get_ip,null,true);
		createTypeMetatable(l,constructor, typeof(UnityEngine.Ping));
	}
}
