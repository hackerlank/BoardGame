using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_AudioHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			AudioHelper o;
			o=new AudioHelper();
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
	static public int Init_s(IntPtr l) {
		try {
			AudioHelper.Init();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetSystemVolume_s(IntPtr l) {
		try {
			var ret=AudioHelper.GetSystemVolume();
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
	static public int SetSystemVolume_s(IntPtr l) {
		try {
			System.Single a1;
			checkType(l,1,out a1);
			AudioHelper.SetSystemVolume(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetVoiceVolume_s(IntPtr l) {
		try {
			var ret=AudioHelper.GetVoiceVolume();
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
	static public int SetVoiceVolume_s(IntPtr l) {
		try {
			System.Single a1;
			checkType(l,1,out a1);
			AudioHelper.SetVoiceVolume(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetMusicVolume_s(IntPtr l) {
		try {
			var ret=AudioHelper.GetMusicVolume();
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
	static public int SetMusicVolume_s(IntPtr l) {
		try {
			System.Single a1;
			checkType(l,1,out a1);
			AudioHelper.SetMusicVolume(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_MIN_VOLUME(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AudioHelper.MIN_VOLUME);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_maxMusicVolume(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AudioHelper.maxMusicVolume);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_maxSystemVolume(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AudioHelper.maxSystemVolume);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_maxVoiceVolume(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,AudioHelper.maxVoiceVolume);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"AudioHelper");
		addMember(l,Init_s);
		addMember(l,GetSystemVolume_s);
		addMember(l,SetSystemVolume_s);
		addMember(l,GetVoiceVolume_s);
		addMember(l,SetVoiceVolume_s);
		addMember(l,GetMusicVolume_s);
		addMember(l,SetMusicVolume_s);
		addMember(l,"MIN_VOLUME",get_MIN_VOLUME,null,false);
		addMember(l,"maxMusicVolume",get_maxMusicVolume,null,false);
		addMember(l,"maxSystemVolume",get_maxSystemVolume,null,false);
		addMember(l,"maxVoiceVolume",get_maxVoiceVolume,null,false);
		createTypeMetatable(l,constructor, typeof(AudioHelper));
	}
}
