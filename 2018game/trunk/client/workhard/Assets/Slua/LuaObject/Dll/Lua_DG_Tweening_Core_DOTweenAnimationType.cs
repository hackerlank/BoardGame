using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Core_DOTweenAnimationType : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"DG.Tweening.Core.DOTweenAnimationType");
		addMember(l,0,"None");
		addMember(l,1,"Move");
		addMember(l,2,"LocalMove");
		addMember(l,3,"Rotate");
		addMember(l,4,"LocalRotate");
		addMember(l,5,"Scale");
		addMember(l,6,"Color");
		addMember(l,7,"Fade");
		addMember(l,8,"Text");
		addMember(l,9,"PunchPosition");
		addMember(l,10,"PunchRotation");
		addMember(l,11,"PunchScale");
		addMember(l,12,"ShakePosition");
		addMember(l,13,"ShakeRotation");
		addMember(l,14,"ShakeScale");
		addMember(l,15,"CameraAspect");
		addMember(l,16,"CameraBackgroundColor");
		addMember(l,17,"CameraFieldOfView");
		addMember(l,18,"CameraOrthoSize");
		addMember(l,19,"CameraPixelRect");
		addMember(l,20,"CameraRect");
		addMember(l,21,"UIWidthHeight");
		LuaDLL.lua_pop(l, 1);
	}
}
