using System;
using SLua;
using System.Collections.Generic;
[UnityEngine.Scripting.Preserve]
public class Lua_GameHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int constructor(IntPtr l) {
		try {
			GameHelper o;
			o=new GameHelper();
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
	static public int ReadFileFromDatabase_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=GameHelper.ReadFileFromDatabase(a1);
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
	static public int ReadFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=GameHelper.ReadFile(a1);
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
	static public int WriteFile_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Byte[] a2;
			checkArray(l,2,out a2);
			GameHelper.WriteFile(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetBundleBuildStates_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			List<BundleSmallData> a2;
			GameHelper.GetBundleBuildStates(a1,out a2);
			pushValue(l,true);
			pushValue(l,a2);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int SaveUpdateState_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Collections.Generic.List<BundleSmallData> a2;
			checkType(l,2,out a2);
			GameHelper.SaveUpdateState(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GC_s(IntPtr l) {
		try {
			GameHelper.GC();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int Decompress_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UnityEngine.WWW a2;
			checkType(l,2,out a2);
			GameHelper.Decompress(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int LoadScript_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Byte[] a2;
			GameHelper.LoadScript(a1,out a2);
			pushValue(l,true);
			pushValue(l,a2);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int DoBuffer_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkArray(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=GameHelper.DoBuffer(a1,a2);
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
	static public int RunScript_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=GameHelper.RunScript(a1,a2);
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
	static public int GetFileName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=GameHelper.GetFileName(a1);
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
	static public int LastIndexOf_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=GameHelper.LastIndexOf(a1,a2);
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
	static public int Decrypt_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.String a3;
			checkType(l,3,out a3);
			var ret=GameHelper.Decrypt(a1,a2,a3);
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
	static public int GetFileNameWithoutExtension_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=GameHelper.GetFileNameWithoutExtension(a1);
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
	static public int LoadTextAsset_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UnityEngine.AssetBundle a2;
			checkType(l,2,out a2);
			var ret=GameHelper.LoadTextAsset(a1,a2);
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
	static public int LoadSprite_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			UnityEngine.AssetBundle a2;
			checkType(l,2,out a2);
			var ret=GameHelper.LoadSprite(a1,a2);
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
	static public int LoadAsset_Editor_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			GameHelper.EAssetType a2;
			checkEnum(l,2,out a2);
			var ret=GameHelper.LoadAsset_Editor(a1,a2);
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
	static public int ImportAsset_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			GameHelper.ImportAsset(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int GetAssetType_s(IntPtr l) {
		try {
			GameHelper.EAssetType a1;
			checkEnum(l,1,out a1);
			var ret=GameHelper.GetAssetType(a1);
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
	static public int EndsWith_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=GameHelper.EndsWith(a1,a2);
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
	static public int StopEditorPlayer_s(IntPtr l) {
		try {
			GameHelper.StopEditorPlayer();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int CalculateTextSize_s(IntPtr l) {
		try {
			UnityEngine.UI.Text a1;
			checkType(l,1,out a1);
			var ret=GameHelper.CalculateTextSize(a1);
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
	static public int Bitand_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			var ret=GameHelper.Bitand(a1,a2);
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
	static public int Bitshift_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			System.Boolean a3;
			checkType(l,3,out a3);
			var ret=GameHelper.Bitshift(a1,a2,a3);
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
	static public int Bitor_s(IntPtr l) {
		try {
			System.Int32 a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			var ret=GameHelper.Bitor(a1,a2);
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
	static public int GetString_s(IntPtr l) {
		try {
			System.Byte[] a1;
			checkArray(l,1,out a1);
			var ret=GameHelper.GetString(a1);
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
	static public int IsHited_s(IntPtr l) {
		try {
			UnityEngine.BoxCollider2D a1;
			checkType(l,1,out a1);
			UnityEngine.BoxCollider2D a2;
			checkType(l,2,out a2);
			System.Single a3;
			System.Single a4;
			System.Single a5;
			var ret=GameHelper.IsHited(a1,a2,out a3,out a4,out a5);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a3);
			pushValue(l,a4);
			pushValue(l,a5);
			return 5;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int ScreenCapture_s(IntPtr l) {
		try {
			UnityEngine.Camera a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			checkType(l,2,out a2);
			System.Int32 a3;
			checkType(l,3,out a3);
			System.Int32 a4;
			checkType(l,4,out a4);
			System.Int32 a5;
			checkType(l,5,out a5);
			System.String a6;
			checkType(l,6,out a6);
			GameHelper.ScreenCapture(a1,a2,a3,a4,a5,a6);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_LUA_FILENAME_EXTENSION(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.LUA_FILENAME_EXTENSION);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_SETTING_FILE_EXTENSION(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.SETTING_FILE_EXTENSION);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_BUNDLE_FILENAME_EXTENSION(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.BUNDLE_FILENAME_EXTENSION);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isEditor(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isEditor);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isWithBundle(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isWithBundle);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isWithLuajit(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isWithLuajit);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isWithSkipCheckAPK(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isWithSkipCheckAPK);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isSkipUpdate(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isSkipUpdate);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isDistribution(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isDistribution);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isLogEnabled(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isLogEnabled);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isCompressedBundle(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isCompressedBundle);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_isWithWeChat(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.isWithWeChat);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_runtimePlatform(IntPtr l) {
		try {
			pushValue(l,true);
			pushEnum(l,(int)GameHelper.runtimePlatform);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_batteryLevel(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.batteryLevel);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	[UnityEngine.Scripting.Preserve]
	static public int get_osTime(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,GameHelper.osTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[UnityEngine.Scripting.Preserve]
	static public void reg(IntPtr l) {
		getTypeTable(l,"GameHelper");
		addMember(l,ReadFileFromDatabase_s);
		addMember(l,ReadFile_s);
		addMember(l,WriteFile_s);
		addMember(l,GetBundleBuildStates_s);
		addMember(l,SaveUpdateState_s);
		addMember(l,GC_s);
		addMember(l,Decompress_s);
		addMember(l,LoadScript_s);
		addMember(l,DoBuffer_s);
		addMember(l,RunScript_s);
		addMember(l,GetFileName_s);
		addMember(l,LastIndexOf_s);
		addMember(l,Decrypt_s);
		addMember(l,GetFileNameWithoutExtension_s);
		addMember(l,LoadTextAsset_s);
		addMember(l,LoadSprite_s);
		addMember(l,LoadAsset_Editor_s);
		addMember(l,ImportAsset_s);
		addMember(l,GetAssetType_s);
		addMember(l,EndsWith_s);
		addMember(l,StopEditorPlayer_s);
		addMember(l,CalculateTextSize_s);
		addMember(l,Bitand_s);
		addMember(l,Bitshift_s);
		addMember(l,Bitor_s);
		addMember(l,GetString_s);
		addMember(l,IsHited_s);
		addMember(l,ScreenCapture_s);
		addMember(l,"LUA_FILENAME_EXTENSION",get_LUA_FILENAME_EXTENSION,null,false);
		addMember(l,"SETTING_FILE_EXTENSION",get_SETTING_FILE_EXTENSION,null,false);
		addMember(l,"BUNDLE_FILENAME_EXTENSION",get_BUNDLE_FILENAME_EXTENSION,null,false);
		addMember(l,"isEditor",get_isEditor,null,false);
		addMember(l,"isWithBundle",get_isWithBundle,null,false);
		addMember(l,"isWithLuajit",get_isWithLuajit,null,false);
		addMember(l,"isWithSkipCheckAPK",get_isWithSkipCheckAPK,null,false);
		addMember(l,"isSkipUpdate",get_isSkipUpdate,null,false);
		addMember(l,"isDistribution",get_isDistribution,null,false);
		addMember(l,"isLogEnabled",get_isLogEnabled,null,false);
		addMember(l,"isCompressedBundle",get_isCompressedBundle,null,false);
		addMember(l,"isWithWeChat",get_isWithWeChat,null,false);
		addMember(l,"runtimePlatform",get_runtimePlatform,null,false);
		addMember(l,"batteryLevel",get_batteryLevel,null,false);
		addMember(l,"osTime",get_osTime,null,false);
		createTypeMetatable(l,constructor, typeof(GameHelper));
	}
}
