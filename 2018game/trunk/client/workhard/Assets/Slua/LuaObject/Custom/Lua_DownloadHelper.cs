using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_DownloadHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			DownloadHelper o;
			o=new DownloadHelper();
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
	static public int FormatUrl(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.FormatUrl(a1);
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
	static public int UseBackupDownloadUrls(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			self.UseBackupDownloadUrls();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int isAbsoluteUrl(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.isAbsoluteUrl(a1);
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
	static public int InterpretPath(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			BuildPlatform a2;
			checkEnum(l,3,out a2);
			var ret=self.InterpretPath(a1,a2);
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
	static public int IsBundleUrl(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			var ret=self.IsBundleUrl(a1,a2);
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
	static public int StripBundleSuffix(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.StripBundleSuffix(a1);
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
	static public int OnDestroy_s(IntPtr l) {
		try {
			DownloadHelper.OnDestroy();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_bmUrl(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.bmUrl);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_downloadRootUrl(IntPtr l) {
		try {
			DownloadHelper self=(DownloadHelper)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.downloadRootUrl);
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
			pushValue(l,DownloadHelper.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"DownloadHelper");
		addMember(l,FormatUrl);
		addMember(l,UseBackupDownloadUrls);
		addMember(l,isAbsoluteUrl);
		addMember(l,InterpretPath);
		addMember(l,IsBundleUrl);
		addMember(l,StripBundleSuffix);
		addMember(l,OnDestroy_s);
		addMember(l,"bmUrl",get_bmUrl,null,true);
		addMember(l,"downloadRootUrl",get_downloadRootUrl,null,true);
		addMember(l,"Instance",get_Instance,null,false);
		createTypeMetatable(l,constructor, typeof(DownloadHelper));
	}
}
