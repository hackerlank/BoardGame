using UnityEngine;
using System.Collections.Generic;
using System;
using System.IO;
using LitJson;
using System.Security.Cryptography;
using System.Text;
using System.Runtime.InteropServices;


[SLua.CustomLuaClass]
public class GameHelper
{
    [SLua.CustomLuaClass]
    public enum EAssetType
    {
        EAT_Texture = 1,
        EAT_Sprite = 2,
        EAT_UI = 3,
        EAT_GameObject = 4,
        EAT_AudioClip = 5,
        EAT_TextAsset = 6,
        EAT_SpriteAsset =7,
        EAT_MAX = 8,
    }

    public static readonly string LUA_FILENAME_EXTENSION = ".bytes";
    public static readonly string SETTING_FILE_EXTENSION = ".txt";
    public static readonly string BUNDLE_FILENAME_EXTENSION = ".u";
    /// <summary>
    /// whether runtime platform is unity editor?
    /// </summary>
	public static bool isEditor
    {
        get
        {
            return Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.WindowsEditor;
        }
    }

    /// <summary>
    /// whether package with USE_BUNDLE macro??
    /// </summary>
    public static bool isWithBundle
    {
        get
        {
            return DefinedMacro.isWithBundle;
        }
    }

    /// <summary>
    /// whether package with USE_LUAJIT macro
    /// </summary>
    public static bool isWithLuajit
    {
        get
        {
            return DefinedMacro.isWithLuajit;
        }
    }

    /// <summary>
    /// whether skip check update apk
    /// </summary>
    public static bool isWithSkipCheckAPK
    {
        get
        {
            return DefinedMacro.isSkipCheckAPK;
        }
    }

    /// <summary>
    /// whether skip update
    /// </summary>
    public static bool isSkipUpdate
    {
        get
        {
            return DefinedMacro.isSkipUpdate;
        }
    }

    /// <summary>
    /// whether application is  distribution version
    /// </summary>
    public static bool isDistribution
    {
        get
        {
            #if DEVELOPMENT_BUILD || UNITY_EDITOR
                return false;
            #else
                return true;
            #endif
        }
    }

    /// <summary>
    /// whether log enabled
    /// </summary>
    public static bool isLogEnabled
    {
        get
        {
            return DefinedMacro.isLogEnabled;
        }
    }

    /// <summary>
    /// whether bundle has been compressed
    /// </summary>
    public static bool isCompressedBundle
    {
        get
        {
            return DefinedMacro.isCompressedBundle;
        }
    }

    /// <summary>
    /// whether support login game with wechat, share msg to wechat ... and so on
    /// </summary>
    public static bool isWithWeChat
    {
        get
        {
            return DefinedMacro.isWithWeChat;
        }
    }

    /// <summary>
    /// runtime platform
    /// </summary>
    public static BuildPlatform runtimePlatform
    {
        get
        {
#if UNITY_ANDROID
                return BuildPlatform.Android;
#elif UNITY_IPHONE
                return BuildPlatform.IOS;
#else
                return BuildPlatform.Standalones;
#endif
            //if (Application.platform == RuntimePlatform.WindowsPlayer ||
            // Application.platform == RuntimePlatform.OSXPlayer)
            //{
            //    return BuildPlatform.Standalones;
            //}
            //else if (Application.platform == RuntimePlatform.IPhonePlayer || Application.platform == RuntimePlatform.OSXEditor)
            //{
            //    return BuildPlatform.IOS;
            //}
            //else if (Application.platform == RuntimePlatform.Android || (Application.platform == RuntimePlatform.WindowsEditor && UnityEditor.PlayerSettings.)
            //{
            //    return BuildPlatform.Android;
            //}
            //else
            //{
            //    Debug.LogError("Platform " + Application.platform + " is not supported by BundleManager.");
            //    return BuildPlatform.Standalones;
            //}
        }
    }

    public static TextAsset ReadFileFromDatabase(string inFile)
    {
#if UNITY_EDITOR
        TextAsset text = UnityEditor.AssetDatabase.LoadAssetAtPath(inFile, typeof(TextAsset)) as TextAsset;
        return text;
#else
        return null;
#endif
    }

    /// <summary>
    /// read file
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public static string ReadFile(string path)
    {
        if (File.Exists(path))
        {
            FileStream stream = new FileStream(path, FileMode.Open);
            stream.Seek(0, SeekOrigin.Begin);
            byte[] bytes = new byte[stream.Length];
            stream.Read(bytes, 0, (int)stream.Length);
            string content = System.Text.Encoding.Default.GetString(bytes);
            stream.Close();
            return content;
        }

        return null;
    }

