
-- Fuel driven alloy furnace. This uses no EUs:

local S = technic.getter

technic.register_recipe_type("potions", {
	description = S("Brewing"),
	input_size = 3,
})

function technic.register_potion_recipe(data)
	data.time = data.time or 12
	technic.register_recipe("potions", data)
end

local recipes = {
	{"witchcraft:potion_lightyellow", "witchcraft:potion_green", "witchcraft:potion_lightyellow",   "witchcraft:potion_grey"},
	{"witchcraft:potion_red", "witchcraft:potion_grey", "witchcraft:potion_orange",   "witchcraft:potion_red_2"},
	{"witchcraft:potion_red", "witchcraft:potion_grey", "witchcraft:potion_blue2",   "witchcraft:potion_red_blue"},
	{"witchcraft:potion_red_blue", "witchcraft:potion_grey", "witchcraft:potion_brown",   "witchcraft:potion_darkpurple"},
	{"witchcraft:potion_orange", "witchcraft:potion_grey", "default:coal_lump",   "witchcraft:potion_orange_2"},
	{"witchcraft:potion_grey_2", "vessels:glass_bottle", "",   "witchcraft:potion_grey 2"},
	{"witchcraft:potion_grey 2", "", "",   "witchcraft:potion_grey_2"},
	{"witchcraft:potion_blue2 2", "", "",   "witchcraft:potion_blue2_2"},
	{"witchcraft:potion_ggreen", "witchcraft:potion_grey", "witchcraft:potion_red_2",   "witchcraft:potion_gpurple"},
	{"witchcraft:potion_red 2", "witchcraft:potion_grey", "witchcraft:potion_yellow 2",   "witchcraft:potion_red_yellow"},
	{"witchcraft:potion_red_yellow", "witchcraft:potion_grey", "witchcraft:potion_blue2 2",   "witchcraft:potion_white"},
	{"witchcraft:potion_green 2", "witchcraft:potion_grey", "witchcraft:potion_brown 2",   "witchcraft:potion_green2"},
	{"witchcraft:potion_red", "witchcraft:potion_grey", "witchcraft:potion_green",   "witchcraft:potion_red_green"},
	{"witchcraft:potion_red_green", "witchcraft:potion_magenta", "",   "witchcraft:potion_red_green_2"},
	{"witchcraft:potion_purple", "witchcraft:potion_grey", "witchcraft:potion_yellow",   "witchcraft:potion_purple_2"},
	{"witchcraft:potion_yellow_2", "witchcraft:potion_brown 2", "witchcraft:potion_red_blue",   "witchcraft:potion_cyan"},
	{"witchcraft:potion_cyan", "witchcraft:potion_grey_2", "witchcraft:potion_brown 2",   "witchcraft:potion_aqua"},
	{"witchcraft:potion_blue2_2", "witchcraft:potion_red", "witchcraft:potion_yellow",   "witchcraft:potion_magenta"},
	{"witchcraft:potion_magenta", "witchcraft:potion_grey", "witchcraft:potion_brown",   "witchcraft:potion_magenta_2"},
	--{"witchcraft:potion_yellow 3", "witchcraft:potion_green 3", "witchcraft:potion_brown",  "witchcraft:potion_yellgrn"},
	--{"witchcraft:potion_yellgrn", "witchcraft:potion_grey", "witchcraft:potion_yellgrn",  "witchcraft:potion_yellgrn_2 2"},
	{"witchcraft:potion_yellow", "witchcraft:potion_grey", "witchcraft:potion_yellow",  "witchcraft:potion_yellow_2"},
	{"witchcraft:potion_yellow_2", "witchcraft:potion_grey", "witchcraft:potion_green 2",  "witchcraft:potion_ggreen"},
	{"witchcraft:potion_red_2", "witchcraft:potion_grey", "witchcraft:potion_brown 2",  "witchcraft:potion_gred"},
	{"technic:sulfur_lump", "vessels:glass_bottle", "",   "witchcraft:potion_so2"},
	{"technic:sulfur_dust", "vessels:glass_bottle", "",   "witchcraft:potion_so2"},
	{"witchcraft:potion_so2", "witchcraft:potion_blue", "",   "technic:h2so4"},
}

