using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_SpriteAsset : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			SpriteAsset o;
			o=new SpriteAsset();
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
	static public int get_ID(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_ID(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.ID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get__IsStatic(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self._IsStatic);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set__IsStatic(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self._IsStatic=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_texSource(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.texSource);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_texSource(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			UnityEngine.Texture v;
			checkType(l,2,out v);
			self.texSource=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_listSpriteGroup(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.listSpriteGroup);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_listSpriteGroup(IntPtr l) {
		try {
			SpriteAsset self=(SpriteAsset)checkSelf(l);
			System.Collections.Generic.List<SpriteInforGroup> v;
			checkType(l,2,out v);
			self.listSpriteGroup=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"SpriteAsset");
		addMember(l,"ID",get_ID,set_ID,true);
		addMember(l,"_IsStatic",get__IsStatic,set__IsStatic,true);
		addMember(l,"texSource",get_texSource,set_texSource,true);
		addMember(l,"listSpriteGroup",get_listSpriteGroup,set_listSpriteGroup,true);
		createTypeMetatable(l,constructor, typeof(SpriteAsset),typeof(UnityEngine.ScriptableObject));
	}
}
