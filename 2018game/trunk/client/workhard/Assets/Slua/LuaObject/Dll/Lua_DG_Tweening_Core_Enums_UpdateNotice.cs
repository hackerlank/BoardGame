using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_Enums_UpdateNotice : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.Core.Enums.UpdateNotice");
		addMember(l,0,"None");
		addMember(l,1,"RewindStep");
		LuaDLL.lua_pop(l, 1);
	}
}
