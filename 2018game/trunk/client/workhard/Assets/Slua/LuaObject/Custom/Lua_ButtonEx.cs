using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ButtonEx : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_interactable(IntPtr l) {
		try {
			ButtonEx self=(ButtonEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.interactable);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_interactable(IntPtr l) {
		try {
			ButtonEx self=(ButtonEx)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.interactable=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_dragable(IntPtr l) {
		try {
			ButtonEx self=(ButtonEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.dragable);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_dragable(IntPtr l) {
		try {
			ButtonEx self=(ButtonEx)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.dragable=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onClick(IntPtr l) {
		try {
			ButtonEx self=(ButtonEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onClick);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onDrag(IntPtr l) {
		try {
			ButtonEx self=(ButtonEx)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onDrag);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"ButtonEx");
		addMember(l,"interactable",get_interactable,set_interactable,true);
		addMember(l,"dragable",get_dragable,set_dragable,true);
		addMember(l,"onClick",get_onClick,null,true);
		addMember(l,"onDrag",get_onDrag,null,true);
		createTypeMetatable(l,null, typeof(ButtonEx),typeof(UnityEngine.EventSystems.UIBehaviour));
	}
}
