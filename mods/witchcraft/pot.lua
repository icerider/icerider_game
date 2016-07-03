--Stuff from vessels

-- -
-- Copyright (C) 2012 Vanessa Ezekowitz
-- Copyright (C) 2012 celeron55, Perttu Ahola <celeron55@gmail.com>
-- Copyright (C) 2016 icerider <icerider@mail.ru>

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

-- Crafting, cauldrons and pot brewing

local vessels_shelf_formspec =
	"size[8,7;]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[context;vessels;0,0.3;8,2;]"..
	"list[current_player;main;0,2.85;8,1;]"..
	"list[current_player;main;0,4.08;8,3;8]"..
	"listring[context;vessels]"..
	"listring[current_player;main]"..
	default.get_hotbar_bg(0,2.85)

minetest.register_node("witchcraft:shelf", {
	description = "Potion shelf",
	tiles = {"default_wood.png", "default_wood.png", "default_wood.png^vessels_shelf.png^vessels_shelf_overlay.png"},
	is_ground_content = false,
	groups = {choppy=3,oddly_breakable_by_hand=2,flammable=3},
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", vessels_shelf_formspec)
		local inv = meta:get_inventory()
		inv:set_size("vessels", 8*2)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("vessels")
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local to_stack = inv:get_stack(listname, index)
		if listname == "vessels" then
			local itemname = stack:get_name()
			if (minetest.get_item_group(itemname, "potion") ~= 0 or minetest.get_item_group(itemname, "potion2") ~= 0
					or minetest.get_item_group(itemname, "scroll") ~= 0 and to_stack:is_empty()) then
				return 1
			else
				return 0
			end
		end
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		local to_stack = inv:get_stack(to_list, to_index)
		if to_list == "vessels" then
			if (minetest.get_item_group(itemname, "potion") ~= 0 or minetest.get_item_group(itemname, "potion2") ~= 0
					or minetest.get_item_group(itemname, "scroll") ~= 0 and to_stack:is_empty()) then
				return 1
			else
				return 0
			end
		end
	end,

	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
			   " moves stuff in vessels shelf at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			   " moves stuff to vessels shelf at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
			   " takes stuff from vessels shelf at "..minetest.pos_to_string(pos))
	end,
})

--ingredients

minetest.register_node("witchcraft:bottle_eyes", {
	description = "Jar of eyes",
	drawtype = "plantlike",
	tiles = {"witchcraft_jar_eyes.png"},
	inventory_image = "witchcraft_jar_eyes.png",
	wield_image = "witchcraft_jar_eyes.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	stack_max = 50,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1, potion=1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("witchcraft:bottle_slime", {
	description = "Jar of Slime",
	drawtype = "plantlike",
	tiles = {"witchcraft_jar_slime.png"},
	inventory_image = "witchcraft_jar_slime.png",
	wield_image = "witchcraft_jar_slime.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	stack_max = 50,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1, potion=1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craftitem("witchcraft:herb", {
	description = "herb",
	inventory_image = "witchcraft_herbs.png"
})

--crafting

minetest.register_craft({
	output = 'witchcraft:shelf',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:potion', 'group:potion', 'group:potion'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

if minetest.get_modpath("moreplants") then
minetest.register_craft({
	output = 'witchcraft:bottle_eyes',
	recipe = {
		{'moreplants:eye'},
		{'moreplants:eye'},
		{'vessels:drinking_glass'},
	}
})


minetest.register_craft({
	output = "moreplants:eye 2",
	type = "shapeless",
	recipe = {"witchcraft:bottle_eyes"}
})

minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"moreplants:bush"}
})

minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"moreplants:weed"}
})

minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"moreplants:groundfung"}
})
else
minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"default:grass_5"}
})

minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"default:grass_4"}
})

minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"default:grass_3"}
})

minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"default:grass_2"}
})

minetest.register_craft({
	output = "witchcraft:herb 4",
	type = "shapeless",
	recipe = {"default:grass_1"}
})

