using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ENetConnectivityType : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"ENetConnectivityType");
		addMember(l,0,"ENT_Mobile");
		addMember(l,1,"ENT_Wifi");
		addMember(l,2,"ENT_MAX");
		addMember(l,-1,"ENT_Invalid");
		LuaDLL.lua_pop(l, 1);
	}
}
