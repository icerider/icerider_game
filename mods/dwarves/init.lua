--
-- Tool definition
--

dofile(minetest.get_modpath("dwarves").."/beer.lua")

minetest.register_craft({
	output = 'dwarves:barrel',
	recipe = {
		{'group:wood', '', 'group:wood'},
		{'group:wood', '', 'group:wood'},
		{'group:wood', 'bucket:bucket_water', 'group:wood'},
	}
})


minetest.register_craftitem("dwarves:water_boiled", {
	description = "Boiled Water",
	inventory_image = "dwarves_water_boiled.png",
})

minetest.register_craft({
	type = "cooking",
	output = 'dwarves:water_boiled',
	recipe = "bucket:bucket_water"
})

