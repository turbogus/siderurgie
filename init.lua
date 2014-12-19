--[[

Mod Siderurgie
Créé par turbogus
Licence gpl v2 ou supérieur

Mod permettant d'augmenter la production de lingot d'acier dans minetest ( 1 minerai de fer = 4 lingots d'acier

]]--

--Déclaration des items
minetest.register_craftitem("siderurgie:coke", {
	description = "Coke.",
	inventory_image = "coke.png",	
})

minetest.register_craftitem("siderurgie:spoon", {
	description = "Spoon to convert lava bucket to lava source.",
	inventory_image = "spoon.png",	
})

minetest.register_craftitem("siderurgie:liquid_steel", {
	description = "Bucket of liquid steel",
	inventory_image = "liquid_steel.png",	
})

minetest.register_craftitem("siderurgie:liquid_steel_spec", {
	description = "Bucket of liquid steel",
	inventory_image = "liquid_steel.png",	
})

-- comburant
minetest.register_craft({
	type = "cooking",
	output = "siderurgie:coke",
	recipe = "default:coalblock", --ici, mettre un coalblock au lieu d'un coal lump sinon il y a conflit avec la recette du black dye.
})

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot 4",
	recipe = "siderurgie:liquid_steel",
	
	replacements = {{"siderurgie:liquid_steel", "bucket:bucket_empty"}},
})

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot 4",
	recipe = "siderurgie:liquid_steel_spec",
	
})

--Déclaration des crafts
--acier liquide :
minetest.register_craft({
	output = 'siderurgie:liquid_steel',
	recipe = {
		{'default:iron_lump'},
		{'siderurgie:coke'},
		{'bucket:bucket_lava'},
	}		
})
minetest.register_craft({
	output = 'siderurgie:liquid_steel_spec',
	recipe = {
		{'default:iron_lump'},
		{'siderurgie:coke'},
		{'default:lava_source'},
	}		
})



--Spécial : transformation d'un lava bucket en lava source avec la cuillère
minetest.register_craft({
	output = 'siderurgie:spoon',
	recipe = {
		{'default:obsidian_shard'},
		{'default:obsidian_shard'},
		{'default:steel_ingot'},
	}		
})

minetest.register_craft({
	output = 'default:lava_source',
	recipe = {
		{'bucket:bucket_lava'},
		{'siderurgie:spoon'},
	},
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})

--transformation d'un seau de lave en lava source via un four ( pour utiliser avec pipeworks )
minetest.register_craft({
	type = "cooking",
	output = "default:lava_source",
	recipe = "bucket:bucket_lava",
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})


