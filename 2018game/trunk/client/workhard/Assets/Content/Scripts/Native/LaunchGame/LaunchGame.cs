using UnityEngine;
using System.Collections.Generic;
using System.Collections;
using System.IO;
using SLua;

[SLua.CustomLuaClass]
public class LaunchGame : MonoBehaviour
{
    #region property
    [SLua.DoNotToLua]
    private static LaunchGame GInstance = null;

    [SLua.DoNotToLua]
    private LuaSvr GScripter = null;

    /// <summary>
    /// the lua script which needs to be executed when the first map has been loaded
    /// </summary>
    [SLua.DoNotToLua]
    [SerializeField]
    private string LAUNCH_GAME_LUA_SCRIPT = "";

    public static string WECHAT_JAVA_PACKAGE = "";
    public static readonly string GAME_UTILITY_JAVA_PACKAGE = "com.utility.helper";

    /// <summary>
    /// decompress launch script key
    /// </summary>
    public string DECOMPRESS_COMMON_LUA_KEY = "DecompressCommonLua";


    public const string UPDATE_COMMON_BUNDLE_KEY = "update_common_bundle";

    /// <summary>
    /// lua script parent directory
    /// </summary>
    [SLua.DoNotToLua]
    [SerializeField]
    private string LUA_PATH = "Assets/Content/Scripts/Lua";

    /// <summary>
    /// binary code lua file parent directory
    /// </summary>
    [SLua.DoNotToLua]
    [SerializeField]
    private string LUA_GEN_PATH = "Assets/Content/Scripts/LuaGen";

    [Tooltip("lua common bundle name")]
    [SLua.DoNotToLua]
    [SerializeField]
    private string BUNDLE_LUA_COMMON = "lua_common.u";

    [Tooltip("lua pure mvc bundle name")]
    [SLua.DoNotToLua]
    [SerializeField]
    private string BUNDLE_LUA_PUREMVC = "lua_puremvc.u";

    [SLua.DoNotToLua]
    private Dictionary<string, AssetBundle> static_bundle = new Dictionary<string, AssetBundle>();

    /// <summary>
    /// Load common lua scripts. lua_common.u includes all managers and game mode base etc....
    /// </summary>
    /// <param name="szFile">file path</param>
    /// <param name="bytes">file contents</param>
    public void LoadCommonLuaScript(string szFile, out byte[] bytes)
    {
        bytes = null;

        AssetBundle bundle = null;
        if(szFile.Contains("Common/"))
        {
            if(static_bundle.ContainsKey(BUNDLE_LUA_COMMON))
            {
                bundle = static_bundle[BUNDLE_LUA_COMMON];
            }
        }
        else if(szFile.Contains("Puremvc/"))
        {
            if (static_bundle.ContainsKey(BUNDLE_LUA_PUREMVC))
            {
                bundle = static_bundle[BUNDLE_LUA_PUREMVC];
            }
        }

        if(bundle != null && string.IsNullOrEmpty(szFile) ==false )
        {
            string lua = GameHelper.GetFileName(szFile);
            if(bundle.Contains(lua))
            {
                bytes = (bundle.LoadAsset(lua) as TextAsset).bytes;
            }
        }
    }


    /// <summary>
    /// unload common bundle , this can be called after update finished.
    /// </summary>
    /// <param name="unloadAllLoadedObjects"></param>
    public void UnloadCommonBundle(bool unloadAllLoadedObjects)
    {
        foreach(var dic in static_bundle)
        {
            if(dic.Value)
            {
                dic.Value.Unload(unloadAllLoadedObjects);
            }
        }
    }
        
    /// <summary>
    /// property return the lua script parent directory
    /// </summary>
    public string luaPath
    {
        get
        {
            return LUA_PATH;
        }
    }

    /// <summary>
    /// property return binary code lua file parent directory
    /// </summary>
    public string luaGenPath
    {
        get
        {
            return LUA_GEN_PATH;
        }
    }
   
    /// <summary>
    /// property return global script instance object
    /// </summary>
    [SLua.DoNotToLua]
    public LuaSvr luaScripter
    {
        get
        {
            return GScripter;
        }
    }

    /// <summary>
    /// return global instance object of LaunchGame class
    /// </summary>
    public static LaunchGame Instance
    {
        get
        {
            return GInstance;
        }
    }

    [SLua.DoNotToLua]
    private bool bInited = false;

    [SLua.DoNotToLua]
     public bool HasInit
    {
        get
        {
            return bInited;
        }
    }
    #endregion

    [SLua.DoNotToLua]
    void Awake()
    {
        static_bundle.Clear();
        DontDestroyOnLoad(this.gameObject);
        GInstance = this;
        bInited = false;
        //load game defined macro
        DefinedMacro.Init();
        //init Logs 
        Logs.Instance.Init(DefinedMacro.isLogEnabled);
        //Debug.LogWarning("start game time " + Time.time);
    }

