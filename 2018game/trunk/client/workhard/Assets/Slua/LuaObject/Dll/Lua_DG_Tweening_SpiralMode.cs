using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_SpiralMode : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.SpiralMode");
		addMember(l,0,"Expand");
		addMember(l,1,"ExpandThenContract");
		LuaDLL.lua_pop(l, 1);
	}
}
