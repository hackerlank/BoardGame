using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ButtonEx_FDragData : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			ButtonEx.FDragData o;
			o=new ButtonEx.FDragData();
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
	static public int get_state(IntPtr l) {
		try {
			ButtonEx.FDragData self=(ButtonEx.FDragData)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.state);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_state(IntPtr l) {
		try {
			ButtonEx.FDragData self=(ButtonEx.FDragData)checkSelf(l);
			EDragState v;
			checkEnum(l,2,out v);
			self.state=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_eventData(IntPtr l) {
		try {
			ButtonEx.FDragData self=(ButtonEx.FDragData)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.eventData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_eventData(IntPtr l) {
		try {
			ButtonEx.FDragData self=(ButtonEx.FDragData)checkSelf(l);
			UnityEngine.EventSystems.PointerEventData v;
			checkType(l,2,out v);
			self.eventData=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"ButtonEx.FDragData");
		addMember(l,"state",get_state,set_state,true);
		addMember(l,"eventData",get_eventData,set_eventData,true);
		createTypeMetatable(l,constructor, typeof(ButtonEx.FDragData));
	}
}
