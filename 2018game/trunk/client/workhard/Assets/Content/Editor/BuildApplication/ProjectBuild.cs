using UnityEngine;
using System.Collections;
using System.IO;
using UnityEditor;
using UnityEditor.Callbacks;
using System.Collections.Generic;
using LitJson;



public class ProjectBuild
{
    static void CreateApplication()
    {
       
        List<string> parameters = ProjectBuildHelper.ParseParameters(System.Environment.GetCommandLineArgs());

        if (parameters.Count <= 0)
        {
            Debug.LogError("Invalid parameters");
            EditorApplication.Exit((int)EBuildError.EBE_InvalidParam);
            return;
        };

        FBuildParam param = JsonMapper.ToObject<FBuildParam>(parameters[0]);

        _CreateApplication(param);
    }


    private static void _CreateApplication(FBuildParam param)
    {
        if (param == null)
        {
            Debug.LogError(string.Format("Invalid parameters:: "));
            EditorApplication.Exit((int)EBuildError.EBE_InvalidParam);
            return;
        }

        if (param.platform != BuildPlatform.Android && param.platform != BuildPlatform.IOS && param.platform != BuildPlatform.Standalones)
        {
            Debug.LogError(string.Format("Currently not support {0} platform", param.platform.ToString()));
            EditorApplication.Exit((int)EBuildError.EBE_NotSupport);
            return;
        }

        //reset player setting
        ProjectBuildHelper.ResetPlayerSettings(param);


        Debug.LogWarning("Constructor param is:: " + param.ToString());

        CustomTool.ManageBundleWindow.BuildBundles(param);


        if (param.type == EBuildType.EBT_BundleApp)
        {
            //delete play maker editor object in game scenes
           // ProjectBuildHelper.RemovePlayMakerGUI();


            //build xcode project
            if (param.platform == BuildPlatform.IOS)
            {
                ProjectBuildHelper.RegisterSymbols(param);
                string app_path = param.appPath;
                string lp = app_path;// app_path.Substring(0, app_path.LastIndexOf("."));

                string sub_bundle_version = PlayerSettings.bundleVersion.Substring(0, PlayerSettings.bundleVersion.LastIndexOf("."));

                param.appPath = string.Format("{0}_{1}.{2}", lp, sub_bundle_version, ProjectBuildHelper.GetGameCookCount(param.platform));

                BuildPipeline.BuildPlayer(ProjectBuildHelper.GetBuildScenes(), param.appPath, BuildTarget.iOS, ProjectBuildHelper.GetBuildOption(param.bDevelopment));
            }
            else if (param.platform == BuildPlatform.Android)
            {
                PlayerSettings.keyaliasPass = "w8yx.net";
                PlayerSettings.keystorePass = "w8yx.net";
                ProjectBuildHelper.RegisterSymbols(param);
                //now reset app name 
                string app_path = param.appPath;
                string lp = app_path.Substring(0, app_path.LastIndexOf("."));

                string sub_bundle_version = PlayerSettings.bundleVersion.Substring(0, PlayerSettings.bundleVersion.LastIndexOf("."));

                param.appPath = string.Format("{0}_{1}.{2}.apk", lp, sub_bundle_version, ProjectBuildHelper.GetGameCookCount(param.platform));
                
  
                BuildPipeline.BuildPlayer(ProjectBuildHelper.GetBuildScenes(), param.appPath, BuildTarget.Android, ProjectBuildHelper.GetBuildOption(param.bDevelopment));
            }
            else if (param.platform == BuildPlatform.Standalones)
            {
                ProjectBuildHelper.RegisterSymbols(param);
                BuildPipeline.BuildPlayer(ProjectBuildHelper.GetBuildScenes(), param.appPath, BuildTarget.StandaloneWindows64, ProjectBuildHelper.GetBuildOption(param.bDevelopment));
            }
            else
            {
                Debug.LogError(string.Format("Currently do not support {0} platform", param.platform.ToString()));
            }

        }
    }

    //cook android. if you want to build distribution version. so 
    //try to set param.bDevelopment = false
    [MenuItem("CustomTool/Cook/Cook Android Development")]
    public static void CookAndroid()
    {
        BuildTarget target = BuildTarget.Android;
        BuildPlatform platform = BuildPlatform.Android;

        //construct build param 
        FBuildParam param = new FBuildParam();
        param.bundleVersion = "1.1.0";
        DirectoryInfo info = new DirectoryInfo(Application.dataPath);

        string root = info.Root.FullName;
        param.displayName = Application.productName;
        root = string.Format("{0}/{1}/Android", root, param.displayName);
        if(Directory.Exists(root) == false)
        {
            Directory.CreateDirectory(root);
        }

        //only save 10 apks. delete old 
        List<string> files = CustomTool.FileSystem.GetSubFiles(root);
        List<FileInfo> infos = new List<FileInfo>();
        if(files.Count > 9)
        {
            foreach (string file in files)
            {
                FileInfo file_info = new FileInfo(root + "/" + file);
                if(file_info != null)
                {
                    infos.Add(file_info);
                }
            }

            while(infos.Count > 9)
            {
                long create_time = infos[0].CreationTime.Ticks;
                int idx = 0;
                for(int i=1; i < infos.Count; ++i)
                {
                    if(create_time > infos[i].CreationTime.Ticks)
                    {
                        create_time = infos[i].CreationTime.Ticks;
                        idx = i;
                    }
                }
                Debug.LogWarning("delete " + infos[idx].FullName);
                File.Delete(infos[idx].FullName);
                infos.RemoveAt(idx);
            }

        }


        param.appPath = string.Format("{0}/{1}.apk", root, Application.productName);
        if (File.Exists(param.appPath))
        {
            File.Delete(param.appPath);
        }
        param.platform = BuildPlatform.Android;
        param.savePath = ProjectBuildHelper.GetSaveBundlePath(target, platform);
        param.bCompressedBundle = false;
        param.bDevelopment = true;
        param.bSkipCheckAPK = true;
        param.bUseLuajit = false;
        param.gameType = (int)EGameType.EGT_MAX;
        param.bSkipUpdate = true;
        param.bWithWeChat = true;
        param.type = EBuildType.EBT_BundleApp;

        ProjectBuild._CreateApplication(param);

    }

