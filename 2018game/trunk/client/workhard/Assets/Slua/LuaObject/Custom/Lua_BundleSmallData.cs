using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_BundleSmallData : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			BundleSmallData o;
			o=new BundleSmallData();
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
	static public int get_name(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.name);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_name(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.name=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_includs(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.includs);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_includs(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			self.includs=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_sceneBundle(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.sceneBundle);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_sceneBundle(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.sceneBundle=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_parents(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.parents);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_parents(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			self.parents=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_bEncrypt(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.bEncrypt);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_bEncrypt(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.bEncrypt=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_bundleHashCode(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.bundleHashCode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_bundleHashCode(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.bundleHashCode=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_size(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.size);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_size(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.Int64 v;
			checkType(l,2,out v);
			self.size=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_compressedSize(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.compressedSize);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_compressedSize(IntPtr l) {
		try {
			BundleSmallData self=(BundleSmallData)checkSelf(l);
			System.Int64 v;
			checkType(l,2,out v);
			self.compressedSize=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"BundleSmallData");
		addMember(l,"name",get_name,set_name,true);
		addMember(l,"includs",get_includs,set_includs,true);
		addMember(l,"sceneBundle",get_sceneBundle,set_sceneBundle,true);
		addMember(l,"parents",get_parents,set_parents,true);
		addMember(l,"bEncrypt",get_bEncrypt,set_bEncrypt,true);
		addMember(l,"bundleHashCode",get_bundleHashCode,set_bundleHashCode,true);
		addMember(l,"size",get_size,set_size,true);
		addMember(l,"compressedSize",get_compressedSize,set_compressedSize,true);
		createTypeMetatable(l,constructor, typeof(BundleSmallData));
	}
}
