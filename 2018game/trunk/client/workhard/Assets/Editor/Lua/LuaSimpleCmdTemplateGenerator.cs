using UnityEngine;
using System.IO;
using UnityEditor;
public class LuaSimpleCmdTemplateGenerator: UnityEditor.ProjectWindowCallback.EndNameEditAction
{

    // Template content for lua  view file.
    private const string DefaultContent =
@"--[[
  * COMMAND:: $CLASS. 
  *   edit helpful in here ......
  *
  *   call this by sending one notification with facade. like::
  *   facade:sendNotification(command-string ,note) 
]]

local $CLASS = class('$CLASS', pm.SimpleCommand)

--log function reference. you can remove all of this, if this command never output log
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--replace nn with xxx
--local game_proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)

--constructor function. do not overwrite it
function $CLASS:ctor()
    self.executed = false
end

--coding function in here
function $CLASS:execute(note)
    --Log('$CLASS')
end

return $CLASS";

    [MenuItem("Assets/Create/Game Lua/Lua simple-cmd Script")]
    public static void Create()
    {
        TextAsset Asset = new TextAsset();
        UnityEditor.ProjectWindowUtil.StartNameEditingIfProjectWindowExists(
            Asset.GetInstanceID(),
            ScriptableObject.CreateInstance<LuaSimpleCmdTemplateGenerator>(),
            "Assets.asset",
            AssetPreview.GetMiniThumbnail(Asset),
            null);
    }

    public override void Action(int InstanceId, string PathName, string ResourceFile)
    {
        string NameForLuaFile = Path.ChangeExtension(PathName, ".lua");
        string ClassName = Path.GetFileNameWithoutExtension(NameForLuaFile);
        string Content = DefaultContent.Replace("$CLASS", ClassName);
        StreamWriter Writer = new StreamWriter(new FileStream(NameForLuaFile, FileMode.OpenOrCreate));
        Writer.Write(Content);
        Writer.Flush();
        Writer.Close();
        AssetDatabase.Refresh();

    }
}
