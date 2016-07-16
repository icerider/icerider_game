
minetest.register_alias("lv_cable", "technic:lv_cable")

minetest.register_craft({
	output = 'technic:lv_cable 6',
	recipe = {
		{'homedecor:plastic_sheeting',        'homedecor:plastic_sheeting',        'homedecor:plastic_sheeting'},
		{'moreores:tin_ingot', 'moreores:tin_ingot', 'moreores:tin_ingot'},
		{'homedecor:plastic_sheeting',        'homedecor:plastic_sheeting',        'homedecor:plastic_sheeting'},
	}
}) 

technic.register_cable("LV", 2/16)

