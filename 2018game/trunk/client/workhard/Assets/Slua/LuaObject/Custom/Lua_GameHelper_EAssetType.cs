using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_GameHelper_EAssetType : LuaObject {
	static public void reg(IntPtr l) {
		getEnumTable(l,"GameHelper.EAssetType");
		addMember(l,1,"EAT_Texture");
		addMember(l,2,"EAT_Sprite");
		addMember(l,3,"EAT_UI");
		addMember(l,4,"EAT_GameObject");
		addMember(l,5,"EAT_AudioClip");
		addMember(l,6,"EAT_TextAsset");
		addMember(l,7,"EAT_SpriteAsset");
		addMember(l,8,"EAT_MAX");
		LuaDLL.lua_pop(l, 1);
	}
}
