using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class LuaMedaitorTemplateGenerator : UnityEditor.ProjectWindowCallback.EndNameEditAction
{

    // Template content for lua file.
    private const string DefaultContent =
@"--[[
  * ui mediator class:: $CLASS
  * inherits from mediator class of lua mvc plugin. control view render state
  * @ctor
  *   don't recoding
  * @listNotificationInterests
  *   list all notifications that self interests
  * @handleNotification
  *   deal notification events
  * @OnDisable
  *   this function will be invoked when player is hiding window.each of menu 
  *   view class must contains it.called by ui manager
  * @OnRestore
  *   this function will be invoked when player wants to active self. called by ui manager
  * @OnClose
  *   this function will be called when player is closing self. called by ui mediator.
]]

--must named file first
local mediator = class('$CLASS',pm.Mediator)
local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
--mediator constructor function.
function mediator:ctor(mediatorName,viewComponent)
    self.super.ctor(self,mediatorName,viewComponent)
end 

--list all notification that self want to listen
function mediator:listNotificationInterests()
    local notification = {}
    table.insert(notification, Common.ON_TOUCHED_EXIT_BTN)
	return notification
end

--handle notification events
function mediator:handleNotification(notification)
    local name = notification:getName()
    local body = notification:getBody()
    if Common.ON_TOUCHED_EXIT_BTN == name then 
        --send exit game command in here
        facade:sendNotification('leave_game_command -- need to be overwrite')
    end 
end

--Opened:: dont remove.. called by uimanager
function mediator:Opened(param)
    self.viewComponent:SetMediator(self)

    if param and param:GetCallBack() ~= nil then 
        local cb = param:GetCallBack()
        cb()
    end 
end 

--OnRestore:: dont remove.. called by uimanager
function mediator:OnRestore()
    if self.viewComponent ~= nil  then 
        if self.viewComponent.OnRestore then 
            self.viewComponent:OnRestore()
        end 
    end 
end 

--OnDisable:: dont remove.. called by uimanager
function mediator:OnDisable()
    if self.viewComponent ~= nil  then 
        if self.viewComponent.OnDisable then 
            self.viewComponent:OnDisable()
        end 
    end
end 

--OnClose:: dont remove.. called by uimanager
function mediator:OnClose()
    if self.viewComponent ~= nil  then 
        if self.viewComponent.OnClose then
            self.viewComponent:OnClose()
        elseif self.viewComponent.SafeRelease then 
            self.viewComponent:SafeRelease()
        end 
    end 
    self.viewComponent = nil
end 

--onRemove:: dont remove.. called by super class
function mediator:onRemove()
    self = nil
end

return mediator";
	
	[MenuItem("Assets/Create/Game Lua/Lua Mediator Script")]
	public static void Create() {
		TextAsset Asset = new TextAsset();
		UnityEditor.ProjectWindowUtil.StartNameEditingIfProjectWindowExists (
			Asset.GetInstanceID(), 
			ScriptableObject.CreateInstance<LuaMedaitorTemplateGenerator>(), 
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