for _, data in pairs(recipes) do
	technic.register_potion_recipe({input = {data[1], data[2], data[3]}, output = data[4], time = data[5]})
end


minetest.register_craft({
	output = 'witchcraft:brewing_stand',
	recipe = {
		{'vessels:glass_bottle', '', 'vessels:glass_bottle'},
		{'default:obsidian_glass', 'group:stick', 'default:obsidian_glass'},
		{'', 'group:stick', ''},
	}
})

machine_name = "Brewing Stand"

local formspec =
	"size[8,9]"..
	"label[0,0;"..machine_name.."]"..
	"image[2,2;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;2,3;1,1;]"..
	"list[current_name;src;1,1;3,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"listring[current_name;dst]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	"listring[current_name;fuel]"..
	"listring[current_player;main]"

minetest.register_node("witchcraft:brewing_stand", {
    description = machine_name,
    tiles = {
        "witchcraft_brewing_stand_top.png^[colorize:black:100",
        "witchcraft_brewing_stand_top.png^[colorize:black:100",
        "witchcraft_brewing_stand_side.png^[colorize:black:100",
        "witchcraft_brewing_stand_side.png^[colorize:black:100",
        "witchcraft_brewing_stand_side.png^[colorize:black:100",
        "witchcraft_brewing_stand_side.png^[colorize:black:100"
    },
    drawtype = "nodebox",
    use_texture_alpha = true,
    paramtype = "light",
    groups = {cracky=1, oddly_breakable_by_hand=1},
    sounds = default.node_sound_stone_defaults(),
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", formspec)
        meta:set_string("infotext", machine_name)
        local inv = meta:get_inventory()
        inv:set_size("fuel", 1)
        inv:set_size("src", 3)
        inv:set_size("dst", 4)
    end,
    --can_dig = technic.machine_can_dig,
    --allow_metadata_inventory_put = technic.machine_inventory_put,
    --allow_metadata_inventory_take = technic.machine_inventory_take,
    --allow_metadata_inventory_move = technic.machine_inventory_move,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.5, -0.25, 0.25, -0.4375, 0.25}, -- NodeBox1
            {-0.0625, -0.5, -0.0625, 0.0625, 0, 0.0625}, -- NodeBox2
            {-0.5, 0, -0.125, 0.5, 0.0625, 0.125}, -- NodeBox3
            {-0.4375, -0.1875, -0.0625, -0.3125, 0.375, 0.0625}, -- NodeBox4
            {0.3125, -0.1875, -0.0625, 0.4375, 0.375, 0.0625}, -- NodeBox5
            {-0.125, 0.0625, -0.125, 0.125, 0.125, 0.125}, -- NodeBox6
            {-0.1875, 0.125, -0.125, 0.1875, 0.375, 0.125}, -- NodeBox7
            {-0.125, 0.125, -0.1875, 0.125, 0.375, 0.1875}, -- NodeBox8
            {-0.0625, 0.375, -0.0625, 0.0625, 0.5, 0.0625}, -- NodeBox9
        }
    }
})

