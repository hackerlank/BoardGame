using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using System.IO;

public enum EGameType
{
    EGT_Fish = 1,
    EGT_Fish2d = 2,
    EGT_NiuNiu=3,
    EGT_BlackJack=4,//21点
    EGT_Baccarat=5, //百家乐
    EGT_ShuiHuZhuan=6, //slot
    EGT_MAX = 10000,
}

public class GameMacroWindow : EditorWindow
{

    private static readonly string PATH_OF_MACRO_TEMPLATE = "Assets/Editor/GameMacro/GameMacroTemplate.txt";

    private static readonly string TARGET_GAME_MACRO_FILE = "Assets/Resources/DefinedMacro";


    private static readonly string USE_BUNDLE_KEY = "USE_BUNDLE";
    private static readonly string USE_LUAJIT = "USE_LUAJIT";
    private static readonly string ENABLED_LOGS = "LOG";
    private static readonly string SKIP_CHECK_APK = "SKIP_CHECK_APK";
    private static readonly string GAME_TYPE = "GAME_TYPE";
    private static readonly string BUNDLE_COMPRESSED = "BUNDLE_COMPRESSED";
    private static readonly string SKIP_UPDATE = "SKIP_UPDATE";
    private static readonly string USE_WECHAT = "USE_WECHAT";

    private static Vector2 ScrollPos = Vector2.zero;


    private static int changedCount = 0;

    private static Dictionary<string, bool> _saved = new Dictionary<string, bool>();

    private static Dictionary<string, int> _savedGameType = new Dictionary<string, int>();

    private static List<string> games = new List<string>();

   

    private class FGameMacroListItem
    {
        public string title = "";
        public string macro = "";
        public bool value = true;
        public int gameType = 0;
        public FGameMacroListItem()
        {

        }

        public FGameMacroListItem(string inTitle, string inMacro, bool inValue)
        {
            title = inTitle;
            macro = inMacro;
            value = inValue;
        }

        public FGameMacroListItem(string inTitle, string inMacro, int inGameType)
        {
            title = inTitle;
            macro = inMacro;
            gameType = inGameType;
        }
    }

    private static List<FGameMacroListItem> _list = new List<FGameMacroListItem>();

    /// <summary>
    /// open definition game macro window
    /// </summary>
    [MenuItem("CustomTool/GameMacro/SetGameMacro")]
    public static void OpenGameMacroWin()
    {
        if(File.Exists(PATH_OF_MACRO_TEMPLATE) == false)
        {
            MakeMacroTemplate();
        }

        TextAsset asset = AssetDatabase.LoadAssetAtPath(PATH_OF_MACRO_TEMPLATE, typeof(TextAsset) )as TextAsset;

        if(asset == null)
        {
            Debug.LogError("Failed to load " + PATH_OF_MACRO_TEMPLATE);
        }
        else
        {
            string text = asset.text;

            _list = LitJson.JsonMapper.ToObject<List<FGameMacroListItem>>(text);
            DefinedMacro.FGameMacro _macro = new DefinedMacro.FGameMacro();

            if(File.Exists(TARGET_GAME_MACRO_FILE + GameHelper.SETTING_FILE_EXTENSION))
            {
                TextAsset ass = Resources.Load("DefinedMacro", typeof(TextAsset)) as TextAsset;
                _macro = LitJson.JsonMapper.ToObject<DefinedMacro.FGameMacro>(ass.text);
            }

            _saved.Clear();
            for (int i=0; i < _list.Count; ++i)
            {
                if (_list[i].macro == USE_BUNDLE_KEY)
                {
                    _list[i].value = _macro.bUseBundle;
                }
                else if (_list[i].macro == USE_LUAJIT)
                {
                    _list[i].value = _macro.bUseLuajit;
                }
                else if (_list[i].macro == ENABLED_LOGS)
                {
                    _list[i].value = _macro.bLogEnabled;
                }
                else if (_list[i].macro == SKIP_CHECK_APK)
                {
                    _list[i].value = _macro.bSkipCheckAPK;
                }
                else if (_list[i].macro == SKIP_UPDATE)
                {
                    _list[i].value = _macro.bSkipUpdate;
                }
                else if (_list[i].macro == GAME_TYPE)
                {
                    _list[i].gameType = _macro.gameType;
                    _savedGameType.Add(_list[i].title, _list[i].gameType);
                    continue;
                }
                else if (_list[i].macro == BUNDLE_COMPRESSED)
                {
                    _list[i].value = _macro.bCompressedBundle;
                }
                else if (_list[i].macro == USE_WECHAT)
                {
                    _list[i].value = _macro.bWithWeChat;
                }

                _saved.Add(_list[i].title, _list[i].value);
            }

            changedCount = 0;

        }

        games.Clear();
        games.AddRange(new string[] { "Fish", "Fish2d", "NiuNiu","BlackJack","Baccarat", "ShuiHuZhuan", "MAX" });

        GetWindow<GameMacroWindow>(true, "Define Game Macro", true);
    }

