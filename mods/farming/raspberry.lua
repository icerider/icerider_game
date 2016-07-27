
local S = farming.intllib

-- raspberry smoothie
minetest.register_craftitem("farming:smoothie_raspberry", {
	description = S("Raspberry Smoothie"),
	inventory_image = "farming_raspberry_smoothie.png",
	on_use = minetest.item_eat(2, "vessels:drinking_glass"),
})

minetest.register_craft({
	output = "farming:smoothie_raspberry",
	recipe = {
		{"default:snow"},
		{"farming:raspberries"},
		{"vessels:drinking_glass"},
	}
})

