using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_GameModeBase : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int BindLuaGameMode(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.BindLuaGameMode(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int RemoveLuaGameMode(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			self.RemoveLuaGameMode();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int FreeGameMode(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			self.FreeGameMode();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int EndGame(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.EndGame(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int PlayGame(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			self.PlayGame();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int PauseGame(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			self.PauseGame();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ResumeGame(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			self.ResumeGame();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_gameState(IntPtr l) {
		try {
			GameModeBase self=(GameModeBase)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.gameState);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_GameMode(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameModeBase.GameMode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"GameModeBase");
		addMember(l,BindLuaGameMode);
		addMember(l,RemoveLuaGameMode);
		addMember(l,FreeGameMode);
		addMember(l,EndGame);
		addMember(l,PlayGame);
		addMember(l,PauseGame);
		addMember(l,ResumeGame);
		addMember(l,"gameState",get_gameState,null,true);
		addMember(l,"GameMode",get_GameMode,null,false);
		createTypeMetatable(l,null, typeof(GameModeBase),typeof(UnityEngine.MonoBehaviour));
	}
}
