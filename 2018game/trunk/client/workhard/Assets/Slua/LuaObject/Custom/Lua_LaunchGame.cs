using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_LaunchGame : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int LoadCommonLuaScript(IntPtr l) {
		try {
			LaunchGame self=(LaunchGame)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Byte[] a2;
			self.LoadCommonLuaScript(a1,out a2);
			pushValue(l,true);
			pushValue(l,a2);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int UnloadCommonBundle(IntPtr l) {
		try {
			LaunchGame self=(LaunchGame)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.UnloadCommonBundle(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Init(IntPtr l) {
		try {
			LaunchGame self=(LaunchGame)checkSelf(l);
			System.Action a1;
			checkDelegate(l,2,out a1);
			self.Init(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_WECHAT_JAVA_PACKAGE(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LaunchGame.WECHAT_JAVA_PACKAGE);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_WECHAT_JAVA_PACKAGE(IntPtr l) {
		try {
			System.String v;
			checkType(l,2,out v);
			LaunchGame.WECHAT_JAVA_PACKAGE=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_GAME_UTILITY_JAVA_PACKAGE(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LaunchGame.GAME_UTILITY_JAVA_PACKAGE);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_DECOMPRESS_COMMON_LUA_KEY(IntPtr l) {
		try {
			LaunchGame self=(LaunchGame)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.DECOMPRESS_COMMON_LUA_KEY);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_DECOMPRESS_COMMON_LUA_KEY(IntPtr l) {
		try {
			LaunchGame self=(LaunchGame)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.DECOMPRESS_COMMON_LUA_KEY=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_UPDATE_COMMON_BUNDLE_KEY(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,LaunchGame.UPDATE_COMMON_BUNDLE_KEY);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_luaPath(IntPtr l) {
		try {
			LaunchGame self=(LaunchGame)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.luaPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_luaGenPath(IntPtr l) {
		try {
			LaunchGame self=(LaunchGame)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.luaGenPath);
			return 2;
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
			pushValue(l,LaunchGame.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"LaunchGame");
		addMember(l,LoadCommonLuaScript);
		addMember(l,UnloadCommonBundle);
		addMember(l,Init);
		addMember(l,"WECHAT_JAVA_PACKAGE",get_WECHAT_JAVA_PACKAGE,set_WECHAT_JAVA_PACKAGE,false);
		addMember(l,"GAME_UTILITY_JAVA_PACKAGE",get_GAME_UTILITY_JAVA_PACKAGE,null,false);
		addMember(l,"DECOMPRESS_COMMON_LUA_KEY",get_DECOMPRESS_COMMON_LUA_KEY,set_DECOMPRESS_COMMON_LUA_KEY,true);
		addMember(l,"UPDATE_COMMON_BUNDLE_KEY",get_UPDATE_COMMON_BUNDLE_KEY,null,false);
		addMember(l,"luaPath",get_luaPath,null,true);
		addMember(l,"luaGenPath",get_luaGenPath,null,true);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,null, typeof(LaunchGame),typeof(UnityEngine.MonoBehaviour));
	}
}
