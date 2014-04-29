BindGlobal()

local assets=
{
	Asset("ANIM", "anim/cotton_vest.zip"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "cotton_vest", "swap_body")
    inst.components.fueled:StartConsuming()
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
end

local function onperish(inst)
	inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("armor_sanity")
    inst.AnimState:SetBuild("cotton_vest")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cotton_vest.xml"

    inst:AddComponent("dapperness")
    inst.components.dapperness.dapperness = TUNING.DAPPERNESS_TINY

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "USAGE"
    inst.components.fueled:InitializeFuelLevel(TUNING.SWEATERVEST_PERISHTIME)
    inst.components.fueled:SetDepletedFn(onperish)
    
	inst:AddComponent("insulator")
    inst.components.insulator.insulation = TUNING.INSULATION_LARGE

    local function melt(inst)
        TheMod:DebugSay("Rain start.")
        inst.updatetask = inst:DoPeriodicTask(0.5, function()
            TheMod:DebugSay("Still raining.")
            inst.components.fueled:DoDelta(-25)
        end)
    end    

    inst:ListenForEvent("rainstart", function() 
        melt(inst)
    end, GetWorld())

    inst:ListenForEvent("rainstop", function()
        TheMod:DebugSay("Rain stop.")
        if inst.updatetask then
            inst.updatetask:Cancel()
            inst.updatetask = nil
        end    
    end, GetWorld())

    if GetSeasonManager().precip and GetSeasonManager().preciptype == "rain" then
        melt(inst)
    end

    return inst
end

return Prefab ("common/inventory/cotton_vest", fn, assets) 
