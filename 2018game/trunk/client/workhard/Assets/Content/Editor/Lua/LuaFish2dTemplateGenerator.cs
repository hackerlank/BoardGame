using UnityEngine;
using System.IO;
using System.Collections;
using UnityEditor;

public class LuaFish2dTemplateGenerator : UnityEditor.ProjectWindowCallback.EndNameEditAction
{
    // Template content for lua file.
    private const string DefaultContent =
@"--[[
 * character class:: $CLASS
 * controls actions of $CLASS
]]
local $CLASS = $CLASS or {}

local Speed = 10;

--swim animation state name
local SWIM_ANIM = 'dy_swim'

--death animation state name
local DEATH_ANIM = 'dy_death'

--death transform condition
local DEATH_TRANSFORM_CONDITON = 'death'

--whether self is bDisabled: Default is true
local bDisabled = true;

--fish action state
local state = Fish2d.EFishAction.EFA_Idle

local damageColor = UnityEngine.Color(255,0,0)

--Init the character
--@param guid the unique id of character.build by game mode
--@param templateID the templateID id of character.
--@param uniqueName the unique name of character.named by game mode
--@param parent character pool of game.
--@param location character's born position
function $CLASS:Init(guid, templateID, uniqueName, parent, location)
    self.effect_coin_comp = 'Games.Fish2d.FishLogic.DropCoinEffect'
    local templateInfo = GetGameConfig():GetFishTemplateInfo(templateID);
    self.uniqueName = uniqueName
    self.Guid = guid
    self.templateID = templateID
    if templateInfo ~= nil then
        self.scale =  templateInfo:GetFishSize()
        self.hitLimit = templateInfo:GetHitLimit()
        self.hitProb = templateInfo:GetHitProbability()
        self.awardMult = templateInfo:GetAwardMultiple()
        self.boundCircleRadius = templateInfo:GetBornRange();
        self.prefabPath = templateInfo:GetPrefabPath()
        self.wholePath = templateInfo:GetFishPath()
    end

    bDisabled = true

    GetResourceManager().LoadAssetAsync(GameHelper.EAssetType.EAT_GameObject, self.prefabPath, function(asset)
        if asset and asset:IsValid() then
            self.fishPrefabAsset = asset
            local char = UnityEngine.GameObject.Instantiate(asset: GetAsset());
            if char then
                self.gameObject = char
                self.transform = self.gameObject.transform
                self.transform.parent = parent.transform;
                self.gameObject.name = uniqueName
                TransformLuaUtil.SetTransformLocalScale(self.transform, self.scale, self.scale, self.scale); -- 暂时使用
                self.GameMode = GetLuaGameManager().GetGameMode();
                self.animator = self.gameObject:GetComponent('Animator')
                self.spriteRenderer = self.gameObject:GetComponent('SpriteRenderer')
                if self.spriteRenderer then
                    self.spriteRendererColor = self.spriteRenderer.color
                end

                self.GameMode:RegisterComponent(self, self.uniqueName)
                self:RegisterCollisionListener()
                self:Start(location)
            end
        end
    end);
end 

--collision event
local function OnCollisionEnter(other)
    if other ~= nil then
        local causer = other.gameObject
        local tag = causer.tag
        if tag == Fish2d.BULLET_TAG then


        end
    end
end 

--bind the collision event
function $CLASS:RegisterCollisionListener()
    if self.gameObject ~= nil then
       self.colliderHelper = self.gameObject:GetComponent('Collider2DHelper')
       if self.colliderHelper ~= nil then
            self.colliderHelper:AddTriggerEnterListener(function(other)
                OnCollisionEnter(other)
            end)
       end
    end
end 

--execute fish logic
function $CLASS:Start(location)
    local pos = location.position
    local rot = location.rotation
    TransformLuaUtil.SetTransformRotation(self.transform, rot.x, rot.y, rot.z, rot.w)
    TransformLuaUtil.SetTransformPos(self.transform, pos.x, pos.y, pos.z)
    bDisabled = false
    self:Swim()
end 

--goto swim state
function $CLASS:Swim()
    self:SetAnimatorBool(DEATH_TRANSFORM_CONDITON, false)
    self:PlayAnimation(SWIM_ANIM)
    state = Fish2d.EFishAction.EFA_Swim
end 

--called once in per frame
function $CLASS:Update()
    if bDisabled then 
        return
    end 

    --walk, run, swim???
    if state == Fish2d.EFishAction.EFA_Idle then

    elseif state == Fish2d.EFishAction.EFA_Swim then
        local position = self.transform.position
        position.x = position.x + Speed * UnityEngine.Time.deltaTime * 2.5
        TransformLuaUtil.SetTransformPos(self.transform, position.x, position.y, position.z)

        if not self.GameMode:IsInWorld(position) then
            self:Suicide()
        end
    elseif state == Fish2d.EFishAction.EFA_Death then 
        local animinfo = self.animator:GetCurrentAnimatorStateInfo(0)
        if animinfo:IsName(DEATH_ANIM) and animinfo.normalizedTime >= 1 then
            self:OnDeathAnimCompleted()
        end
    else
        UnityEngine.Debug.LogError('Invalid action state. goto idle')
        state = Fish2d.EFishAction.EFA_Idle
    end
