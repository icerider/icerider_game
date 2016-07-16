
-- Iron Monster by icerider

mobs:register_mob("mobs:iron_monster", {
	-- animal, monster, npc, barbarian
	type = "monster",
	-- aggressive, deals 8 damage to player when hit
	passive = false,
	attack_type = "dogfight",
	pathfinding = false,
	reach = 2,
	damage = 6,
	-- health & armor
	hp_min = 25,
	hp_max = 30,
	armor = 90,
	-- textures and model
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.b3d",
	textures = {
		{"mobs_iron_monster.png"},
		{"mobs_iron_monster2.png"}, -- by AMMOnym
	},
	blood_texture = "default_stone.png",
	-- sounds
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_stonemonster",
		attack = "mobs_stonemonster_attack",
	},
	-- speed and jump, sinks in water
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	floats = 0,
	view_range = 16,
	-- chance of dropping torch, iron lump, coal lump and/or silver coins
	drops = {
		{name = "default:torch",
		chance = 10, min = 3, max = 5,},
		{name = "default:iron_lump", chance = 2, min = 1, max = 5,},
		{name = "default:coal_lump", chance = 3, min = 1, max = 3,},
		{name = "maptools:silver_coin", chance = 1, min = 1, max = 1,},
	},
	-- damaged by
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	-- model animation
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	},
})

-- spawns on iron between -1 and 5 light, 1 in 9000 chance, 1 in area below -25
mobs:spawn_specific("mobs:iron_monster", {"default:stone_with_iron", "glooptest:mineral_desert_iron"}, {"air"}, -1, 5, 30, 30000, 3, -31000, -155, false)

-- register spawn egg
mobs:register_egg("mobs:iron_monster", "Iron Monster", "mobs_iron_monster_inv.png", 1)

minetest.register_craft({
	output = "mobs:iron_monster",
	recipe = {
		{"default:iron_lump", "default:iron_lump", "default:iron_lump"},
		{"default:iron_lump", "default:nyancat_rainbow", "default:iron_lump"},
		{"default:iron_lump", "default:iron_lump", "default:iron_lump"}
	}
})
