using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
using LitJson;
using System.Diagnostics;
using System;
using System.Net.Sockets;

public enum EGameBundle
{
    EGB_Common=0,
    EGB_Fish = 1,
    EGB_Fish2d=2,
    EGB_NiuNiu=3,
    EGB_BlackJack=4,
    EGB_Baccarat=5, //百家乐
    EGB_ShuiHuZhuan=6,//slot
    EGB_ALL=7, //cook all
}

public class FGameBundles
{
    public int gameType;
    public string gameName;
    public List<string> bundles = new List<string>();
}

/// <summary>
/// 创建，删除，修改 bundle
/// </summary>
namespace CustomTool
{
    public class ManageBundleWindow : EditorWindow
    {
        //private static string PathOfConf = "Assets/BundleManager/Bundles.asset";
        private static readonly string PATH_OF_LUA = "Assets/Content/Scripts/Lua";
        private static BundleInfo Setting = null;

        private static int focusGame = (int)EGameBundle.EGB_Common;
        private static int SelPlatform = 0;
        private static int SelBundle = 0;
        private static Vector2 ScrollPos = Vector2.zero;
        private static Dictionary<string, string> RebuiltRelation = new Dictionary<string, string>();

        public static List<string> checkBundleBinary = new List<string>();
        public static Dictionary<string, string> backOldBundleBinary = new Dictionary<string, string>();

        private static Dictionary<EGameBundle, string> bundlesConfigs = new Dictionary<EGameBundle, string>();


        private static BundleInfo cookingSetting = null;

        private List<string> tipString = new List<string>();

        private static List<string> gameNames = new List<string>();

        public static BundleInfo GetCurrentCookingSetting()
        {
            return cookingSetting;
        }


        #region unity events
        void OnDisable()
        {
            //if ((EGameBundle)focusGame != EGameBundle.EGB_ALL)
            //{
            //    if (Setting != null)
            //    {
            //        EditorUtility.SetDirty(Setting);
            //        AssetDatabase.SaveAssets();
            //    }
            //}
        }

