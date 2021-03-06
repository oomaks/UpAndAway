BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/faceentity"

local SheepBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, 4)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= 6*6 and not target:HasTag("notarget")
end


local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() and
       inst.sg:HasStateTag("trapped") == false then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function EatFoodAction(inst)

    local target = FindEntity(inst, CFG.SHEEP.SEE_BAIT_DIST, function(item) return inst.components.eater:CanEat(item) and item.components.bait and not item:HasTag("planted") and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end)
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end
end

function SheepBrain:OnStart()
    local clock = GetPseudoClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        Follow(self.inst, function() return self.inst.components.follower and self.inst.components.follower.leader end, 1, 5, 5, false),
        RunAway(self.inst, "scarytoprey", CFG.SHEEP.AVOID_PLAYER_DIST, CFG.SHEEP.AVOID_PLAYER_STOP),
        RunAway(self.inst, "scarytoprey", CFG.SHEEP.SEE_PLAYER_DIST, CFG.SHEEP.STOP_RUN_DIST, nil, true),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, CFG.SHEEP.MAX_WANDER_DIST),
        DoAction(self.inst, EatFoodAction)
    }, .25)
    self.bt = BT(self.inst, root)
end

return SheepBrain
