using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_CardRoundSelectorEx : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Spawn(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
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
	static public int Reset(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			self.Reset();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int BringUp(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.BringUp(a1);
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
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
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
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
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
	static public int OnPointerClick(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			UnityEngine.EventSystems.PointerEventData a1;
			checkType(l,2,out a1);
			self.OnPointerClick(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetTargetCallback(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			System.Action<UnityEngine.GameObject> a1;
			checkDelegate(l,2,out a1);
			self.SetTargetCallback(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int UpdateTargetTransform(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			UnityEngine.Transform a1;
			checkType(l,2,out a1);
			self.UpdateTargetTransform(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_clickBringup(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.clickBringup);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_clickBringup(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.clickBringup=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_container(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.container);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_container(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.container=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_centerPos(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.centerPos);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_centerPos(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			UnityEngine.RectTransform v;
			checkType(l,2,out v);
			self.centerPos=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_moveSpeed(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.moveSpeed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_moveSpeed(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.moveSpeed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_radius(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.radius);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_radius(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.radius=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_aspectRatio(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.aspectRatio);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_aspectRatio(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.aspectRatio=v;
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
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
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
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
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
	static public int get_disableDrag(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.disableDrag);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_disableDrag(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.disableDrag=v;
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
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
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
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			CardRoundSelectorEx.Mode v;
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
	static public int get_parent(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.parent);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_parent(IntPtr l) {
		try {
			CardRoundSelectorEx self=(CardRoundSelectorEx)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.parent=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"CardRoundSelectorEx");
		addMember(l,Spawn);
		addMember(l,Reset);
		addMember(l,BringUp);
		addMember(l,OnDrag);
		addMember(l,OnEndDrag);
		addMember(l,OnPointerClick);
		addMember(l,SetTargetCallback);
		addMember(l,UpdateTargetTransform);
		addMember(l,"clickBringup",get_clickBringup,set_clickBringup,true);
		addMember(l,"container",get_container,set_container,true);
		addMember(l,"centerPos",get_centerPos,set_centerPos,true);
		addMember(l,"moveSpeed",get_moveSpeed,set_moveSpeed,true);
		addMember(l,"radius",get_radius,set_radius,true);
		addMember(l,"aspectRatio",get_aspectRatio,set_aspectRatio,true);
		addMember(l,"scale",get_scale,set_scale,true);
		addMember(l,"disableDrag",get_disableDrag,set_disableDrag,true);
		addMember(l,"touchMode",get_touchMode,set_touchMode,true);
		addMember(l,"parent",get_parent,set_parent,true);
		createTypeMetatable(l,null, typeof(CardRoundSelectorEx),typeof(UnityEngine.MonoBehaviour));
	}
}
