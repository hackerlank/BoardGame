using UnityEngine;
using System.Collections;
using UnityEditor;
using SevenZip.Compression.LZMA;
using System.IO;
using System;
using LitJson;
using System.Text;

using System.Collections.Generic;

using System.Security.Cryptography;

public class SimpleLZMA : Editor
{
    static readonly string BundleSuffix = "u";

    readonly static string Localkey = "12345678";
    readonly static string LocalIV = "abcdefgh";

    /// <summary>
    /// this funcition only used to test. do not call this when build distribution bundles
    /// </summary>
    /// <param name="path"></param>
    /// <param name="bToStreamingAsset"></param>
    public static void CompressFile(string path, bool bToStreamingAsset = false)
    {
        //the path of save bundle file
        string pathbase = path;

        Dictionary<string, bool> ScenenBundleMap = new Dictionary<string, bool>();

        //the path used to save compressed bundle file
        string targetbase = pathbase.Substring(0, pathbase.LastIndexOf("/")) + "/Compressed";

        //try to clear cache path of bundles. if build type is quick, skip this step
        if (Directory.Exists(targetbase))
        {
            CustomTool.FileSystem.ClearPath(targetbase, false);
        }
        else
        {
            CustomTool.FileSystem.CreatePath(targetbase);
        }

        //load all bundles from bundle configuration file
        List<string> AllFiles = CustomTool.FileSystem.GetSubFiles(pathbase);
        BundleInfo Setting = CustomTool.ManageBundleWindow.GetCurrentCookingSetting();// AssetDatabase.LoadAssetAtPath(PathOfConf, typeof(BundleInfo)) as BundleInfo;
        List<BundleInfo.Element> bundleinfos = new List<BundleInfo.Element>(Setting.ListOfBundles);


        AssetDatabase.RemoveUnusedAssetBundleNames();

        string finalTypeName = "." + BundleSuffix;
        foreach (var file in AllFiles)
        {
            int startIndex = file.LastIndexOf(".");
            if (startIndex < 0)
                continue;
            string typename = file.Substring(file.LastIndexOf("."), file.Length - file.LastIndexOf("."));

            if (typename == "manifest")
            {
                continue;
            }

            if (typename != finalTypeName)
            {
                if (typename == ".data")
                {
                }
                else continue;
            }

            string tgname;
            string bundleName = "";

            if (file.LastIndexOf("/") >= 0)
            {
                tgname = file.Substring(file.LastIndexOf("/"), file.Length - file.LastIndexOf("/"));
                bundleName = file.Substring(0, file.Length - typename.Length);
                bundleName = bundleName.Substring(bundleName.LastIndexOf("/") + 1, bundleName.Length - bundleName.LastIndexOf("/") - 1);
            }
            else
            {
                tgname = "/" + file;
                bundleName = file.Substring(0, file.Length - typename.Length);
            }


            bool bSceneBundle = false;

            //值判断allinone
            foreach (var tmpinfo in bundleinfos)
            {
                if (tmpinfo.Mode != BundleInfo.BundleMode.AllInOne && tmpinfo.Mode != BundleInfo.BundleMode.SceneBundle) continue;

                if (tmpinfo.Name == bundleName)
                {
                    bSceneBundle = (tmpinfo.Mode == BundleInfo.BundleMode.SceneBundle);
                    ScenenBundleMap[bundleName] = bSceneBundle;
                    break;
                }
            }

            tgname = targetbase + tgname;
            tgname = tgname.Substring(0, tgname.LastIndexOf("."));

            if (typename != finalTypeName)
            {
                if (typename == ".data")
                {
                    tgname += ".data";
                }
            }
            else
            {
                tgname += finalTypeName;
            }



            if (File.Exists(pathbase + "/" + file))
            {
                FileUtil.ReplaceFile(pathbase + "/" + file, tgname);
            }
        }

        CustomTool.FileSystem.ReplaceFile(targetbase + "/UpdateCommonBundle.txt", "0");

        List<string> files = new List<string>();
        files = CustomTool.FileSystem.GetSubFiles(targetbase);

        if (bToStreamingAsset)
        {
            string streamingAssetPath = "Assets/StreamingAssets";

            if (Directory.Exists(streamingAssetPath))
            {
                files.Clear();
                files = CustomTool.FileSystem.GetSubFiles(streamingAssetPath);

                foreach (string file in files)
                {
                    string typename = file.Substring(file.LastIndexOf("."), file.Length - file.LastIndexOf(".")).ToLower();
                    if (typename == ".mp4" || typename == ".txt")
                    {
                        continue;
                    }
                    File.Delete(streamingAssetPath + "/" + file);
                }
            }
            else
            {
                //FileUtil.cre
                Directory.CreateDirectory(streamingAssetPath);
            }

            files.Clear();
            files = CustomTool.FileSystem.GetSubFiles(targetbase);
            Debug.Log("File.Count = " + files.Count);
            foreach (string file in files)
            {
                string tmpTypeName = file.Substring(file.LastIndexOf("."), file.Length - file.LastIndexOf("."));
                if (tmpTypeName.Equals(".txt") || tmpTypeName.Equals(".manifest"))
                {
                    Debug.Log("Skip copy file:: " + file);
                    continue;
                }
                if (CustomTool.ManageBundleWindow.isToStreamingAsset(file))
                {
                    Debug.Log("Copying file :: " + file);
                    FileUtil.ReplaceFile(targetbase + "/" + file, streamingAssetPath + "/" + file);
                }

            }
        }
    }

