using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_WWWRequest : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			WWWRequest o;
			o=new WWWRequest();
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
	static public int CreatWWW(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			self.CreatWWW();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_requestString(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.requestString);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_requestString(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.requestString=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_url(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.url);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_url(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.url=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_triedTimes(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.triedTimes);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_triedTimes(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.triedTimes=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_priority(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.priority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_priority(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.priority=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_bundleData(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.bundleData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_bundleData(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			BundleSmallData v;
			checkType(l,2,out v);
			self.bundleData=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_www(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.www);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_www(IntPtr l) {
		try {
			WWWRequest self=(WWWRequest)checkSelf(l);
			UnityEngine.WWW v;
			checkType(l,2,out v);
			self.www=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"WWWRequest");
		addMember(l,CreatWWW);
		addMember(l,"requestString",get_requestString,set_requestString,true);
		addMember(l,"url",get_url,set_url,true);
		addMember(l,"triedTimes",get_triedTimes,set_triedTimes,true);
		addMember(l,"priority",get_priority,set_priority,true);
		addMember(l,"bundleData",get_bundleData,set_bundleData,true);
		addMember(l,"www",get_www,set_www,true);
		createTypeMetatable(l,constructor, typeof(WWWRequest));
	}
}
