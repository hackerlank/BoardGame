using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_ShortcutExtensionsPro : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DOSpiral_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(UnityEngine.Rigidbody),typeof(float),typeof(System.Nullable<UnityEngine.Vector3>),typeof(DG.Tweening.SpiralMode),typeof(float),typeof(float),typeof(float),typeof(bool))){
				UnityEngine.Rigidbody a1;
				checkType(l,1,out a1);
				System.Single a2;
				checkType(l,2,out a2);
				System.Nullable<UnityEngine.Vector3> a3;
				checkNullable(l,3,out a3);
				DG.Tweening.SpiralMode a4;
				checkEnum(l,4,out a4);
				System.Single a5;
				checkType(l,5,out a5);
				System.Single a6;
				checkType(l,6,out a6);
				System.Single a7;
				checkType(l,7,out a7);
				System.Boolean a8;
				checkType(l,8,out a8);
				var ret=DG.Tweening.ShortcutExtensionsPro.DOSpiral(a1,a2,a3,a4,a5,a6,a7,a8);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.Transform),typeof(float),typeof(System.Nullable<UnityEngine.Vector3>),typeof(DG.Tweening.SpiralMode),typeof(float),typeof(float),typeof(float),typeof(bool))){
				UnityEngine.Transform a1;
				checkType(l,1,out a1);
				System.Single a2;
				checkType(l,2,out a2);
				System.Nullable<UnityEngine.Vector3> a3;
				checkNullable(l,3,out a3);
				DG.Tweening.SpiralMode a4;
				checkEnum(l,4,out a4);
				System.Single a5;
				checkType(l,5,out a5);
				System.Single a6;
				checkType(l,6,out a6);
				System.Single a7;
				checkType(l,7,out a7);
				System.Boolean a8;
				checkType(l,8,out a8);
				var ret=DG.Tweening.ShortcutExtensionsPro.DOSpiral(a1,a2,a3,a4,a5,a6,a7,a8);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function DOSpiral to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.ShortcutExtensionsPro");
		addMember(l,DOSpiral_s);
		createTypeMetatable(l,null, typeof(DG.Tweening.ShortcutExtensionsPro));
	}
}