minetest.register_craft({
	output = 'witchcraft:bottle_eyes 1',
	recipe = {
		{'bucket:bucket_water'},
		{'vessels:drinking_glass'},
	}
})

end

minetest.register_craft({
	output = 'witchcraft:pot',
	recipe = {
		{'default:copper_lump', '', 'default:copper_lump'},
		{'default:copper_lump', '', 'default:copper_lump'},
		{'', 'default:copper_lump', ''},
	}
})

--splash potions crafting

minetest.register_craft({
	output = 'witchcraft:splash_yellgrn',
	recipe = {
		{'vessels:glass_fragments'},
		{'witchcraft:potion_yellgrn'},
	}
})

minetest.register_craft({
	output = 'witchcraft:splash_orange',
	recipe = {
		{'vessels:glass_fragments'},
		{'witchcraft:potion_orange'},
	}
})



--the all important cooking pot

minetest.register_node("witchcraft:pot", {
	description = "magic cooking pot",
	tiles = {
		"witchcraft_pot_top.png",
		"witchcraft_pot_bottom.png",
		"witchcraft_pot_side.png",
		"witchcraft_pot_side.png",
		"witchcraft_pot_side.png",
		"witchcraft_pot_side.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}, -- NodeBox1
			{-0.375, -0.4375, -0.375, 0.375, -0.375, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.3125, 0.3125}, -- NodeBox3
			{-0.375, -0.3125, -0.375, 0.375, 0.5, 0.375}, -- NodeBox4
			{-0.4375, -0.25, -0.4375, 0.4375, 0.3125, 0.4375}, -- NodeBox5
			{-0.5, -0.1875, -0.5, 0.5, 0.3125, 0.5}, -- NodeBox6
			{-0.4375, 0.375, -0.4375, 0.4375, 0.5, 0.4375}, -- NodeBox7
		}
	},
	on_rightclick = function(pos, node, clicker, item, _)
		local wield_item = clicker:get_wielded_item():get_name()
		if wield_item == "bucket:bucket_water" or
				wield_item == "bucket:bucket_river_water" then
			minetest.set_node(pos, {name="witchcraft:pot_blue", param2=node.param2})
			item:replace("bucket:bucket_empty")
		elseif wield_item == "vessels:drinking_glass" then
			item:replace("witchcraft:bottle_slime")
		end
	end,
	groups = {cracky=1, falling_node=1, oddly_breakable_by_hand=1}
})

--level 1 potions from cooking pot

local witchcraft = {}
witchcraft.pot = {
	{"aqua", "", "", "", "", "blue", "cyan"},
	{"blue", "brown", "default:dirt", "blue2", "flowers:geranium", "red", "purple"},
	{"blue2", "yellow", "default:steelblock", "yellow", "default:copperblock", "green2", "aqua"},
	{"brown", "red", "witchcraft:herb", "grey", "farming_plus:strawberry_item", "red", "redbrown"},
	{"cyan", "aqua", "default:diamond", "gcyan", "default:mese_crystal", "green", "cyan2"},
	{"cyan2", "", "", "", "", "", ""},
	{"darkpurple", "cyan", "flowers:mushroom_red", "green", "farming:weed", "yellow", "redbrown"},
	{"gcyan", "", "", "", "", "", ""},
	{"ggreen", "", "", "", "", "", ""},
	{"gpurple", "", "", "", "", "", ""},
	{"gred", "", "", "", "", "", ""},
	{"green2", "darkpurple", "default:glass", "red", "default:gold_lump", "blue2", "aqua"},
	{"green", "green2", "default:apple", "ggreen", "default:mese_crystal", "orange", "yellgrn"},
	{"grey", "orange", "default:torch", "brown", "default:apple", "yellgrn", "magenta"},
	{"magenta", "purple", "witchcraft:bottle_eyes", "darkpurple", "flowers:mushroom_red", "purple", "darkpurple"},
	{"orange", "redbrown", "witchcraft:bottle_slime", "yellow", "farming_plus:orange_item", "green", "yellgrn"},
	{"purple", "blue2", "flowers:waterlily", "gpurple", "default:mese_crystal", "magenta", "darkpurple"},
	{"redbrown", "magenta", "flowers:mushroom_brown", "magenta", "default:stone", "grey", "brown"},
	{"red", "grey", "default:gravel", "gred", "default:mese_crystal", "blue", "purple"},
	{"yellow", "yellgrn", "tnt:tnt", "cyan2", "mobs:minotaur_eye", "darkpurple", "redbrown"},
	{"yellgrn", "green", "default:gold_lump", "orange", "mobs:lava_orb", "grey", "magenta"},
}

