using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_Collider2DHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int AddTriggerEnterListener(IntPtr l) {
		try {
			Collider2DHelper self=(Collider2DHelper)checkSelf(l);
			UnityEngine.Events.UnityAction<UnityEngine.Collider2D> a1;
			checkDelegate(l,2,out a1);
			self.AddTriggerEnterListener(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Clear(IntPtr l) {
		try {
			Collider2DHelper self=(Collider2DHelper)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int OverlapCircleAll_s(IntPtr l) {
		try {
			UnityEngine.Vector2 a1;
			checkType(l,1,out a1);
			System.Single a2;
			checkType(l,2,out a2);
			var ret=Collider2DHelper.OverlapCircleAll(a1,a2);
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
		getTypeTable(l,"Collider2DHelper");
		addMember(l,AddTriggerEnterListener);
		addMember(l,Clear);
		addMember(l,OverlapCircleAll_s);
		createTypeMetatable(l,null, typeof(Collider2DHelper),typeof(UnityEngine.MonoBehaviour));
	}
}
