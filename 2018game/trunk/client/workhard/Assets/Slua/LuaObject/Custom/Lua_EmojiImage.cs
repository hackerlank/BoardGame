using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_EmojiImage : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int UpdateEmoji(IntPtr l) {
		try {
			EmojiImage self=(EmojiImage)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Collections.Generic.List<System.Object> a3;
			checkType(l,4,out a3);
			self.UpdateEmoji(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"EmojiImage");
		addMember(l,UpdateEmoji);
		createTypeMetatable(l,null, typeof(EmojiImage),typeof(UnityEngine.UI.Image));
	}
}