    public static void CompressFiles(string path, bool bCopyToStreamingAsset = false, bool bQuick = false)
    {
        //the path of save bundle file
        string pathbase = path;

        //backup old lua bundle path
        string backOldLuaPath = path.Substring(0, path.LastIndexOf("/"));

        Dictionary<string, bool> ScenenBundleMap = new Dictionary<string, bool>();

        //the path used to save compressed bundle file
        string targetbase = pathbase.Substring(0, pathbase.LastIndexOf("/")) + "/Compressed";

        //the latest bundle file path
        string currentBmFile = path + "/bm.data";

        //save the hash code of lua bundle file
        Dictionary<string, string> hashCodes = new Dictionary<string, string>();
        hashCodes.Clear();


        //First cook bundles. ensure directory is exists. never read hash code of lua bundles
        string bmpathbase = pathbase.Substring(0, pathbase.LastIndexOf("/"));
        if (!Directory.Exists(bmpathbase + "/Bundle_Latest"))
        {
            Directory.CreateDirectory(bmpathbase + "/Bundle_Latest");
        }
        else
        {
            //read hash code of lua bundles
            if (File.Exists(backOldLuaPath + "/bm_old.data") && CustomTool.ManageBundleWindow.checkBundleBinary.Count > 0)
            {
                FileStream readStream = new FileStream(backOldLuaPath + "/bm_old.data", FileMode.Open);
                byte[] content = new byte[readStream.Length];
                readStream.Seek(0, SeekOrigin.Begin);
                readStream.Read(content, 0, content.Length);
                string bm_string = System.Text.Encoding.Default.GetString(content);
                List<BundleSmallData> data = LitJson.JsonMapper.ToObject<List<BundleSmallData>>(bm_string);
                readStream.Close();

                foreach (var obj in CustomTool.ManageBundleWindow.checkBundleBinary)
                {
                    foreach (var bundle in data)
                    {
                        if (bundle.name.Equals(obj))
                        {
                            hashCodes.Add(obj, bundle.bundleHashCode);
                        }
                    }
                }
            }
        }

        //try to delete old bundle manage file
        if (File.Exists(backOldLuaPath + "/bm_old.data"))
        {
            File.Delete(backOldLuaPath + "/bm_old.data");
        }

        //try to delete bm.data file which was cooked in last time. not current 
        if (File.Exists(bmpathbase + "/Bundle_Latest/bm.data"))
            File.Delete(bmpathbase + "/Bundle_Latest/bm.data");

        //copy newest bm.data file to cache directory
        FileUtil.CopyFileOrDirectory(bmpathbase + "/tmp/bm.data", bmpathbase + "/Bundle_Latest/bm.data");

        //load all cooked bundles from bm.data file
        FileStream bmfile = new FileStream(currentBmFile, FileMode.Open);
        byte[] bmcontent = new byte[bmfile.Length];
        bmfile.Seek(0, SeekOrigin.Begin);
        bmfile.Read(bmcontent, 0, bmcontent.Length);
        string tmpbm = System.Text.Encoding.Default.GetString(bmcontent);
        List<BundleSmallData> AllBundleData = LitJson.JsonMapper.ToObject<List<BundleSmallData>>(tmpbm);
        bmfile.Close();


        //老的信息
        List<BundleSmallData> OldStates = new List<BundleSmallData>();

        //load old bm.data file to compare bundles with current
        if (bQuick)
        {
            if (File.Exists(targetbase + "/bm.data"))
            {
                //解压到bm.tmp

                DecompressFileLZMA(targetbase + "/bm.data", targetbase + "/bm.tmp");
                FileStream tmpfile = new FileStream(targetbase + "/bm.tmp", FileMode.Open);
                byte[] tmpcontent = new byte[tmpfile.Length];
                tmpfile.Seek(0, SeekOrigin.Begin);
                tmpfile.Read(tmpcontent, 0, tmpcontent.Length);
                string tmpstr = System.Text.Encoding.Default.GetString(tmpcontent);
                OldStates = LitJson.JsonMapper.ToObject<List<BundleSmallData>>(tmpstr);

                tmpfile.Close();
            }
            else
            {
                Debug.LogError("No Last Build DLC");
            }

        }


        //try to clear cache path of bundles. if build type is quick, skip this step
        if (Directory.Exists(targetbase))
        {
            if (!bQuick)
            {
                CustomTool.FileSystem.ClearPath(targetbase, false);
            }
        }
        else
        {
            CustomTool.FileSystem.CreatePath(targetbase);
        }


        //load all bundles from bundle configuration file
        List<string> AllFiles = CustomTool.FileSystem.GetSubFiles(pathbase);
        BundleInfo Setting = CustomTool.ManageBundleWindow.GetCurrentCookingSetting();// AssetDatabase.LoadAssetAtPath(PathOfConf, typeof(BundleInfo)) as BundleInfo;
        List<BundleInfo.Element> bundleinfos = new List<BundleInfo.Element>(Setting.ListOfBundles);


        AssetDatabase.RemoveUnusedAssetBundleNames();

        string finalTypeName = "." + BundleSuffix;
        foreach (var file in AllFiles)
        {
            int startIndex = file.LastIndexOf(".");
            if (startIndex < 0)
                continue;
            string typename = file.Substring(file.LastIndexOf("."), file.Length - file.LastIndexOf("."));

            if (typename == "manifest")
            {
                continue;
            }

            if (typename != finalTypeName)
            {
                if (typename == ".data")
                {
                }
                else continue;
            }

            string tgname;
            string bundleName = "";

            if (file.LastIndexOf("/") >= 0)
            {
                tgname = file.Substring(file.LastIndexOf("/"), file.Length - file.LastIndexOf("/"));
                bundleName = file.Substring(0, file.Length - typename.Length);
                bundleName = bundleName.Substring(bundleName.LastIndexOf("/") + 1, bundleName.Length - bundleName.LastIndexOf("/") - 1);
            }
            else
            {
                tgname = "/" + file;
                bundleName = file.Substring(0, file.Length - typename.Length);
            }

            //Debug.Log("BundleName is = " + bundleName);
            bool bEncrypt = false;

            bEncrypt = false;

            bool bSceneBundle = false;

            //值判断allinone
            foreach (var tmpinfo in bundleinfos)
            {
                if (tmpinfo.Mode != BundleInfo.BundleMode.AllInOne && tmpinfo.Mode != BundleInfo.BundleMode.SceneBundle) continue;

                if (tmpinfo.Name == bundleName)
                {
                    bEncrypt = tmpinfo.bEncrypt;
                    bSceneBundle = (tmpinfo.Mode == BundleInfo.BundleMode.SceneBundle);
                    ScenenBundleMap[bundleName] = bSceneBundle;
                    break;
                }
            }

            tgname = targetbase + tgname;
            tgname = tgname.Substring(0, tgname.LastIndexOf("."));

            if (typename != finalTypeName)
            {
                if (typename == ".data")
                {
                    tgname += ".data";
                }
            }
            else
            {
                tgname += finalTypeName;
            }


            if (file != "bm.data")
            {
                string oldhash = "";
                string newhash = "-1";
                if (bQuick)
                {
                    //对比老信息，看是否需要重新压缩
                    foreach (var tmp in AllBundleData)
                    {
                        if (tmp.name == file)
                        {
                            newhash = tmp.bundleHashCode;
                        }
                    }

                    foreach (var tmp in OldStates)
                    {
                        if (tmp.name == file)
                        {
                            oldhash = tmp.bundleHashCode;
                        }
                    }
                }
                if (oldhash == newhash)
                {
                    Debug.Log("Skip compress  " + file + " !!");
                }
                else
                {
                    if (File.Exists(pathbase + "/" + file))
                    {
                        CompressFileLZMA(pathbase + "/" + file, tgname, bEncrypt);
                    }

                }


            }
        }

        //decide which lua bundle file need to be real updated
        Dictionary<string, bool> needUpdateLua = new Dictionary<string, bool>();
        if (hashCodes.Count > 0)
        {
            int idx = 0;
            foreach (var lua in CustomTool.ManageBundleWindow.backOldBundleBinary)
            {
                bool bShouldUpdateLua = true;

                //compare the lua bundle 
                string tmpPath = backOldLuaPath + "/" + lua.Value;
                FileStream readStream = new FileStream(tmpPath, FileMode.Open);
                byte[] tmpcontent = new byte[readStream.Length];
                readStream.Seek(0, SeekOrigin.Begin);
                readStream.Read(tmpcontent, 0, tmpcontent.Length);
                string oldLua = System.Text.Encoding.Default.GetString(tmpcontent);
                readStream.Close();


                tmpPath = bmpathbase + "/Bundle_Latest/" + CustomTool.ManageBundleWindow.checkBundleBinary[idx];
                readStream = new FileStream(tmpPath, FileMode.Open);
                tmpcontent = new byte[readStream.Length];
                readStream.Seek(0, SeekOrigin.Begin);
                readStream.Read(tmpcontent, 0, tmpcontent.Length);
                string newLua = System.Text.Encoding.Default.GetString(tmpcontent);
                readStream.Close();


                if (oldLua.Equals(newLua))
                {
                    bShouldUpdateLua = false;
                    // Debug.Log(CustomTool.ManageBundleWindow.checkBundleBinary[idx] + " was not modified, do not update it");
                }
                needUpdateLua.Add(CustomTool.ManageBundleWindow.checkBundleBinary[idx], bShouldUpdateLua);
                idx++;
            }
        }
        else
        {
            Debug.Log("Hash code list doesn't contains any lua bundle file name.  Does this means first cook bundle????");
        }

        //try to delete backed lua file
        foreach (var oldLua in CustomTool.ManageBundleWindow.backOldBundleBinary)
        {
            if (File.Exists(backOldLuaPath + "/" + oldLua.Value))
            {
                File.Delete(backOldLuaPath + "/" + oldLua.Value);
            }
        }

        //now modify bm.data
        DirectoryInfo compressdicinfo = new DirectoryInfo(targetbase);

        FileInfo[] compressfileinfo = compressdicinfo.GetFiles();
        List<BundleSmallData> newBundleData = new List<BundleSmallData>();
        CustomTool.FileSystem.ReplaceFile(bmpathbase + "/Compressed/UpdateCommonBundle.txt", "0");

        bool bSkipLuaCommon = false;
        foreach (var bminfo in AllBundleData)
        {
            bool bfind = false;

            string key = bminfo.name;
            if (needUpdateLua.ContainsKey(key) && needUpdateLua[key] == false && hashCodes.ContainsKey(key) && hashCodes[key] != "")
            {
                if (bminfo.name.Equals("lua_common.u"))
                {
                    bSkipLuaCommon = true;
                }
                Debug.LogWarning(string.Format("Skip update bundle:: " + bminfo.name + ". Replace  bundle hash code:: {0} with {1}", bminfo.bundleHashCode, hashCodes[key]));
                bminfo.bundleHashCode = hashCodes[key];
            }

            for (int i = 0; i < compressfileinfo.Length; i++)
            {
                if (bminfo.name == compressfileinfo[i].Name)
                {
                    bminfo.compressedSize = compressfileinfo[i].Length;
                    bfind = true;
                    string tmps = bminfo.name.Substring(0, bminfo.name.LastIndexOf('.'));
                    if (ScenenBundleMap.ContainsKey(tmps))
                    {
                        bminfo.sceneBundle = ScenenBundleMap[tmps];
                    }
                    else
                    {
                        bminfo.sceneBundle = false;
                    }
                    break;
                }
            }
            if (bfind == false)
            {
                Debug.LogError("Can't find " + bminfo.name);
            }


            newBundleData.Add(bminfo);
        }

        //means not first cook bundle
        if (!bSkipLuaCommon && hashCodes.Count > 0)
        {
            CustomTool.FileSystem.ReplaceFile(bmpathbase + "/Compressed/UpdateCommonBundle.txt", "1");
        }

        //写回bm.data
        string bmfinal = JsonFormatter.PrettyPrint(JsonMapper.ToJson(newBundleData));

        CustomTool.FileSystem.ReplaceFile(bmpathbase + "/Bundle_Latest" + "/bm.data", bmfinal);

        //压缩bm.data
        CompressFileLZMA(bmpathbase + "/Bundle_Latest" + "/bm.data", targetbase + "/bm.data", false);


        List<string> files = new List<string>();
        files = CustomTool.FileSystem.GetSubFiles(targetbase);

        if (bCopyToStreamingAsset)
        {
            string streamingAssetPath = "Assets/StreamingAssets";

            if (Directory.Exists(streamingAssetPath))
            {
                files.Clear();
                files = CustomTool.FileSystem.GetSubFiles(streamingAssetPath);

                foreach (string file in files)
                {
                    string typename = file.Substring(file.LastIndexOf("."), file.Length - file.LastIndexOf(".")).ToLower();
                    if (typename == ".mp4" || typename == ".txt")
                    {
                        continue;
                    }
                    File.Delete(streamingAssetPath + "/" + file);
                }
            }
            else
            {
                //FileUtil.cre
                Directory.CreateDirectory(streamingAssetPath);
            }

            files.Clear();
            files = CustomTool.FileSystem.GetSubFiles(targetbase);
            Debug.Log("File.Count = " + files.Count);
            foreach (string file in files)
            {
                string tmpTypeName = file.Substring(file.LastIndexOf("."), file.Length - file.LastIndexOf("."));
                if (tmpTypeName.Equals(".txt") || tmpTypeName.Equals(".manifest"))
                {
                    Debug.Log("Skip copy file:: " + file);
                    continue;
                }
                if (CustomTool.ManageBundleWindow.isToStreamingAsset(file))
                {
                    Debug.Log("Copying file :: " + file);
                    FileUtil.ReplaceFile(targetbase + "/" + file, streamingAssetPath + "/" + file);
                }

            }
        }
    }

