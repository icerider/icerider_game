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
		{'mobs:minotaur_eye'},
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
			local meta = minetest.get_meta(pos)
			meta:set_int("capacity", 4)
			meta:set_string("infotext", "Capacity:4")
			item:replace("bucket:bucket_empty")
		elseif wield_item == "bucket:bucket_lava" then
			minetest.set_node(pos, {name="witchcraft:pot_lava", param2=node.param2})
			local meta = minetest.get_meta(pos)
			meta:set_int("capacity", 4)
			meta:set_string("infotext", "Capacity:4")
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
    "blue",
    "blue2",
    "grey",
    "grey_2",
    "lightyellow",
    "red",
    "green",
    "lava",
    "purple",
    "yellow",
    "brown",
    "orange",
    "magenta",
    "gcyan",
    "aqua",
    "yellgrn",
    "yellgrn_2",
    "redbrown",
    "darkpurple",
}

--the pot itself

for _, color in ipairs(witchcraft.pot) do
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
            fill_bottle(item, clicker,"witchcraft:potion_"..color)
            local meta = minetest.get_meta(pos)
            local capacity = (meta:get_int("capacity") or 1) - 1

            if capacity <= 0 then
                minetest.set_node(pos, {name="witchcraft:pot", param2=node.param2})
            else
                meta:set_int("capacity", capacity)
            end
            meta:set_string("infotext", "Capacity:"..capacity)
        else
            local meta = minetest.get_meta(pos)
            local capacity = (meta:get_int("capacity") or 1)

            local result = nil

            local count = item:get_count()
            local n_count = min(count, capacity)
            local rstack = ItemStack(wield_item)
            result = technic.get_recipe("cauldron", {ItemStack("witchcraft:pot_"..color),
                                                           rstack})
            if not result then
                if minetest.get_item_group(wield_item, "leaves") > 0 then
                    rstack = ItemStack("group:leaves")
                    result = technic.get_recipe("cauldron", {ItemStack("witchcraft:pot_"..color),
                                                                   rstack})
                end
            end
            local capacity = nil
            if result then
                local spl = string.gmatch(result.output, "%S+")
                local output = spl()
                local capmult = spl() or 1
                capacity = capmult * n_count
                minetest.set_node(pos, {name=output, param2=node.param2})
            end
            meta = minetest.get_meta(pos)

            if string.find(wield_item, "witchcraft:potion_grey") then
                capacity = (meta:get_int("capacity") or 1)
                n_count = 1
                if wield_item  == "witchcraft:potion_grey_2"
                then
                    capacity = capacity + 2
                else
                    capacity = capacity + 1
                end
            end
            if capacity then
                meta:set_int("capacity", capacity)
                item:take_item(n_count)
                if string.find(wield_item, "witchcraft:potion_") then
                    use_bottle(item, clicker)
                end
                meta:set_string("infotext", "Capacity:"..capacity)
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
	{"witchcraft:pot_blue",         "flowers:mushroom_brown",         "witchcraft:pot_brown"},
	{"witchcraft:pot_blue",         "mobs:dung",                      "witchcraft:pot_brown"},
	{"witchcraft:pot_blue",         "flowers:geranium",               "witchcraft:pot_blue2"},
	{"witchcraft:pot_blue",         "bushes:blueberry",               "witchcraft:pot_blue2"},
	{"witchcraft:pot_blue",         "flowers:mushroom_red",           "witchcraft:pot_red"},
	{"witchcraft:pot_blue",         "flowers:rose",                   "witchcraft:pot_red"},
	{"witchcraft:pot_blue",         "default:apple",                  "witchcraft:pot_red"},
	{"witchcraft:pot_blue",         "flowers:sunflower",              "witchcraft:pot_yellow"},
	{"witchcraft:pot_blue",         "flowers:dandelion_yellow",       "witchcraft:pot_yellow"},
	{"witchcraft:pot_blue",         "flowers:viola",                  "witchcraft:pot_purple"},
	{"witchcraft:pot_blue",         "farming:grapes",                 "witchcraft:pot_purple"},
	{"witchcraft:pot_blue",         "witchcraft:herb",                "witchcraft:pot_green"},
	{"witchcraft:pot_blue",         "group:leaves",                   "witchcraft:pot_green"},
	{"witchcraft:pot_blue",         "flowers:tulip",                  "witchcraft:pot_orange"},
	{"witchcraft:pot_blue",         "farming_plus:orange_item",       "witchcraft:pot_orange"},
	{"witchcraft:pot_blue",         "bushes:blackberry",              "witchcraft:pot_magenta"},
	{"witchcraft:pot_blue",         "bushes:raspberry",               "witchcraft:pot_magenta"},
	{"witchcraft:pot_blue",         "default:mese_crystal_fragment",  "witchcraft:pot_lightyellow"},
	{"witchcraft:pot_blue",         "mobs:zombie_tibia",              "witchcraft:pot_grey"},
	{"witchcraft:pot_blue",         "mobs:lava_orb",                  "witchcraft:pot_grey 2"},
	{"witchcraft:pot_blue",         "mobs:minotaur_horn",             "witchcraft:pot_grey 3"},
	{"witchcraft:pot_brown",        "witchcraft:bottle_eyes",         "witchcraft:pot_gcyan 2"},
	{"witchcraft:pot_red",          "mobs:minotaur_lots_of_fur",      "witchcraft:pot_darkpurple 2"},
	{"witchcraft:pot_yellow",       "mobs:dungeon_master_diamond",    "witchcraft:pot_aqua 4"},
	{"witchcraft:pot_orange",       "mobs:dungeon_master_blood",      "witchcraft:pot_grey_2 4"},
	{"witchcraft:pot_blue2",        "default:apple",                  "witchcraft:pot_purple"},
	{"witchcraft:pot_red",          "flowers:sunflower",              "witchcraft:pot_orange"},
	{"witchcraft:pot_yellow",       "witchcraft:potion_gred",         "witchcraft:pot_cyan"},
	{"witchcraft:pot_lava",         "farming:weed",                   "witchcraft:pot_yellgrn"},
	{"witchcraft:pot_lava",         "witchcraft:potion_aqua",         "witchcraft:pot_aqua"},
	{"witchcraft:pot_yellgrn",      "witchcraft:potion_grey",         "witchcraft:pot_yellgrn_2"},
}

--{"witchcraft:potion_yellow_2", "witchcraft:potion_brown 2", "witchcraft:potion_red_blue",   "witchcraft:potion_cyan"},
--{"witchcraft:potion_cyan", "witchcraft:potion_grey2", "witchcraft:potion_brown 2",   "witchcraft:potion_aqua"},
for _, data in pairs(recipes) do
	technic.register_cauldron_recipe({input = {data[1], data[2]}, output = data[3], time = data[4]})
end
