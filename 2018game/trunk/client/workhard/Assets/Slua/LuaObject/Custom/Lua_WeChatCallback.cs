using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_WeChatCallback : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			WeChatCallback o;
			o=new WeChatCallback();
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
	static public int get_onWeChatShare(IntPtr l) {
		try {
			WeChatCallback self=(WeChatCallback)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onWeChatShare);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onWeChatPay(IntPtr l) {
		try {
			WeChatCallback self=(WeChatCallback)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onWeChatPay);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onLoginWeChat(IntPtr l) {
		try {
			WeChatCallback self=(WeChatCallback)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onLoginWeChat);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_onGetUserInfoWeChat(IntPtr l) {
		try {
			WeChatCallback self=(WeChatCallback)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onGetUserInfoWeChat);
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
			pushValue(l,WeChatCallback.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"WeChatCallback");
		addMember(l,"onWeChatShare",get_onWeChatShare,null,true);
		addMember(l,"onWeChatPay",get_onWeChatPay,null,true);
		addMember(l,"onLoginWeChat",get_onLoginWeChat,null,true);
		addMember(l,"onGetUserInfoWeChat",get_onGetUserInfoWeChat,null,true);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,constructor, typeof(WeChatCallback));
	}
}
