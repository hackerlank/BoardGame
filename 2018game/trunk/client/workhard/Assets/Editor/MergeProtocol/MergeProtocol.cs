using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using CustomTool;
using System.IO;

public class MergeProtocol
{
    /// <summary>
    /// test build bundle manager file
    /// </summary>
    [MenuItem("CustomTool/Merge Protocol")]
    public static void MergeProtocols()
    {
        string project_root = Application.dataPath;

        string client_root = project_root + "/Content/Scripts/Lua/network";

        int clientPos = project_root.LastIndexOf("client");

        string serverProtocolRoot = project_root.Substring(0, clientPos) + "server/";

        string client_msg_path = client_root + "/msg_id/";
        string client_sproto_path = client_root + "/sproto/";
        string client_type_path = client_root + "/types/";

        List<string> configs = new List<string>();

        string config_file_path = project_root + "/Editor/MergeProtocol/NeedCopyProtocolConfig.txt";

        FileStream fs = new FileStream(config_file_path, FileMode.Open);
        if (fs != null)
        {
            StreamReader reader = new StreamReader(fs);

            if (reader != null)
            {
                string line = reader.ReadLine();
                while (line != null)
                {
                    if (line != "")
                    {
                        configs.Add(line);
                    }

                    line = reader.ReadLine();
                }
            }

            reader.Close();
        }

        fs.Close();

        if (Directory.Exists(client_type_path) == false)
        {
            Directory.CreateDirectory(client_type_path);
        }

        if (Directory.Exists(client_msg_path) == false)
        {
            Directory.CreateDirectory(client_msg_path);
        }

        if (Directory.Exists(client_sproto_path) == false)
        {
            Directory.CreateDirectory(client_sproto_path);
        }

        //clear msg path
        FileSystem.ClearFilesSkipExtend(client_msg_path, ".meta");
        FileSystem.ClearFilesSkipExtend(client_sproto_path, ".meta");

        List<string> files = new List<string>();



        string serverProtocolPath = "";
        while (configs.Count > 0)
        {

            string tmpFilePath = configs[0];
            serverProtocolPath = serverProtocolRoot + tmpFilePath;

            string prefix = "";
            if (tmpFilePath.StartsWith("games"))
            {
                serverProtocolPath += "/sproto";
                if (tmpFilePath.Contains("/") == true)
                {
                    prefix = string.Format("{0}_", tmpFilePath.Substring(tmpFilePath.LastIndexOf("/") + 1, tmpFilePath.Length - tmpFilePath.LastIndexOf("/") - 1));
                }
            }

            files.Clear();
            if (Directory.Exists(serverProtocolPath))
            {
                files = FileSystem.GetSubFiles(serverProtocolPath);

                foreach (string file in files)
                {

                    if (file.ToLower().Equals("test.sproto") || file.ToLower().Equals("netpack.sproto") || file.ToLower().Equals("test.msgid.lua"))
                        continue;

                    int startIdx = file.LastIndexOf(".");
                    string extension = file.Substring(startIdx + 1, file.Length - startIdx - 1);
                    string sourceFile = serverProtocolPath + "/" + file;

                    string content = File.ReadAllText(sourceFile, System.Text.Encoding.UTF8);

                    int charIdx = file.LastIndexOf("/");

                    string parent = null;
                    if (charIdx > 0)
                        parent = file.Substring(0, file.LastIndexOf("/"));

                    string desFile = "";
                    if (extension.ToLower().Equals("sproto"))
                    {
                        if (string.IsNullOrEmpty(parent) == false)
                        {
                            Directory.CreateDirectory(client_sproto_path + parent);
                        }
                        desFile = client_sproto_path + prefix + file.Replace(".", "_") + ".lua";
                        FileSystem.ReplaceFile(desFile, content);
                    }
                    else if (extension.ToLower().Equals("lua"))
                    {
                        string splitchar = ".";
                        string[] str = file.Split(splitchar.ToCharArray());
                        string fileName = file;
                        if (tmpFilePath.Equals("types") == false)
                        {
                            if (str.Length == 3)
                                fileName = prefix + str[0] + "_" + str[1] + ".lua";

                            if (string.IsNullOrEmpty(parent) == false)
                            {
                                Directory.CreateDirectory(client_msg_path + parent);
                            }
                            desFile = client_msg_path + fileName;
                        }
                        else
                        {
                            desFile = client_type_path + file;
                        }
                        FileSystem.ReplaceFile(desFile, content);
                    }

                    Debug.Log(string.Format("{0} ... {1}", file, desFile));
                }
            }
            else
            {
                Debug.LogError("Failed to find directory " + serverProtocolPath);
            }
            configs.RemoveAt(0);
        }

    }

    public class FEmoji
    {
        public bool bIsStatic;
        public string tag;
        public string content;
    }


    [MenuItem("CustomTool/Merge Emoji")]
    public static void MergeEmojiss()
    {
        string project_root = Application.dataPath;

        string emoji_path = "Assets/Content/ArtWork/UI/Common/emoji";
        string emoji_config_path = "Assets/Content/Setting/Common/Emojis.txt";

      
        List<FEmoji> emojis = new List<FEmoji>();
        List<string> files = FileSystem.GetSubFiles(emoji_path);
        foreach (string file in files)
        {
            string extend = file.Substring(file.LastIndexOf(".") + 1, file.Length - file.LastIndexOf(".") - 1);
            if (extend != "meta")
            {
                if(extend == "asset")
                {
                    SpriteAsset asset = AssetDatabase.LoadAssetAtPath<SpriteAsset>(emoji_path + "/" + file);
                    if(asset != null)
                    {
                        string path = AssetDatabase.GetAssetPath(asset.texSource);
                        if (asset._IsStatic)
                        {
                            continue;
                            //if(asset.listSpriteGroup != null)
                            //{
                            //    foreach(var sprite in asset.listSpriteGroup)
                            //    {
                            //        FEmoji emoji = new FEmoji();
                            //        emoji.bIsStatic = true;
                            //        emoji.tag = sprite.tag;
                            //        emoji.content = string.Format("[{0}#{1}]", asset.ID, sprite.listSpriteInfor[0].name);
                            //        emojis.Add(emoji);
                            //    }
                            //}
                        }
                        else
                        {
                            if (asset.listSpriteGroup != null)
                            {
                                foreach (var sprite in asset.listSpriteGroup)
                                {
                                    FEmoji emoji = new FEmoji();
                                    emoji.bIsStatic = false;
                                    emoji.tag = sprite.tag;
                                    emoji.content = string.Format("[{0}#{1}]", asset.ID, sprite.listSpriteInfor[0].name);
                                    emojis.Add(emoji);
                                }
                            }
                        }
                    }
                }
              
            }

        }

        string s = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(emojis));
        FileSystem.ReplaceFile(emoji_config_path, s);
        AssetDatabase.Refresh();
        //int clientPos = project_root.LastIndexOf("client"); 
    }
}