--the pot itself

for _, row in ipairs(witchcraft.pot) do
local color = row[1]
local newcolor = row[2]
local newcolor2 = row[4]
local ingredient = row[3]
local ingredient2 = row[5]
local combine = row[6]
local cresult = row[7]
minetest.register_node("witchcraft:pot_"..color, {
  description = (color.." brew pot"):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end),
	tiles = {
		{ name = "witchcraft_pot_"..color..".png",
			animation = {type="vertical_frames", length=3.0} },
		"witchcraft_pot_bottom.png",
		"witchcraft_pot_side.png",
		"witchcraft_pot_side.png",
		"witchcraft_pot_side.png",
		"witchcraft_pot_side.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	drop = {
		items = {
			{items = {'witchcraft:pot'}, rarity = 1},
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}, -- NodeBox1
			{-0.375, -0.4375, -0.375, 0.375, -0.375, 0.375}, -- NodeBox2
			{-0.3125, -0.375, -0.3125, 0.3125, -0.3125, 0.3125}, -- NodeBox3
			{-0.375, -0.3125, -0.375, 0.375, 0.5, 0.375}, -- NodeBox4
			{-0.4375, -0.25, -0.4375, 0.4375, 0.3125, 0.4375}, -- NodeBox5
			{-0.5, -0.1875, -0.5, 0.5, 0.3125, 0.5}, -- NodeBox6
			{-0.4375, 0.375, -0.4375, 0.4375, 0.5, 0.4375}, -- NodeBox7
		}
	},
	on_rightclick = function(pos, node, clicker, item, _)
        local wield_item = clicker:get_wielded_item():get_name()
        if wield_item == "vessels:glass_bottle" then
            item:replace("witchcraft:potion_"..color)
            minetest.set_node(pos, {name="witchcraft:pot", param2=node.param2})
        else
            local result = technic.get_recipe("cauldron", {"witchcraft:pot_"..color, wield_item})
        if result then
            minetest.set_node(pos, {name=result.output, param2=node.param2})
        end
    end
	end,
	groups = {cracky=1, falling_node=1, oddly_breakable_by_hand=1}
})
end

--pot effects
minetest.register_abm({
	nodenames = {"witchcraft:pot_water", "witchcraft:pot_redbrown", "witchcraft:pot_blue2", "witchcraft:pot_cyan", "witchcraft:pot_green", "witchcraft:pot_green2", "witchcraft:pot_aqua", "witchcraft:pot_yellow", "witchcraft:pot_yellgrn", "witchcraft:pot_red", "witchcraft:pot_magenta", "witchcraft:pot_brown", "witchcraft:pot_cyan2"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node)
		minetest.add_particlespawner({
			amount = 2,
			time = 1,
			minpos = {x=pos.x-0.1, y=pos.y, z=pos.z-0.1},
			maxpos = {x=pos.x+0.1, y=pos.y, z=pos.z+0.1},
			minvel = {x=0, y=0.5, z=0},
			maxvel = {x=0, y=0.6, z=0},
			minacc = {x=0, y=0.2, z=0},
			maxacc = {x=0, y=0.3, z=0},
			minexptime = 1,
			maxexptime = 2,
			minsize = 2,
			maxsize = 3,
			collisiondetection = false,
			texture = "witchcraft_bubbles.png"
		})
	end
})

