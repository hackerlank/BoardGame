using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_EDragState : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"EDragState");
		addMember(l,0,"EDS_Begin");
		addMember(l,1,"EDS_Draging");
		addMember(l,2,"EDS_Ended");
		addMember(l,3,"EDS_Max");
		LuaDLL.lua_pop(l, 1);
	}
}