    //cook android. if you want to build distribution version. so 
    //try to set param.bDevelopment = false
    [MenuItem("CustomTool/Cook/Cook Android Distribution")]
    public static void CookAndroid_Distribution()
    {
        BuildTarget target = BuildTarget.Android;
        BuildPlatform platform = BuildPlatform.Android;

        //construct build param 
        FBuildParam param = new FBuildParam();
        param.bundleVersion = "1.1.0";
        DirectoryInfo info = new DirectoryInfo(Application.dataPath);

        string root = info.Root.FullName;
        param.displayName = Application.productName;
        root = string.Format("{0}/{1}/Android", root, param.displayName);
        if (Directory.Exists(root) == false)
        {
            Directory.CreateDirectory(root);
        }

        //only save 10 apks. delete old 
        List<string> files = CustomTool.FileSystem.GetSubFiles(root);
        List<FileInfo> infos = new List<FileInfo>();
        if (files.Count > 9)
        {
            foreach (string file in files)
            {
                FileInfo file_info = new FileInfo(root + "/" + file);
                if (file_info != null)
                {
                    infos.Add(file_info);
                }
            }

            while (infos.Count > 9)
            {
                long create_time = infos[0].CreationTime.Ticks;
                int idx = 0;
                for (int i = 1; i < infos.Count; ++i)
                {
                    if (create_time > infos[i].CreationTime.Ticks)
                    {
                        create_time = infos[i].CreationTime.Ticks;
                        idx = i;
                    }
                }
                Debug.LogWarning("delete " + infos[idx].FullName);
                File.Delete(infos[idx].FullName);
                infos.RemoveAt(idx);
            }

        }


        param.appPath = string.Format("{0}/{1}.apk", root, Application.productName);
        if (File.Exists(param.appPath))
        {
            File.Delete(param.appPath);
        }
        param.platform = BuildPlatform.Android;
        param.savePath = ProjectBuildHelper.GetSaveBundlePath(target, platform);
        param.bCompressedBundle = false;
        param.bDevelopment = false;
        param.bSkipCheckAPK = true;
        param.bUseLuajit = false;
        param.gameType = (int)EGameType.EGT_MAX;
        param.bSkipUpdate = true;
        param.bWithWeChat = true;
        param.type = EBuildType.EBT_BundleApp;

        ProjectBuild._CreateApplication(param);

    }

    //cook android. if you want to build distribution version. so 
    //try to set param.bDevelopment = false
    [MenuItem("CustomTool/Cook/Cook IPhone Distribution")]
    public static void CookIPhone_Distribution()
    {
        BuildTarget target = BuildTarget.iOS;
        BuildPlatform platform = BuildPlatform.IOS;

        //construct build param 
        FBuildParam param = new FBuildParam();
        param.bundleVersion = "1.1.0";
        DirectoryInfo info = new DirectoryInfo(Application.dataPath);

        string root = info.Root.FullName;
        param.displayName = Application.productName;
        root = string.Format("{0}/{1}/IPhone", root, param.displayName);
        if (Directory.Exists(root) == false)
        {
            Directory.CreateDirectory(root);
        }

        //only save 10 apks. delete old 
        List<string> files = CustomTool.FileSystem.GetSubFiles(root);
        List<FileInfo> infos = new List<FileInfo>();
        if (files.Count > 9)
        {
            foreach (string file in files)
            {
                FileInfo file_info = new FileInfo(root + "/" + file);
                if (file_info != null)
                {
                    infos.Add(file_info);
                }
            }

            while (infos.Count > 9)
            {
                long create_time = infos[0].CreationTime.Ticks;
                int idx = 0;
                for (int i = 1; i < infos.Count; ++i)
                {
                    if (create_time > infos[i].CreationTime.Ticks)
                    {
                        create_time = infos[i].CreationTime.Ticks;
                        idx = i;
                    }
                }
                Debug.LogWarning("delete " + infos[idx].FullName);
                File.Delete(infos[idx].FullName);
                infos.RemoveAt(idx);
            }

        }


        param.appPath = string.Format("{0}/{1}", root, Application.productName);
        if (File.Exists(param.appPath))
        {
            File.Delete(param.appPath);
        }
        param.platform = BuildPlatform.IOS;
        param.savePath = ProjectBuildHelper.GetSaveBundlePath(target, platform);
        param.bCompressedBundle = false;
        param.bDevelopment = true;
        param.bSkipCheckAPK = true;
        param.bUseLuajit = false;
        param.gameType = (int)EGameType.EGT_MAX;
        param.bSkipUpdate = true;
        param.bWithWeChat = true;
        param.type = EBuildType.EBT_BundleApp;

        ProjectBuild._CreateApplication(param);

    }
}
