using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Plugins_Core_ITweenPlugin : LuaObject {
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Plugins.Core.ITweenPlugin");
		createTypeMetatable(l,null, typeof(DG.Tweening.Plugins.Core.ITweenPlugin));
	}
}