    [SLua.DoNotToLua]
    void Start()
    {
       
        //init download root url
        DownloadHelper.Instance.InitRootUrl();
        
        if(string.IsNullOrEmpty(LAUNCH_GAME_LUA_SCRIPT))
        {
            Debug.LogError("Must config launch game script. Config it in " + this.gameObject.name);
        }
        if(RuntimePlatform.WindowsPlayer == Application.platform)
        {
            PlayerPrefs.DeleteAll();
        }

        if (GameHelper.isWithBundle)
        {
            //decompress LAUNCH_GAME_LUA_SCRIPT_NAME script first
            StartCoroutine(DecompressCommonLuaBundle());
        }
        else
        {
            Init(null);
        }
    }


    /// <summary>
    /// real decompress launch scripts
    /// </summary>
    /// <returns></returns>
    [SLua.DoNotToLua]
    private IEnumerator DecompressCommonLuaBundle()
    {
        
        //cache the target file path
        string luaVersionFile = "DecompressBundle" + GameHelper.SETTING_FILE_EXTENSION;
        
        bool bNeedDecompress = PlayerPrefs.HasKey(DECOMPRESS_COMMON_LUA_KEY) == false;

        //load decompress bundle version file. 
        string luaVersion = "";

        Debug.Log(CustomTool.FileSystem.GetStreamingPath() + " " + luaVersionFile);
        WWW versionWWW = new WWW(string.Format("{0}{1}", CustomTool.FileSystem.GetStreamingPath(), luaVersionFile));
        yield return versionWWW;

        if (versionWWW.error != null)
        {
            Debug.LogError("Can not load common lua version file DecompressBundle from streaming asset");
        }
        else
        {
            luaVersion = System.Text.Encoding.Default.GetString(versionWWW.bytes);
        }

        //cached bundle version is not equal streaming asset. so we need decompress lua_common bundle
        if(!bNeedDecompress &&  luaVersion.Equals(PlayerPrefs.GetString(DECOMPRESS_COMMON_LUA_KEY)) == false)
        {
            bNeedDecompress = true;
        }

        if (bNeedDecompress)
        {
            List<string> decompress = new List<string>();
            decompress.Add(BUNDLE_LUA_COMMON);
            decompress.Add(BUNDLE_LUA_PUREMVC);

            CustomTool.FileSystem.ClearFilesSkipExtend(CustomTool.FileSystem.bundleLocalPath, ".txt");
            //decompress common lua bundle file
            while (decompress.Count > 0)
            {
                string bundle_name = decompress[0];
                Debug.Log( string.Format("Decompress {0} file", bundle_name));
                string file = CustomTool.FileSystem.GetStreamingPath() + bundle_name;

                WWW bundle_www = new WWW(file);
                yield return bundle_www;

                if (bundle_www.error != null)
                {
                    Debug.LogError("Can not decompress lua common bundle:: " + bundle_name);
                    //@todo:: block game???
                }
                else
                {
                    if (GameHelper.isCompressedBundle)
                    {
                        GameHelper.Decompress(bundle_name, bundle_www);
                    }
                    else
                    {
                        CustomTool.FileSystem.ReplaceFileBytes(CustomTool.FileSystem.bundleLocalPath + "/" + bundle_name, bundle_www.bytes);
                    }
                    PlayerPrefs.SetString(DECOMPRESS_COMMON_LUA_KEY, luaVersion);
                    decompress.RemoveAt(0);
                }
            }
        }
        else
        {

            //download lua common version file from server
            //@TODO should us try backup update server or try to download more times?????
            string updateCommonFile = "UpdateCommonBundle" + GameHelper.SETTING_FILE_EXTENSION;
            string luaVersionUrl = DownloadHelper.Instance.FormatUrl(updateCommonFile);
            WWW luaVersionWWW = new WWW(luaVersionUrl);
            string serverLuaVersion = "";
            yield return luaVersionWWW;
            if(luaVersionWWW.error != null)
            {
                Debug.LogError("Failed to download " + luaVersionUrl);
            }
            else
            {
                serverLuaVersion = System.Text.Encoding.Default.GetString(luaVersionWWW.bytes);
            }

            if(PlayerPrefs.HasKey(UPDATE_COMMON_BUNDLE_KEY) == false)
            {
                PlayerPrefs.SetString(UPDATE_COMMON_BUNDLE_KEY, "0");
            }
			
			Debug.Log("server version=" + serverLuaVersion + " local version=" + PlayerPrefs.GetString(UPDATE_COMMON_BUNDLE_KEY));
            //download latest lua common bundle file from server
            if(GameHelper.isSkipUpdate == false && serverLuaVersion.Equals(PlayerPrefs.GetString(UPDATE_COMMON_BUNDLE_KEY)) == false)
            {
                //@TODO should us try backup update server or try to download more times?????
                string luaCommonBundleUrl = DownloadHelper.Instance.FormatUrl(BUNDLE_LUA_COMMON);
                WWW bundleWWW = new WWW(luaCommonBundleUrl);

                yield return bundleWWW;

                if(bundleWWW.error != null)
                {
                    Debug.LogError("Failed to download lua common bundle with " + bundleWWW.error.ToString());
                }
                else
                {
                    Debug.Log("Updated lua_common.u bundle file");
                    if (GameHelper.isCompressedBundle)
                    {
                        GameHelper.Decompress(BUNDLE_LUA_COMMON, bundleWWW);
                    }
                    else
                    {
                        CustomTool.FileSystem.ReplaceFileBytes(CustomTool.FileSystem.bundleLocalPath + "/" + BUNDLE_LUA_COMMON, bundleWWW.bytes);
                    }
                    PlayerPrefs.SetString(UPDATE_COMMON_BUNDLE_KEY, serverLuaVersion);
                }
            }
            else
            {
                Debug.LogWarning("Skip update " + BUNDLE_LUA_COMMON);
            }
        }

        yield return new WaitForSeconds(0.03f);

        //real launch game
        Init(null);
    }

