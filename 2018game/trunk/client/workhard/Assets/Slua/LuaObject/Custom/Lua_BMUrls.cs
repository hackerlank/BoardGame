using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_BMUrls : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			BMUrls o;
			o=new BMUrls();
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
	static public int GetInterpretedDownloadUrl(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			BuildPlatform a1;
			checkEnum(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			var ret=self.GetInterpretedDownloadUrl(a1,a2);
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
	static public int GetInterpretedOutputPath(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			BuildPlatform a1;
			checkEnum(l,2,out a1);
			var ret=self.GetInterpretedOutputPath(a1);
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
	static public int SerializeToString_s(IntPtr l) {
		try {
			BMUrls a1;
			checkType(l,1,out a1);
			var ret=BMUrls.SerializeToString(a1);
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
	static public int get_downloadUrls(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.downloadUrls);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_downloadUrls(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			System.Collections.Generic.Dictionary<System.String,System.String> v;
			checkType(l,2,out v);
			self.downloadUrls=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_outputs(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.outputs);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_outputs(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			System.Collections.Generic.Dictionary<System.String,System.String> v;
			checkType(l,2,out v);
			self.outputs=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_backupDownloadUrls(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.backupDownloadUrls);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_backupDownloadUrls(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			System.Collections.Generic.Dictionary<System.String,System.String> v;
			checkType(l,2,out v);
			self.backupDownloadUrls=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_bundleTarget(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.bundleTarget);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_bundleTarget(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			BuildPlatform v;
			checkEnum(l,2,out v);
			self.bundleTarget=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_useEditorTarget(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.useEditorTarget);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_useEditorTarget(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.useEditorTarget=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_downloadFromOutput(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.downloadFromOutput);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_downloadFromOutput(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.downloadFromOutput=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_offlineCache(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.offlineCache);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_offlineCache(IntPtr l) {
		try {
			BMUrls self=(BMUrls)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.offlineCache=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"BMUrls");
		addMember(l,GetInterpretedDownloadUrl);
		addMember(l,GetInterpretedOutputPath);
		addMember(l,SerializeToString_s);
		addMember(l,"downloadUrls",get_downloadUrls,set_downloadUrls,true);
		addMember(l,"outputs",get_outputs,set_outputs,true);
		addMember(l,"backupDownloadUrls",get_backupDownloadUrls,set_backupDownloadUrls,true);
		addMember(l,"bundleTarget",get_bundleTarget,set_bundleTarget,true);
		addMember(l,"useEditorTarget",get_useEditorTarget,set_useEditorTarget,true);
		addMember(l,"downloadFromOutput",get_downloadFromOutput,set_downloadFromOutput,true);
		addMember(l,"offlineCache",get_offlineCache,set_offlineCache,true);
		createTypeMetatable(l,constructor, typeof(BMUrls));
	}
}
