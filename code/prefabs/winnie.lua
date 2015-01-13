BindGlobal()

local CFG = TheMod:GetConfig()

local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset( "ANIM", "anim/player_basic.zip" ),
    Asset( "ANIM", "anim/player_idles_shiver.zip" ),
    Asset( "ANIM", "anim/player_actions.zip" ),
    Asset( "ANIM", "anim/player_actions_axe.zip" ),
    Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
    Asset( "ANIM", "anim/player_actions_shovel.zip" ),
    Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
    Asset( "ANIM", "anim/player_actions_eat.zip" ),
    Asset( "ANIM", "anim/player_actions_item.zip" ),
    Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
    Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
    Asset( "ANIM", "anim/player_actions_fishing.zip" ),
    Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
    Asset( "ANIM", "anim/player_bush_hat.zip" ),
    Asset( "ANIM", "anim/player_attacks.zip" ),
    Asset( "ANIM", "anim/player_idles.zip" ),
    Asset( "ANIM", "anim/player_rebirth.zip" ),
    Asset( "ANIM", "anim/player_jump.zip" ),
    Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
    Asset( "ANIM", "anim/player_teleport.zip" ),
    Asset( "ANIM", "anim/wilson_fx.zip" ),
    Asset( "ANIM", "anim/player_one_man_band.zip" ),
    Asset( "ANIM", "anim/shadow_hands.zip" ),
    Asset( "SOUND", "sound/sfx.fsb" ),
    Asset( "SOUND", "sound/wilson.fsb" ),
    Asset( "ANIM", "anim/beard.zip" ),

    Asset( "ANIM", "anim/winnie.zip" ),
    --Asset( "ANIM", "anim/ghost_winnie_build.zip" ),
}

local prefabs = CFG.WINNIE.PREFABS

local seeds = CFG.WINNIE.POTENTIAL_SEEDS
local seed = seeds[math.random(#seeds)]

local starting_inventory = CFG.WINNIE.STARTING_INV

table.insert(starting_inventory, seed)

-- Winnie gets a damage resistance to lureplants.

-- Winnie can craft a Lureplant Bulb, which costs health.

-- Winnie gets special gains/losses for eating.
local function penalty(inst, food)
    local eater = inst.components.eater
    local food = food.components.edible.foodtype
    local prefab = food.prefab

    if eater and food == "MEAT" and not (prefab == "plantmeat" or "plantmeat_cooked") then
            inst.components.sanity:DoDelta(-45)
            inst.components.health:DoDelta(-35)
            inst.components.talker:Say("Blech.")
            inst.components.kramped:OnNaughtyAction(5)
    elseif eater and food == "VEGGIE" then
            inst.components.sanity:DoDelta(2)
            inst.components.health:DoDelta(1)
            inst.components.hunger:DoDelta(5)
    end
end

-- Makes sure the sanity bonus isn't overwhelming for creatures with a large amount of health.
local function bonus_fn(target)
    if target and target.components.health then
        local health_to_sanity = target.components.health.currenthealth / CFG.WINNIE.HEALTH_PERCENT
        if health_to_sanity <= CFG.WINNIE.SANITY_BONUS_CAP then
            return health_to_sanity
        else
            return CFG.WINNIE.SANITY_BONUS_CAP
        end
    end
end

-- Winnie will gain sanity and naughtiness when attacking.
local function on_combat(inst)
    TheMod:DebugSay("Attemping to apply sanity bonus.")
    local target = inst.components.combat.target
    if target then
        inst.components.sanity:DoDelta(bonus_fn(target))
        inst.components.kramped:OnNaughtyAction(bonus_fn(target) * CFG.WINNIE.NAUGHTY_BONUS)
        TheMod:DebugSay("Applying a sanity bonus of " .. bonus_fn(target) .. ".")        
    end
end        

local function compat_fn(inst)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("winnie.tex")

end

local function post_compat_fn(inst)

    TheMod:DebugSay("Applying character stats.")

    inst.soundsname = "winnie"

    inst.components.eater:SetOnEatFn(penalty)

    inst:ListenForEvent("onattackother", on_combat)  

    inst.components.inventory:GuaranteeItems(CFG.WINNIE.PERMANENT_ITEMS)

    inst.components.health:SetMaxHealth(CFG.WINNIE.HEALTH)
    inst.components.hunger:SetMax(CFG.WINNIE.HUNGER)
    inst.components.sanity:SetMax(CFG.WINNIE.SANITY)

    inst.components.combat.damagemultiplier = CFG.WINNIE.DAMAGE_MULTIPLIER

    inst.components.locomotor.walkspeed = CFG.WINNIE.WALK_SPEED
    inst.components.locomotor.runspeed = CFG.WINNIE.RUN_SPEED

    inst.components.kramped.timetodecay = CFG.WINNIE.NAUGHTY_DECAY

end

-- Don't Starve Together
local common_postinit = function(inst) 
    TheMod:DebugSay("Playing on Don't Starve Together.")
    compat_fn(inst)
end

local master_postinit = function(inst)    
    post_compat_fn(inst)
end

-- Don't Starve
local character_fn = function(inst) 
    TheMod:DebugSay("Playing on Don't Starve.")
    compat_fn(inst) 
    post_compat_fn(inst) 
end

if IsDST() then
    return MakePlayerCharacter("winnie", prefabs, assets, common_postinit, master_postinit, starting_inventory)
else 
    return MakePlayerCharacter("winnie", prefabs, assets, character_fn, starting_inventory)
end
