using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Sequence : LuaObject {
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Sequence");
		createTypeMetatable(l,null, typeof(DG.Tweening.Sequence),typeof(DG.Tweening.Tween));
	}
}
