﻿using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Plugins_Options_QuaternionOptions : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DG.Tweening.Plugins.Options.QuaternionOptions o;
			o=new DG.Tweening.Plugins.Options.QuaternionOptions();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Plugins.Options.QuaternionOptions");
		createTypeMetatable(l,constructor, typeof(DG.Tweening.Plugins.Options.QuaternionOptions),typeof(System.ValueType));
	}
}
