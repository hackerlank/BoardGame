using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class LuaGameModeTemplateGenerator : UnityEditor.ProjectWindowCallback.EndNameEditAction
{

    string DefaultContent = @"-----------------------------------------------------------------------------
--$CLASS:: 
-- edit helper comment in here
-----------------------------------------------------------------------------

local $CLASS = class('$CLASS', GameModeTemplate)

--log function reference
local Log = UnityEngine.Debug.Log
local LogWarning = UnityEngine.Debug.LogWarning
local LogError = UnityEngine.Debug.LogError


--whether game has been inited
$CLASS.bInited = false

--constructor function
function $CLASS:ctor()
	self.super.ctor(self)
end 

--init function. please set the BGM
function $CLASS:Init()
	self.super.Init(self, '$CLASS', EGameSound.EGS_MAX)
	--start update game content
	self:PlayGame()
end

--start playing game
function $CLASS:PlayGame()
    --write your code before call super function
    self.super.PlayGame()
end 

--Update is called once per frame
function $CLASS:Update()
	self.super.Update(self)
end 

--FixedUpdate. This can be deleted
function $CLASS:FixedUpdate()
	self.super.FixedUpdate(self)
end 

--end game
--@param endReason kill game reason
function $CLASS:EndGame(endReason)
    self.super.EndGame(endReason)



    local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
    facade:sendNotification(Common.EXIT_GAME_COMMAND)
end

--safe release assets and references.
function $CLASS:OnLeaveLevel()
    self.super.OnLeaveLevel(self)

    self = nil
end 

return $CLASS";

    [MenuItem("Assets/Create/Game Lua/Lua Game Mode")]
    public static void Create()
    {
        TextAsset Asset = new TextAsset();
        UnityEditor.ProjectWindowUtil.StartNameEditingIfProjectWindowExists(
            Asset.GetInstanceID(),
            ScriptableObject.CreateInstance<LuaGameModeTemplateGenerator>(),
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
