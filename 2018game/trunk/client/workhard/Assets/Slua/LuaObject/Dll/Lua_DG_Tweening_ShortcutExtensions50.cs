using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_ShortcutExtensions50 : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOSetFloat_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			System.Single a4;
			checkType(l,4,out a4);
			var ret=DG.Tweening.ShortcutExtensions50.DOSetFloat(a1,a2,a3,a4);
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
	static public int DOComplete_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			var ret=DG.Tweening.ShortcutExtensions50.DOComplete(a1,a2);
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
	static public int DOKill_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			var ret=DG.Tweening.ShortcutExtensions50.DOKill(a1,a2);
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
	static public int DOFlip_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DOFlip(a1);
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
	static public int DOGoto_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Boolean a3;
			checkType(l,3,out a3);
			var ret=DG.Tweening.ShortcutExtensions50.DOGoto(a1,a2,a3);
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
	static public int DOPause_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DOPause(a1);
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
	static public int DOPlay_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DOPlay(a1);
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
	static public int DOPlayBackwards_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DOPlayBackwards(a1);
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
	static public int DOPlayForward_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DOPlayForward(a1);
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
	static public int DORestart_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DORestart(a1);
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
	static public int DORewind_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DORewind(a1);
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
	static public int DOSmoothRewind_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DOSmoothRewind(a1);
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
	static public int DOTogglePause_s(IntPtr l) {
		try {
			UnityEngine.Audio.AudioMixer a1;
			checkType(l,1,out a1);
			var ret=DG.Tweening.ShortcutExtensions50.DOTogglePause(a1);
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
		getTypeTable(l,"DG.Tweening.ShortcutExtensions50");
		addMember(l,DOSetFloat_s);
		addMember(l,DOComplete_s);
		addMember(l,DOKill_s);
		addMember(l,DOFlip_s);
		addMember(l,DOGoto_s);
		addMember(l,DOPause_s);
		addMember(l,DOPlay_s);
		addMember(l,DOPlayBackwards_s);
		addMember(l,DOPlayForward_s);
		addMember(l,DORestart_s);
		addMember(l,DORewind_s);
		addMember(l,DOSmoothRewind_s);
		addMember(l,DOTogglePause_s);
		createTypeMetatable(l,null, typeof(DG.Tweening.ShortcutExtensions50));
	}
}
