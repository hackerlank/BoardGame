using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_DOTweenInspectorMode : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.DOTweenInspectorMode");
		addMember(l,0,"Default");
		addMember(l,1,"InfoAndWaypointsOnly");
		LuaDLL.lua_pop(l, 1);
	}
}
