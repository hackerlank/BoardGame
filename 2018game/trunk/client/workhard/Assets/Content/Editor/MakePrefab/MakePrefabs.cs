using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System;

public class FMakePrefabParam
{
    public string source;
    public string dest;
    public string gameName;
    public EMakePrefab operation = EMakePrefab.EMP_Sound;
    public int act_type; //see user act_type of game
    public string prefab_config_path = "";
    public string source_folder = "";
}

public enum EMakePrefab
{
    EMP_Sound=0,
    EMP_Max=1,
}

public class MakePrefabs //: EditorWindow
{
    public static readonly string PATH_OF_CONFIG = "Assets/Editor/MakePrefab/prefab.txt";

    protected class FOutputSoundConfig
    {
        public int act_type = 0;
        public List<string> soundPaths = new List<string>();
    }

    [MenuItem("CustomTool/MakePrefabs/MakeSoundPrefab")]
    public static void MakeSoundPrefab()
    {

        if (File.Exists(PATH_OF_CONFIG) == false)
        {
           FileStream fs =  File.Create(PATH_OF_CONFIG);
            if (null != fs)
            {
                fs.Close();
            }
            else
            {
                Debug.LogError("Filed create sound prefab configuration file");
                return;
            }
        }

        string content = File.ReadAllText(PATH_OF_CONFIG);
        FMakePrefabParam param = null;
        if (string.IsNullOrEmpty(content))
        {
            param = new FMakePrefabParam();
            param.source = "Assets/Content/ArtWork/Sound/";
            param.dest = "Assets/Content/Prefabs/Sound/";
            param.gameName = "mj_cdxz";
            param.source_folder = "xiayu";
            param.act_type = 1;
            param.prefab_config_path = "Assets/Content/Setting/" + param.gameName + "/gamesound.txt";
            param.operation = EMakePrefab.EMP_Sound;
            string s = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(param));
            CustomTool.FileSystem.ReplaceFile(PATH_OF_CONFIG, s);
            Debug.LogError("miss configuration file. now has create a template that is " + PATH_OF_CONFIG);
            return;
        }
        else
        {
            param = LitJson.JsonMapper.ToObject<FMakePrefabParam>(content);
        }

        bool bNeedSwitchMap = false;
        if (param.operation == EMakePrefab.EMP_Sound)
        {

           
            if (string.IsNullOrEmpty(param.source))
            {
                Debug.LogError("Missed source directory");
                return;
            }

            if (string.IsNullOrEmpty(param.dest))
            {
                Debug.LogError("Missed dest dirctory");
                return;
            }

            if(string.IsNullOrEmpty(param.prefab_config_path))
            {
                Debug.LogError("missed output configuration file of prefabs");
                return;
            }

            List<FOutputSoundConfig> all_config = null;
            //create output configuration file
            if(File.Exists(param.prefab_config_path) == false)
            {
                FileStream fs = File.Create(param.prefab_config_path);
                if(null != fs)
                {
                    fs.Close();
                }
                else
                {
                    Debug.LogError("Failed create file " + param.prefab_config_path);
                    return;
                }

                all_config = new List<FOutputSoundConfig>();
            }
            else
            {
                string text = File.ReadAllText(param.prefab_config_path);
                if(string.IsNullOrEmpty(text) == false)
                {
                    all_config = LitJson.JsonMapper.ToObject<List<FOutputSoundConfig>>(text);
                }
                else
                {
                    all_config = new List<FOutputSoundConfig>();
                }
            }

            string source = param.source + param.gameName + "/" + param.source_folder;

            if(Directory.Exists(source) == false)
            {
                Debug.LogError("missed source directory");
                return;
            }

            string dest = param.dest + param.gameName;

            if (Directory.Exists(dest) == false )
            {
                Directory.CreateDirectory(dest);
            }
            List<string> files = CustomTool.FileSystem.GetSubFiles(source);
            if(files.Count > 0)
            {
                UnityEditor.SceneManagement.EditorSceneManager.NewScene( UnityEditor.SceneManagement.NewSceneSetup.EmptyScene, UnityEditor.SceneManagement.NewSceneMode.Single);
                bNeedSwitchMap = true;
                FOutputSoundConfig new_config = new FOutputSoundConfig();
                new_config.act_type = param.act_type;

                foreach(string file in files)
                {
                    string extend = file.Substring(file.LastIndexOf(".") + 1, file.Length - file.LastIndexOf(".") - 1);

                    if (extend == "meta")
                        continue;
                    int dot_idx = file.LastIndexOf(".");
                    string file_name = file.Substring(0, dot_idx);

                    string src = source + "/" + file;
                    string to = dest + "/" + file_name + ".prefab";
                    Debug.Log(src);
                    UnityEngine.Object obj = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(src);
                    if(obj != null)
                    {
                        GameObject go = new GameObject(file_name);
                        AudioSource tmp = go.AddComponent<AudioSource>();
                        if(tmp != null)
                        {
                            tmp.clip = obj as UnityEngine.AudioClip;
                        }
                        if (go != null)
                        {
                            go.name = file_name;
                            PrefabUtility.CreatePrefab(to, go, ReplacePrefabOptions.ConnectToPrefab);
                            new_config.soundPaths.Add(to);
                            Debug.Log("Made prefab " + to);
                            GameObject.DestroyImmediate(go);
                        }

                    }
                    else
                    {
                        Debug.LogError("Failed to load " + src);
                    }
                }

                bool bExist = false;
                foreach(FOutputSoundConfig config in all_config)
                {
                    if(config.act_type == new_config.act_type)
                    {
                        config.soundPaths.Clear();
                        config.soundPaths.AddRange(new_config.soundPaths);
                        bExist = true;
                        break;
                    }
                }

                if(!bExist)
                {
                    all_config.Add(new_config);
                }

                //now save the file
                string s = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(all_config));

                CustomTool.FileSystem.ReplaceFile(param.prefab_config_path, s);
                AssetDatabase.Refresh();

                if (bNeedSwitchMap)
                {
                    if (EditorBuildSettings.scenes != null && EditorBuildSettings.scenes.Length > 0)
                    {
                        string scene = EditorBuildSettings.scenes[0].path;
                        UnityEditor.SceneManagement.EditorSceneManager.OpenScene(scene, UnityEditor.SceneManagement.OpenSceneMode.Single);
                    }
                }
            }
        }
        else
        {
            Debug.LogError("make prefab operation is not matched.which is " +  param.operation.ToString() + "=" + (int)param.operation);
        }

    }
}
