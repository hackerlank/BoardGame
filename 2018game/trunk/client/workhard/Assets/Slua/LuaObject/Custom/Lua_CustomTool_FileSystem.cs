using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_CustomTool_FileSystem : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			CustomTool.FileSystem o;
			o=new CustomTool.FileSystem();
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
	static public int CreatePath_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			CustomTool.FileSystem.CreatePath(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ClearPath_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			CustomTool.FileSystem.ClearPath(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ClearFilesSkipExtend_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			CustomTool.FileSystem.ClearFilesSkipExtend(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetStreamingPath_s(IntPtr l) {
		try {
			var ret=CustomTool.FileSystem.GetStreamingPath();
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
	static public int GetDataPath_s(IntPtr l) {
		try {
			var ret=CustomTool.FileSystem.GetDataPath();
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
	static public int FormatUrl_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=CustomTool.FileSystem.FormatUrl(a1);
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
	static public int FetchFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UnityEngine.Events.UnityAction<UnityEngine.WWW> a2;
			checkDelegate(l,2,out a2);
			var ret=CustomTool.FileSystem.FetchFile(a1,a2);
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
	static public int ReplaceFileBytes_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Byte[] a2;
			checkArray(l,2,out a2);
			CustomTool.FileSystem.ReplaceFileBytes(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ReplaceFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			CustomTool.FileSystem.ReplaceFile(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int CurrentPlatform_s(IntPtr l) {
		try {
			var ret=CustomTool.FileSystem.CurrentPlatform();
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
	static public int GetSubFiles_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=CustomTool.FileSystem.GetSubFiles(a1);
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
	static public int GetSubFolders_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=CustomTool.FileSystem.GetSubFolders(a1);
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
	static public int Exist_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=CustomTool.FileSystem.Exist(a1);
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
	static public int CopyFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=CustomTool.FileSystem.CopyFile(a1,a2);
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
	static public int get_directoryPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,CustomTool.FileSystem.directoryPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int set_directoryPath(IntPtr l) {
		try {
			string v;
			checkType(l,2,out v);
			CustomTool.FileSystem.directoryPath=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_bundleLocalPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,CustomTool.FileSystem.bundleLocalPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_screenshotPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,CustomTool.FileSystem.screenshotPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_logPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,CustomTool.FileSystem.logPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_headIconPath(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,CustomTool.FileSystem.headIconPath);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"CustomTool.FileSystem");
		addMember(l,CreatePath_s);
		addMember(l,ClearPath_s);
		addMember(l,ClearFilesSkipExtend_s);
		addMember(l,GetStreamingPath_s);
		addMember(l,GetDataPath_s);
		addMember(l,FormatUrl_s);
		addMember(l,FetchFile_s);
		addMember(l,ReplaceFileBytes_s);
		addMember(l,ReplaceFile_s);
		addMember(l,CurrentPlatform_s);
		addMember(l,GetSubFiles_s);
		addMember(l,GetSubFolders_s);
		addMember(l,Exist_s);
		addMember(l,CopyFile_s);
		addMember(l,"directoryPath",get_directoryPath,set_directoryPath,false);
		addMember(l,"bundleLocalPath",get_bundleLocalPath,null,false);
		addMember(l,"screenshotPath",get_screenshotPath,null,false);
		addMember(l,"logPath",get_logPath,null,false);
		addMember(l,"headIconPath",get_headIconPath,null,false);
		createTypeMetatable(l,constructor, typeof(CustomTool.FileSystem));
	}
}
