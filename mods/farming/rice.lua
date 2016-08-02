minetest.register_craftitem("farming:seed_rice", {
	description = "Rice",
	inventory_image = "farming_rice_seed.png",
	tiles = {"farming_rice_seed.png"},
	wield_image = "farming_rice_seed.png",
	drawtype = "signlike",
	groups = {seed = 1, snappy = 3, attached_node = 1},
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	sunlight_propagates = true,
	selection_box = farming.select,
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:rice_1")
	end,
})
--
-- rice definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_rice_1.png"},
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
minetest.register_node("farming:rice_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_rice_2.png"}
minetest.register_node("farming:rice_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_rice_3.png"}
minetest.register_node("farming:rice_3", table.copy(crop_def))
--
-- stage 4 (final)
crop_def.tiles = {"farming_rice.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {"farming:seed_rice"}, rarity = 1},
		{items = {"farming:seed_rice"}, rarity = 1},
		{items = {"farming:seed_rice"}, rarity = 2},
		{items = {"farming:seed_rice"}, rarity = 5},
	}
}

minetest.register_node("farming:rice_4", table.copy(crop_def))

minetest.register_craft({
	output = 'farming:onigiri',
	recipe = {
		{'', 'farming:seed_rice', ''},
		{'farming:seed_rice', '', 'farming:seed_rice'},
	}
})

minetest.register_craftitem("farming:onigiri", {
	description = "Onigiri",
	inventory_image = "farming_onigiri.png",
	on_use = minetest.item_eat(3)
})