        public void OnGUI()
        {
            Color Backup = GUI.color;

            if (Setting != null)
            {

                List<string> Platforms = new List<string>();
                Platforms.AddRange(new string[] { "Android", "Standalones", "IOS" });

                List<string> BundleNames = new List<string>();
                foreach (var OneOf in Setting.ListOfBundles)
                    BundleNames.Add(OneOf.Name);

                if (tipString.Count == 0)
                {
                    tipString.Add("Platform: 当前支持的平台");
                    tipString.Add("Game(Common): Game表明当前配置为游戏bundle配置, Common表明是通用bundle配置");
                    tipString.Add("Amount: 当前配置含有的bundle数量");
                    tipString.Add("是否拷贝：是否需要拷贝到StreamingAsset目录");
                }

                GUILayout.BeginHorizontal();
                {
                    GUILayout.BeginVertical();
                    {
                        GUI.color = Color.cyan;
                        foreach (string str in tipString)
                        {
                            GUI.color = Color.white;
                            GUILayout.Label(str, BMGUIStyles.GetStyle("BoldLabel"));
                            //GUILayout.Space(2);
                        }
                    }
                    GUILayout.EndVertical();
                }
                GUILayout.EndHorizontal();

                GUILayout.Space(10);
                GUI.color = Color.white;
                GUILayout.BeginVertical();
                {
                    GUILayout.BeginHorizontal();
                    {
                        //platform
                        GUI.color = Color.white;
                        GUILayout.Label("Platform:", BMGUIStyles.GetStyle("BoldLabel"));
                        GUI.color = Color.cyan;
                        SelPlatform = EditorGUILayout.Popup(SelPlatform, Platforms.ToArray(), GUILayout.MaxWidth(80));
                        GUILayout.FlexibleSpace();

                        //cook for
                        GUI.color = Color.white;
                        GUILayout.Label("Game(Common):", BMGUIStyles.GetStyle("BoldLabel"));
                        GUI.color = Color.cyan;
                        int section = EditorGUILayout.Popup(focusGame, gameNames.ToArray(), GUILayout.MaxWidth(80));
                        if (section != focusGame)
                        {
                            focusGame = section;
                            UpdateFocusGame(focusGame);
                        }
                        GUILayout.FlexibleSpace();


                        //bundle amount
                        GUI.color = Color.white;
                        GUILayout.Label("Amount:", BMGUIStyles.GetStyle("BoldLabel"));
                        GUI.color = Color.cyan;
                        GUILayout.Label("" + Setting.ListOfBundles.Count + " 个", BMGUIStyles.GetStyle("BoldLabel"));
                        GUILayout.FlexibleSpace();

                        if ((EGameBundle)focusGame != EGameBundle.EGB_ALL)
                        {
                            GUI.color = Color.white;
                            GUILayout.Label("是否拷贝:", BMGUIStyles.GetStyle("BoldLabel"));
                            GUI.color = Color.cyan;
                            section = Setting.bToStreamingAsset == true ? 1 : 0;
                            int result = EditorGUILayout.Popup(section, new string[] { "false", "true" }, new GUILayoutOption[] { GUILayout.MaxWidth(100) });
                            bool bCopy = result == 0 ? false : true;
                            if (bCopy != Setting.bToStreamingAsset)
                            {
                                foreach (var obj in Setting.ListOfBundles)
                                {
                                    obj.bCopy = bCopy;
                                }

                                Setting.bToStreamingAsset = bCopy;
                            }
                            GUI.color = Color.white;
                        }
                    }
                    GUILayout.EndHorizontal();
                }

                GUILayout.Space(10);
                GUI.color = Color.white;
                ScrollPos = GUILayout.BeginScrollView(ScrollPos, new GUILayoutOption[] { GUILayout.ExpandHeight(true) });
                {
                    GUILayout.MinHeight(600);
                    GUILayout.BeginVertical(BMGUIStyles.GetStyle("Wizard Box"));
                    {
                        for (int Index = 0; Index < Setting.ListOfBundles.Count; ++Index)
                        {
                            BundleInfo.Element OneOf = Setting.ListOfBundles[Index];

                            if (SelBundle.Equals(OneOf.GetHashCode()))
                                GUI.color = Color.yellow;
                            else
                                GUI.color = new Color(2, 2, 2, 1);

                            GUILayout.BeginVertical("box");
                            {
                                GUILayout.BeginHorizontal();
                                GUILayout.Label("名    称 : ");
                                OneOf.Name = GUILayout.TextArea(OneOf.Name);
                                GUILayout.EndHorizontal();

                                GUILayout.BeginHorizontal();
                                GUILayout.Label("路    径 : ");
                                GUILayout.FlexibleSpace();
                                GUI.color = Color.yellow;
                                GUILayout.Label(OneOf.Path);
                                GUI.color = Color.white;
                                if (GUILayout.Button(BMGUIStyles.GetIcon("assetBundleIcon"), new GUILayoutOption[] { GUILayout.MaxWidth(16), GUILayout.MaxHeight(16) }))
                                {
                                    if (Selection.activeObject == null)
                                    {
                                        EditorUtility.DisplayDialog("提示", "请在Project视图中选择路径！", "OK");
                                    }
                                    else
                                    {
                                        OneOf.Path = AssetDatabase.GetAssetPath(Selection.activeObject).Replace("\\", "/");
                                    }
                                }
                                GUILayout.EndHorizontal();

                                GUILayout.BeginHorizontal();
                                GUILayout.Label("模    式 : ");
                                OneOf.Mode = (BundleInfo.BundleMode)EditorGUILayout.Popup((int)OneOf.Mode, new string[] { "Separate By SubFiles", "Separate By SubFolders", "All In One Package", "Single File", "Scene Bundle" }, new GUILayoutOption[] { GUILayout.MaxWidth(140) });
                                GUILayout.EndHorizontal();

                                GUILayout.BeginHorizontal();
                                GUILayout.Label("是否加密 :");
                                int section = 0;
                                if (OneOf.bEncrypt)
                                    section = 1;

                                int result = EditorGUILayout.Popup(section, new string[] { "false", "true" }, new GUILayoutOption[] { GUILayout.MaxWidth(140) });
                                OneOf.bEncrypt = result == 1;
                                GUILayout.EndHorizontal();
                            }

                            GUILayout.EndVertical();

                            bool IsRClicked = Event.current.type == EventType.MouseUp && GUILayoutUtility.GetLastRect().Contains(Event.current.mousePosition);
                            if (IsRClicked)
                            {
#if UNITY_EDITOR_OSX
							if((Event.current.button == 0 && Event.current.control == true)
							   || Event.current.button == 1)
								SelBundle = OneOf.GetHashCode();
#else
                                if (Event.current.button == 1)
                                    SelBundle = OneOf.GetHashCode();
#endif

                                Repaint();
                            }
                        }
                    }
                    GUILayout.EndVertical();
                }
                GUILayout.EndScrollView();
            }


            GUILayout.Space(5);
            GUI.color = Color.green;
            GUILayout.BeginHorizontal();
            {
                if (GUILayout.Button("保存配置")) SaveBundleCondfig();
                if (GUILayout.Button("新建")) Create();
                if (GUILayout.Button("删除")) Delete();
                if (GUILayout.Button("打包")) Publish();

                // if (GUILayout.Button("快速打包")) DoMakeBundle(BuildOutPath_, BuildTarget.Android);
                //if (GUILayout.Button("复制")) CopyResult();
                //if (GUILayout.Button("资源复制到res")) CopyRes();
            }
            GUILayout.EndHorizontal();
            GUILayout.Space(10);

            GUI.color = Backup;
        }

        /// <summary>
        /// save bundle assets
        /// </summary>
        private static void SaveBundleCondfig()
        {
            if ((EGameBundle)focusGame != EGameBundle.EGB_ALL)
            {
                if (Setting != null)
                {
                    foreach (var obj in Setting.ListOfBundles)
                    {
                        obj.bCopy = Setting.bToStreamingAsset;
                    }
                    EditorUtility.SetDirty(Setting);
                    AssetDatabase.SaveAssets();
                }
            }
            else
            {
                EditorUtility.DisplayDialog("Warning", "Can not save bundle configuration file in preview model(ALL)", "Cancel");
            }
        }

        /// <summary>
        /// update scroll view according to us selection
        /// </summary>
        /// <param name="section"></param>
        private static void UpdateFocusGame(int section)
        {
            string pathOfBun = "";
            EGameBundle game = (EGameBundle)section;
            if (game == EGameBundle.EGB_ALL)
            {
                Setting = ScriptableObject.CreateInstance<BundleInfo>();
                foreach (var obj in bundlesConfigs)
                {
                    LoadBundles(obj.Value, true);
                }
            }
            else
            {
                Setting = null;
                pathOfBun = bundlesConfigs[game];
                LoadBundles(pathOfBun, false);
            }
        }

