using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_VisualManagerPreset : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.Core.VisualManagerPreset");
		addMember(l,0,"Custom");
		addMember(l,1,"PoolingSystem");
		LuaDLL.lua_pop(l, 1);
	}
}
