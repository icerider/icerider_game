
minetest.register_alias("mv_cable", "technic:mv_cable")

minetest.register_craft({
	output = 'technic:mv_cable 3',
	recipe ={
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
		{'default:copper_ingot', 'default:copper_ingot', 'default:copper_ingot'},
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
	}
}) 

minetest.register_craft({
	output = 'technic:mv_cable 3',
	recipe ={
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
		{'moreores:silver_ingot', 'moreores:silver_ingot', 'moreores:silver_ingot'},
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
	}
}) 

minetest.register_craft({
	output = 'technic:mv_cable 3',
	recipe ={
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
		{'technic_aluminum:aluminum_ingot', 'technic_aluminum:aluminum_ingot', 'technic_aluminum:aluminum_ingot'},
		{'technic:rubber',   'technic:rubber',   'technic:rubber'},
	}
}) 

technic.register_cable("MV", 2.5/16)

