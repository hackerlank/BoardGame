using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_DOTweenUtils46 : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SwitchToRectTransform_s(IntPtr l) {
		try {
			UnityEngine.RectTransform a1;
			checkType(l,1,out a1);
			UnityEngine.RectTransform a2;
			checkType(l,2,out a2);
			var ret=DG.Tweening.DOTweenUtils46.SwitchToRectTransform(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.DOTweenUtils46");
		addMember(l,SwitchToRectTransform_s);
		createTypeMetatable(l,null, typeof(DG.Tweening.DOTweenUtils46));
	}
}
