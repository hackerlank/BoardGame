using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_ABSAnimationComponent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOPlay(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
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
	static public int get_updateType(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.updateType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_updateType(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			DG.Tweening.UpdateType v;
			checkEnum(l,2,out v);
			self.updateType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isSpeedBased(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isSpeedBased);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_isSpeedBased(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isSpeedBased=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_hasOnStart(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hasOnStart);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_hasOnStart(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hasOnStart=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_hasOnPlay(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hasOnPlay);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_hasOnPlay(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hasOnPlay=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_hasOnUpdate(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hasOnUpdate);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_hasOnUpdate(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hasOnUpdate=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_hasOnStepComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hasOnStepComplete);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_hasOnStepComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hasOnStepComplete=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_hasOnComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hasOnComplete);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_hasOnComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hasOnComplete=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_hasOnTweenCreated(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hasOnTweenCreated);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_hasOnTweenCreated(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hasOnTweenCreated=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onStart(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onStart);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onStart(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			UnityEngine.Events.UnityEvent v;
			checkType(l,2,out v);
			self.onStart=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onPlay(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onPlay);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onPlay(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			UnityEngine.Events.UnityEvent v;
			checkType(l,2,out v);
			self.onPlay=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onUpdate(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onUpdate);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onUpdate(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			UnityEngine.Events.UnityEvent v;
			checkType(l,2,out v);
			self.onUpdate=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onStepComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onStepComplete);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onStepComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			UnityEngine.Events.UnityEvent v;
			checkType(l,2,out v);
			self.onStepComplete=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onComplete);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onComplete(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			UnityEngine.Events.UnityEvent v;
			checkType(l,2,out v);
			self.onComplete=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onTweenCreated(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onTweenCreated);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onTweenCreated(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			UnityEngine.Events.UnityEvent v;
			checkType(l,2,out v);
			self.onTweenCreated=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_tween(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.tween);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_tween(IntPtr l) {
		try {
			DG.Tweening.Core.ABSAnimationComponent self=(DG.Tweening.Core.ABSAnimationComponent)checkSelf(l);
			DG.Tweening.Tween v;
			checkType(l,2,out v);
			self.tween=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Core.ABSAnimationComponent");
		addMember(l,DOPlay);
		addMember(l,DOPlayBackwards);
		addMember(l,DOPlayForward);
		addMember(l,DOPause);
		addMember(l,DOTogglePause);
		addMember(l,DORewind);
		addMember(l,DORestart);
		addMember(l,DOComplete);
		addMember(l,DOKill);
		addMember(l,"updateType",get_updateType,set_updateType,true);
		addMember(l,"isSpeedBased",get_isSpeedBased,set_isSpeedBased,true);
		addMember(l,"hasOnStart",get_hasOnStart,set_hasOnStart,true);
		addMember(l,"hasOnPlay",get_hasOnPlay,set_hasOnPlay,true);
		addMember(l,"hasOnUpdate",get_hasOnUpdate,set_hasOnUpdate,true);
		addMember(l,"hasOnStepComplete",get_hasOnStepComplete,set_hasOnStepComplete,true);
		addMember(l,"hasOnComplete",get_hasOnComplete,set_hasOnComplete,true);
		addMember(l,"hasOnTweenCreated",get_hasOnTweenCreated,set_hasOnTweenCreated,true);
		addMember(l,"onStart",get_onStart,set_onStart,true);
		addMember(l,"onPlay",get_onPlay,set_onPlay,true);
		addMember(l,"onUpdate",get_onUpdate,set_onUpdate,true);
		addMember(l,"onStepComplete",get_onStepComplete,set_onStepComplete,true);
		addMember(l,"onComplete",get_onComplete,set_onComplete,true);
		addMember(l,"onTweenCreated",get_onTweenCreated,set_onTweenCreated,true);
		addMember(l,"tween",get_tween,set_tween,true);
		createTypeMetatable(l,null, typeof(DG.Tweening.Core.ABSAnimationComponent),typeof(UnityEngine.MonoBehaviour));
	}
}