        /// <summary>
        /// load bundles that need to be rendered
        /// </summary>
        /// <param name="path"></param>
        /// <param name="bShowALL"></param>
        private static void LoadBundles(string path, bool bShowALL)
        {
            if (string.IsNullOrEmpty(path))
            {
                return;
            }

            BundleInfo info = AssetDatabase.LoadAssetAtPath(path, typeof(BundleInfo)) as BundleInfo;

            if (info == null)
            {
                return;
            }

            if (bShowALL)
            {
                Setting.ListOfBundles.AddRange(info.ListOfBundles);
            }
            else
            {
                Setting = info;
                if (Setting.gameType != focusGame)
                {
                    string chars = "_";
                    string name = ((EGameBundle)focusGame).ToString().Split(chars.ToCharArray())[1];
                    Setting.gameType = focusGame;
                    foreach (var obj in info.ListOfBundles)
                    {
                        obj.gameName = name;
                    }

                    SaveBundleCondfig();
                }

            }
        }

        #endregion

        #region bundles


        /// <summary>
        /// 新建一组Bundle的配置
        /// </summary>
        public static void Create()
        {
            EGameBundle tmp = (EGameBundle)focusGame;
            if (tmp != EGameBundle.EGB_ALL)
            {
                BundleInfo.Element OneOf = new BundleInfo.Element();
                OneOf.Name = "Bundle_" + Time.realtimeSinceStartup;
                //OneOf.Parent = OneOf.Name;
                OneOf.Path = "";
                OneOf.Mode = BundleInfo.BundleMode.AllInOne;
                OneOf.bCopy = Setting.bToStreamingAsset;

                string str = tmp.ToString();
                string chars = "_";
                OneOf.gameName = str.Split(chars.ToCharArray())[1];
                Setting.ListOfBundles.Add(OneOf);
                SelBundle = 0;
            }
            else
            {
                EditorUtility.DisplayDialog("Warning", "Can not create a bundle in preview model(ALL)", "Cancel");
            }
        }

        /// <summary>
        /// whehter need to be copy to streaming asset
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static bool isToStreamingAsset(string fileName)
        {
            if (bForceCopy)
            {
                return true;
            }
            string name_without_extension = GameHelper.GetFileNameWithoutExtension(fileName);

            if (cookingSetting != null)
            {
                foreach (var obj in cookingSetting.ListOfBundles)
                {
                    if (name_without_extension.Equals(obj.Name))
                    {
                        return obj.bCopy;
                    }
                }
            }

            if (name_without_extension.Equals("bm"))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 从当前Bundle组集合中删除一组Bundle的配置
        /// </summary>
        public static void Delete()
        {
            if ((EGameBundle)focusGame != EGameBundle.EGB_ALL)
            {
                foreach (var OneOf in Setting.ListOfBundles)
                {
                    if (OneOf.GetHashCode() == SelBundle)
                    {
                        Setting.ListOfBundles.Remove(OneOf);
                        break;
                    }
                }
            }
            else
            {
                EditorUtility.DisplayDialog("Warning", "Can not delete a bundle in preview model(ALL)", "Cancel");
            }
        }

        /// <summary>
        /// 应用当前Bundle配置打包生成所有的Bundle
        /// </summary>
        public static void Publish(bool bQuick = false)
        {
            BuildTarget target = BuildTarget.Android;
            BuildPlatform platform = BuildPlatform.Android;
            string rootPath = ProjectBuildHelper.GetSaveBundlePath(target, platform);
            //build lua scripts
            DefinedMacro.FGameMacro macro = null;
            TextAsset ass = Resources.Load("DefinedMacro", typeof(TextAsset)) as TextAsset;
            if (ass != null)
                macro = LitJson.JsonMapper.ToObject<DefinedMacro.FGameMacro>(ass.text);

            bool bUseLuajit = false;
            bool bCompressedBundle = true;
            if (macro != null)
            {
                bUseLuajit = macro.bUseLuajit;
                bCompressedBundle = macro.bCompressedBundle;
            }
            UpdateLuaScripts(bUseLuajit);

            //if we have one update server. skip this
            string url = rootPath + "/Compressed";
            ResetUrls(url, platform);

            UpdateBundleManager();

            string outpath = rootPath + "/tmp";
            if (Directory.Exists(outpath))
            {
                Directory.Delete(outpath, true);
            }
            Directory.CreateDirectory(outpath);

            AssetDatabase.Refresh();


            UnityEngine.Debug.Log("Build bundle for " + platform.ToString());
            DoMakeBundle(outpath, target);

            MakeBMFile(outpath);

            string[] AllBundles = AssetDatabase.GetAllAssetBundleNames();
            string tmp = outpath.Substring(0, outpath.LastIndexOf("/")) + "/Bundle_Latest";
            if (Directory.Exists(tmp))
            {
                if (bCompressedBundle)
                    BackupLuaBundleFile(tmp);
            }
            else
            {
                Directory.CreateDirectory(tmp);
            }

            foreach (var Bundle in AllBundles)
            {

                string BundlePath = tmp + "/" + Bundle;
                if (!Directory.Exists(Path.GetDirectoryName(BundlePath)))
                    FileSystem.CreatePath(Path.GetDirectoryName(BundlePath));
                if (File.Exists(outpath + "/" + Bundle))
                    FileUtil.ReplaceFile(outpath + "/" + Bundle, BundlePath);
                else
                {
                    UnityEngine.Debug.LogError("Failed cooking bundle:: " + Bundle);
                }
            }


            if (bCompressedBundle)
            {
                SimpleLZMA.CompressFiles(outpath, true, false);
            }
            else
            {
                SimpleLZMA.CompressFile(outpath, true);
            }



            checkBundleBinary.Clear();
            backOldBundleBinary.Clear();
            cookingSetting = null;

            if (File.Exists("Assets/Resources/GameBundle.txt"))
            {
                File.Delete("Assets/Resources/GameBundle.txt");
            }

            //create game config
            UpdateGameBundlesConfig(rootPath);
            EditorUtility.DisplayDialog("提示", "打包工作已完成，请检测输出已确定成功打包！", "确定");
        }

        /// <summary>
        /// update game bundles configuration file
        /// </summary>
        /// <param name="rootPath"></param>
        private static void UpdateGameBundlesConfig(string rootPath)
        {
            List<string> needBuild = new List<string>();

            foreach (var obj in bundlesConfigs)
            {
                if (obj.Key != EGameBundle.EGB_ALL)
                    needBuild.Add(obj.Value);
            }

            List<FGameBundles> gameConfig = new List<FGameBundles>();
            foreach (string path in needBuild)
            {
                BundleInfo tmpSetting = AssetDatabase.LoadAssetAtPath(path, typeof(BundleInfo)) as BundleInfo;

                if (tmpSetting != null)
                {
                    FGameBundles tmpConfig = new FGameBundles();
                    tmpConfig.gameType = tmpSetting.gameType;
                    string fileName = GameHelper.GetFileNameWithoutExtension(path);
                    string chars = "_";
                    string name = fileName.Split(chars.ToCharArray())[1];
                    tmpConfig.gameName = name;
                    foreach (var bundle in tmpSetting.ListOfBundles)
                    {
                        tmpConfig.bundles.Add(bundle.Name + ".u");
                    }
                    gameConfig.Add(tmpConfig);
                }


            }

            if (focusGame == (int)EGameBundle.EGB_ALL)
            {
                string content = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(gameConfig));
                CustomTool.FileSystem.ReplaceFile("Assets/Resources/GameBundle.txt", content);
            }
            else
            {
                string content = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(gameConfig));
                CustomTool.FileSystem.ReplaceFile(rootPath + "/Compressed/GameBundle.txt", content);
            }
        }

