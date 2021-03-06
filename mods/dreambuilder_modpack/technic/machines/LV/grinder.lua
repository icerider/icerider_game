
minetest.register_alias("grinder", "technic:lv_grinder")
minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{'default:desert_stone', 'default:diamond',        'default:desert_stone'},
		{'default:desert_stone', 'technic:machine_casing', 'default:desert_stone'},
		{'technic:granite',      'technic:lv_cable',       'technic:granite'},
	}
})

minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{'default:desert_stone', 'default:diamond',        'default:desert_stone'},
		{'glooptest:rubyblock', 'technic:machine_casing', 'glooptest:rubyblock'},
		{'glooptest:sapphireblock',      'technic:lv_cable',       'glooptest:sapphireblock'},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

