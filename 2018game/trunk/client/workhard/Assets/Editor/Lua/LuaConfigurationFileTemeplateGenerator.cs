using UnityEngine;
using System.IO;
using System.Collections;
using UnityEditor;


public class LuaConfigurationFileTemeplateGenerator : UnityEditor.ProjectWindowCallback.EndNameEditAction
{

    private const string DefaultContent = @"--[[
 * $CLASS configuration file.
 * code helper in here....
 *
]]
local $CLASS = class('$CLASS')

--constructor function 
--@param tbKey keys of configuration file
--@param tbValue values of configuration file
function $CLASS:ctor(tbKey, tbValue)
    self.id = nil
    for k, v in ipairs(tbKey) do
        if v == 'id' then
            self.id = tonumber(tbValue[k])
        end
    end
end

--get item's id
function $CLASS:GetId()
    return self.id
end

--whether the obj is equal self
function $CLASS:isEqual(obj)
    return id == obj:GetId()
end 

--reutrn a string which contains all info of item.
function $CLASS:ToString()
    local t = { 'id=', self.id }
    return  table.concat(t)
end 

return $CLASS";

    [MenuItem("Assets/Create/Game Lua/Lua Data Struct(load configfile)")]
    public static void Create()
    {
        TextAsset Asset = new TextAsset();
        UnityEditor.ProjectWindowUtil.StartNameEditingIfProjectWindowExists(
            Asset.GetInstanceID(),
            ScriptableObject.CreateInstance<LuaConfigurationFileTemeplateGenerator>(),
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