minetest.register_node("witchcraft:brewing_stand_active", {
    description = machine_name,
    tiles = {
        "witchcraft_brewing_stand_top.png",
        "witchcraft_brewing_stand_top.png",
        "witchcraft_brewing_stand_side.png",
        "witchcraft_brewing_stand_side.png",
        "witchcraft_brewing_stand_side.png",
        "witchcraft_brewing_stand_side.png"
    },
    drawtype = "nodebox",
    use_texture_alpha = true,
    paramtype = "light",
    light_source = 3,
    drop = "witchcraft:brewing_stand",
    groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
    sounds = default.node_sound_stone_defaults(),
	--can_dig = technic.machine_can_dig,
	--allow_metadata_inventory_put = technic.machine_inventory_put,
	--allow_metadata_inventory_take = technic.machine_inventory_take,
	--allow_metadata_inventory_move = technic.machine_inventory_move,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.5, -0.25, 0.25, -0.4375, 0.25}, -- NodeBox1
            {-0.0625, -0.5, -0.0625, 0.0625, 0, 0.0625}, -- NodeBox2
            {-0.5, 0, -0.125, 0.5, 0.0625, 0.125}, -- NodeBox3
            {-0.4375, -0.1875, -0.0625, -0.3125, 0.375, 0.0625}, -- NodeBox4
            {0.3125, -0.1875, -0.0625, 0.4375, 0.375, 0.0625}, -- NodeBox5
            {-0.125, 0.0625, -0.125, 0.125, 0.125, 0.125}, -- NodeBox6
            {-0.1875, 0.125, -0.125, 0.1875, 0.375, 0.125}, -- NodeBox7
            {-0.125, 0.125, -0.1875, 0.125, 0.375, 0.1875}, -- NodeBox8
            {-0.0625, 0.375, -0.0625, 0.0625, 0.5, 0.0625}, -- NodeBox9
        }
    }
})

minetest.register_abm({
	nodenames = {"witchcraft:brewing_stand", "witchcraft:brewing_stand_active"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local inv    = meta:get_inventory()
		
		local recipe = nil

		for i, name in pairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"}) do
			if not meta:get_float(name) then
				meta:set_float(name, 0.0)
			end
		end

		-- Get what to cook if anything
		local result = technic.get_recipe("potions", inv:get_list("src"))

		local was_active = false

		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_int("fuel_time", meta:get_int("fuel_time") + 1)
			if result then
				meta:set_int("src_time", meta:get_int("src_time") + 1)
				if meta:get_int("src_time") >= result.time then
					meta:set_int("src_time", 0)
					local result_stack = ItemStack(result.output)
					if inv:room_for_item("dst", result_stack) then
						inv:set_list("src", result.new_input)
						inv:add_item("dst", result_stack)
					end
				end
			else
				meta:set_int("src_time", 0)
			end
		end

		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			local percent = math.floor(meta:get_float("fuel_time") /
					meta:get_float("fuel_totaltime") * 100)
			meta:set_string("infotext", S("%s Active"):format(machine_name).." ("..percent.."%)")
			technic.swap_node(pos, "witchcraft:brewing_stand_active")
			meta:set_string("formspec",
					"size[8,9]"..
					"label[0,0;"..machine_name.."]"..
					"image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
					(100 - percent)..":default_furnace_fire_fg.png]"..
					"list[current_name;fuel;2,3;1,1;]"..
					"list[current_name;src;1,1;3,1;]"..
					"list[current_name;dst;5,1;2,2;]"..
					"list[current_player;main;0,5;8,4;]"..
					"listring[current_name;dst]"..
					"listring[current_player;main]"..
					"listring[current_name;src]"..
					"listring[current_player;main]"..
					"listring[current_name;fuel]"..
					"listring[current_player;main]")
			return
		end

		local recipe = technic.get_recipe("potions", inv:get_list("src"))

		if not recipe then
			if was_active then
				meta:set_string("infotext", S("%s is empty"):format(machine_name))
				technic.swap_node(pos, "witchcraft:brewing_stand")
				meta:set_string("formspec", formspec)
			end
			return
		end

		-- Next take a hard look at the fuel situation
		local fuel = nil
		local afterfuel
		local fuellist = inv:get_list("fuel")

		if fuellist then
			fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel.time <= 0 then
			meta:set_string("infotext", S("%s Out Of Fuel"):format(machine_name))
			technic.swap_node(pos, "witchcraft:brewing_stand")
			meta:set_string("formspec", formspec)
			return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)

		inv:set_stack("fuel", 1, afterfuel.items[1])
	end,
})

