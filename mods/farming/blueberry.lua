
local S = farming.intllib

-- blueberry muffin (thanks to sosogirl123 @ deviantart.com for muffin image)

minetest.register_craftitem("farming:muffin_blueberry", {
	description = S("Blueberry Muffin"),
	inventory_image = "farming_blueberry_muffin.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "farming:muffin_blueberry 2",
	recipe = {
		{"farming:blueberries", "farming:bread", "farming:blueberries"},
	}
})