minetest.register_abm({
	nodenames = {"witchcraft:pot_ggreen", "witchcraft:pot_gred", "witchcraft:pot_gpurple", "witchcraft:pot_gcyan"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node)
		minetest.add_particlespawner({
			amount = 2,
			time = 1,
			minpos = {x=pos.x-0.1, y=pos.y, z=pos.z-0.1},
			maxpos = {x=pos.x+0.1, y=pos.y, z=pos.z+0.1},
			minvel = {x=0, y=0.5, z=0},
			maxvel = {x=0, y=0.6, z=0},
			minacc = {x=0, y=0.2, z=0},
			maxacc = {x=0, y=0.3, z=0},
			minexptime = 1,
			maxexptime = 2,
			minsize = 1,
			maxsize = 2,
			collisiondetection = false,
			texture = "witchcraft_light_over.png"
		})
	end
})

minetest.register_abm({
	nodenames = {"witchcraft:pot_purple"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node)
		minetest.add_particlespawner({
			amount = 2,
			time = 1,
			minpos = {x=pos.x-0.1, y=pos.y, z=pos.z-0.1},
			maxpos = {x=pos.x+0.1, y=pos.y, z=pos.z+0.1},
			minvel = {x=0, y=0.5, z=0},
			maxvel = {x=0, y=0.6, z=0},
			minacc = {x=0, y=0.2, z=0},
			maxacc = {x=0, y=0.3, z=0},
			minexptime = 1,
			maxexptime = 2,
			minsize = 5,
			maxsize = 8,
			collisiondetection = false,
			texture = "witchcraft_smoke.png"
		})
	end
})

minetest.register_abm({
	nodenames = {"witchcraft:pot_darkpurple"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node)
		minetest.add_particlespawner({
			amount = 2,
			time = 1,
			minpos = {x=pos.x-0.1, y=pos.y, z=pos.z-0.1},
			maxpos = {x=pos.x+0.1, y=pos.y, z=pos.z+0.1},
			minvel = {x=0, y=0.5, z=0},
			maxvel = {x=0, y=0.6, z=0},
			minacc = {x=0, y=0.2, z=0},
			maxacc = {x=0, y=0.3, z=0},
			minexptime = 1,
			maxexptime = 2,
			minsize = 2,
			maxsize = 3,
			collisiondetection = false,
			texture = "witchcraft_symbol.png"
		})
	end
})

minetest.register_abm({
	nodenames = {"witchcraft:pot_orange"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node)
		minetest.add_particlespawner({
			amount = 2,
			time = 1,
			minpos = {x=pos.x-0.1, y=pos.y, z=pos.z-0.1},
			maxpos = {x=pos.x+0.1, y=pos.y, z=pos.z+0.1},
			minvel = {x=0, y=0.5, z=0},
			maxvel = {x=0, y=0.6, z=0},
			minacc = {x=0, y=0.2, z=0},
			maxacc = {x=0, y=0.3, z=0},
			minexptime = 1,
			maxexptime = 2,
			minsize = 2,
			maxsize = 3,
			collisiondetection = false,
			texture = "witchcraft_flame.png"
		})
	end
})

technic.register_recipe_type("cauldron", {
	description = "Cauldron brewing",
	input_size = 2,
})

function technic.register_cauldron_recipe(data)
	data.time = data.time or 12
	technic.register_recipe("cauldron", data)
end

local recipes = {
	{"witchcraft:pot_blue",         "default:dirt",           "witchcraft:pot_brown"},
	{"witchcraft:pot_brown",         "witchcraft:herb",           "witchcraft:pot_red"},
}

for _, data in pairs(recipes) do
	technic.register_cauldron_recipe({input = {data[1], data[2]}, output = data[3], time = data[4]})
end