        /// <summary>
        /// collect all bundles which will be cooked
        /// </summary>
        private static void CollectNeedBuildBundles()
        {
            EGameBundle game = (EGameBundle)focusGame;
            List<string> needBuild = new List<string>();
            if (game == EGameBundle.EGB_ALL)
            {
                foreach (var obj in bundlesConfigs)
                {
                    if (obj.Key != EGameBundle.EGB_ALL)
                    {
                        needBuild.Add(obj.Value);
                    }
                }
            }
            else
            {
                needBuild.Add(bundlesConfigs[EGameBundle.EGB_Common]);
                if (game != EGameBundle.EGB_Common)
                    needBuild.Add(bundlesConfigs[game]);
            }

            //build bundle
            cookingSetting = ScriptableObject.CreateInstance<BundleInfo>();

            int idx = 0;
            foreach (string path in needBuild)
            {
                BundleInfo tmpSetting = AssetDatabase.LoadAssetAtPath(path, typeof(BundleInfo)) as BundleInfo;
                if (tmpSetting != null)
                {
                    if (idx > 0)
                    {
                        BundleInfo.Element info = null;
                        for (int i = 0; i < tmpSetting.ListOfBundles.Count; ++i)
                        {
                            info = tmpSetting.ListOfBundles[i];
                            foreach (var obj in cookingSetting.ListOfBundles)
                            {
                                if (obj.Name.Equals(info.Name))
                                {
                                    info = null;
                                    UnityEngine.Debug.LogWarning("has contains " + obj.Name);
                                    break;
                                }
                            }

                            if (info != null)
                            {
                                cookingSetting.ListOfBundles.Add(info);
                            }
                        }
                    }
                    else
                    {
                        cookingSetting.ListOfBundles.AddRange(tmpSetting.ListOfBundles);
                    }
                }

                idx++;
            }
        }

        /// <summary>
        /// backup lua bundles
        /// </summary>
        /// <param name="outpath"></param>
        private static void BackupLuaBundleFile(string outpath)
        {
            checkBundleBinary.Clear();
            if (cookingSetting != null)
            {
                foreach (var obj in cookingSetting.ListOfBundles)
                {
                    string title = obj.Name.ToLower();
                    if (title.StartsWith("lua_"))
                    {
                        checkBundleBinary.Add(obj.Name + ".u");
                    }
                }
            }

            backOldBundleBinary.Clear();

            string desPath = outpath.Substring(0, outpath.LastIndexOf("/"));
            foreach (var str in checkBundleBinary)
            {
                string fromFile = string.Format("{0}/{1}", outpath, str);
                if (File.Exists(fromFile))
                {
                    string name = str.Split('.')[0] + "_old.u";
                    string toFile = string.Format("{0}/{1}", desPath, name);

                    backOldBundleBinary.Add(str, name);
                    File.Copy(fromFile, toFile, true);
                }
            }

            if (File.Exists(outpath + "/bm.data"))
            {
                File.Copy(outpath + "/bm.data", desPath + "/bm_old.data", true);
            }
        }

