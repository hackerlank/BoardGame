using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;

/// <summary>
/// This class is used to descript all pre_defined macro of games.
/// DONt directly visit all property or interface of it. Please visit it by using GameHelper.
/// </summary>
public class DefinedMacro
{
    public static readonly string GAME_DEFINED_MACRO_FILE = "DefinedMacro";

    public class FGameMacro
    {
        public bool bUseBundle;
        public bool bUseLuajit;
        public bool bLogEnabled;
        public bool bSkipCheckAPK;
        public int gameType;
        public bool bCompressedBundle;
        public bool bSkipUpdate;
        public bool bWithWeChat;

        public FGameMacro()
        {
            bUseBundle = true;
            bUseLuajit = true;
            bLogEnabled = true;
            bSkipCheckAPK = true;
            gameType = 0;
            bCompressedBundle = true;
            bSkipUpdate = false;
            bWithWeChat = true;
        }
    }

    private static FGameMacro _GameMacro = null;

    public static void Init()
    {
        if (_GameMacro == null)
        {
            TextAsset asset = Resources.Load<TextAsset>(GAME_DEFINED_MACRO_FILE);
            if(asset == null)
            {
                _GameMacro = new FGameMacro();
            }
            else
            {
                if(string.IsNullOrEmpty(asset.text))
                {
                    _GameMacro = new FGameMacro();
                    #if UNITY_EDITOR
                        string content = JsonFormatter.PrettyPrint( LitJson.JsonMapper.ToJson(_GameMacro));
                        CustomTool.FileSystem.ReplaceFile("Assets/Resources/" + GAME_DEFINED_MACRO_FILE + GameHelper.SETTING_FILE_EXTENSION, content);
                    #endif
                }
                else
                { 
                    _GameMacro = LitJson.JsonMapper.ToObject<FGameMacro>(asset.text);
                    if(_GameMacro.bUseBundle == false)
                    {
                        #if (UNITY_IPHONE || UNITY_ANDROID) && !UNITY_EDITOR
                            _GameMacro.bUseBundle = true;
                        #endif
                    }
                }
            }
        }
    }

    public static bool isWithBundle
    {
        get
        {
            if (_GameMacro == null)
                return true;

            return _GameMacro.bUseBundle;
        }
    }

    public static bool isWithLuajit
    {
        get
        {
            if(_GameMacro == null)
            {
                return true;
            }

            return _GameMacro.bUseLuajit;
        }
    }

    public static bool isLogEnabled
    {
        get
        {
            if (_GameMacro == null)
                return false;

            return _GameMacro.bLogEnabled;
        }
    }

    public static bool isSkipCheckAPK
    {
        get
        {
            if (_GameMacro == null)
                return true;

            return _GameMacro.bSkipCheckAPK;
        }
    }

    public static int getGameType
    {
        get
        {
            if (_GameMacro == null)
                return 10000;
            return _GameMacro.gameType;
        }
    }


    public static bool isCompressedBundle
    {
        get
        {
            if (_GameMacro == null)
            {
                return true;
            }
            return _GameMacro.bCompressedBundle;
        }
    }

    public static bool isSkipUpdate
    {
        get
        {
            if (_GameMacro == null)
            {
                return false;
            }
            return _GameMacro.bSkipUpdate;
        }
    }

    public static bool isWithWeChat
    {
        get
        {
            if(_GameMacro == null)
            {
                return true;
            }
            return _GameMacro.bWithWeChat;
        }
    }

    public static void  OnDestroy()
    {
        _GameMacro = null;
    }


}
