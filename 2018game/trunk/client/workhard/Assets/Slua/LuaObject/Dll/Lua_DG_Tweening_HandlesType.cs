using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_HandlesType : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.HandlesType");
		addMember(l,0,"Free");
		addMember(l,1,"Full");
		LuaDLL.lua_pop(l, 1);
	}
}
