using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_BuildPlatform : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"BuildPlatform");
		addMember(l,0,"Standalones");
		addMember(l,1,"IOS");
		addMember(l,2,"Android");
		addMember(l,3,"WP8");
		LuaDLL.lua_pop(l, 1);
	}
}
