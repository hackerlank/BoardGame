using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_DOTweenVisualManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_preset(IntPtr l) {
		try {
			DG.Tweening.DOTweenVisualManager self=(DG.Tweening.DOTweenVisualManager)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.preset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_preset(IntPtr l) {
		try {
			DG.Tweening.DOTweenVisualManager self=(DG.Tweening.DOTweenVisualManager)checkSelf(l);
			DG.Tweening.Core.VisualManagerPreset v;
			checkEnum(l,2,out v);
			self.preset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onEnableBehaviour(IntPtr l) {
		try {
			DG.Tweening.DOTweenVisualManager self=(DG.Tweening.DOTweenVisualManager)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.onEnableBehaviour);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onEnableBehaviour(IntPtr l) {
		try {
			DG.Tweening.DOTweenVisualManager self=(DG.Tweening.DOTweenVisualManager)checkSelf(l);
			DG.Tweening.Core.OnEnableBehaviour v;
			checkEnum(l,2,out v);
			self.onEnableBehaviour=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onDisableBehaviour(IntPtr l) {
		try {
			DG.Tweening.DOTweenVisualManager self=(DG.Tweening.DOTweenVisualManager)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.onDisableBehaviour);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onDisableBehaviour(IntPtr l) {
		try {
			DG.Tweening.DOTweenVisualManager self=(DG.Tweening.DOTweenVisualManager)checkSelf(l);
			DG.Tweening.Core.OnDisableBehaviour v;
			checkEnum(l,2,out v);
			self.onDisableBehaviour=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.DOTweenVisualManager");
		addMember(l,"preset",get_preset,set_preset,true);
		addMember(l,"onEnableBehaviour",get_onEnableBehaviour,set_onEnableBehaviour,true);
		addMember(l,"onDisableBehaviour",get_onDisableBehaviour,set_onDisableBehaviour,true);
		createTypeMetatable(l,null, typeof(DG.Tweening.DOTweenVisualManager),typeof(UnityEngine.MonoBehaviour));
	}
}