    /// <summary>
    /// write bytes to one pointed file
    /// </summary>
    /// <param name="inPath"></param>
    /// <param name="content"></param>
    public static void WriteFile(string inPath, byte[] content)
    {
        if (content == null)
        {
            Debug.LogError("content is null, path is:: " + inPath);
            return;
        }
        if (!File.Exists(inPath))
        {
            using (FileStream tmpf = File.Create(inPath))
            {
                tmpf.Close();
            }

            //System.GC.Collect();
        }

        File.WriteAllBytes(inPath, content);
    }

    /// <summary>
    /// get bundle build state
    /// </summary>
    /// <param name="path">the path of bundle build file</param>
    /// <param name="buildState">list all bundle state</param>
    public static void GetBundleBuildStates(string path, out List<BundleSmallData> buildState)
    {
        List<BundleSmallData> data = new List<BundleSmallData>();
        string content = ReadFile(path);
        if (content != null && content != "")
        {
            data = LitJson.JsonMapper.ToObject<List<BundleSmallData>>(content);
        }

        buildState = data;
    }


    /// <summary>
    /// save bundle state to local disk. means update log 
    /// </summary>
    /// <param name="inPath">file path</param>
    /// <param name="buildState">all bundle has been updated</param>
    public static void SaveUpdateState(string inPath, List<BundleSmallData> buildState)
    {
        if (buildState == null || string.IsNullOrEmpty(inPath))
        {
            Debug.LogWarning("Can not save update state");
            return;
        }
        string state = "";
        if (buildState.Count > 0)
            state = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(buildState));
        CustomTool.FileSystem.ReplaceFile(inPath, state);
    }

    /// <summary>
    /// garbage collection
    /// </summary>
    public static void GC()
    {
        Resources.UnloadUnusedAssets();
        System.GC.Collect();
    }

    /// <summary>
    /// decompress bundle file
    /// </summary>
    /// <param name="updateUrl"></param>
    /// <param name="content"></param>
    public static void Decompress(string updateUrl, WWW content)
    {
        string writePath = CustomTool.FileSystem.bundleLocalPath + "/" + updateUrl;
        string finalpath = writePath;
        writePath = writePath.Substring(0, writePath.LastIndexOf(".")) + ".7z";

        if (File.Exists(writePath))
        {
            using (FileStream tmpf = File.Create(writePath))
            {
                tmpf.Close();
            }
        }


        File.WriteAllBytes(writePath, content.bytes);

        DecompressFileLZMA(writePath, finalpath);

        File.Delete(writePath);
    }

    /// <summary>
    /// real uncompress file
    /// </summary>
    /// <param name="inFile"></param>
    /// <param name="outFile"></param>
    private static void DecompressFileLZMA(string inFile, string outFile)
    {
        SevenZip.Compression.LZMA.Decoder coder = new SevenZip.Compression.LZMA.Decoder();

        FileStream Inputfs, Outputfs;

        Inputfs = File.Open(inFile, FileMode.Open);
        Outputfs = File.Open(outFile, FileMode.Create);
        {
            // Read the decoder properties
            byte[] properties = new byte[5];
            Inputfs.Read(properties, 0, 5);

            // Read in the decompress file size.
            byte[] fileLengthBytes = new byte[8];
            Inputfs.Read(fileLengthBytes, 0, 8);
            long fileLength = BitConverter.ToInt64(fileLengthBytes, 0);

            // Decompress the file.
            coder.SetDecoderProperties(properties);
            coder.Code(Inputfs, Outputfs, Inputfs.Length, fileLength, null);

            Outputfs.Flush();
            Inputfs.Flush();
            Inputfs.Close();
            Outputfs.Close();

        }
    }

    /// <summary>
    /// load lua script(only for editor)
    /// </summary>
    /// <param name="inPath"></param>
    /// <param name="result"></param>
    public static void LoadScript(string inPath, out byte[] result)
    {
        result = null;
        if (string.IsNullOrEmpty(inPath))
        {
            return;
        }


#if UNITY_EDITOR
        if (File.Exists(inPath))
        {
            result = File.ReadAllBytes(inPath);
        }
#endif
    }

    /// <summary>
    /// run lua scripts
    /// </summary>
    /// <param name="scripts">lua script content</param>
    /// <param name="fn">lua script file name</param>
    /// <returns>the lua script class object</returns>
    public static object DoBuffer(byte[] scripts, string fn)
    {
        if (scripts == null)
            return null;
         
        object obj;
        if (SLua.LuaSvr.mainState.doBuffer(scripts, "@" + fn, out obj))
        {
            return obj;
        }
        //return lua scripts object
        return null;
    }

    public static object RunScript(string inPath, string bundleName)
    {
        if (isEditor)
        {

        }
        else
        {

        }


        return null;
    }

    /// <summary>
    /// Get file name with file extension title
    /// </summary>
    /// <param name="inFile"></param>
    /// <returns></returns>
    public static string GetFileName(string inFile)
    {
        return Path.GetFileName(inFile);
    }

    public static int LastIndexOf(string inStr, string subStr)
    {
        if (string.IsNullOrEmpty(inStr) || string.IsNullOrEmpty(subStr))
            return -1;

        return inStr.LastIndexOf(subStr);
    }

    [SLua.DoNotToLua]
    public static byte[] Decrypt(byte[] inData, string key, string iv)
    {
        byte[] btKey = Encoding.UTF8.GetBytes(key);

        byte[] btIV = Encoding.UTF8.GetBytes(iv);

        DESCryptoServiceProvider des = new DESCryptoServiceProvider();

        using (MemoryStream ms = new MemoryStream())
        {

            try
            {
                using (CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(btKey, btIV), CryptoStreamMode.Write))
                {
                    cs.Write(inData, 0, inData.Length);

                    cs.FlushFinalBlock();
                }

                return ms.ToArray();
            }
            catch
            {
                return null;
            }
        }
    }


    public static byte[] Decrypt(string inFile, string key, string iv)
    {
        if (string.IsNullOrEmpty(inFile))
        {
            return null;
        }

        FileStream fs = new FileStream(inFile, FileMode.Open);
        byte[] newbt = new byte[fs.Length];
        fs.Read(newbt, 0, newbt.Length);
        fs.Close();
        return Decrypt(newbt, key, iv);
    }

    /// <summary>
    /// Get file name without file extension title
    /// </summary>
    /// <param name="inFile"></param>
    /// <returns></returns>
    public static string GetFileNameWithoutExtension(string inFile)
    {
        if (string.IsNullOrEmpty(inFile))
            return "";
        return inFile.Substring(inFile.LastIndexOf('/') + 1, inFile.LastIndexOf('.') - inFile.LastIndexOf('/') - 1);
    }

    /// <summary>
    /// Load text asset from bundle
    /// </summary>
    /// <param name="fileName">script name</param>
    /// <param name="inBundle">bundle</param>
    /// <returns></returns>
    public static TextAsset LoadTextAsset(string fileName, AssetBundle inBundle)
    {
        if (inBundle == null)
            return null;

        TextAsset asset = inBundle.LoadAsset(fileName) as TextAsset;

        return asset;
    }

    /// <summary>
    /// load sprite image from bundle
    /// </summary>
    /// <param name="fileName"></param>
    /// <param name="inBundle"></param>
    /// <returns></returns>
    public static Sprite LoadSprite(string fileName, AssetBundle inBundle)
    {
        if (null != inBundle)
        {
            return inBundle.LoadAsset(fileName) as Sprite;
        }

        return null;
    }

    /// <summary>
    /// load asset in editor.
    /// </summary>
    /// <param name="szFile"></param>
    /// <param name="inType"></param>
    /// <returns></returns>
    public static UnityEngine.Object LoadAsset_Editor(string szFile, EAssetType inType)
    {
#if UNITY_EDITOR
        Type tmp = GetAssetType(inType);
        if (tmp == null)
            return null;
        return UnityEditor.AssetDatabase.LoadAssetAtPath(szFile, tmp);
#else
        return null;
#endif
    }

    /// <summary>
    /// import a file
    /// </summary>
    /// <param name="szFile"></param>
    public static void ImportAsset(string szFile)
    {
#if UNITY_EDITOR
        if (string.IsNullOrEmpty(szFile))
        {
            return;
        }

        UnityEditor.AssetDatabase.ImportAsset(szFile, UnityEditor.ImportAssetOptions.ForceUpdate);
#endif
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetType"></param>
    /// <returns></returns>
    public static Type GetAssetType(EAssetType assetType)
    {
        if (assetType == EAssetType.EAT_Texture)
            return typeof(Texture);
        else if (assetType == EAssetType.EAT_Sprite)
            return typeof(Sprite);
        else if (assetType == EAssetType.EAT_UI || assetType == EAssetType.EAT_GameObject)
            return typeof(GameObject);
        else if (assetType == EAssetType.EAT_AudioClip)
            return typeof(AudioClip);
        else if (assetType == EAssetType.EAT_TextAsset)
            return typeof(TextAsset);
        else if (assetType == EAssetType.EAT_SpriteAsset)
            return typeof(SpriteAsset);
        else
            return null;
    }

#region Helper for downloadManager
    public static bool EndsWith(string content, string end)
    {
        if (content == null)
            return false;

        if (string.IsNullOrEmpty(end))
        {
            return true;
        }

        return content.EndsWith(end, System.StringComparison.OrdinalIgnoreCase);
    }

#endregion

    public static float batteryLevel
    {
        get
        {
            return Mathf.Abs(UnityEngine.SystemInfo.batteryLevel);
        }
    }

    public static string osTime
    {
        get
        {
            return System.DateTime.Now.ToString("HH:mm").ToString();
        }
    }

    public static void StopEditorPlayer()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }

    public static float CalculateTextSize(UnityEngine.UI.Text text)
    {
        float len = 0;
        if (text == null)
            return len;

        if (text.text == "")
        {
            return len;
        }

        Font myFont = text.font;

        string msg = text.text;

        myFont.RequestCharactersInTexture(msg, text.fontSize, text.fontStyle);
        CharacterInfo characterInfo = new CharacterInfo();

        char[] arr = msg.ToCharArray();

        foreach (char c in arr)
        {
            myFont.GetCharacterInfo(c, out characterInfo, text.fontSize);

            len += characterInfo.advance;
        }
        return len;
    }


