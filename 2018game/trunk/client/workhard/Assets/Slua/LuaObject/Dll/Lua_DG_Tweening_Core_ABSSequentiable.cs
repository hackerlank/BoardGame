using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_ABSSequentiable : LuaObject {
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Core.ABSSequentiable");
		createTypeMetatable(l,null, typeof(DG.Tweening.Core.ABSSequentiable));
	}
}
