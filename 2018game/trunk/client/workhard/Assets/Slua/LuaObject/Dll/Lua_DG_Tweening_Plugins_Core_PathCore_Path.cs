using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DG_Tweening_Plugins_Core_PathCore_Path : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DG.Tweening.Plugins.Core.PathCore.Path o;
			DG.Tweening.PathType a1;
			checkEnum(l,2,out a1);
			UnityEngine.Vector3[] a2;
			checkArray(l,3,out a2);
			System.Int32 a3;
			checkType(l,4,out a3);
			System.Nullable<UnityEngine.Color> a4;
			checkNullable(l,5,out a4);
			o=new DG.Tweening.Plugins.Core.PathCore.Path(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_wpLengths(IntPtr l) {
		try {
			DG.Tweening.Plugins.Core.PathCore.Path self=(DG.Tweening.Plugins.Core.PathCore.Path)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.wpLengths);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_wpLengths(IntPtr l) {
		try {
			DG.Tweening.Plugins.Core.PathCore.Path self=(DG.Tweening.Plugins.Core.PathCore.Path)checkSelf(l);
			System.Single[] v;
			checkArray(l,2,out v);
			self.wpLengths=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DG.Tweening.Plugins.Core.PathCore.Path");
		addMember(l,"wpLengths",get_wpLengths,set_wpLengths,true);
		createTypeMetatable(l,constructor, typeof(DG.Tweening.Plugins.Core.PathCore.Path));
	}
}
