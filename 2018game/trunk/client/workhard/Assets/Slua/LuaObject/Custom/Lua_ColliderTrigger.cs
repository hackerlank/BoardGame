using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_ColliderTrigger : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int AddTriggerEnterListener(IntPtr l) {
		try {
			ColliderTrigger self=(ColliderTrigger)checkSelf(l);
			UnityEngine.Events.UnityAction<UnityEngine.Collider> a1;
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
	static public int AddTriggerStayListener(IntPtr l) {
		try {
			ColliderTrigger self=(ColliderTrigger)checkSelf(l);
			UnityEngine.Events.UnityAction<UnityEngine.Collider> a1;
			checkDelegate(l,2,out a1);
			self.AddTriggerStayListener(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int AddTriggerExitListener(IntPtr l) {
		try {
			ColliderTrigger self=(ColliderTrigger)checkSelf(l);
			UnityEngine.Events.UnityAction<UnityEngine.Collider> a1;
			checkDelegate(l,2,out a1);
			self.AddTriggerExitListener(a1);
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
			ColliderTrigger self=(ColliderTrigger)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"ColliderTrigger");
		addMember(l,AddTriggerEnterListener);
		addMember(l,AddTriggerStayListener);
		addMember(l,AddTriggerExitListener);
		addMember(l,Clear);
		createTypeMetatable(l,null, typeof(ColliderTrigger),typeof(UnityEngine.MonoBehaviour));
	}
}