#region  bit operation
    public static int Bitand(int left, int right)
    {
        return left & right;
    }

    public static int Bitshift(int value, int shiftCount, bool bRight = false)
    {
        if (bRight)
        {
            return value >> shiftCount;
        }
        else
        {
            return value << shiftCount;
        }
    }

    public static int Bitor(int lhs, int rhs)
    {
        return lhs | rhs;
    }

    public static string GetString(Byte[] inbyte)
    {
        if (inbyte == null)
        {
            return "";
        }

        return System.Text.Encoding.Default.GetString(inbyte);
    }

    public static bool IsHited(BoxCollider2D bulletCollider, BoxCollider2D fishCollider, out float x, out float y, out float z)
    {
        x = 0;
        y = 0;
        z = 0;
        bool bHited = false;
        if (bulletCollider == null || fishCollider == null)
        {
            return bHited;
        }
        Bounds bulletBounds = bulletCollider.bounds;
        Vector3 target_old_center = fishCollider.bounds.center;

        Vector3 targetCenter = new Vector3(target_old_center.x, target_old_center.y, bulletBounds.center.z);
        Bounds target_new_bounds = new Bounds(targetCenter, fishCollider.bounds.size);

        bHited = bulletBounds.Intersects(target_new_bounds);

        Vector3 collision_pos = bulletBounds.ClosestPoint(targetCenter);
        collision_pos.z = bulletCollider.bounds.center.z;

        x = collision_pos.x;
        y = collision_pos.y;
        z = collision_pos.z;
        return bHited;
    }
    #endregion


    #region screen capture

    /// <summary>
    /// screenshot
    /// </summary>
    /// <param name="camera"></param>
    /// <param name="posx"></param>
    /// <param name="posy"></param>
    /// <param name="width"></param>
    /// <param name="height"></param>
    /// <param name="name"></param>
    public static void ScreenCapture(Camera camera, int posx, int posy, int width, int height, string name)
    {
        if(camera == null)
        {
            camera = Camera.main;
        }

        // 创建一个RenderTexture对象  
        RenderTexture rt = new RenderTexture(width, height, 0);
        // 临时设置相关相机的targetTexture为rt, 并手动渲染相关相机  
        camera.targetTexture = rt;
        camera.Render();

        // 激活这个rt, 并从中中读取像素。  
        RenderTexture.active = rt;
        Texture2D screenShot = new Texture2D(width, height, TextureFormat.RGB24, false);
        Rect rect = new Rect(posx, posy, width, height);
        screenShot.ReadPixels(rect, 0, 0);
        screenShot.Apply();

        // 重置相关参数，以使用camera继续在屏幕上显示  
        camera.targetTexture = null;
       
        RenderTexture.active = null; // JC: added to avoid errors  
        GameObject.Destroy(rt);
        // 最后将这些纹理数据，成一个png图片文件  
        byte[] bytes = screenShot.EncodeToPNG();
        int idx = name.LastIndexOf(".");
        if (idx < 0)
        {
            name += ".png";
        }
        string filename = CustomTool.FileSystem.screenshotPath + "/" + name;
        if(File.Exists(filename))
        {
            File.Delete(filename);
        }

        CustomTool.FileSystem.ReplaceFileBytes(filename, bytes);
        Debug.Log(string.Format("screenshot has been saved into: {0}", filename));
    }
#endregion

}
