﻿using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_LoopType : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.LoopType");
		addMember(l,0,"Restart");
		addMember(l,1,"Yoyo");
		addMember(l,2,"Incremental");
		LuaDLL.lua_pop(l, 1);
	}
}