end 

--on despawn.disable my body
function $CLASS:OnDespawn()
    bDisabled = true
    self:ResetColor()
    if self.gameObject ~= nil then
        self.gameObject:SetActive(false)
    end
end 

--on spawn.enable my body
function $CLASS:OnSpawn()
    bDisabled = false
    if self.gameObject ~= nil then
        self.gameObject:SetActive(true)
    end
end

--play animation
function $CLASS:PlayAnimation(animName)
    if self.animator and animName then
        self.animator:Play(animName);
    end
end

--set animator bool
function $CLASS:SetAnimatorBool(name, value)
    if self.animator and name ~= nil and value ~= nil then
        self.animator:SetBool(name, value)
    end
end 

--set animation speed
--@param speed  desired animation speed.must large 0
function $CLASS:SetAnimatorSpeed(speed)
    if self.animator and speed >= 0 then
        self.animator.speed = speed;
    end
end

--suicide.called by self or game mode. if player exit game, so game mode will call this function
--to kill all character.
function $CLASS:Suicide()
    if state ~= Fish2d.EFishAction.EFA_Death then
        self:OnDeath(true)
    end
end 

--onDeath(privacy function)
--param bSuicide whether self was killed by other character.
function $CLASS:OnDeath(bSuicide)
     state = Fish2d.EFishAction.EFA_Death
     self:SetAnimatorBool(DEATH_TRANSFORM_CONDITON, true)
     if bSuicide == false then 
        self.GameMode:SpawnEffect(EFishParticleType.EFPT_Coin, self.transform.position, self.effect_coin_comp)
     end 
end 

--on death animation completed
function $CLASS:OnDeathAnimCompleted()
    state = Fish2d.EFishAction.EFA_Idle
    self.GameMode:DespawnFish(self.Guid)
end 

--OnKilled.deal take damage and play hurt animation in here.
--called by game mode
--@param causedBy who hurt me
function $CLASS:OnKilled(causedBy)
    if state == Fish2d.EFishAction.EFA_Death then 
        return 
    end  
    AudioManager.getInstance():PlaySound(EGameSound.EGS_Fish2d_Catch)
    self:OnDeath(false)
end 

--OnTakeDamage. deal take damage and play hurt animation in here. 
--called by game mode
--@param causedBy who hurted me
function $CLASS:OnTakeDamage(causedBy)
    if state == Fish2d.EFishAction.EFA_Death then 
        return 
    end  
    self:SetEmissiveColor()
end 

-- Set fish Emissive Color
function $CLASS:SetEmissiveColor()
    if self.spriteRenderer then
        self.spriteRenderer.color = damageColor
    end

    self.asyncCor = coroutine.create(function()
		UnityEngine.Yield(UnityEngine.WaitForSeconds(0.1)); 
        self:ResetColor()
	end);
    coroutine.resume(self.asyncCor);
end

-- Set default color as the value of it
function $CLASS:ResetColor()
    if self.spriteRenderer and self.spriteRendererColor then
        self.spriteRenderer.color = self.spriteRendererColor
    end
end


--safe release asset and destroy game object in here.
--called by game mode.
function $CLASS:SafeRelease()
    self.GameMode:RemoveComponent(self.uniqueName)
    if self.colliderTrigger then
        self.colliderTrigger:Clear();
    end

    self.GameMode = nil
    self.transform = nil
    if self.gameObject then
        UnityEngine.GameObject.Destroy(self.gameObject)
    end
    self.gameObject = nil
    
    if self.fishPrefabAsset ~= nil then
        self.fishPrefabAsset:Free(1)
    end
    self.fishPrefabAsset = nil

    if self.effectCoinAsset ~= nil then
        self.effectCoinAsset:Free(1)
    end
    self.effectCoinAsset = nil
end 

--get character template id
function $CLASS:GetTemplateId()
    return self.templateID
end 

--get the guid of character
function $CLASS:GetGuid()
    return self.Guid
end 

--get the unique name of character
function $CLASS:GetUniqueName()
    return self.uniqueName
end 

--get the hit probability of character
function $CLASS:GetHitProbability()
    return self.hitProb or 0 
end 

--get award multiple
function $CLASS:GetAwardMultiple()
    return self.awardMult
end 

--get position
function $CLASS:GetPosition()
    if self.transform ~= nil then 
        return self.transform.position
    end 
    return nil
end 

--update guid
function $CLASS:SetGuid(inGuid)
    self.Guid = inGuid
end 

return $CLASS";

    [MenuItem("Assets/Create/Game Lua/Fish2d Character")]
    public static void Create()
    {
        TextAsset Asset = new TextAsset();
        UnityEditor.ProjectWindowUtil.StartNameEditingIfProjectWindowExists(
            Asset.GetInstanceID(),
            ScriptableObject.CreateInstance<LuaFish2dTemplateGenerator>(),
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
