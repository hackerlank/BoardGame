using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DoTweenPathLuaUtil : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DoTweenPathLuaUtil o;
			o=new DoTweenPathLuaUtil();
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
	static public int DOPath_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			UnityEngine.Vector3[] a2;
			checkArray(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			DG.Tweening.PathType a4;
			checkEnum(l,4,out a4);
			DG.Tweening.PathMode a5;
			checkEnum(l,5,out a5);
			System.Int32 a6;
			checkType(l,6,out a6);
			System.Nullable<UnityEngine.Color> a7;
			checkNullable(l,7,out a7);
			var ret=DoTweenPathLuaUtil.DOPath(a1,a2,a3,a4,a5,a6,a7);
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
	static public int SetEase_s(IntPtr l) {
		try {
			DG.Tweening.Core.TweenerCore<UnityEngine.Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> a1;
			checkType(l,1,out a1);
			DG.Tweening.Ease a2;
			checkEnum(l,2,out a2);
			DoTweenPathLuaUtil.SetEase(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOScaleX_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			var ret=DoTweenPathLuaUtil.DOScaleX(a1,a2,a3);
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
	static public int DOMove_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			UnityEngine.Vector3 a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			var ret=DoTweenPathLuaUtil.DOMove(a1,a2,a3);
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
	static public int DoRotation_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			System.Single a4;
			checkType(l,4,out a4);
			System.Single a5;
			checkType(l,5,out a5);
			DG.Tweening.RotateMode a6;
			checkEnum(l,6,out a6);
			var ret=DoTweenPathLuaUtil.DoRotation(a1,a2,a3,a4,a5,a6);
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
	static public int DoLocalRotation_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			System.Single a4;
			checkType(l,4,out a4);
			System.Single a5;
			checkType(l,5,out a5);
			var ret=DoTweenPathLuaUtil.DoLocalRotation(a1,a2,a3,a4,a5);
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
	static public int DoScale_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			System.Single a4;
			checkType(l,4,out a4);
			System.Single a5;
			checkType(l,5,out a5);
			var ret=DoTweenPathLuaUtil.DoScale(a1,a2,a3,a4,a5);
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
	static public int DOMoveX_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			var ret=DoTweenPathLuaUtil.DOMoveX(a1,a2,a3);
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
	static public int DOLocalMove_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			UnityEngine.Vector3 a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			var ret=DoTweenPathLuaUtil.DOLocalMove(a1,a2,a3);
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
	static public int DOLocalMoveY_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			var ret=DoTweenPathLuaUtil.DOLocalMoveY(a1,a2,a3);
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
	static public int SetRelative_s(IntPtr l) {
		try {
			DG.Tweening.Core.TweenerCore<UnityEngine.Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> a1;
			checkType(l,1,out a1);
			DoTweenPathLuaUtil.SetRelative(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOLocalMoveX_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			var ret=DoTweenPathLuaUtil.DOLocalMoveX(a1,a2,a3);
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
	static public int SetLookAt_s(IntPtr l) {
		try {
			DG.Tweening.Core.TweenerCore<UnityEngine.Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Nullable<UnityEngine.Vector3> a3;
			checkNullable(l,3,out a3);
			System.Nullable<UnityEngine.Vector3> a4;
			checkNullable(l,4,out a4);
			DoTweenPathLuaUtil.SetLookAt(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetLookAtPosition_s(IntPtr l) {
		try {
			DG.Tweening.Core.TweenerCore<UnityEngine.Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			System.Single a4;
			checkType(l,4,out a4);
			System.Nullable<UnityEngine.Vector3> a5;
			checkNullable(l,5,out a5);
			System.Nullable<UnityEngine.Vector3> a6;
			checkNullable(l,6,out a6);
			DoTweenPathLuaUtil.SetLookAtPosition(a1,a2,a3,a4,a5,a6);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetSpeedBased_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			DoTweenPathLuaUtil.SetSpeedBased(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetAutoKill_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			DoTweenPathLuaUtil.SetAutoKill(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetRecyclable_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			DoTweenPathLuaUtil.SetRecyclable(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Kill_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			DoTweenPathLuaUtil.Kill(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsActive_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			var ret=DoTweenPathLuaUtil.IsActive(a1);
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
	static public int IsPlaying_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			var ret=DoTweenPathLuaUtil.IsPlaying(a1);
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
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			DoTweenPathLuaUtil.DOPause(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetEaseTweener_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			DG.Tweening.Ease a2;
			checkEnum(l,2,out a2);
			DoTweenPathLuaUtil.SetEaseTweener(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OnComplete_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			System.Action a2;
			checkDelegate(l,2,out a2);
			DoTweenPathLuaUtil.OnComplete(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OnRewind_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			System.Action a2;
			checkDelegate(l,2,out a2);
			DoTweenPathLuaUtil.OnRewind(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DORewind_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			DoTweenPathLuaUtil.DORewind(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOPlay_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			DoTweenPathLuaUtil.DOPlay(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DORestart_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			DoTweenPathLuaUtil.DORestart(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetLoop_s(IntPtr l) {
		try {
			DG.Tweening.Tween a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			DG.Tweening.LoopType a3;
			checkEnum(l,3,out a3);
			DoTweenPathLuaUtil.SetLoop(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetOptions_s(IntPtr l) {
		try {
			DG.Tweening.Core.TweenerCore<UnityEngine.Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			DG.Tweening.AxisConstraint a3;
			checkEnum(l,3,out a3);
			DG.Tweening.AxisConstraint a4;
			checkEnum(l,4,out a4);
			DoTweenPathLuaUtil.SetOptions(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOPlayBackwards_s(IntPtr l) {
		try {
			UnityEngine.Transform a1;
			checkType(l,1,out a1);
			DoTweenPathLuaUtil.DOPlayBackwards(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DoColor_s(IntPtr l) {
		try {
			UnityEngine.UI.Image a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			System.Single a3;
			checkType(l,3,out a3);
			System.Single a4;
			checkType(l,4,out a4);
			System.Single a5;
			checkType(l,5,out a5);
			System.Single a6;
			checkType(l,6,out a6);
			var ret=DoTweenPathLuaUtil.DoColor(a1,a2,a3,a4,a5,a6);
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
	static public int PathLerp_s(IntPtr l) {
		try {
			UnityEngine.Vector3[] a1;
			checkArray(l,1,out a1);
			var ret=DoTweenPathLuaUtil.PathLerp(a1);
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
	static public int OnWaypointChanged_s(IntPtr l) {
		try {
			DG.Tweening.Core.TweenerCore<UnityEngine.Vector3,DG.Tweening.Plugins.Core.PathCore.Path,DG.Tweening.Plugins.Options.PathOptions> a1;
			checkType(l,1,out a1);
			System.Action<System.Int32> a2;
			checkDelegate(l,2,out a2);
			DoTweenPathLuaUtil.OnWaypointChanged(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DoTweenPathLuaUtil");
		addMember(l,DOPath_s);
		addMember(l,SetEase_s);
		addMember(l,DOScaleX_s);
		addMember(l,DOMove_s);
		addMember(l,DoRotation_s);
		addMember(l,DoLocalRotation_s);
		addMember(l,DoScale_s);
		addMember(l,DOMoveX_s);
		addMember(l,DOLocalMove_s);
		addMember(l,DOLocalMoveY_s);
		addMember(l,SetRelative_s);
		addMember(l,DOLocalMoveX_s);
		addMember(l,SetLookAt_s);
		addMember(l,SetLookAtPosition_s);
		addMember(l,SetSpeedBased_s);
		addMember(l,SetAutoKill_s);
		addMember(l,SetRecyclable_s);
		addMember(l,Kill_s);
		addMember(l,IsActive_s);
		addMember(l,IsPlaying_s);
		addMember(l,DOPause_s);
		addMember(l,SetEaseTweener_s);
		addMember(l,OnComplete_s);
		addMember(l,OnRewind_s);
		addMember(l,DORewind_s);
		addMember(l,DOPlay_s);
		addMember(l,DORestart_s);
		addMember(l,SetLoop_s);
		addMember(l,SetOptions_s);
		addMember(l,DOPlayBackwards_s);
		addMember(l,DoColor_s);
		addMember(l,PathLerp_s);
		addMember(l,OnWaypointChanged_s);
		createTypeMetatable(l,constructor, typeof(DoTweenPathLuaUtil));
	}
}
