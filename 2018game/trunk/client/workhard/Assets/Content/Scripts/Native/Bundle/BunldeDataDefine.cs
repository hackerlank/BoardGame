using UnityEngine;
using System.Collections.Generic;
using LitJson;

[SLua.CustomLuaClass]
/// <summary>
/// Build platforms
/// </summary>
public enum BuildPlatform
{
    Standalones,
    IOS,
    Android,
    WP8,
}

[SLua.CustomLuaClass]
/// <summary>
/// bundle data
/// </summary>
public class BundleSmallData
{
    /**
     * Name of the bundle. The name should be unique in all bundles
     */
    public string name = "";

    /**
     * List of paths included. The path can be directories.
     */
    public List<string> includs = new List<string>();


    ///**
    // * Is this bundle a scene bundle?
    // */
    public bool sceneBundle = false;

    /**
     * Parent name of this bundle.
     */
    public List<string> parents = new List<string>();

    /**
     * whether this bundle has been encrypted
     */
    public bool bEncrypt = false;

    /**
     * bundle hash code
     */
    public string bundleHashCode;

    /**
     * bunlde size 
     */
    public long size = -1;

    /**
     * the size of compressed bundle
     */
    public long compressedSize = -1;
}

public class BundleBuildSmallState
{
    public string bundleName = "";
    public int version = -1;
    public uint crc = 0;
    public long size = -1;
    public long compressedSize = -1;
    public bool bEncrypt = false;
}

[SLua.CustomLuaClass]
public class BundleCacheInfo
{
    public AssetBundle Bundle = null;
    public float OutOfTime = 0.0f;
    public BundleCacheInfo(AssetBundle InBundle, float InTimeout)
    {
        Bundle = InBundle;
        if (InTimeout < 0)
        {
            OutOfTime = float.MaxValue;
        }
        else
        {
            OutOfTime = Time.realtimeSinceStartup + InTimeout;
        }
        
    }
}


[SLua.CustomLuaClass]
public class BMUrls
{
    public Dictionary<string, string> downloadUrls;
    public Dictionary<string, string> outputs;
    public Dictionary<string, string> backupDownloadUrls;
    public BuildPlatform bundleTarget = BuildPlatform.Standalones;
    public bool useEditorTarget = false;
    public bool downloadFromOutput = false;
    public bool offlineCache = false;

    public BMUrls()
    {
        downloadUrls = new Dictionary<string, string>()
        {
            {"Standalones", ""},
            {"IOS", ""},
            {"Android", ""},
            {"WP8", ""}
        };
        outputs = new Dictionary<string, string>()
        {
            {"Standalones", ""},
            {"IOS", ""},
            {"Android", ""},
            {"WP8", ""}
        };

        backupDownloadUrls = new Dictionary<string, string>()
        {
            {"Standalones", ""},
            {"IOS", ""},
            {"Android", ""},
            {"WP8", ""}
        };
    }

    public string GetInterpretedDownloadUrl(BuildPlatform platform, bool bUseBackup = false)
    {
        if (bUseBackup)
        {
            return BMUtility.InterpretPath(backupDownloadUrls[platform.ToString()], platform);
        }

        return BMUtility.InterpretPath(downloadUrls[platform.ToString()], platform);
    }

    public string GetInterpretedOutputPath(BuildPlatform platform)
    {
        return BMUtility.InterpretPath(outputs[platform.ToString()], platform);
    }

    public static string SerializeToString(BMUrls urls)
    {
        return JsonMapper.ToJson(urls);
    }
}

[SLua.CustomLuaClass]
public class WWWRequest
{
    public string requestString = "";
    public string url = "";
    public int triedTimes = 0;
    public int priority = 0;
    public BundleSmallData bundleData = null;
    public WWW www = null;


    public void CreatWWW()
    {
        triedTimes++;
        www = new WWW(url);
    }
}