using UnityEngine;
using System.Collections;
using System.IO;
using UnityEditor;
using UnityEditor.Callbacks;
using System.Collections.Generic;

public enum EBuildType
{
    EBT_BundleApp = 0,         //构建bundle 并生成app
    EBT_Bundle = 1,            //构建增量更新bundle,不生成app
    EBT_BundleQuick = 2,       //快速构建增量更新bundle
}

public class FGameVersion
{
    public int platform = (int)BuildPlatform.Android;
    public string release_version = "1.1.0";
    public int build = 0;
    public string development_version = "1.1.0";
}


public class FBuildParam
{
    public string appPath = "";
    public string savePath = "";
    public EBuildType type = EBuildType.EBT_BundleApp;
    public BuildPlatform platform = BuildPlatform.IOS;
    public bool bDevelopment = true;
    public string bundleVersion = "1.1.0";
    public string displayName = "";
    public bool bUseLuajit = true;
    public bool bSkipCheckAPK = true;
    public int gameType = 10000;
    public bool bSkipUpdate = true;
    public bool bCompressedBundle = true;
    public bool bWithWeChat = true;

    public override string ToString()
    {
        return string.Format("appPath={0}, savePath={1}, type={2}, platform={3}, bDevelopment={4}, bundleVersion={5}, displayName={6},bUseLuajit={7}, bSkipCheckAPK={8}, gameType={9}, bCompressedBundle={10}", appPath, savePath, type, platform, bDevelopment, bundleVersion, displayName,bUseLuajit, bSkipCheckAPK,gameType, bCompressedBundle);
    }
}

public enum EBuildError
{
    EBE_InvalidParam=1024,   //无效参数
    EBE_NotSupport=1025,//不支持的平台
    EBE_MAX,            //未知错误
}

public class ProjectBuildHelper
{
    /// <summary>
    /// Get all scenes from build settings
    /// </summary>
    /// <returns></returns>
    public static string[] GetBuildScenes()
    {
        List<string> names = new List<string>();

        foreach (EditorBuildSettingsScene e in EditorBuildSettings.scenes)
        {
            if (e == null)
                continue;
            if (e.enabled)
                names.Add(e.path);
        }
        return names.ToArray();
    }

    /// <summary>
    /// Get build options
    /// </summary>
    /// <param name="bDevelopment"></param>
    /// <returns></returns>
    public static BuildOptions GetBuildOption(bool bDevelopment)
    {
        BuildOptions option = BuildOptions.None;
        if (bDevelopment)
        {
            Debug.Log("build development package");
            option = BuildOptions.Development | BuildOptions.AllowDebugging | BuildOptions.ConnectWithProfiler;
        }

        return option;
    }

    /// <summary>
    /// parse parameters
    /// </summary>
    /// <param name="args"></param>
    /// <returns>return the list object</returns>
    public static List<string> ParseParameters(string[] args)
    {
		 string tmpParam = "";
        string[] parameter = null;
        foreach (string arg in args)
        {

            if (arg.StartsWith("project") )
            {
                parameter = arg.Split("-"[0]);

                tmpParam = parameter[1];
       
                break;
            }
        }

        List<string> param = null;
        if (tmpParam != "")
        {
            //parameter = para.Split()
            parameter = tmpParam.Split(',');
            for(int idx=0; idx < parameter.Length; ++idx)
            {
                string leftPart = parameter[idx].Substring(0, parameter[idx].IndexOf(":"));
                string rightPart = parameter[idx].Substring(parameter[idx].IndexOf(":")+1, parameter[idx].Length - leftPart.Length - 1);
                rightPart = rightPart.Replace("\\", "/");

                bool bRegisterQuot = IsCanRegisterQuot(rightPart);
                if(idx == 0)
                {
                    leftPart = string.Format("{{\"{0}\"", leftPart);

                    if(bRegisterQuot)
                        rightPart = string.Format(":\"{0}\",", rightPart);
                    else
                        rightPart = string.Format(":{0},", rightPart);

                    tmpParam = string.Format("{0}{1}", leftPart, rightPart);
                }
                else if (idx == parameter.Length -1)
                {
                    leftPart = string.Format("\"{0}\"", leftPart);
                    if (bRegisterQuot)
                        rightPart = string.Format(":\"{0}\"}}", rightPart);
                    else
                        rightPart = string.Format(":{0}}}", rightPart);

                    tmpParam = string.Format("{0}{1}{2}", tmpParam, leftPart, rightPart);
                }
                else
                {
                    leftPart = string.Format("\"{0}\"", leftPart);
                    if (bRegisterQuot)
                        rightPart = string.Format(":\"{0}\",", rightPart);
                    else
                        rightPart = string.Format(":{0},", rightPart);

                    tmpParam = string.Format("{0}{1}{2}", tmpParam, leftPart, rightPart);
                }
				
				//Debug.Log("tmpParam=" +tmpParam );
            }
            param = new List<string>();
            param.Add(tmpParam);
        }

        if (param == null || (param != null && param.Count <= 0))
        {
            Debug.LogError("Invalid parameter.......");
            //EditorApplication.Exit(-2);
            param = new List<string>();
        }

        return param;
    }