        /// <summary>
        /// set update urls
        /// </summary>
        /// <param name="url"></param>
        /// <param name="platform"></param>
        private static void ResetUrls(string url, BuildPlatform platform)
        {
            if (url == null || url == "")
            {
                return;
            }

            TextAsset downloadUrlText = (TextAsset)Resources.Load("Urls");
            BMUrls _bmUrl = JsonMapper.ToObject<BMUrls>(downloadUrlText.text);
            if (_bmUrl == null)
                return;

            if (platform == BuildPlatform.Android || platform == BuildPlatform.IOS || platform == BuildPlatform.Standalones)
            {
                _bmUrl.downloadUrls[platform.ToString()] = url;
                _bmUrl.backupDownloadUrls[platform.ToString()] = url;
                _bmUrl.bundleTarget = platform;
                string content = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(_bmUrl));
                string file_path = "Assets/BundleManager/Resources/Urls" + GameHelper.SETTING_FILE_EXTENSION;
                CustomTool.FileSystem.ReplaceFile(file_path, content);
                UnityEditor.AssetDatabase.ImportAsset(file_path);
            }

        }



        /// <summary>
        /// build bundles
        /// </summary>
        /// <param name="param"></param>
        public static void BuildBundles(FBuildParam param)
        {

            string finalSavePath = "";
            finalSavePath = param.savePath;
            //always cooking all bundles
            //if((EGameType) param.gameType == EGameType.EGT_MAX)
            //{
            focusGame = (int)EGameBundle.EGB_ALL;
            //}
            //else
            //{
            //    focusGame = param.gameType;
            //}
            UpdateLuaScripts(false);
            //if we have one update server. skip this
            string url = param.savePath + "/Compressed";
            ResetUrls(url, param.platform);

            //load bundle asset path
            LoadBundleAssetPath();
            UnityEngine.Debug.Log("finalSavePath=" + finalSavePath);

            if (!Directory.Exists(finalSavePath))
            {
                Directory.CreateDirectory(finalSavePath);
            }
            string Folder = finalSavePath + "/tmp";

            string outputPath = Folder;
            if (Directory.Exists(outputPath))
            {
                foreach (string file in Directory.GetFiles(outputPath))
                {
                    File.Delete(file);
                    UnityEngine.Debug.Log("Remove " + file);
                }
            }
            UnityEngine.Debug.Log("outputPath=" + outputPath);

            AssetDatabase.Refresh();


            if (param.type != EBuildType.EBT_BundleQuick)
            {
                UpdateBundleManager();
            }

            //ensure output directory is exist
            if (!Directory.Exists(outputPath))
            {
                Directory.CreateDirectory(outputPath);
            }

            DoMakeBundle(outputPath, EditorUserBuildSettings.activeBuildTarget);

            //fresh asset data base 
            AssetDatabase.Refresh();

            //remove unused asset bundle 
            AssetDatabase.RemoveUnusedAssetBundleNames();

            //build bundle manager bundle file
            MakeBMFile(outputPath);

            string[] AllBundles = AssetDatabase.GetAllAssetBundleNames();

            string original_path = finalSavePath + "/Bundle_Basic";
            if (param.type == EBuildType.EBT_Bundle || param.type == EBuildType.EBT_BundleApp)
            {
                if (Directory.Exists(original_path))
                {
                    FileUtil.DeleteFileOrDirectory(original_path);

                }

                finalSavePath = original_path;
            }
            else
            {
                finalSavePath += "/Bundle_Latest";
            }
            UnityEngine.Debug.Log("finalSavePath=" + finalSavePath);

            //ensure path is exist
            if (Directory.Exists(finalSavePath) == false)
                Directory.CreateDirectory(finalSavePath);

            //quick means dlc?
            if (param.type == EBuildType.EBT_BundleQuick)
            {
                BackupLuaBundleFile(finalSavePath);
            }

            foreach (var Bundle in AllBundles)
            {
                string BundlePath = finalSavePath + "/" + Bundle;
                if (!Directory.Exists(Path.GetDirectoryName(BundlePath)))
                    FileSystem.CreatePath(Path.GetDirectoryName(BundlePath));

                if (File.Exists(Folder + "/" + Bundle))
                    FileUtil.ReplaceFile(Folder + "/" + Bundle, BundlePath);
                else
                {
                    UnityEngine.Debug.LogError("Failed cooking bundle:: " + Bundle);
                }
            }
            UnityEngine.Debug.Log("Now compressing bundle:: parameter is :: " + param.ToString());


            //copy bm.data
            if (File.Exists(Folder + "/bm.data"))
            {
                FileUtil.ReplaceFile(Folder + "/bm.data", finalSavePath + "/bm.data");
            }
            if (param.bCompressedBundle)
            {

                //now compress bundle files;
                if (param.type == EBuildType.EBT_Bundle || param.type == EBuildType.EBT_BundleQuick || param.type == EBuildType.EBT_BundleApp)
                {
                    UnityEngine.Debug.Log("Compressing dlc bundle");
                    bool bCopy = false;
                    if (param.type == EBuildType.EBT_BundleApp)
                    {
                        bCopy = true;
                    }

                    //开始压缩
                    if (param.type == EBuildType.EBT_BundleQuick)
                    {
                        SimpleLZMA.CompressFiles(finalSavePath, bCopy, true);
                    }
                    else
                    {
                        SimpleLZMA.CompressFiles(finalSavePath, bCopy);
                    }

                    //now delete the lateset files;
                    // Directory.Delete(finalSavePath, true);
                }
            }
            else
            {
                SimpleLZMA.CompressFile(finalSavePath, true);
            }

            backOldBundleBinary.Clear();
            checkBundleBinary.Clear();
            cookingSetting = null;

            UpdateGameBundlesConfig(param.savePath + "/Compressed");
            AssetDatabase.Refresh();

        }

        /// <summary>
        /// 将Lua/*.lua文件复制为LuaGen/*.lua.txt文件.
        /// </summary>
        private static void UpdateLuaScripts(bool bLuajit = true)
        {
            bool bSuccess = true;

            if (Directory.Exists(PATH_OF_LUA + "Gen"))
                FileSystem.ClearPath(PATH_OF_LUA + "Gen", false);
            else
                FileSystem.CreatePath(PATH_OF_LUA + "Gen");

            AssetDatabase.Refresh();

            if (bLuajit)
            {
                string tool_path = "";
                string ROOT_PATH = Application.dataPath;

                ROOT_PATH = ROOT_PATH.Replace("\\", "/");
                ROOT_PATH = ROOT_PATH.Substring(0, ROOT_PATH.LastIndexOf("/") + 1);


                tool_path = ROOT_PATH + "Tools/buildLua.bat";


                string full_path_lua = string.Format("{0}{1}/", ROOT_PATH, PATH_OF_LUA);
                Process proc;

                try
                {
                    proc = new Process();
                    proc.StartInfo.FileName = tool_path;
                    proc.StartInfo.Arguments = string.Format("{0} {1} {2} {3}", PATH_OF_LUA, full_path_lua.Length, ROOT_PATH, bLuajit.ToString().ToLower());//this is argument
                    proc.StartInfo.CreateNoWindow = false;
                    proc.Start();
                    proc.WaitForExit();
                }
                catch (Exception ex)
                {
                    bSuccess = false;
                    Console.WriteLine("Exception Occurred :{0},{1}", ex.Message, ex.StackTrace.ToString());
                }

                AssetDatabase.Refresh();
                AssetDatabase.SaveAssets();

                if (!bSuccess)
                {
                    //failed to build lua scripts, exit now and force set jenkins build flag as unstable
                    EditorApplication.Exit(1);
                }

            }
            else
            {

                List<string> subFiles = new List<string>();
                subFiles = CustomTool.FileSystem.GetSubFiles(PATH_OF_LUA);
                string from_set = PATH_OF_LUA;
                string to_set = PATH_OF_LUA + "Gen";
                foreach (var file in subFiles)
                {

                    // if (file.Contains("sproto"))
                    {
                        string BundlePath = to_set + "/" + file + GameHelper.LUA_FILENAME_EXTENSION;
                        if (!Directory.Exists(Path.GetDirectoryName(BundlePath)))
                            FileSystem.CreatePath(Path.GetDirectoryName(BundlePath));
                        if (File.Exists(from_set + "/" + file))
                            FileUtil.ReplaceFile(from_set + "/" + file, BundlePath);
                        else
                        {
                            // UnityEngine.Debug.LogError("Failed cooking bundle:: " + file);
                        }
                    }
                }
            }



            AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
        }

        /// <summary>
        /// 生成BundleManager的Bundle配置
        /// </summary>
        private static void UpdateBundleManager()
        {
            clearallflag();
            CollectNeedBuildBundles();

            AssetDatabase.Refresh();
            RebuiltRelation.Clear();

            float PreProgress = cookingSetting.ListOfBundles.Count > 0 ? 1.0f / cookingSetting.ListOfBundles.Count : 1.0f;
            float CurProgress = 0;

            List<BundleInfo.Element> AllToBuild = new List<BundleInfo.Element>();
            bool BuildSelection = false;

            foreach (var OneOf in cookingSetting.ListOfBundles)
            {
                if (OneOf.GetHashCode() == SelBundle)
                {
                    AllToBuild.Add(OneOf);
                    BuildSelection = true;
                    break;
                }
            }

            if (!BuildSelection) AllToBuild = cookingSetting.ListOfBundles;

            foreach (var OneOf in AllToBuild)
            {
                if (OneOf.Mode == BundleInfo.BundleMode.AllInOne)
                {
                    List<string> Files = FileSystem.GetSubFiles(OneOf.Path);
                    for (int Index = 0; Index < Files.Count; ++Index)
                        Files[Index] = OneOf.Path + "/" + Files[Index];

                    CurProgress += PreProgress;
                    if (Files.Count <= 0) continue;

                    EditorUtility.DisplayProgressBar("生成BundleManager配置", "处理配置 : " + OneOf.Name + " of " + OneOf.gameName, CurProgress);
                    string fullname = OneOf.Path + "/" + OneOf.Name;

                    SetSingleAssetBundleName(OneOf.Path, OneOf.Name, "u");
                    UnityEngine.Debug.Log(fullname + "..........." + fullname.Replace('/', '_'));
                }
                else if (OneOf.Mode == BundleInfo.BundleMode.SeparateSubFile)
                {
                    List<string> Files = FileSystem.GetSubFiles(OneOf.Path);
                    float Step = Files.Count > 0 ? PreProgress / (1.0f * Files.Count) : 1.0f;
                    foreach (var OneOfFile in Files)
                    {
                        CurProgress += Step;
                        string tmpfile = OneOfFile.Replace("/", "_");
                        string BundleName = OneOf.Name + "_" + tmpfile;
                        EditorUtility.DisplayProgressBar("生成BundleManager配置", "处理配置 : " + BundleName + " of " + OneOf.gameName, CurProgress);
                        string fullname = OneOf.Path + "/" + OneOfFile;
                        SetSingleAssetBundleName(fullname, fullname.Replace('/', '_'), "u");
                        UnityEngine.Debug.Log(fullname + "............" + fullname.Replace('/', '_'));
                    }
                }
                else if (OneOf.Mode == BundleInfo.BundleMode.SeparateSubFolder)
                {
                    List<string> Folders = FileSystem.GetSubFolders(OneOf.Path);
                    float Step = Folders.Count > 0 ? PreProgress / (1.0f * Folders.Count) : 1.0f;
                    foreach (var OneOfFolder in Folders)
                    {
                        List<string> Files = FileSystem.GetSubFiles(OneOf.Path + "/" + OneOfFolder);
                        for (int Index = 0; Index < Files.Count; ++Index)
                            Files[Index] = OneOf.Path + "/" + OneOfFolder + "/" + Files[Index];

                        CurProgress += Step;
                        if (Files.Count <= 0) continue;

                        string BundleName = OneOf.Name + "_" + OneOfFolder;
                        EditorUtility.DisplayProgressBar("生成BundleManager配置", "处理配置 : " + BundleName + " of " + OneOf.gameName, CurProgress);

                        string fullname = OneOf.Path + "/" + OneOfFolder;
                        SetSingleAssetBundleName(fullname, fullname.Replace('/', '_'), "u");
                        UnityEngine.Debug.Log(fullname + "......." + fullname.Replace('/', '_'));
                    }

                    if (!Directory.Exists(OneOf.Path))
                        continue;
                }
                else if (OneOf.Mode == BundleInfo.BundleMode.SingleFile)
                {
                    List<string> Files = new List<string>();
                    Files.Add(OneOf.Path);


                    CurProgress += PreProgress;
                    if (Files.Count <= 0) continue;

                    EditorUtility.DisplayProgressBar("生成BundleManager配置", "处理配置 : " + OneOf.Name + " of " + OneOf.gameName, CurProgress);
                    string fullname = OneOf.Path + "......." + OneOf.Name;
                    SetSingleAssetBundleName(fullname, fullname.Replace('/', '_'), "u");
                    UnityEngine.Debug.Log(fullname + "......." + fullname.Replace('/', '_'));
                }
                else if (OneOf.Mode == BundleInfo.BundleMode.SceneBundle)
                {
                    List<string> Files = new List<string>();
                    Files.Add(OneOf.Path);


                    CurProgress += PreProgress;
                    if (Files.Count <= 0) continue;

                    EditorUtility.DisplayProgressBar("生成BundleManager配置", "处理配置 : " + OneOf.Name + " of " + OneOf.gameName, CurProgress);

                    // string fullname = OneOf.Path;
                    SetSingleAssetBundleName(OneOf.Path, OneOf.Name, "u");
                }
            }
            EditorUtility.ClearProgressBar();
        }

        /// <summary>
        /// set bundlen name when this mode is signle mode
        /// </summary>
        /// <param name="path"></param>
        /// <param name="assetBundleName"></param>
        /// <param name="variant"></param>
        private static void SetSingleAssetBundleName(string path, string assetBundleName, string variant)
        {
            AssetImporter assetImporter = AssetImporter.GetAtPath(path);

            assetImporter.assetBundleName = assetBundleName;
            if (assetImporter.assetBundleVariant != variant)
                assetImporter.assetBundleVariant = variant;
        }

        /// <summary>
        /// actually build bundles
        /// </summary>
        /// <param name="BuildOutPath_"></param>
        /// <param name="BuildTarget_"></param>
        private static void DoMakeBundle(string BuildOutPath_, BuildTarget BuildTarget_)
        {
            BuildPipeline.BuildAssetBundles(BuildOutPath_, BuildAssetBundleOptions.UncompressedAssetBundle, BuildTarget_);
        }

        /// <summary>
        /// Build bundle manager file(bm.data)
        /// </summary>
        /// <param name="manifestpath"></param>
        public static void MakeBMFile(string manifestpath)
        {
            List<BundleSmallData> AllBundleData = new List<BundleSmallData>();

            //特殊处理：如果没有打任何包
            if (!File.Exists(manifestpath + "/tmp.manifest"))
            {

            }
            else
            {
                string bundlebasepath = manifestpath;


                AssetBundle bundlemanifest = AssetBundle.LoadFromFile(manifestpath + "/tmp");
                AssetBundleManifest ABM = bundlemanifest.LoadAsset<AssetBundleManifest>("AssetBundleManifest");

                bundlemanifest.Unload(false);

                AssetDatabase.RemoveUnusedAssetBundleNames();

                string[] AllBundles = AssetDatabase.GetAllAssetBundleNames();

                foreach (var bundle in AllBundles)
                {
                    if (bundle == "BM.data" || bundle == "bm.data")
                        continue;

                    BundleSmallData newData = new BundleSmallData();

                    newData.name = bundle;
                    foreach (var asp in AssetDatabase.GetAssetPathsFromAssetBundle(bundle))
                    {
                        newData.includs.Add(asp);

                    }

                    foreach (var parents in ABM.GetAllDependencies(bundle))
                    {
                        newData.parents.Add(parents);
                    }
                    newData.bundleHashCode = ABM.GetAssetBundleHash(bundle).ToString();


                    //读取文件大小
                    if (File.Exists(bundlebasepath + "/" + bundle))
                    {
                        FileInfo tmpfi = new FileInfo(bundlebasepath + "/" + bundle);
                        newData.size = tmpfi.Length;
                    }
                    else
                    {
                        UnityEngine.Debug.LogError("Can not find " + bundlebasepath + "/" + bundle);
                    }

                    AllBundleData.Add(newData);
                }
            }

            //写成txt
            string targetpath = manifestpath + "/bm.data";

            string writestr = JsonFormatter.PrettyPrint(JsonMapper.ToJson(AllBundleData));
            FileSystem.ReplaceFile(targetpath, writestr);

            AssetDatabase.Refresh();
        }

        /// <summary>
        /// load bundle configuration files
        /// </summary>
        private static void LoadBundleAssetPath()
        {
            gameNames.Clear();
            gameNames.AddRange(new string[] { "Common", "Fish", "Fish2d", "NiuNiu", "BlackJack", "Baccarat", "ShuiHuZhuan", "ALL" });

            bundlesConfigs.Clear();
            bundlesConfigs.Add(EGameBundle.EGB_Common, "Assets/BundleManager/Bundles_Common.asset");
            //bundlesConfigs.Add(EGameBundle.EGB_Fish, "Assets/BundleManager/Bundles_Fish.asset");
            //bundlesConfigs.Add(EGameBundle.EGB_Fish2d, "Assets/BundleManager/Bundles_Fish2d.asset");
            //bundlesConfigs.Add(EGameBundle.EGB_NiuNiu, "Assets/BundleManager/Bundles_NiuNiu.asset");
            //bundlesConfigs.Add(EGameBundle.EGB_BlackJack, "Assets/BundleManager/Bundles_BlackJack.asset");
            //bundlesConfigs.Add(EGameBundle.EGB_Baccarat, "Assets/BundleManager/Bundles_Baccarat.asset");
            //bundlesConfigs.Add(EGameBundle.EGB_ShuiHuZhuan, "Assets/BundleManager/Bundles_ShuiHuZhuan.asset");
            bundlesConfigs.Add(EGameBundle.EGB_ALL, "Assets/BundleManager/");
        }


        #endregion

        #region editor tools

        /// <summary>
        /// clear asset flag
        /// </summary>
        [MenuItem("CustomTool/Bundle/清空asset flag")]
        public static void clearallflag()
        {
            AssetDatabase.RemoveUnusedAssetBundleNames();

            foreach (var tmp in AssetDatabase.GetAllAssetBundleNames())
            {
                AssetDatabase.RemoveAssetBundleName(tmp, true);
            }
        }

        [MenuItem("CustomTool/Bundle/CompileLua")]
        public static void CompileLua()
        {
            UpdateLuaScripts(false);
        }

        /// <summary>
        /// open manage bundle window
        /// </summary>
        [MenuItem("CustomTool/Bundle/ManageBundle")]
        public static void OpenManageBundleWin()
        {
            if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android)
                SelPlatform = 0;
            else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS)
                SelPlatform = 2;
            else
                SelPlatform = 1;

            LoadBundleAssetPath();

            focusGame = (int)EGameBundle.EGB_Common;
            LoadBundles(bundlesConfigs[EGameBundle.EGB_Common], false);

            GetWindow<ManageBundleWindow>(true, "打包配置器", true);
        }

        /// <summary>
        /// clear player prefs
        /// </summary>
        [MenuItem("CustomTool/ClearPlayerPrefs")]
        public static void ClearPlayerPrefs()
        {
            PlayerPrefs.DeleteAll();
        }

        /// <summary>
        /// cook all bundles.
        /// </summary>
        private static bool bForceCopy = false;
        [MenuItem("CustomTool/Bundle/CookAllBundles(ForceAllToStreamingAsset)")]
        private static void CookAllBundles_FoceCopy ()
        {
            if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android)
                SelPlatform = 0;
            else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS)
                SelPlatform = 2;
            else
                SelPlatform = 1;

            LoadBundleAssetPath();
            focusGame = (int)EGameBundle.EGB_ALL;
            bForceCopy = true;
            Publish();
        }

        [MenuItem("CustomTool/Bundle/CookAllBundles(OnlyConfiguration)")]
        public static void CookAllBundles()
        {
            if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android)
                SelPlatform = 0;
            else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS)
                SelPlatform = 2;
            else
                SelPlatform = 1;

            LoadBundleAssetPath();
            focusGame = (int)EGameBundle.EGB_ALL;
            bForceCopy = false;
            Publish();
        }

        #endregion
    }

}