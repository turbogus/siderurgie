-- A FAIRE :
-- essai nouveau bloc cockerie
-- modifier le bloc hf ( coke a la place de charbon et 4 cke = 1 seau de fonte )

-- creation d'une texture panneau danger gaz // OK
-- programmation panneau danger gaz
-- creation de tuyaux ( remplacement du gaz ) //OK
-- programmation des tuyaux : si contre bloc hf_on ou alors contre tuyaux_on alors tuyaux_on

-- programmation bloc acierie et cockerie : si contre bloc tuyaux on alors block acierie/cokerie_on

--Ajout du bloc effaceur de jat


--=====================================================================================================================================================================
--=====================================================================================================================================================================


-- SIDERURGIE

-- créé par turbogus

-- Licence GPL

--Description :
--Mode permettant de créer de l'acier ( steel_ingot ) à partir du charbon de la glaise et du gravier.
-- On créer un haut fourneau, celui-ci doit être plaçé en dessous d'une source de lave ( combustible )
-- L'utilisateur doit avoir du minerai de charbon dans son inventaire ( coal_lump). En cliquant sur le bloc haut fourneau, le minerai de fer se transforme en fonte.
-- On craft ensuite de l'additif avec du gravier et de la glaise ( clay_lump )
-- On place un seau de fonte et le melange d'additif dans le bloc acierie et le tout se transforme alors en lingot de fer.

--=================================================================
--=================================================================

--melange additif
-----------------

--Déclaration du mélange additif :

minetest.register_craftitem("siderurgie:melange", {
	description = "melange pour acier",
	inventory_image = "melange.png",
})


-- Craft du melange additif :

minetest.register_craft({
	output = 'siderurgie:melange 4',
	recipe = {
		{'default:clay_lump'},
		{'default:gravel'},
	}
})

--Déclaration du mélange additif comme utilisable dans un four

minetest.register_craft({
	type = "cooking",
	output = "default:steel_ingot",
	recipe = "siderurgie:melange",
})

--================================================================

--Seau de fonte
---------------

--Déclaration du seau de fonte :

minetest.register_craftitem("siderurgie:fonte", {
	description = "seau de fonte liquide",
	inventory_image = "fonte.png",
})

--Déclaration du seau de fonte en temps que combustible :

minetest.register_craft({
	type = "fuel",
	recipe = "siderurgie:fonte",
	burntime = 40,
})

--=================================================================

--Coke
------

