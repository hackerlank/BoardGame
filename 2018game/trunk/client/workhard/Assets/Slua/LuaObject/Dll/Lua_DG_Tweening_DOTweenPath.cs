using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_DOTweenPath : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOPlay(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DOPlay();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOPlayBackwards(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DOPlayBackwards();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOPlayForward(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DOPlayForward();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOPause(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DOPause();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOTogglePause(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DOTogglePause();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DORewind(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DORewind();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DORestart(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.DORestart(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOComplete(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DOComplete();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOKill(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			self.DOKill();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetTween(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			var ret=self.GetTween();
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
	static public int GetDrawPoints(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			var ret=self.GetDrawPoints();
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
	static public int get_delay(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.delay);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_delay(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.delay=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_duration(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.duration);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_duration(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.duration=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_easeType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.easeType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_easeType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.Ease v;
			checkEnum(l,2,out v);
			self.easeType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_easeCurve(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.easeCurve);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_easeCurve(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			UnityEngine.AnimationCurve v;
			checkType(l,2,out v);
			self.easeCurve=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_loops(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.loops);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_loops(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.loops=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_id(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.id);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_id(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.id=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_loopType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.loopType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_loopType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.LoopType v;
			checkEnum(l,2,out v);
			self.loopType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_orientType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.orientType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_orientType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.Plugins.Options.OrientType v;
			checkEnum(l,2,out v);
			self.orientType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_lookAtTransform(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.lookAtTransform);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_lookAtTransform(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.lookAtTransform=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_lookAtPosition(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.lookAtPosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_lookAtPosition(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.lookAtPosition=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_lookAhead(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.lookAhead);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_lookAhead(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.lookAhead=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_autoPlay(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.autoPlay);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_autoPlay(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.autoPlay=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_autoKill(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.autoKill);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_autoKill(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.autoKill=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_relative(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.relative);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_relative(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.relative=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isLocal(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isLocal);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_isLocal(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isLocal=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isClosedPath(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isClosedPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_isClosedPath(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isClosedPath=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_pathResolution(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pathResolution);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_pathResolution(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.pathResolution=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_pathMode(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.pathMode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_pathMode(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.PathMode v;
			checkEnum(l,2,out v);
			self.pathMode=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_lockRotation(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.lockRotation);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_lockRotation(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.AxisConstraint v;
			checkEnum(l,2,out v);
			self.lockRotation=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_assignForwardAndUp(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.assignForwardAndUp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_assignForwardAndUp(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.assignForwardAndUp=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_forwardDirection(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.forwardDirection);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_forwardDirection(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.forwardDirection=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_upDirection(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.upDirection);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_upDirection(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.upDirection=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_wps(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.wps);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_wps(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Collections.Generic.List<UnityEngine.Vector3> v;
			checkType(l,2,out v);
			self.wps=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_fullWps(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.fullWps);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_fullWps(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Collections.Generic.List<UnityEngine.Vector3> v;
			checkType(l,2,out v);
			self.fullWps=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_path(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.path);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_path(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.Plugins.Core.PathCore.Path v;
			checkType(l,2,out v);
			self.path=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_inspectorMode(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.inspectorMode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_inspectorMode(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.DOTweenInspectorMode v;
			checkEnum(l,2,out v);
			self.inspectorMode=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_pathType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.pathType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_pathType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.PathType v;
			checkEnum(l,2,out v);
			self.pathType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_handlesType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.handlesType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_handlesType(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.HandlesType v;
			checkEnum(l,2,out v);
			self.handlesType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_livePreview(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.livePreview);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_livePreview(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.livePreview=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_handlesDrawMode(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.handlesDrawMode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_handlesDrawMode(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			DG.Tweening.HandlesDrawMode v;
			checkEnum(l,2,out v);
			self.handlesDrawMode=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_perspectiveHandleSize(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.perspectiveHandleSize);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_perspectiveHandleSize(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.perspectiveHandleSize=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_showIndexes(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.showIndexes);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_showIndexes(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.showIndexes=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_showWpLength(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.showWpLength);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_showWpLength(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.showWpLength=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_pathColor(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pathColor);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_pathColor(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			UnityEngine.Color v;
			checkType(l,2,out v);
			self.pathColor=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_lastSrcPosition(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.lastSrcPosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_lastSrcPosition(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.lastSrcPosition=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_wpsDropdown(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.wpsDropdown);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_wpsDropdown(IntPtr l) {
		try {
			DG.Tweening.DOTweenPath self=(DG.Tweening.DOTweenPath)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.wpsDropdown=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.DOTweenPath");
		addMember(l,DOPlay);
		addMember(l,DOPlayBackwards);
		addMember(l,DOPlayForward);
		addMember(l,DOPause);
		addMember(l,DOTogglePause);
		addMember(l,DORewind);
		addMember(l,DORestart);
		addMember(l,DOComplete);
		addMember(l,DOKill);
		addMember(l,GetTween);
		addMember(l,GetDrawPoints);
		addMember(l,"delay",get_delay,set_delay,true);
		addMember(l,"duration",get_duration,set_duration,true);
		addMember(l,"easeType",get_easeType,set_easeType,true);
		addMember(l,"easeCurve",get_easeCurve,set_easeCurve,true);
		addMember(l,"loops",get_loops,set_loops,true);
		addMember(l,"id",get_id,set_id,true);
		addMember(l,"loopType",get_loopType,set_loopType,true);
		addMember(l,"orientType",get_orientType,set_orientType,true);
		addMember(l,"lookAtTransform",get_lookAtTransform,set_lookAtTransform,true);
		addMember(l,"lookAtPosition",get_lookAtPosition,set_lookAtPosition,true);
		addMember(l,"lookAhead",get_lookAhead,set_lookAhead,true);
		addMember(l,"autoPlay",get_autoPlay,set_autoPlay,true);
		addMember(l,"autoKill",get_autoKill,set_autoKill,true);
		addMember(l,"relative",get_relative,set_relative,true);
		addMember(l,"isLocal",get_isLocal,set_isLocal,true);
		addMember(l,"isClosedPath",get_isClosedPath,set_isClosedPath,true);
		addMember(l,"pathResolution",get_pathResolution,set_pathResolution,true);
		addMember(l,"pathMode",get_pathMode,set_pathMode,true);
		addMember(l,"lockRotation",get_lockRotation,set_lockRotation,true);
		addMember(l,"assignForwardAndUp",get_assignForwardAndUp,set_assignForwardAndUp,true);
		addMember(l,"forwardDirection",get_forwardDirection,set_forwardDirection,true);
		addMember(l,"upDirection",get_upDirection,set_upDirection,true);
		addMember(l,"wps",get_wps,set_wps,true);
		addMember(l,"fullWps",get_fullWps,set_fullWps,true);
		addMember(l,"path",get_path,set_path,true);
		addMember(l,"inspectorMode",get_inspectorMode,set_inspectorMode,true);
		addMember(l,"pathType",get_pathType,set_pathType,true);
		addMember(l,"handlesType",get_handlesType,set_handlesType,true);
		addMember(l,"livePreview",get_livePreview,set_livePreview,true);
		addMember(l,"handlesDrawMode",get_handlesDrawMode,set_handlesDrawMode,true);
		addMember(l,"perspectiveHandleSize",get_perspectiveHandleSize,set_perspectiveHandleSize,true);
		addMember(l,"showIndexes",get_showIndexes,set_showIndexes,true);
		addMember(l,"showWpLength",get_showWpLength,set_showWpLength,true);
		addMember(l,"pathColor",get_pathColor,set_pathColor,true);
		addMember(l,"lastSrcPosition",get_lastSrcPosition,set_lastSrcPosition,true);
		addMember(l,"wpsDropdown",get_wpsDropdown,set_wpsDropdown,true);
		createTypeMetatable(l,null, typeof(DG.Tweening.DOTweenPath),typeof(DG.Tweening.Core.ABSAnimationComponent));
	}
}
