using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_GameScrollRect : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int StopMovement(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			self.StopMovement();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetListInfos(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			System.Collections.Generic.List<System.Object> a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.SetListInfos(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int RegisterItem(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			System.Object a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.RegisterItem(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SetColumn(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.SetColumn(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int LayoutComplete(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			self.LayoutComplete();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GraphicUpdateComplete(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			self.GraphicUpdateComplete();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OnClose(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			self.OnClose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_SetMinColumnOrRaw(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			int v;
			checkType(l,2,out v);
			self.SetMinColumnOrRaw=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_content(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.content);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_content(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			UnityEngine.RectTransform v;
			checkType(l,2,out v);
			self.content=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onValueChanged(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onValueChanged);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_onValueChanged(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			GameScrollRect.ScrollRectEvent v;
			checkType(l,2,out v);
			self.onValueChanged=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_viewport(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.viewport);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_viewport(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			UnityEngine.RectTransform v;
			checkType(l,2,out v);
			self.viewport=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_normalizedPosition(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.normalizedPosition);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_normalizedPosition(IntPtr l) {
		try {
			GameScrollRect self=(GameScrollRect)checkSelf(l);
			UnityEngine.Vector2 v;
			checkType(l,2,out v);
			self.normalizedPosition=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"GameScrollRect");
		addMember(l,StopMovement);
		addMember(l,SetListInfos);
		addMember(l,RegisterItem);
		addMember(l,SetColumn);
		addMember(l,LayoutComplete);
		addMember(l,GraphicUpdateComplete);
		addMember(l,OnClose);
		addMember(l,"SetMinColumnOrRaw",null,set_SetMinColumnOrRaw,true);
		addMember(l,"content",get_content,set_content,true);
		addMember(l,"onValueChanged",get_onValueChanged,set_onValueChanged,true);
		addMember(l,"viewport",get_viewport,set_viewport,true);
		addMember(l,"normalizedPosition",get_normalizedPosition,set_normalizedPosition,true);
		createTypeMetatable(l,null, typeof(GameScrollRect),typeof(UnityEngine.EventSystems.UIBehaviour));
	}
}
