using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_GameManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int BindGameManager(IntPtr l) {
		try {
			GameManager self=(GameManager)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			self.BindGameManager(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SwitchLevel(IntPtr l) {
		try {
			GameManager self=(GameManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			UnityEngine.SceneManagement.LoadSceneMode a3;
			checkEnum(l,4,out a3);
			self.SwitchLevel(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int UnloadLevel(IntPtr l) {
		try {
			GameManager self=(GameManager)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.UnloadLevel(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onAsyncLoadLevel(IntPtr l) {
		try {
			GameManager self=(GameManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onAsyncLoadLevel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_Instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameManager.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_defaultGameType(IntPtr l) {
		try {
			GameManager self=(GameManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.defaultGameType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isCanBind(IntPtr l) {
		try {
			GameManager self=(GameManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isCanBind);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_currentScene(IntPtr l) {
		try {
			GameManager self=(GameManager)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.currentScene);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"GameManager");
		addMember(l,BindGameManager);
		addMember(l,SwitchLevel);
		addMember(l,UnloadLevel);
		addMember(l,"onAsyncLoadLevel",get_onAsyncLoadLevel,null,true);
		addMember(l,"Instance",get_Instance,null,false);
		addMember(l,"defaultGameType",get_defaultGameType,null,true);
		addMember(l,"isCanBind",get_isCanBind,null,true);
		addMember(l,"currentScene",get_currentScene,null,true);
		createTypeMetatable(l,null, typeof(GameManager),typeof(UnityEngine.MonoBehaviour));
	}
}
