using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_OnEnableBehaviour : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.Core.OnEnableBehaviour");
		addMember(l,0,"None");
		addMember(l,1,"Play");
		addMember(l,2,"Restart");
		addMember(l,3,"RestartFromSpawnPoint");
		LuaDLL.lua_pop(l, 1);
	}
}