    private static void CompressFileLZMA(string inFile, string outFile, bool bEncrypt = false)
    {
        //  bEncrypt = false;


        SevenZip.Compression.LZMA.Encoder coder = new SevenZip.Compression.LZMA.Encoder();
        FileStream input = new FileStream(inFile, FileMode.Open);
        FileStream output = new FileStream(outFile, FileMode.Create);

        // Write the encoder properties
        coder.WriteCoderProperties(output);

        if (bEncrypt)
        {
            byte[] inbyte = new byte[input.Length];

            input.Read(inbyte, 0, inbyte.Length);


            MemoryStream encryptinput = new MemoryStream();

            Encrypt(inbyte, Localkey, LocalIV, encryptinput);
            //新增，加密

            encryptinput.Position = 0;
            // Write the decompressed file size.
            output.Write(BitConverter.GetBytes(encryptinput.Length), 0, 8);

            // Encode the file.
            coder.Code(encryptinput, output, encryptinput.Length, -1, null);
            encryptinput.Flush();
            encryptinput.Close();
        }
        else
        {
            //input.Position = 0;
            // Write the decompressed file size.
            output.Write(BitConverter.GetBytes(input.Length), 0, 8);

            // Encode the file.
            coder.Code(input, output, input.Length, -1, null);
        }

        //Debug.LogWarning("Compressing " + inFile + " size is : " + input.Length / 1024 + "Compressed File size :: " + output.Length / 1024 + "bEncrypt=" + bEncrypt);
        output.Flush();
        output.Close();
        input.Flush();
        input.Close();


    }

