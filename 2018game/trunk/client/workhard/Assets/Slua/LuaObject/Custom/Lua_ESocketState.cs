using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ESocketState : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"ESocketState");
		addMember(l,0,"ESS_Invalid");
		addMember(l,1,"ESS_Connectting");
		addMember(l,2,"ESS_Connected");
		addMember(l,3,"ESS_ConnecttingFailed");
		addMember(l,4,"ESS_Disconnected");
		addMember(l,5,"ESS_Quit");
		LuaDLL.lua_pop(l, 1);
	}
}
