using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_BundleCacheInfo : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			BundleCacheInfo o;
			UnityEngine.AssetBundle a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			o=new BundleCacheInfo(a1,a2);
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
	static public int get_Bundle(IntPtr l) {
		try {
			BundleCacheInfo self=(BundleCacheInfo)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Bundle);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_Bundle(IntPtr l) {
		try {
			BundleCacheInfo self=(BundleCacheInfo)checkSelf(l);
			UnityEngine.AssetBundle v;
			checkType(l,2,out v);
			self.Bundle=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_OutOfTime(IntPtr l) {
		try {
			BundleCacheInfo self=(BundleCacheInfo)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.OutOfTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_OutOfTime(IntPtr l) {
		try {
			BundleCacheInfo self=(BundleCacheInfo)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.OutOfTime=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"BundleCacheInfo");
		addMember(l,"Bundle",get_Bundle,set_Bundle,true);
		addMember(l,"OutOfTime",get_OutOfTime,set_OutOfTime,true);
		createTypeMetatable(l,constructor, typeof(BundleCacheInfo));
	}
}