    private static void DecompressFileLZMA(string inFile, string outFile)
    {
        SevenZip.Compression.LZMA.Decoder coder = new SevenZip.Compression.LZMA.Decoder();
        FileStream input = new FileStream(inFile, FileMode.Open);
        FileStream output = new FileStream(outFile, FileMode.Create);

        // Read the decoder properties
        byte[] properties = new byte[5];
        input.Read(properties, 0, 5);

        // Read in the decompress file size.
        byte[] fileLengthBytes = new byte[8];
        input.Read(fileLengthBytes, 0, 8);
        long fileLength = BitConverter.ToInt64(fileLengthBytes, 0);

        // Decompress the file.
        coder.SetDecoderProperties(properties);
        coder.Code(input, output, input.Length, fileLength, null);
        output.Flush();
        output.Close();
        input.Flush();
        input.Close();
    }

    static UInt32[] CrcTable = {
            0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535, 0x9E6495A3,
            0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD, 0xE7B82D07, 0x90BF1D91,
            0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7,
            0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5,
            0x3B6E20C8, 0x4C69105E, 0xD56041E4, 0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B,
            0x35B5A8FA, 0x42B2986C, 0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59,
            0x26D930AC, 0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
            0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D,
            0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F, 0x9FBFE4A5, 0xE8B8D433,
            0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 0x086D3D2D, 0x91646C97, 0xE6635C01,
            0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457,
            0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65,
            0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB,
            0x4369E96A, 0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9,
            0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
            0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81, 0xB7BD5C3B, 0xC0BA6CAD,
            0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739, 0x9DD277AF, 0x04DB2615, 0x73DC1683,
            0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8, 0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1,
            0xF00F9344, 0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7,
            0xFED41B76, 0x89D32BE0, 0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5,
            0xD6D6A3E8, 0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
            0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF, 0x4669BE79,
            0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703, 0x220216B9, 0x5505262F,
            0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D,
            0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713,
            0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21,
            0x86D3D2D4, 0xF1D4E242, 0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777,
            0x88085AE6, 0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45,
            0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D, 0x3E6E77DB,
            0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 0x47B2CF7F, 0x30B5FFE9,
            0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605, 0xCDD70693, 0x54DE5729, 0x23D967BF,
            0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94, 0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D
        };

