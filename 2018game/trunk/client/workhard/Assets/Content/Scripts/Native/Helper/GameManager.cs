using UnityEngine;
using System.Collections.Generic;
using UnityEngine.Events;
using SLua;


/// <summary>
/// Global manager. It will send level events to GameManager.lua.
/// </summary>
[CustomLuaClass]
public class GameManager : MonoBehaviour
{

    /// <summary>
    /// Global instance 
    /// </summary>
    [DoNotToLua]
    private static GameManager GInstance = null;


    [DoNotToLua]
    private FLuaBind luaGameManager = new FLuaBind();

    /// <summary>
    /// loading level events
    /// </summary>
    [DoNotToLua]
    private FLoadlevelProgress _onAsyncLoadLevel = new FLoadlevelProgress();

    /// <summary>
    /// get the reference of loading level event
    /// </summary>
    public FLoadlevelProgress onAsyncLoadLevel { get { return _onAsyncLoadLevel; } }

    /// <summary>
    /// loading level operation
    /// </summary>
    [DoNotToLua]
    AsyncOperation operation = null;

    /// <summary>
    /// return the global instance object of GameManager
    /// </summary>
    public static GameManager Instance
    {
        get
        {
            return GInstance;
        }
    }

    /// <summary>
    /// Get Default Game mode
    /// </summary>
    public  int defaultGameType
    {
        get
        {
            return (int)DefinedMacro.getGameType;
        }
    }

    #region Unity Events
    /// <summary>
    /// init game manager global instance object
    /// </summary>
    [DoNotToLua]
    private void Awake()
    {
        //dont destroy this game object
        DontDestroyOnLoad(this.gameObject);

        //cache instance
        GInstance = this;

        UnityEngine.SceneManagement.SceneManager.sceneLoaded += onSceneLoaded;
    }

	//Update is called once per frame
    [DoNotToLua]
	private void Update ()
    {
        if (luaGameManager != null && luaGameManager.luaTable != null)
        {
            LuaFunction luaUpdate = luaGameManager.luaTable["Update"] as LuaFunction;
            if (luaUpdate != null)
            {
                luaUpdate.call();
            }
            else
            {
                Debug.LogWarning("[GameManager]:; Miss update function. LuaGameManger is:: " + luaGameManager.luaFileName);
            }
        }

        if(operation != null && _onAsyncLoadLevel != null)
        {
            _onAsyncLoadLevel.Invoke(operation.progress);

            if(operation.isDone)
            {
                operation = null;
            }
        }
    }

    //Fixed update. execution ratio can be set in player setting window
    [DoNotToLua]
    private void FixedUpdate()
    {
        if (luaGameManager != null && luaGameManager.luaTable != null)
        {
            LuaFunction luaUpdate = luaGameManager.luaTable["FixedUpdate"] as LuaFunction;
            if (luaUpdate != null)
            {
                luaUpdate.call();
            }
            else
            {
                Debug.LogWarning("[GameManager]:; Miss FixedUpdate function. LuaGameManger is:: " + luaGameManager.luaFileName);
            }
        }
    }

    //Free memory in here. Also send notifications
    [DoNotToLua]
    private void OnDestroy()
    {
        if(luaGameManager != null)
        {
            if(luaGameManager.luaTable != null)
            {
                LuaFunction luaOnDestroy = luaGameManager.luaTable["OnDestroy"] as LuaFunction;
                if (luaOnDestroy != null)
                {
                    luaOnDestroy.call();
                }
                else
                {
                    Debug.LogWarning("[GameManager]:; Miss OnDestroy function. LuaGameManger is:: " + luaGameManager.luaFileName);
                }
            }
            luaGameManager.luaTable = null;
            luaGameManager.luaFileName = "";
            luaGameManager = null;
        }

        if(GInstance != null)
        {
            UnityEngine.SceneManagement.SceneManager.sceneLoaded -= onSceneLoaded;
            GInstance = null;
        }
    }


    #if !UNITY_EDITOR
        float m_fLostFocusRealTime = 0;
        [DoNotToLua]
        private void OnApplicationFocus(bool bFocus)
        {
            if(luaGameManager != null)
            {
                if(luaGameManager.luaTable != null)
                {
                    LuaFunction luaOnApplicationFocus = luaGameManager.luaTable["OnApplicationFocus"] as LuaFunction;
                    if (luaOnApplicationFocus != null)
                    {
                        luaOnApplicationFocus.call(bFocus);
                    }
                    else
                    {
                        Debug.LogWarning("[GameManager]:; Miss OnDestroy function. LuaGameManger is:: " + luaGameManager.luaFileName);
                    }
                }
            }
        }
    #endif
    #endregion


    #region Level Events
    /// <summary>
    /// this function will be automatic called at once when level was loaded.
    /// Send level loaded events to GameManager.lua file
    /// </summary>
    private void onSceneLoaded(UnityEngine.SceneManagement.Scene scene, UnityEngine.SceneManagement.LoadSceneMode loadSceneMode )
    {
        operation = null;
        //Debug.Log("on scene loaded " + scene.name + " " + Time.time);
        if (luaGameManager != null && luaGameManager.luaTable != null)
        {
            LuaFunction luaLevelLoaded = luaGameManager.luaTable["OnLevelLoaded"] as LuaFunction;
            if (luaLevelLoaded != null)
            {
                string levelName = scene.name;
                luaLevelLoaded.call(levelName);
            }
            else
            {
                Debug.LogWarning("[GameManager]:; Miss OnLevelLoaded function. LuaGameManger is:: " + luaGameManager.luaFileName);
            }
        }
        operation = null;
    }

    [DoNotToLua]
    public void EndGame()
    {
        if(luaGameManager != null && luaGameManager.luaTable != null)
        {
            LuaFunction luaEndGame = luaGameManager.luaTable["GameEnded"] as LuaFunction;
            if(luaEndGame != null)
            {
                luaEndGame.call();
            }
        }
    }

    public void BindGameManager(LuaTable inTable, string luaFile)
    {
        if(luaGameManager == null)
        {
            luaGameManager = new FLuaBind();
        }
        if(inTable != null && luaGameManager.luaTable == null)
        {
            luaGameManager.luaTable = inTable;
            luaGameManager.luaFileName = luaFile;
        }
    }

    /// <summary>
    /// whether can bind lua game manager
    /// </summary>
    public bool isCanBind
    {
        get
        {
            if (luaGameManager == null)
                return true;

            if (luaGameManager.luaTable == null)
                return true;

            return false;
        }
    }

    /// <summary>
    /// switch level.default with async modle
    /// </summary>
    /// <param name="levelName"></param>
    /// <param name="bAsyncLoad"></param>
    /// <param name="mode"></param>
    public void SwitchLevel(string levelName, bool bAsyncLoad, UnityEngine.SceneManagement.LoadSceneMode mode)
    {
        if(string.IsNullOrEmpty(levelName))
        {
            Debug.LogError("Invalid level name");
            return;
        }
        if (bAsyncLoad)
        {
            operation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(levelName, mode);
        }
        else
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene(levelName, mode);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="levelName"></param>
    public void UnloadLevel(string levelName)
    {
        if(string.IsNullOrEmpty(levelName))
        {
            return;
        }

        UnityEngine.SceneManagement.SceneManager.UnloadSceneAsync(levelName);
    }

    public string currentScene
    {
        get
        {
            UnityEngine.SceneManagement.Scene scene = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
            if(scene == null)
            {
                return "";
            }
            return scene.name;
        }
    }

    [CustomLuaClass]
    public class FLoadlevelProgress : UnityEvent<float> { public FLoadlevelProgress() { } }
    #endregion

}
