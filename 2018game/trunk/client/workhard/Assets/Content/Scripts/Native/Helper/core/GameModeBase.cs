using UnityEngine;
using System.Collections.Generic;
using SLua;

/***
 * GameModeBase class:: this is the base class of game mode. it will send unity system events to 
 * each xxxGameMode.lua script. So we can update all logic with bundle asset, not with re-cook whole game package. 
 * NOTE::lua script must contain one function at least which name must as same as this class contains. 
 * Generally xxxGameMode.lua file must contain Update and OnDestroy functions.
 * eg:: 
 * local tmpGameMode = {}
 * function tmpGameMode.Start()
 * end 
 * return tmpGameMode
 **/

/// <summary>
/// Define game state
/// </summary>
[CustomLuaClass]
public enum EGameState
{
    EGS_WaitStart = 0,
    EGS_Start = 1,
    EGS_Playing = 2,
    EGS_Paused = 3,
    EGS_Ended = 4,
    EGS_MAX = 5,
}


public class FLuaBind
{
    public LuaTable luaTable = null;
    public string luaFileName = "";
}

[CustomLuaClass]
public class GameModeBase : MonoBehaviour
{
    /// <summary>
    /// Game mode singleton
    /// </summary>
    [DoNotToLua]
    private static GameModeBase _gameMode = null;


    [DoNotToLua]
    private EGameState _gameState = EGameState.EGS_WaitStart;

    /// <summary> 
    /// game state
    /// </summary>
    public EGameState gameState { get { return _gameState; } }

    public static GameModeBase GameMode
    {
        get
        {
            return _gameMode;
        }
    }

    /// <summary>
    /// Cache lua game mode. the file includes all level basic logic. such as level mission, etc.
    /// </summary>
    [DoNotToLua]
    private FLuaBind luaGameMode = new FLuaBind();


    [DoNotToLua]
    protected virtual void Awake()
    {
        if(_gameMode == null)
        {
            _gameMode = this;
        }
        DontDestroyOnLoad(this.gameObject);
    }

    [DoNotToLua]
	// Update is called once per frame
	protected virtual void Update ()
    {
        if (luaGameMode != null && luaGameMode.luaTable != null)
        {
            LuaFunction luaUpdate = luaGameMode.luaTable["_Update"] as LuaFunction;
            if(luaUpdate != null)
            {
                luaUpdate.call(luaGameMode.luaTable);
            }
            else
            {
                Debug.LogWarning("[GameModeBase]:; Miss update function. LuaGameMode is:: " + luaGameMode.luaFileName);
            }
        }
	}

    //Fixed update.execution ratio can be set in player setting window
    [DoNotToLua]
    protected virtual void FixedUpdate()
    {
        if (luaGameMode != null && luaGameMode.luaTable != null)
        {
            LuaFunction luaUpdate = luaGameMode.luaTable["_FixedUpdate"] as LuaFunction;
            if (luaUpdate != null)
            {
                luaUpdate.call(luaGameMode.luaTable);
            }
            else
            {
                Debug.LogWarning("[GameModeBase]:; Miss FixedUpdate function. LuaGameMode is:: " + luaGameMode.luaFileName);
            }
        }
    }

    [DoNotToLua]
    protected virtual void OnDestroy()
    {
        if(luaGameMode != null)
        {
            if(luaGameMode.luaTable != null)
            {
                LuaFunction luaOnDestroy = luaGameMode.luaTable["_OnDestroy"] as LuaFunction;
                if(luaOnDestroy != null)
                {
                    luaOnDestroy.call(luaGameMode.luaTable);
                }
                else
                {
                    Debug.LogError("[GameModeBase]:: Can not load OnDestroy function from " + luaGameMode.luaFileName);
                }
            }
        }

        _gameMode = null;
    }

    #region public interface
    /// <summary>
    /// Bind lua game mode logic with level basic game mode component.if failed to bind, maybe game will not normally execute.
    /// this function must be invoked after lua game mode has been loaded.
    /// </summary>
    /// <param name="inGameMode">lua script table</param>
    /// <param name="luaGameModeFileName">name of lua script</param>
    /// <returns>return true if successfully band. otherwise false</returns>
    public bool BindLuaGameMode(LuaTable inGameMode, string luaGameModeFileName)
    {
        Debug.Log("[GameModeBase]::GameMode is " + luaGameModeFileName);
        if (luaGameMode != null)
        {
            if (luaGameMode.luaTable != null && luaGameMode.luaFileName.Equals(luaGameModeFileName))
            {
                Debug.LogWarning("[GameModeBase]:: repeat band game mode logic.please check game code and fixed this. will return.....  ");
                return true;
            }

            if (luaGameMode.luaTable != null && !luaGameMode.luaFileName.Equals(luaGameModeFileName))
            {
                Debug.LogError("[GameModeBase]:: repeat band game mode logic. are you sure re-bind game logic with " + luaGameModeFileName + "?? currently this was forbidden");
                return false;
            }
        }
        else
        {
            luaGameMode = new  FLuaBind();
        }

        if(inGameMode == null)
        {
            Debug.LogError("[GameModeBase]:: invalid game mode.... please try to fixed this");
            return false;
        }

        if(string.IsNullOrEmpty(luaGameModeFileName))
        {
            Debug.LogWarning("[GameModeBase]:: invalid game mode file name. will allow game execution, but please fixed this bug as soon as possible");
        }

        _gameState = EGameState.EGS_Start;
        luaGameMode.luaTable = inGameMode;
        luaGameMode.luaFileName = luaGameModeFileName;

        return true;
    }

    /// <summary>
    /// unbind lua game mode
    /// </summary>
    public void RemoveLuaGameMode()
    {
        if(luaGameMode != null)
        {
            _gameState = EGameState.EGS_WaitStart;
            luaGameMode.luaTable = null;
            luaGameMode.luaFileName = null; 
        }
    }

    /// <summary>
    /// free static game mode instance object. this only be invoked from OnDestroy funtion of LuaGameModeBase script
    /// </summary>
    public void FreeGameMode()
    {
        _gameMode = null;
    }

    /// <summary>
    /// End game
    /// </summary>
    /// <param name="endReason">game end reason</param>
    /// <param name="bSuccess">whether pass this level</param>
    public void  EndGame(string endReason)
    {
        _gameState = EGameState.EGS_Ended;
        if(GameManager.Instance != null)
        {
            GameManager.Instance.EndGame();
        }
    }

    /// <summary>
    /// play game
    /// </summary>
    public void PlayGame()
    {
        if (_gameState == EGameState.EGS_Start || _gameState == EGameState.EGS_WaitStart)
            _gameState = EGameState.EGS_Playing;
    }

    /// <summary>
    /// pause game
    /// </summary>
    public void PauseGame()
    {
        if (_gameState == EGameState.EGS_Playing)
            _gameState = EGameState.EGS_Paused;
    }

    /// <summary>
    /// resume game
    /// </summary>
    public void ResumeGame()
    {
        if (_gameState == EGameState.EGS_Paused)
            _gameState = EGameState.EGS_Playing;
    }
    #endregion
}