    /// <summary>
    /// Init the lua engine and real start game logic
    /// </summary>
    /// <param name="callback"></param>
    public void Init(System.Action callback)
    {
        if (bInited)
            return;

       

        GScripter  = new LuaSvr();
        luaScripter.init(
            null, 
            () => {
                    bool bLoadBundle = false;
                    string path = "";
                    if (GameHelper.isEditor)
                    {
                        path = LUA_PATH + "/" + LAUNCH_GAME_LUA_SCRIPT;
                        if (GameHelper.isWithBundle)
                        {
                            bLoadBundle = true;
                            path = GetLaunchGameScriptPath();
                        }
                    }
                    else
                    {
                        bLoadBundle = true;
                        path = GetLaunchGameScriptPath();
                    }


                    byte[] tmp = null;
                    object obj;
                    if (bLoadBundle)
                    {
                        List<string> needLoad = new List<string>();
                        needLoad.Add(BUNDLE_LUA_COMMON);
                        needLoad.Add(BUNDLE_LUA_PUREMVC);

                        while (needLoad.Count > 0)
                        {
                            string bundlePath = CustomTool.FileSystem.bundleLocalPath + "/" + needLoad[0];
                            
                            AssetBundle bundle = AssetBundle.LoadFromFile(bundlePath);
                            if (bundle == null)
                            {
                                Debug.LogError("Failed to load asset bundle");
                            }
                            else
                            {
                                static_bundle.Add(needLoad[0], bundle);
                                
                            }
                            needLoad.RemoveAt(0);
                        }



                        if (static_bundle.ContainsKey(BUNDLE_LUA_COMMON))
                        {
                            string fileName = GameHelper.GetFileName(path);
                            if (static_bundle[BUNDLE_LUA_COMMON].Contains(fileName))
                            {
                                tmp = (static_bundle[BUNDLE_LUA_COMMON].LoadAsset(fileName) as TextAsset).bytes;
                            }
                            else
                            {
                                Debug.LogError("Missed " + path);
                            }
                        }
                        
                    }
                    else
                    {
                        if (System.IO.File.Exists(path))
                        {
                            tmp = System.IO.File.ReadAllBytes(path);
                            
                        }
                    }

                    if(tmp != null)
                    {
                        LuaSvr.mainState.doBuffer(tmp, "@" + LAUNCH_GAME_LUA_SCRIPT, out obj);
                        if (callback != null)
                            callback.Invoke();

                        bInited = true;
                    }
                    else
                    {
                        Debug.LogError("Failed to launch game");
                    }
                //Debug.LogWarning("start game end time " + Time.time);
                   
                },
            LuaSvrFlag.LSF_EXTLIB
            );

    }

    /// <summary>
    /// build launch game lua script path
    /// </summary>
    /// <returns></returns>
    [SLua.DoNotToLua]
    private string GetLaunchGameScriptPath()
    {
        string path = CustomTool.FileSystem.bundleLocalPath + "/" + LAUNCH_GAME_LUA_SCRIPT;

        if (GameHelper.isWithBundle)
        {
            path += GameHelper.LUA_FILENAME_EXTENSION;
        }
        return path;
    }


    void Update()
    {
        if (!bInited)
            return;

        //fresh log to local disk
        if(GameHelper.isLogEnabled)
            Logs.Instance.Update();

        if(GScripter!=null)
        {
            //GScripter.tick();
        }
    }

    void OnDestroy()
    {
        DefinedMacro.OnDestroy();
        Logs.Instance.OnDestroy();
    }
}