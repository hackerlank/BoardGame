﻿using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Plugins_Options_NoOptions : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DG.Tweening.Plugins.Options.NoOptions o;
			o=new DG.Tweening.Plugins.Options.NoOptions();
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
		getTypeTable(l,"DG.Tweening.Plugins.Options.NoOptions");
		createTypeMetatable(l,constructor, typeof(DG.Tweening.Plugins.Options.NoOptions),typeof(System.ValueType));
	}
}
