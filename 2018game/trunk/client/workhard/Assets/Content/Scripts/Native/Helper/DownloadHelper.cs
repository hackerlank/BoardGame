using UnityEngine;
using System.Collections;
using LitJson;
using Uri = System.Uri;
using System.IO;

[SLua.CustomLuaClass]
public class DownloadHelper
{

    [SLua.DoNotToLua]
    private static DownloadHelper _instance = null;

    [SLua.DoNotToLua]
    string manualUrl = "";

    [SLua.DoNotToLua]
    private BMUrls _bmUrl = null;
    public BMUrls bmUrl { get { return _bmUrl; } }

    [SLua.DoNotToLua]
    private string _downloadRootUrl = "";
    public string downloadRootUrl { get { return _downloadRootUrl; } }



    public static DownloadHelper Instance
    {
        get
        {
            if(_instance == null)
            {
                _instance = new DownloadHelper();
            }

            return _instance;
        }
    }

    /// <summary>
    /// 
    /// </summary>

    public static void OnDestroy()
    {
        _instance._bmUrl = null;
        _instance._downloadRootUrl = null;
        _instance.manualUrl = null;
        _instance = null;
    }

    /// <summary>
    /// 
    /// </summary>
    [SLua.DoNotToLua]
    public void InitRootUrl()
    {

        TextAsset downloadUrlText = (TextAsset)Resources.Load("Urls");
        _bmUrl = JsonMapper.ToObject<BMUrls>(downloadUrlText.text);

        BuildPlatform curPlatform = GameHelper.runtimePlatform;
        Debug.Log(curPlatform.ToString());
        if (manualUrl == "")
        {
            string downloadPathStr;
            if (bmUrl.downloadFromOutput)
                downloadPathStr = bmUrl.GetInterpretedOutputPath(curPlatform);
            else
                downloadPathStr = bmUrl.GetInterpretedDownloadUrl(curPlatform);

            Uri downloadUri = new Uri(downloadPathStr);
            _downloadRootUrl = downloadUri.AbsoluteUri;
        }
        else
        {
            string downloadPathStr = BMUtility.InterpretPath(manualUrl, curPlatform);
            Uri downloadUri = new Uri(downloadPathStr);
            _downloadRootUrl = downloadUri.AbsoluteUri;
        }
        Debug.Log(_downloadRootUrl);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="urlstr"></param>
    /// <returns></returns>
    public string FormatUrl(string urlstr)
    {
        Uri url;
        if (!isAbsoluteUrl(urlstr))
        {
            url = new Uri(new Uri(downloadRootUrl + '/'), urlstr);
        }
        else
            url = new Uri(urlstr);

        return url.AbsoluteUri;
    }

    /// <summary>
    /// 
    /// </summary>
    public void UseBackupDownloadUrls()
    {
        TextAsset downloadUrlText = (TextAsset)Resources.Load("Urls");
        _bmUrl = JsonMapper.ToObject<BMUrls>(downloadUrlText.text);

        BuildPlatform curPlatform = GameHelper.runtimePlatform;

        string downloadPathStr = bmUrl.GetInterpretedDownloadUrl(curPlatform, true);
        Uri downloadUri = new Uri(downloadPathStr);
        _downloadRootUrl = downloadUri.AbsoluteUri;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="url"></param>
    /// <returns></returns>
    public bool isAbsoluteUrl(string url)
    {
        Uri result;
        return Uri.TryCreate(url, System.UriKind.Absolute, out result);
    }

    /// <summary>
    /// build download path string
    /// </summary>
    /// <param name="origPath"></param>
    /// <param name="platform"></param>
    /// <returns></returns>
    public string InterpretPath(string origPath, BuildPlatform platform)
    {
        return BMUtility.InterpretPath(origPath, platform);
    }

    /// <summary>
    /// whether url is bundle url
    /// </summary>
    /// <param name="url"></param>
    /// <param name="bundleSuffix"></param>
    /// <returns></returns>
    public bool IsBundleUrl(string url, string bundleSuffix)
    {
        return string.Compare(Path.GetExtension(url), "." + bundleSuffix, System.StringComparison.OrdinalIgnoreCase) == 0;
    }

    /// <summary>
    /// strip suffix
    /// </summary>
    /// <param name="requestString"></param>
    /// <returns></returns>
    public string StripBundleSuffix(string requestString)
    {
        return requestString.Substring(0, requestString.LastIndexOf("."));
    }
}