    static long CalcCRC32(byte[] content, int prev) {

        if (content == null || content.Length <= 0) return 0;

        long ret = prev ^ 0xFFFFFFFF;

        for (int idx = 0; idx < content.Length; ++idx) {
            ret = (ret >> 8) ^ CrcTable[(ret ^ content[idx]) & 0xFF];
        }

        return ret ^ 0xFFFFFFFF;
    }




    public static bool CheckCRC(string FileA, string FileB)
    {

        FileStream fsa = new FileStream(FileA, FileMode.Open, FileAccess.Read);
        byte[] buffurA = new byte[fsa.Length];
        try
        {
            fsa.Read(buffurA, 0, (int)fsa.Length);
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);

        }
        finally
        {
            if (fsa != null)
            {
                fsa.Close();
            }
        }


        FileStream fsb = new FileStream(FileB, FileMode.Open, FileAccess.Read);
        byte[] buffurB = new byte[fsb.Length];
        try
        {
            fsb.Read(buffurB, 0, (int)fsb.Length);
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
        }
        finally
        {
            if (fsb != null)
            {
                fsb.Close();
            }
        }


        if (fsa != null && fsb != null)
        {
            long crcA = CalcCRC32(buffurA, 0);
            long crcB = CalcCRC32(buffurB, 0);

            if (crcA == crcB) return true;
        }


        return false;
    }

    public static MemoryStream Encrypt(byte[] inData, string key, string iv, MemoryStream ms)
    {
        try
        {
            byte[] btKey = Encoding.UTF8.GetBytes(key);

            byte[] btIV = Encoding.UTF8.GetBytes(iv);

            DESCryptoServiceProvider des = new DESCryptoServiceProvider();

            try
            {
                CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(btKey, btIV), CryptoStreamMode.Write);

                cs.Write(inData, 0, inData.Length);

                cs.FlushFinalBlock();


                // ms.Flush();
                return ms;
            }
            catch (System.Exception e)
            {
                Debug.LogError(e.ToString());
                return null;
            }

        }
        catch
        {

            Debug.LogError("Encrypt Error!!");
            return null;
        }

       
    }



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

    
}
