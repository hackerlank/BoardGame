using UnityEngine;
using System.Collections;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.XCodeEditor;
#endif
using System.IO;

public static class XCodePostProcess
{

#if UNITY_EDITOR
	[PostProcessBuild(999)]
	public static void OnPostProcessBuild( BuildTarget target, string pathToBuiltProject )
	{
        if (target == BuildTarget.iOS)
        {
            PostBuildIPhone(pathToBuiltProject);
        }
        else if(target == BuildTarget.Android)
        {

        }

	}

    [MenuItem("CustomTool/Cook/test_build_plist")]
    public static void CookAndroid_Distributions()
    {
        PostBuildIPhone("F:/xcg_1.1.11");
    }
#endif

        public static void Log(string message)
	{
		UnityEngine.Debug.Log("PostProcess: "+message);
	}


    #region build for IPhone
    private static void EditPlist(string plist)
	{
		string bundleIdentifier = "com.xuanxi.games.xcg";


        Debug.Log("on post build project EidtPlist file");
		XCPlist list = new XCPlist (plist);
		list.OverrideBundleIdentifier (bundleIdentifier);

        Dictionary<string, object> dic = new Dictionary<string, object>();
        dic.Add("NSAllowsArbitraryLoads", true);

        list.AddPlistItem("NSAppTransportSecurity", dic);

        Dictionary<string, string> whiteList = new Dictionary<string, string>();
        whiteList.Add("item0", "weixin");
        whiteList.Add("item1", "ocgame");
        list.RegisterSinglePlistItem("LSApplicationQueriesSchemes", whiteList);
 
        list.RegisterSinglePlistItem("NSMicrophoneUsageDescription", "support replaykit");
        list.RegisterSinglePlistItem("NSCameraUsageDescription", "suppport replaykit");
		list.RegisterSinglePlistItem ("NSBluetoothPeripheralUsageDescription", "used by BETOP joystick");
        dic.Clear();

        //force full screen for solving:: ITMS-90474 iPad Multitasking support requires these orientations
       // list.RegisterSinglePlistItem("UIRequiresFullScreen", "yes");

        /**
         * try to solve ITMS-90339 this bundle is invalid.The info.plist contains 'CFBundleResourceSpecification' 
         * in app bundle with force remove CODE_SIGN_RESOURCE_RULES_PATH key
         */
        //list.RegisterSinglePlistItem("CFBundleResourceSpecification", "");
	}

    /// <summary>
    /// Post deal build iphone project
    /// </summary>
    /// <param name="pathToBuiltProject"> the project's path</param>
    private static void PostBuildIPhone(string pathToBuiltProject)
    {
        // Create a new project object from build target
        //if (Application.platform != RuntimePlatform.)
        //{
        //    Debug.Log("Run this in osx editor; platform=" + Application.platform);
        //    return;
        //}
        Debug.Log(pathToBuiltProject);
        XCProject project = new XCProject(pathToBuiltProject);

        //TODO implement generic settings as a module option

        // Find and run through all projmods files to patch the project.
        // Please pay attention that ALL projmods files in your project folder will be excuted!

        //should us search in all directory? 
        string[] files = Directory.GetFiles(Application.dataPath, "*.projmods", SearchOption.AllDirectories);

        foreach (string file in files)
        {
            UnityEngine.Debug.Log("ProjMod File: " + file);
            project.ApplyMod(file);
        }

        #region GCloudVoice_sdk
        //project.RegisterNewLib("libstdc++.6.0.9.tbd");
        ////project.RegisterNewLib("libGCloudVoice.a");
        //project.RegisterNewFramework("SystemConfiguration.framework");
        //project.RegisterNewFramework("CoreTelephony.framework");
        //project.RegisterNewFramework("AudioToolbox.framework");
        //project.RegisterNewFramework("CoreAudio.framework");
        //project.RegisterNewFramework("AVFoundation.framework");
        #endregion

        project.Consolidate();

        //register parameter for crasheye
        project.AddOtherLinkerFlags("-licucore");

        #region wechat dependency libraries
        project.RegisterNewLib("libz.tbd");
        project.RegisterNewLib("libc++.tbd");
        project.RegisterNewLib("libsqlite3.0.tbd");
       // project.RegisterNewLib("libiconv.2.tbd");
        project.RegisterNewFramework("SystemConfiguration.framework");
        project.RegisterNewFramework("Security.framework");
        project.RegisterNewFramework("CoreTelephony.framework");
        project.AddOtherLinkerFlags("-ObjC");
        project.AddOtherLinkerFlags("-all_load");
        #endregion

        //disable the bitcode
        project.Add_Other_Building_Flags("ENABLE_BITCODE", "NO");

        //project.overwriteBuildSetting("CODE_SIGN_RESOURCE_RULES_PATH", "", "Release");

        /**
         * try to solve ITMS-90339 this bundle is invalid.The info.plist contains 'CFBundleResourceSpecification' 
         * in app bundle with force remove CODE_SIGN_RESOURCE_RULES_PATH key
         */
        // project.Remove_Building_Flags("CODE_SIGN_RESOURCE_RULES_PATH");
        EditPlist(pathToBuiltProject + "/Info.plist");
        Debug.Log(pathToBuiltProject + "/Info.plist");
        //project.overwriteBuildSetting("CODE_SIGN_ENTITLEMENTS", pathToBuiltProject + "/Info.plist", "Release");

        // Finally save the xcode project
        project.Save();
    }
    #endregion
}
