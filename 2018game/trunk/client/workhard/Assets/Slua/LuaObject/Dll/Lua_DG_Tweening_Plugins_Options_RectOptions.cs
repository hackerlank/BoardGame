﻿using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Plugins_Options_RectOptions : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DG.Tweening.Plugins.Options.RectOptions o;
			o=new DG.Tweening.Plugins.Options.RectOptions();
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
	static public int get_snapping(IntPtr l) {
		try {
			DG.Tweening.Plugins.Options.RectOptions self;
			checkValueType(l,1,out self);
			pushValue(l,true);
			pushValue(l,self.snapping);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_snapping(IntPtr l) {
		try {
			DG.Tweening.Plugins.Options.RectOptions self;
			checkValueType(l,1,out self);
			System.Boolean v;
			checkType(l,2,out v);
			self.snapping=v;
			setBack(l,self);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Plugins.Options.RectOptions");
		addMember(l,"snapping",get_snapping,set_snapping,true);
		createTypeMetatable(l,constructor, typeof(DG.Tweening.Plugins.Options.RectOptions),typeof(System.ValueType));
	}
}