    private static bool IsCanRegisterQuot(string rightPart)
    {
        if(rightPart.ToUpper().Equals("TRUE") || rightPart.ToUpper().Equals("FALSE"))
        {
            return false;
        }
        int value;
        bool bSucess = int.TryParse(rightPart, out value);

        if(bSucess)
        {
            return false;
        }


        return true;
    }

    /// <summary>
    /// register symbols
    /// </summary>
    /// <param name="bRawres"> whether we can define RAW_RES symbols</param>
    /// <param name="group"> build platform</param>
    /// <param name="bNoLog"> with log??</param>
    public static void RegisterSymbols(FBuildParam inParam)
    {
        if(inParam == null)
        {
            Debug.LogError("Failed to register game macro");
            return;
        }
        #region force compress bundle when cooking distribution app
        TextAsset ass = Resources.Load("DefinedMacro", typeof(TextAsset)) as TextAsset;
        DefinedMacro.FGameMacro _macro = new DefinedMacro.FGameMacro();
        _macro = LitJson.JsonMapper.ToObject<DefinedMacro.FGameMacro>(ass.text);
        _macro.bCompressedBundle = inParam.bCompressedBundle;
        _macro.bSkipUpdate = inParam.bSkipUpdate;
        _macro.bUseLuajit = inParam.bUseLuajit;
        _macro.bSkipCheckAPK = inParam.bSkipCheckAPK;
        _macro.bLogEnabled = inParam.bDevelopment;
        _macro.bUseBundle = true;
        _macro.bWithWeChat = inParam.bWithWeChat;
        string content = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(_macro));
        string file_path = "Assets/Resources/DefinedMacro" + GameHelper.SETTING_FILE_EXTENSION;
        Debug.Log("Macro:: " + content);
        CustomTool.FileSystem.ReplaceFile(file_path, content);
        UnityEditor.AssetDatabase.ImportAsset(file_path);
        UnityEditor.AssetDatabase.Refresh();
        #endregion
    }

    /// <summary>
    /// try to delete play maker editor object.
    /// </summary>
    public static void RemovePlayMakerGUI()
    {

        //int mLoop = UnityEditor.EditorBuildSettings.scenes.Length;
        //for (int idx = 0; idx < mLoop; ++idx)
        //{
        //    //ensure the launch map has been opened
        //    UnityEditor.SceneManagement.EditorSceneManager.OpenScene(UnityEditor.EditorBuildSettings.scenes[idx].path);
        //    GameObject[] gos = (GameObject[])GameObject.FindObjectsOfType(typeof(GameObject));
        //    foreach (GameObject go in gos)
        //    {

        //        PlayMakerGUI pmg = go.GetComponent<PlayMakerGUI>();
        //        if (pmg != null)
        //        {
        //            pmg.drawStateLabels = false;
        //            pmg.GUITextStateLabels = false;
        //            pmg.GUITextureStateLabels = false;
        //            pmg.filterLabelsWithDistance = false;
        //            Debug.Log("Removed PlayMakerGUI Game Object from " + UnityEditor.EditorBuildSettings.scenes[idx].path);
        //            //GameObject.DestroyImmediate(pmg.gameObject);
        //            break;
        //        }
        //    }

        //    UnityEditor.SceneManagement.EditorSceneManager.SaveOpenScenes();

        //}
    }

    //game version file 
    private static readonly string GAME_VERSION_PATH = "Assets/Content/Setting/Common/GameVersion.txt";
    /// <summary>
    /// read game version file
    /// </summary>
    /// <returns> Dictionary<BuildPlatform, FGameVersion> </returns>
    private static Dictionary<BuildPlatform, FGameVersion> ReadGameVersion()
    {
        Dictionary<BuildPlatform, FGameVersion> m_GameVersion = new Dictionary<BuildPlatform, FGameVersion>();
        if (File.Exists(GAME_VERSION_PATH))
        {
            string s = File.ReadAllText(GAME_VERSION_PATH);
            List<FGameVersion> objs = LitJson.JsonMapper.ToObject<List<FGameVersion>>(s);

            if (null != objs)
            {
                foreach (var obj in objs)
                {
                    m_GameVersion.Add((BuildPlatform)obj.platform, obj);
                }
            }

        }

        return m_GameVersion;
    }

    /// <summary>
    /// save game version file
    /// </summary>
    /// <param name="m_GameVersion"> game version object</param>
    private static void SaveGameVersion(Dictionary<BuildPlatform, FGameVersion> m_GameVersion)
    {
        if (m_GameVersion == null)
        {
            return;
        }
        List<FGameVersion> objs = new List<FGameVersion>();
        foreach(var obj in m_GameVersion)
        {
            objs.Add(obj.Value);
        }

        string content = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(objs));
        CustomTool.FileSystem.ReplaceFile(GAME_VERSION_PATH, content);

        UnityEditor.AssetDatabase.ImportAsset(GAME_VERSION_PATH);
    }

    public static int GetGameCookCount(BuildPlatform platform)
    {
        Dictionary<BuildPlatform, FGameVersion> m_GameVersion = ReadGameVersion();

        FGameVersion m_Version = null;
        if (m_GameVersion.ContainsKey(platform) == false)
        {
            m_Version = new FGameVersion();
            m_Version.build = 0;
            m_Version.release_version = "1.1.0";
            m_Version.development_version = "1.1.0";
            m_Version.platform = (int)platform;
            PlayerSettings.bundleVersion = m_Version.release_version;
            m_GameVersion.Add(platform, m_Version);
        }
        else
        {
            m_Version = m_GameVersion[platform];
        }

        return m_Version.build;
    }

    /// <summary>
    /// update game verison with pointed platform
    /// </summary>
    /// <param name="platform"></param>
    private static void UpdateGameVersion(BuildPlatform platform)
    {
        Dictionary<BuildPlatform, FGameVersion> m_GameVersion = ReadGameVersion();

        FGameVersion m_Version = null;
        if (m_GameVersion.ContainsKey(platform) == false)
        {
            m_Version = new FGameVersion();
            m_Version.build = 0;
            m_Version.release_version = "1.1.0";
            m_Version.development_version = "1.1.0";
            m_Version.platform = (int)platform;
            PlayerSettings.bundleVersion = m_Version.release_version;
            m_GameVersion.Add(platform, m_Version);
        }
        else
        {
            m_Version = m_GameVersion[platform];
        }

        bool bChanged = false;
        if (PlayerSettings.bundleVersion.Equals(m_Version.release_version) == false)
        {
            PlayerSettings.bundleVersion = m_Version.release_version;
            bChanged = true;
        }

        if (bChanged)
        {
            m_Version.build = -1;
        }
        m_Version.build++;

        string[] results = m_Version.release_version.Split('.');

        m_Version.development_version = string.Format("{0}.{1}.{2}", results[0], results[1], m_Version.build);
        if (platform == BuildPlatform.Android)
        {
            string bundle_version_code = string.Format("{0}{1}{2}", results[0], results[1], m_Version.build);
            PlayerSettings.Android.bundleVersionCode = int.Parse(bundle_version_code);


        }
        else
        {
            PlayerSettings.iOS.buildNumber = m_Version.release_version;
        }

        SaveGameVersion(m_GameVersion);
    }

    public static void ResetPlayerSettings(FBuildParam inParam)
    {
        if (inParam.platform == BuildPlatform.IOS)
        {
            #region overwrited optimization setting
            //these setting help us to build the minimum binary file
            PlayerSettings.strippingLevel = StrippingLevel.StripAssemblies;
            PlayerSettings.SetApiCompatibilityLevel(BuildTargetGroup.iOS, ApiCompatibilityLevel.NET_2_0_Subset);
            PlayerSettings.iOS.scriptCallOptimization = ScriptCallOptimizationLevel.SlowAndSafe;

            //force allow automatic rotate to portrait for trying to solve ITMS-90474
            PlayerSettings.allowedAutorotateToPortrait = true;
            PlayerSettings.allowedAutorotateToPortraitUpsideDown = true;
            PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;
            AssetDatabase.SaveAssets();

            PlayerSettings.bundleVersion = inParam.bundleVersion.ToString();
            PlayerSettings.iOS.buildNumber = inParam.bundleVersion.ToString();
            #endregion

            //support 64-bit machine. It can solve the link error when build the ios application.
            //This is the standard setting for ios platform. The most improvement way for link error is 
            //split the large module file or put sdk into the plugin directory. Because files will be 
            //push into new dll file. So it indicates that we can avoid link error with this way.
            PlayerSettings.SetScriptingBackend(BuildTargetGroup.iOS, ScriptingImplementation.IL2CPP);
            PlayerSettings.iOS.targetDevice = iOSTargetDevice.iPhoneAndiPad;
            UpdateGameVersion(inParam.platform);
        }
        else if (inParam.platform == BuildPlatform.Android)
        {
            #region overwrited optimization setting
            //these setting help us to build the minimum binary file
            PlayerSettings.strippingLevel = StrippingLevel.StripAssemblies;
            PlayerSettings.SetApiCompatibilityLevel(BuildTargetGroup.Android, ApiCompatibilityLevel.NET_2_0_Subset);
            PlayerSettings.allowedAutorotateToPortrait = false;
            PlayerSettings.allowedAutorotateToPortraitUpsideDown = false;
            PlayerSettings.Android.forceSDCardPermission = true;
            PlayerSettings.Android.forceInternetPermission = true;
            #endregion

            #region update build version
            PlayerSettings.bundleVersion = inParam.bundleVersion.ToString();

            UpdateGameVersion(inParam.platform);

            #endregion

          
        }
        else if(inParam.platform == BuildPlatform.Standalones)
        {
            #region overwrited optimization setting
            //these setting help us to build the minimum binary file
            PlayerSettings.strippingLevel = StrippingLevel.StripByteCode;
            PlayerSettings.SetApiCompatibilityLevel( BuildTargetGroup.Standalone, ApiCompatibilityLevel.NET_2_0_Subset);
            PlayerSettings.SetGraphicsAPIs(BuildTarget.StandaloneWindows, new UnityEngine.Rendering.GraphicsDeviceType[1] { UnityEngine.Rendering.GraphicsDeviceType.Direct3D9 });

            #endregion
        }
        else
        {
            Debug.LogError(string.Format("Currently do not support {0} platform", inParam.platform.ToString()));
            return;
        }

        PlayerSettings.productName = inParam.displayName;
        AssetDatabase.SaveAssets();
    }

    public static string GetSaveBundlePath(BuildTarget target, BuildPlatform platform)
    {
        string TARGET_NAME = "";
        if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android)
        {
            TARGET_NAME = "Android";
            target = BuildTarget.Android;
            platform = BuildPlatform.Android;
        }
        else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS)
        {
            platform = BuildPlatform.IOS;
            target = BuildTarget.iOS;
            TARGET_NAME = "IPhone";
        }
        else
        {
            platform = BuildPlatform.Standalones;
            target = BuildTarget.StandaloneWindows;
            TARGET_NAME = "Windows";
        }
        DirectoryInfo info = new DirectoryInfo(Application.dataPath);

        string project = Application.dataPath.Split('/')[1];

        string rootPath = info.Root.FullName;

        rootPath = rootPath.Replace("\\", "/");

        rootPath += "GameBundle_Develop";
        if (Directory.Exists(rootPath) == false)
        {
            Directory.CreateDirectory(rootPath);
        }

        rootPath += "/" + project;
        if (Directory.Exists(rootPath) == false)
        {
            Directory.CreateDirectory(rootPath);
        }

        if (TARGET_NAME != "")
        {
            rootPath += "/" + TARGET_NAME;
            if (Directory.Exists(rootPath) == false)
            {
                Directory.CreateDirectory(rootPath);
            }
        }

        rootPath += "/AssetBundle";
        if (Directory.Exists(rootPath) == false)
        {
            Directory.CreateDirectory(rootPath);
        }
        AssetDatabase.Refresh();

        return rootPath;
    }
}