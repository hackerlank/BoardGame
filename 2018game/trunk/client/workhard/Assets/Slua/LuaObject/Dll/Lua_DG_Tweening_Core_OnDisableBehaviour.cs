using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_OnDisableBehaviour : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.Core.OnDisableBehaviour");
		addMember(l,0,"None");
		addMember(l,1,"Pause");
		addMember(l,2,"Rewind");
		addMember(l,3,"Kill");
		addMember(l,4,"KillAndComplete");
		addMember(l,5,"DestroyGameObject");
		LuaDLL.lua_pop(l, 1);
	}
}
