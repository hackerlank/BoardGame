using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_System_StringComparison : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"System.StringComparison");
		addMember(l,0,"CurrentCulture");
		addMember(l,1,"CurrentCultureIgnoreCase");
		addMember(l,2,"InvariantCulture");
		addMember(l,3,"InvariantCultureIgnoreCase");
		addMember(l,4,"Ordinal");
		addMember(l,5,"OrdinalIgnoreCase");
		LuaDLL.lua_pop(l, 1);
	}
}
