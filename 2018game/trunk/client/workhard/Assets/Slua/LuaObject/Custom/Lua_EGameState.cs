using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_EGameState : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"EGameState");
		addMember(l,0,"EGS_WaitStart");
		addMember(l,1,"EGS_Start");
		addMember(l,2,"EGS_Playing");
		addMember(l,3,"EGS_Paused");
		addMember(l,4,"EGS_Ended");
		addMember(l,5,"EGS_MAX");
		LuaDLL.lua_pop(l, 1);
	}
}
