using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_ScrambleMode : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.ScrambleMode");
		addMember(l,0,"None");
		addMember(l,1,"All");
		addMember(l,2,"Uppercase");
		addMember(l,3,"Lowercase");
		addMember(l,4,"Numerals");
		addMember(l,5,"Custom");
		LuaDLL.lua_pop(l, 1);
	}
}
