using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_TargetType : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.Core.TargetType");
		addMember(l,0,"Unset");
		addMember(l,1,"Camera");
		addMember(l,2,"CanvasGroup");
		addMember(l,3,"Image");
		addMember(l,4,"Light");
		addMember(l,5,"RectTransform");
		addMember(l,6,"Renderer");
		addMember(l,7,"SpriteRenderer");
		addMember(l,8,"Rigidbody");
		addMember(l,9,"Rigidbody2D");
		addMember(l,10,"Text");
		addMember(l,11,"Transform");
		addMember(l,12,"tk2dBaseSprite");
		addMember(l,13,"tk2dTextMesh");
		addMember(l,14,"TextMeshPro");
		addMember(l,15,"TextMeshProUGUI");
		LuaDLL.lua_pop(l, 1);
	}
}
