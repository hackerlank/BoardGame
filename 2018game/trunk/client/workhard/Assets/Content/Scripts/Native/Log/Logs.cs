using UnityEngine;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine.Events;

[SLua.CustomLuaClass]
public class FLog
{
    public string content = "";
    public string track = "";
    public LogType logType = LogType.Log;
}

[SLua.CustomLuaClass]
/// <summary>
/// save log to local disk
/// </summary>
public class Logs
{
    private string logPath = "";
    static List<object> mWriteTxt = new List<object>();


    private static Logs _instance = null;

    [SLua.DoNotToLua]
    private static SLua.LuaTable _luaTable = null;

    [SLua.DoNotToLua]
    private SLua.LuaFunction m_onLogCallback = null;
    public SLua.LuaTable luaTable
    {
        set
        {
            _luaTable = value;

        }
        protected get { return _luaTable; }
    }

    public static Logs Instance
    {
        get
        {
            if(_instance == null)
            {
                _instance = new Logs();
            }

            return _instance;
        }
    }

    public void Init(bool bLogEnabled)
    {
        Debug.logger.logEnabled = bLogEnabled;

        if(Debug.logger.logEnabled)
        {
 
            if (GameHelper.isDistribution)
            {
                logPath = CustomTool.FileSystem.logPath + "/RuntimeLog.txt";
                CustomTool.FileSystem.ClearPath(CustomTool.FileSystem.logPath, false);
            }
            else
            {
                int file_count = CustomTool.FileSystem.GetSubFiles(CustomTool.FileSystem.logPath).Count;
                file_count++;
                logPath = CustomTool.FileSystem.logPath + "/RuntimeLog_" + file_count + ".txt";
            }
 
            FileStream fs = File.Create(logPath);
            if(null != fs)
            {
                fs.Close();
            }

            ////registered call back function
            Application.logMessageReceived += OnLogCallback;
        }
    }

    public void OnDestroy()
    {
        if(Debug.logger.logEnabled)
        {
            Application.logMessageReceived -= OnLogCallback;
        }

        _instance = null;
    }

    static void OnLogCallback(string InContent, string InTraceBack, LogType InType)
    {
        FLog log = new FLog();
        log.content = InContent;
        log.track = InTraceBack;
        log.logType = InType;
        mWriteTxt.Add(log); 
    }


    public void Update()
    {
        if(mWriteTxt != null && mWriteTxt.Count > 0)
        {
            if (_luaTable != null)
            {
                SLua.LuaFunction callback = _luaTable["OnLogCallback"] as SLua.LuaFunction;
                if (callback != null)
                {
                    callback.call(mWriteTxt[0]);
                }
            }

            using (StreamWriter writer = new StreamWriter(logPath, true, Encoding.UTF8))
            {
                FLog log = mWriteTxt[0] as FLog;

                string s = string.Format("{0}\n{1}", log.content, log.track);
                writer.WriteLine(s);
                writer.Close();
            }     
            mWriteTxt.RemoveAt(0);
        }
       
    }

}
