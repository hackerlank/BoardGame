﻿using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_PathType : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.PathType");
		addMember(l,0,"Linear");
		addMember(l,1,"CatmullRom");
		LuaDLL.lua_pop(l, 1);
	}
}
