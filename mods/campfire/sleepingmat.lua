--[[

The original code for the Sleeping Mat node is from the Cottages mod  v2.0 by Sokomine.

-- License: GPLv3

The code for sleep/spawn/respawn functions  is based on the
original Beds mod by PilzAdam and Thefamilygrog66

Depends: default, wool

License of code : WTFPL

]]


beds.register_bed("campfire:sleeping_mat_bottom", {
	description = "Sleeping Mat",
  wield_image = "[combine:16x16:0,0=wool_white.png:0,6=wool_brown.png",
  inventory_image = "[combine:16x16:0,0=wool_white.png:0,6=wool_brown.png",
	tiles = {
		bottom = {"[combine:16x16:0,0=wool_brown.png:0,10=wool_brown.png"},
		top = { "[combine:16x16:0,0=wool_white.png:0,6=wool_brown.png" }},
	nodebox = {
		bottom = {-0.48, -0.5, -0.5, 0.48, -0.45, 0.5},
		top = {-0.48, -0.5, -0.5, 0.48, -0.45, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.35, 1.5},
	recipe = {
		{ "wool:brown", "wool:brown", "wool:white"}
	},
})

