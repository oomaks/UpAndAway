BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal_fragment_light.zip"),

	Asset( "ATLAS", "images/inventoryimages/crystal_fragment_light.xml" ),
	Asset( "IMAGE", "images/inventoryimages/crystal_fragment_light.tex" ),		
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("crystal_fragment_light")
	inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/crystal_fragment_light.xml"		

	return inst
end

return Prefab ("common/inventory/crystal_fragment_light", fn, assets) 
