using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_InputManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ClearAll(IntPtr l) {
		try {
			InputManager self=(InputManager)checkSelf(l);
			self.ClearAll();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_GInstance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,InputManager.GInstance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onTouchBegan(IntPtr l) {
		try {
			InputManager self=(InputManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onTouchBegan);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onTouchMoved(IntPtr l) {
		try {
			InputManager self=(InputManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onTouchMoved);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onTouchEnded(IntPtr l) {
		try {
			InputManager self=(InputManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onTouchEnded);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onTouchCancel(IntPtr l) {
		try {
			InputManager self=(InputManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onTouchCancel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"InputManager");
		addMember(l,ClearAll);
		addMember(l,"GInstance",get_GInstance,null,false);
		addMember(l,"onTouchBegan",get_onTouchBegan,null,true);
		addMember(l,"onTouchMoved",get_onTouchMoved,null,true);
		addMember(l,"onTouchEnded",get_onTouchEnded,null,true);
		addMember(l,"onTouchCancel",get_onTouchCancel,null,true);
		createTypeMetatable(l,null, typeof(InputManager),typeof(UnityEngine.MonoBehaviour));
	}
}
