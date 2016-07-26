local S = farming.intllib

minetest.register_node("farming:seed_tea", {
	description = S("Tea Seed"),
	tiles = {"farming_tea_seed.png"},
	inventory_image = "farming_tea_seed.png",
	wield_image = "farming_tea_seed.png",
	drawtype = "signlike",
	groups = {seed = 1, snappy = 3, attached_node = 1},
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	sunlight_propagates = true,
	selection_box = farming.select,
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:tea_1")
	end,
})

minetest.register_craftitem("farming:tea_leaves", {
	description = "Tea Leaves",
	inventory_image = "farming_tea_leaves.png",
})
--
-- cotton definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_tea_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop =  "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:tea_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_tea_2.png"}
minetest.register_node("farming:tea_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_tea_3.png"}
minetest.register_node("farming:tea_3", table.copy(crop_def))

-- stage 4 (final)
crop_def.tiles = {"farming_tea_grown.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{ items = {'farming:seed_tea'}, rarity = 1},
		{ items = {'farming:tea_leaves'}, rarity = 1},
		{ items = {'farming:seed_tea'}, rarity = 2},
		{ items = {'farming:seed_tea'}, rarity = 5},
		{ items = {'farming:tea_leaves'}, rarity = 2},
		{ items = {'farming:tea_leaves'}, rarity = 5},
	}
}
minetest.register_node("farming:tea_4", table.copy(crop_def))

minetest.register_craft({
	output = 'farming:teapot_3',
	recipe = {
		{"farming:tea_leaves"},
		{"dwarves:water_boiled"},
		{"farming:teapot"},
	},
	replacements = {{"dwarves:water_boiled", "bucket:bucket_empty"}},
})

minetest.register_craft({
	output = 'farming:tea_cup',
	recipe = {
		{"farming:teapot_3"},
		{"farming:drinking_cup"},
	},
	replacements = {{"farming:teapot_3", "farming:teapot_2"}},
})

minetest.register_craft({
	output = 'farming:tea_cup',
	recipe = {
		{"farming:teapot_2"},
		{"farming:drinking_cup"},
	},
	replacements = {{"farming:teapot_2", "farming:teapot_1"}},
})

minetest.register_craft({
	output = 'farming:tea_cup',
	recipe = {
		{"farming:teapot_1"},
		{"farming:drinking_cup"},
	},
	replacements = {{"farming:teapot_1", "farming:teapot"}},
})

minetest.register_craft({
	output = 'farming:teapot',
	recipe = {
		{"technic:cast_iron_ingot"},
		{"technic:cast_iron_ingot"},
	}
})

minetest.register_craft({
	output = 'farming:drinking_cup',
	recipe = {
		{'default:clay_lump', '', 'default:clay_lump'},	
		{'', 'default:clay_lump', ''},
	}
})

minetest.register_craftitem("farming:tea_cup", {
	description = "Cup of Tea",
	inventory_image = "farming_tea.png",
	on_use = minetest.item_eat(6, "farming:drinking_cup")
})

minetest.register_craftitem("farming:drinking_cup", {
	description = "Cup",
	inventory_image = "farming_cup.png"
})
minetest.register_craftitem("farming:teapot_3", {
	description = "Teapot 3/3",
	inventory_image = "farming_teapot.png"
})
minetest.register_craftitem("farming:teapot_2", {
	description = "Teapot 2/3",
	inventory_image = "farming_teapot.png"
})
minetest.register_craftitem("farming:teapot_1", {
	description = "Teapot 1/3",
	inventory_image = "farming_teapot.png"
})
minetest.register_craftitem("farming:teapot", {
	description = "Empty Teapot",
	inventory_image = "farming_teapot.png"
})