    private void OnGUI()
    {

        if(_list.Count > 0)
        {
            GUILayout.Space(5);
            ScrollPos = GUILayout.BeginScrollView(ScrollPos, new GUILayoutOption[] { GUILayout.ExpandHeight(true) });
            {
                GUILayout.BeginVertical(BMGUIStyles.GetStyle("Wizard Box"));
                {
                    for (int Index = 0; Index < _list.Count; ++Index)
                    {
                        FGameMacroListItem OneOf = _list[Index];

                       

                        GUILayout.BeginVertical("box");
                        {
                            if (OneOf.title == USE_WECHAT)
                            {
                                GUILayout.Space(10);
                                GUILayout.BeginHorizontal();
                                GUILayout.Label("The third sdk setting");
                                GUILayout.EndHorizontal();
                            }

                            GUILayout.BeginHorizontal();
                            GUILayout.Label(OneOf.title);

                            int section = 0;
                            int result = 0;
                            if (OneOf.macro != GAME_TYPE)
                            {
                                
                                if (OneOf.value)
                                    section = 1;

                               result = EditorGUILayout.Popup(section, new string[] { "false", "true" }, new GUILayoutOption[] { GUILayout.MaxWidth(140) });
                                bool bChanged = OneOf.value != (result == 1);
                                OneOf.value = result == 1;

                                bool bOriginal = _saved[OneOf.title];
                                if (bOriginal == OneOf.value && changedCount > 0 && bChanged)
                                {
                                    changedCount--;
                                }
                                else if (bOriginal != OneOf.value && bChanged)
                                {
                                    changedCount++;
                                }
                            }
                            else
                            {
                                section = OneOf.gameType == (int)EGameType.EGT_MAX ? games.Count - 1 : OneOf.gameType - 1;
                                result = EditorGUILayout.Popup(section, games.ToArray(), new GUILayoutOption[] { GUILayout.MaxWidth(140) });

                                result = result == games.Count - 1 ? (int)EGameType.EGT_MAX : result + 1;
                                bool bChanged = OneOf.gameType != result;
                                OneOf.gameType = result;

                                int Original = _savedGameType[OneOf.title];
                                if (Original == OneOf.gameType && changedCount > 0 && bChanged)
                                {
                                    changedCount--;
                                }
                                else if (Original != OneOf.gameType && bChanged)
                                {
                                    changedCount++;
                                }

                            }

                           
                            GUILayout.EndHorizontal();
                        }
                        GUILayout.EndVertical();
                    }
                }
                GUILayout.EndVertical();
            }
            GUILayout.EndScrollView();
        }
    }



    [MenuItem("CustomTool/GameMacro/MakeMacroTemplate")]
    public static void MakeMacroTemplate()
    {
        
        _list = new List<FGameMacroListItem>();

        _list.Add(new FGameMacroListItem("是否启用bundle:", USE_BUNDLE_KEY, false));
        _list.Add(new FGameMacroListItem("是否启用luajit:", USE_LUAJIT, false));
        _list.Add(new FGameMacroListItem("是否输出log到本地:", ENABLED_LOGS, true));
        _list.Add(new FGameMacroListItem("是否跳过检测APK更新:", SKIP_CHECK_APK, true));
        _list.Add(new FGameMacroListItem("游戏类型:", GAME_TYPE, (int)EGameType.EGT_MAX));
        _list.Add(new FGameMacroListItem("是否压缩bundle:", BUNDLE_COMPRESSED, true));
        _list.Add(new FGameMacroListItem("是否跳过更新:", SKIP_UPDATE, false));
        _list.Add(new FGameMacroListItem("是否使用wechat:", USE_WECHAT, true));

        string content = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(_list));
        CustomTool.FileSystem.ReplaceFile(PATH_OF_MACRO_TEMPLATE, content);

        UnityEditor.AssetDatabase.ImportAsset(PATH_OF_MACRO_TEMPLATE);
        _list.Clear();

    }


    void OnDisable()
    {
        if (changedCount > 0)
        {
            DefinedMacro.FGameMacro _macro = new DefinedMacro.FGameMacro();
            for (int i = 0; i < _list.Count; ++i)
            {
                if (_list[i].macro == USE_BUNDLE_KEY)
                {
                    _macro.bUseBundle = _list[i].value;
                }
                else if (_list[i].macro == USE_LUAJIT)
                {
                    _macro.bUseLuajit = _list[i].value;
                }
                else if (_list[i].macro == ENABLED_LOGS)
                {
                    _macro.bLogEnabled = _list[i].value;
                }
                else if (_list[i].macro == SKIP_CHECK_APK)
                {
                    _macro.bSkipCheckAPK = _list[i].value;
                }
                else if(_list[i].macro == GAME_TYPE)
                {
                    _macro.gameType = _list[i].gameType;
                }
                else if(_list[i].macro == BUNDLE_COMPRESSED)
                {
                    _macro.bCompressedBundle = _list[i].value;
                }
                else if(_list[i].macro == SKIP_UPDATE)
                {
                    _macro.bSkipUpdate = _list[i].value;
                }
                else if(_list[1].macro == USE_WECHAT)
                {
                    _macro.bWithWeChat = _list[i].value;
                }
            }
          //  Debug.Log(_macro.bSkipUpdate);
            string content = JsonFormatter.PrettyPrint(LitJson.JsonMapper.ToJson(_macro));
            CustomTool.FileSystem.ReplaceFile(TARGET_GAME_MACRO_FILE + GameHelper.SETTING_FILE_EXTENSION, content);

            UnityEditor.AssetDatabase.ImportAsset(TARGET_GAME_MACRO_FILE + GameHelper.SETTING_FILE_EXTENSION);
        }

        changedCount = 0;
        _saved.Clear();
        _list.Clear();
        _savedGameType.Clear();
    }
}
