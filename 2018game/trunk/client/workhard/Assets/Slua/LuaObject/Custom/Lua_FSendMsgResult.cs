using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_FSendMsgResult : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			FSendMsgResult o;
			System.Int32 a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Boolean a3;
			checkType(l,4,out a3);
			o=new FSendMsgResult(a1,a2,a3);
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
	static public int get_errorCode(IntPtr l) {
		try {
			FSendMsgResult self=(FSendMsgResult)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.errorCode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_errorCode(IntPtr l) {
		try {
			FSendMsgResult self=(FSendMsgResult)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.errorCode=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_reason(IntPtr l) {
		try {
			FSendMsgResult self=(FSendMsgResult)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.reason);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_reason(IntPtr l) {
		try {
			FSendMsgResult self=(FSendMsgResult)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.reason=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_bPassed(IntPtr l) {
		try {
			FSendMsgResult self=(FSendMsgResult)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.bPassed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_bPassed(IntPtr l) {
		try {
			FSendMsgResult self=(FSendMsgResult)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.bPassed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"FSendMsgResult");
		addMember(l,"errorCode",get_errorCode,set_errorCode,true);
		addMember(l,"reason",get_reason,set_reason,true);
		addMember(l,"bPassed",get_bPassed,set_bPassed,true);
		createTypeMetatable(l,constructor, typeof(FSendMsgResult));
	}
}
