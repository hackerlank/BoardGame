using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_HandlesDrawMode : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.HandlesDrawMode");
		addMember(l,0,"Orthographic");
		addMember(l,1,"Perspective");
		LuaDLL.lua_pop(l, 1);
	}
}
