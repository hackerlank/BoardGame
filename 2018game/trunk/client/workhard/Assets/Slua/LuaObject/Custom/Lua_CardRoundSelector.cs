using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_CardRoundSelector : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Init(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			self.Init();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Spawn(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			var ret=self.Spawn();
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
	static public int SetOnTopChange(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Action<UnityEngine.GameObject> a1;
			checkDelegate(l,2,out a1);
			self.SetOnTopChange(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OnBeginDrag(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.EventSystems.PointerEventData a1;
			checkType(l,2,out a1);
			self.OnBeginDrag(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OnDrag(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.EventSystems.PointerEventData a1;
			checkType(l,2,out a1);
			self.OnDrag(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OnEndDrag(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.EventSystems.PointerEventData a1;
			checkType(l,2,out a1);
			self.OnEndDrag(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Refresh(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			self.Refresh();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int IsOnTop(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			var ret=self.IsOnTop(a1);
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
	static public int BringUp(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			System.Action a2;
			checkDelegate(l,3,out a2);
			self.BringUp(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Clear(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_cardTemplate(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.cardTemplate);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_cardTemplate(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.cardTemplate=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_touchMode(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.touchMode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_touchMode(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			CardRoundSelector.Mode v;
			checkEnum(l,2,out v);
			self.touchMode=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isLoop(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isLoop);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_isLoop(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isLoop=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_radiusScale(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.radiusScale);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_radiusScale(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.radiusScale=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_offset(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.offset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_offset(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.offset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_speed(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.speed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_speed(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.speed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_scale(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.scale);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_scale(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.scale=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_showCardCount(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.showCardCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_showCardCount(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.showCardCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_positionCurve(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.positionCurve);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_positionCurve(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.AnimationCurve v;
			checkType(l,2,out v);
			self.positionCurve=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_scaleCurve(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.scaleCurve);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_scaleCurve(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			UnityEngine.AnimationCurve v;
			checkType(l,2,out v);
			self.scaleCurve=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_current(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.current);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_current(IntPtr l) {
		try {
			CardRoundSelector self=(CardRoundSelector)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.current=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"CardRoundSelector");
		addMember(l,Init);
		addMember(l,Spawn);
		addMember(l,SetOnTopChange);
		addMember(l,OnBeginDrag);
		addMember(l,OnDrag);
		addMember(l,OnEndDrag);
		addMember(l,Refresh);
		addMember(l,IsOnTop);
		addMember(l,BringUp);
		addMember(l,Clear);
		addMember(l,"cardTemplate",get_cardTemplate,set_cardTemplate,true);
		addMember(l,"touchMode",get_touchMode,set_touchMode,true);
		addMember(l,"isLoop",get_isLoop,set_isLoop,true);
		addMember(l,"radiusScale",get_radiusScale,set_radiusScale,true);
		addMember(l,"offset",get_offset,set_offset,true);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"scale",get_scale,set_scale,true);
		addMember(l,"showCardCount",get_showCardCount,set_showCardCount,true);
		addMember(l,"positionCurve",get_positionCurve,set_positionCurve,true);
		addMember(l,"scaleCurve",get_scaleCurve,set_scaleCurve,true);
		addMember(l,"current",get_current,set_current,true);
		createTypeMetatable(l,null, typeof(CardRoundSelector),typeof(UnityEngine.MonoBehaviour));
	}
}
