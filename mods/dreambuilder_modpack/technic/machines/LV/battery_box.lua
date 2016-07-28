
minetest.register_craft({
	output = 'technic:lv_battery_box0',
	recipe = {
		{'group:wood',      'group:wood',             'group:wood'},
		{'technic:battery', 'technic:machine_casing', 'technic:battery'},
		{'technic:battery', 'technic:lv_cable',       'technic:battery'},
	}
})

minetest.register_craft({
	output = 'technic:portable_battery_box0',
	recipe = {
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
		{'technic:lead_battery', 'technic:machine_casing', 'technic:lead_battery'},
		{'technic:battery', 'technic:mv_transformer',       'technic:battery'},
	}
})

technic.register_battery_box({
	tier           = "LV",
	max_charge     = 40000,
	charge_rate    = 1000,
	discharge_rate = 4000,
	charge_step    = 500,
	discharge_step = 800,
})

technic.register_portable_battery_box({
	tier           = "LV",
	max_charge     = 40000,
	charge_rate    = 1000,
	discharge_rate = 4000,
	charge_step    = 10000,
	discharge_step = 800,
})

