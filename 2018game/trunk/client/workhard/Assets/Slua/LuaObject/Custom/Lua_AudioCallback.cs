using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_AudioCallback : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			AudioCallback o;
			o=new AudioCallback();
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
	static public int get_onSystemVolumeChanged(IntPtr l) {
		try {
			AudioCallback self=(AudioCallback)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onSystemVolumeChanged);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onVoiceVolumeChanged(IntPtr l) {
		try {
			AudioCallback self=(AudioCallback)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onVoiceVolumeChanged);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onMusicVolumeChanged(IntPtr l) {
		try {
			AudioCallback self=(AudioCallback)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onMusicVolumeChanged);
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
			pushValue(l,AudioCallback.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"AudioCallback");
		addMember(l,"onSystemVolumeChanged",get_onSystemVolumeChanged,null,true);
		addMember(l,"onVoiceVolumeChanged",get_onVoiceVolumeChanged,null,true);
		addMember(l,"onMusicVolumeChanged",get_onMusicVolumeChanged,null,true);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,constructor, typeof(AudioCallback));
	}
}