--Déclaration du coke ( utiliser dans hf pour obtenir de la fonte

minetest.register_craftitem("siderurgie:coke", {
	description = "Bloc de coke",
	inventory_image ="coke.png",
})	
--================================================================

-- GAZ pour acierie et cokerie
------------------------------

-- Fluide permettant de mettre en service la cockerie ( comme l'ecoulement de gaz sur le bloc HF ):
-- Propriété : tres inflammable et toxique.

WATER_ALPHA = 200
WATER_VISC = 1

minetest.register_node("siderurgie:gaz_flowing", {
	description = "gaz",
	inventory_image = minetest.inventorycube("gaz.png"),
	drawtype = "glasslike",
	tiles = {"gaz.png"},
	special_tiles = {
		{name="gaz.png", backface_culling=false},
		{name="gaz.png", backface_culling=true},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "flowing", 
	liquid_alternative_flowing = "siderurgie:gaz_flowing",
	liquid_alternative_source = "siderurgie:gaz_source",
	liquid_viscosity = WATER_VISC,
	post_effect_color = {a=64, r=100, g=100, b=200},
	
	groups = {flammable=1},
})

minetest.register_node("siderurgie:gaz_source", {
	description = "gaz",
	inventory_image = minetest.inventorycube("gaz.png"),

	drawtype = "glasslike",
	tiles = {"gaz.png"},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{name="gaz.png", backface_culling=false},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	liquidtype = "source",
	liquid_alternative_flowing = "siderurgie:gaz_flowing",
	liquid_alternative_source = "siderurgie:gaz_source",
	liquid_viscosity = WATER_VISC,
	post_effect_color = {a=64, r=100, g=100, b=200},
	
	groups = {flammable=1},
})

minetest.register_abm(									
    {nodenames = {"siderurgie:gaz_flowing"},							
    interval = 1.0,									
    chance = 1,										
    action = function(pos, node, active_object_count, active_object_count_wider)	
    local objs = minetest.env:get_objects_inside_radius(pos, 1)				
        for k, obj in pairs(objs) do							
        obj:set_hp(obj:get_hp()-0.5)  
        end   
    end,
})

--=================================================================

--Panneau danger gaz
--------------------

--Déclaration du panneau :

minetest.register_node("siderurgie:panneaugaz", {
	description = "Panneau danger gaz",
	drawtype = "signlike",
	tiles = {"panneaugaz.png"},
	inventory_image = "panneaugaz.png",
	wield_image = "panneaugaz.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	metadata_name = "sign",
	selection_box = {
		type = "wallmounted",
		--wall_top = <default>
		--wall_bottom = <default>
		--wall_side = <default>
	},
	groups = {choppy=2,dig_immediate=2},
	legacy_wallmounted = true,
--	sounds = default.node_sound_defaults(),
	--on_construct = function(pos)
	--	--local n = minetest.env:get_node(pos)
	--	local meta = minetest.env:get_meta(pos)
	--	meta:set_string("formspec", "hack:sign_text_input")
	--	meta:set_string("infotext", "\"\"")
--	end,
--	on_receive_fields = function(pos, formname, fields, sender)
	--	--print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
	--	local meta = minetest.env:get_meta(pos)
	--	fields.text = fields.text or ""
	--	print((sender:get_player_name() or "").." wrote \""..fields.text..
	--			"\" to sign at "..minetest.pos_to_string(pos))
	--	meta:set_string("text", fields.text)
	--	meta:set_string("infotext", '"'..fields.text..'"')
--	end,
})

--================================================================
--================================================================
--================================================================

-- Bloc cockerie :
------------------

-- Permet de transformer le charbon en coke ( 2 charbon = 1 coke ), doit etre alimenté par une source de gaz

--Declaration du bloc Haut cokerie :

minetest.register_node("siderurgie:ck", {
	description = "bloc Cockerie",
	tiles = {"ck_off.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "default:furnace",
	--groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = false,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

minetest.register_node("siderurgie:ck_on", {
	description = "bloc Cockerie",
	tiles = {"ck_on.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "default:furnace",
	--groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = false,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

-- Gestion : si alimenté en gaz par un tuyau horizontal alors le bloc fonctionne :

minetest.register_abm({
nodenames = {"siderurgie:ck"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_h_on"or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_h_on"or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_h_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ck_on"})
			nodeupdate(pos)
			
		end
	end,
})

minetest.register_abm({
nodenames = {"siderurgie:ck_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_h" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ck"})
			nodeupdate(pos)
			
		end
	end,
})

--Gestion : si alimenté en gaz par un tuyaux vertical alors le bloc fonctionne :

minetest.register_abm({
nodenames = {"siderurgie:ck"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_v_on"or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_v_on"or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_v_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ck_on"})
			nodeupdate(pos)
			
		end
	end,
})

minetest.register_abm({
nodenames = {"siderurgie:ck_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_v" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ck"})
			nodeupdate(pos)
			
		end
	end,
})


-- Creation du coke : si presence de coal ( x2 ) dans le menu des item du joueur, suppression et remplacement par un seau de fonte :


	
minetest.register_on_punchnode(function(p, node, player)
	if node.name=="siderurgie:ck_on" and player:get_inventory():contains_item('main', 'default:coal_lump 2') then
		player:get_inventory():add_item('main', "siderurgie:coke")
		player:get_inventory():remove_item('main', 'default:coal_lump 2')
	end

end)






--================================================================

--Bloc acierie
--------------

-- Bloc acierie :
------------------

-- Permet de transformer la fonte et le melange pour acier en lingot d'acier : doit etre alimenté par une source de gaz provenant d'un haut fourneau via des tuyaux

--Declaration du bloc acierie :

minetest.register_node("siderurgie:ac", {
	description = "bloc Acierie",
	tiles = {"ac_off.png"},
	paramtype2 = "facedir",
	light_source = 8,
	--drop = "default:furnace",
	--groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = false,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

minetest.register_node("siderurgie:ac_on", {
	description = "bloc Acierie",
	tiles = {"ac_on.png"},
	paramtype2 = "facedir",
	light_source = 8,
	--drop = "default:furnace",
	--groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = false,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

-- Gestion : si alimenté en gaz par un tuyaux horizontal alors le bloc fonctionne :

minetest.register_abm({
nodenames = {"siderurgie:ac"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_h_on"or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_h_on"or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_h_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ac_on"})
			nodeupdate(pos)
			
		end
	end,
})

minetest.register_abm({
nodenames = {"siderurgie:ac_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_h" or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_h" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ac"})
			nodeupdate(pos)
			
		end
	end,
})

--Gestion : si alimenté en gaz par un tuyaux vertical alors le bloc fonctionne :

minetest.register_abm({
nodenames = {"siderurgie:ac"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_v_on"or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_v_on"or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_v_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ac_on"})
			nodeupdate(pos)
			
		end
	end,
})

minetest.register_abm({
nodenames = {"siderurgie:ac_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		
		local fuelpos1={x=pos.x+1, y=pos.y, z=pos.z}
		local fuelpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local fuelpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local fuelpos4={x=pos.x, y=pos.y, z=pos.z-1}
		local fuelpos5={x=pos.x, y=pos.y+1, z=pos.z}
		local fuelpos6={x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.env:get_node(fuelpos1).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos2).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos3).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos4).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos5).name=="siderurgie:tuyau_v" or minetest.env:get_node(fuelpos6).name=="siderurgie:tuyau_v" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:ac"})
			nodeupdate(pos)
			
		end
	end,
})


-- Crée de l'acier si le joueur a dans son inventaire 1 seau de fonte et 4 melange pour acier

minetest.register_on_punchnode(function(p, node, player)
	if node.name=="siderurgie:ac_on" and player:get_inventory():contains_item('main', 'siderurgie:fonte') and player:get_inventory():contains_item('main', 'siderurgie:melange 4') then
		player:get_inventory():add_item('main', "default:steel_ingot")
		player:get_inventory():remove_item('main', 'siderurgie:melange 4')
		player:get_inventory():remove_item('main', 'siderurgie:fonte')
	end

end)

--================================================================

--Bloc hf
---------

-- Le bloc hf ( haut fourneau ), permet de transformer le coke obtenu dans la cockerie en fonte liquide ( 4 cokes donne 1 seau de fonte )
-- Ce bloc doit etre alimenté par une source de lave pour fonctionner.
-- Cliquez sur le bloc en ayant du coke dans votre inventaire pour le transformer en seau de fonte

--Declaration du bloc Haut fourneau :

minetest.register_node("siderurgie:hf", {
	description = "bloc haut fourneau",
	tiles = {"hf_off.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "default:furnace",
	--groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = false,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

minetest.register_node("siderurgie:hf_on", {
	description = "bloc haut fourneau",
	tiles = {"hf_on.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "default:furnace",
	--groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = false,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

-- Gestion : si de la lave coule dessus alors le bloc fonctionne :

minetest.register_abm({
nodenames = {"siderurgie:hf"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		if minetest.env:get_node(waterpos).name=="default:lava_flowing" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:hf_on"})
			nodeupdate(pos)
			
		end
	end,
})

minetest.register_abm({
nodenames = {"siderurgie:hf_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		if minetest.env:get_node(waterpos).name~="default:lava_flowing" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:hf"})
			nodeupdate(pos)
			
		end
	end,
})

-- Creation de la fonte : si presence de coal dans le menu des item du joueur, suppression et remplacement par un seau de fonte :

minetest.register_on_punchnode(function(p, node, player)
	if node.name=="siderurgie:hf_on" and player:get_inventory():contains_item('main', 'siderurgie:coke 4') then
		player:get_inventory():add_item('main', "siderurgie:fonte")
		player:get_inventory():remove_item('main', 'siderurgie:coke 4')
	end

end)
		
--===================================================================================================================

--TUYAUX
--------

--Tuyaux pour l'acheminement du gaz provenant du bloc hf. Permet d'alimenter et faire fonctionner les blocs
--Acierie et cockerie

-- Déclaration des blocs tuyaux 

--vertical

minetest.register_node("siderurgie:tuyau_v", {
	description = "tuyaux vertical",
	tiles = {"tuyau_v_off.png"},
	paramtype2 = "facedir",
	drawtype = "glasslike",
	light_source = 8,
	--drop = "default:furnace",
	groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = true,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

minetest.register_node("siderurgie:tuyau_v_on", {
	description = "tuyau vertical",
	tiles = {"tuyau_v_on.png"},
	paramtype2 = "facedir",
	drawtype = "glasslike",
	light_source = 8,
	--drop = "default:furnace",
	groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = true,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

--horizontal

minetest.register_node("siderurgie:tuyau_h", {
	description = "tuyaux horizontal",
	tiles = {"tuyau_h_off.png"},
	paramtype2 = "facedir",
	drawtype = "glasslike",
	light_source = 8,
	--drop = "default:furnace",
	groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = true,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})

minetest.register_node("siderurgie:tuyau_h_on", {
	description = "tuyau horizontal",
	tiles = {"tuyau_h_on.png"},
	paramtype2 = "facedir",
	drawtype = "glasslike",
	light_source = 8,
	--drop = "default:furnace",
	groups = {cracky=2},
	walkable = true,
	pointable = true,
	diggable = true,
	is_ground_content = false,
	legacy_facedir_simple = true,
	
})
----------------------------------------------------------------------------------------------------------------
--Animation : les tuyaux deviennent ON si ils sont plaçés contre un bloc HF_on ou contre un autre tuyau deja ON|
----------------------------------------------------------------------------------------------------------------

--vertical si hf_on y+1
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:hf_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:hf" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v"})
			nodeupdate(pos)
			
		end
	end,
})

--vertical si vertical_on y+1
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_v_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_v" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v"})
			nodeupdate(pos)
			
		end
	end,
})
--vertical si horizontal_on y+1
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_h_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y+1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_h" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v"})
			nodeupdate(pos)
			
		end
	end,
})


--*****

--vertical si hf_on y-1
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:hf_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:hf" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v"})
			nodeupdate(pos)
			
		end
	end,
})

--vertical si vertical_on y-1
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_v_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_v" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v"})
			nodeupdate(pos)
			
		end
	end,
})
--vertical si horizontal_on y-1
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_h_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_v_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x, y=pos.y-1, z=pos.z}
		
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_h" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_v"})
			nodeupdate(pos)
			
		end
	end,
})





--====================================================
--====================================================










--horizontal si hf_on
minetest.register_abm({
nodenames = {"siderurgie:tuyau_h"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x+1, y=pos.y, z=pos.z}
		local waterpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local waterpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local waterpos4={x=pos.x, y=pos.y, z=pos.z-1}
		if minetest.env:get_node(waterpos).name=="siderurgie:hf_on" or minetest.env:get_node(waterpos2).name=="siderurgie:hf_on" or minetest.env:get_node(waterpos3).name=="siderurgie:hf_on" or minetest.env:get_node(waterpos4).name=="siderurgie:hf_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_h_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_h_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x+1, y=pos.y, z=pos.z}
		local waterpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local waterpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local waterpos4={x=pos.x, y=pos.y, z=pos.z-1}
		if minetest.env:get_node(waterpos).name=="siderurgie:hf" or minetest.env:get_node(waterpos2).name=="siderurgie:hf" or minetest.env:get_node(waterpos3).name=="siderurgie:hf" or minetest.env:get_node(waterpos4).name=="siderurgie:hf" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_h"})
			nodeupdate(pos)
			
		end
	end,
})

--horizontal si vertical_on
minetest.register_abm({
nodenames = {"siderurgie:tuyau_h"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x+1, y=pos.y, z=pos.z}
		local waterpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local waterpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local waterpos4={x=pos.x, y=pos.y, z=pos.z-1}
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_v_on"  or minetest.env:get_node(waterpos2).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(waterpos3).name=="siderurgie:tuyau_v_on" or minetest.env:get_node(waterpos4).name=="siderurgie:tuyau_v_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_h_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_h_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x+1, y=pos.y, z=pos.z}
		local waterpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local waterpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local waterpos4={x=pos.x, y=pos.y, z=pos.z-1}
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_v"  or minetest.env:get_node(waterpos2).name=="siderurgie:tuyau_v" or minetest.env:get_node(waterpos3).name=="siderurgie:tuyau_v" or minetest.env:get_node(waterpos4).name=="siderurgie:tuyau_v" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_h"})
			nodeupdate(pos)
			
		end
	end,
})
--horizontal si horizontal_on
minetest.register_abm({
nodenames = {"siderurgie:tuyau_h"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x+1, y=pos.y, z=pos.z}
		local waterpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local waterpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local waterpos4={x=pos.x, y=pos.y, z=pos.z-1}
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(waterpos2).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(waterpos3).name=="siderurgie:tuyau_h_on" or minetest.env:get_node(waterpos4).name=="siderurgie:tuyau_h_on" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_h_on"})
			nodeupdate(pos)
			
		end
	end,
})
minetest.register_abm({
nodenames = {"siderurgie:tuyau_h_on"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local waterpos={x=pos.x+1, y=pos.y, z=pos.z}
		local waterpos2={x=pos.x-1, y=pos.y, z=pos.z}
		local waterpos3={x=pos.x, y=pos.y, z=pos.z+1}
		local waterpos4={x=pos.x, y=pos.y, z=pos.z-1}
		if minetest.env:get_node(waterpos).name=="siderurgie:tuyau_h" or minetest.env:get_node(waterpos2).name=="siderurgie:tuyau_h" or minetest.env:get_node(waterpos3).name=="siderurgie:tuyau_h" or minetest.env:get_node(waterpos4).name=="siderurgie:tuyau_h" then
			--minetest.env:remove_node(pos)
			minetest.env:add_node(pos, {name="siderurgie:tuyau_h"})
			nodeupdate(pos)
			
		end
	end,
})
