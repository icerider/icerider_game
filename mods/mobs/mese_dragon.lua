mobs:register_mob("mobs:mese_dragon", {
	type = "monster",
	-- agressive, deals 13 damage to player when hit
	passive = false,
	damage = 13,
	attack_type = "dogshoot",
	reach = 3,
	shoot_interval = 2,
	arrow = "mobs:mese_dragon_fireball",
	shoot_offset = 2,
	-- health & armor
	hp_min = 175,
	hp_max = 225,
	armor = 70,
	-- textures and model
	collisionbox = {-0.6, 0, -0.6, 0.6, 5, 0.6},
	visual = "mesh",
	mesh = "mese_dragon.b3d",
	textures = {
		{"mese_dragon.png"},
	},
	visual_size = {x=3, y=3},
	blood_texture = "default_mese_crystal_fragment.png",
	-- sounds
	makes_footstep_sound = true,
	sounds = {
		shoot_attack = "mesed",
		attack = "mese_dragon",
		distance = 60,
	},
	-- speed and jump
	view_range = 20,
	knock_back = 0,
	walk_velocity = 1.5,
	run_velocity = 3.5,
	pathfinding = false,
	jump = true,
	jump_height = 4,
	fall_damage = 0,
	fall_speed = -6,
	stepheight = 1.5,
	-- drops returnmirror & mese & class items when dead
	drops = {
		-- Ressource & Decoration drops
		{name = "default:mese", chance = 2, min = 2, max = 4},
		{name = "returnmirror:mirror_inactive", chance = 10, min = 1, max = 1},
		-- Tools drops
		{name = "default:pick_mese", chance = 33, min = 1, max = 1},
		{name = "default:shovel_mese", chance = 33, min = 1, max = 1},
		{name = "default:axe_mese", chance = 33, min = 1, max = 1},
		{name = "farming:hoe_mese", chance = 33, min = 1, max = 1},
		-- Hunter drops
		{name = "3d_armor:leggings_hardenedleather", chance = 10, min = 1, max = 1},
		{name = "3d_armor:boots_hardenedleather", chance = 10, min = 1, max = 1},
		{name = "throwing:arbalest", chance = 33, min = 1, max = 1},
		-- Warrior drops
		{name = "3d_armor:leggings_mithril", chance = 10, min = 1, max = 1},
		{name = "3d_armor:boots_mithril", chance = 10, min = 1, max = 1},
		{name = "default:sword_mese", chance = 33, min = 1, max = 1},
	},
	-- damaged by
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	-- model animation
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 80,
		walk_start = 180,
		walk_end = 200,
		run_start = 180,
		run_end = 200,
		punch_start = 140,
		punch_end = 170,
	},
})

-- mese_dragon_fireball (weapon)
mobs:register_arrow("mobs:mese_dragon_fireball", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"mobs_mese_dragon_fireball.png"},
	velocity = 8,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		player:punch(self.object, 1.0, {		-- Mettre à 2.0 aussi ?
			full_punch_interval = 2.0,			-- Modif MFF
			damage_groups = {fleshy = 13},		-- Modif MFF
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {		-- Mettre à 2.0 aussi ?
			full_punch_interval = 2.0,			-- Modif MFF
			damage_groups = {fleshy = 13},		-- Modif MFF
		}, nil)
	end,

	-- node hit, bursts into flame
	hit_node = function(self, pos, node)
		mobs:explosion(pos, 1, 1, 0)
	end
})

minetest.register_node("mobs:mese_dragon_spawner", {
	description = "Mese Dragon Spawner",
	tiles = {"default_mese_block.png"},
	is_ground_content = false,
	groups = {unbreakable = 1, mob_spawner=1},
	sounds = default.node_sound_stone_defaults({
		dug = {name="mobs_boom", gain=0.25} -- to be changed
	})
})

--(name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height, spawn_in_area)
-- spawn on mobs:mese_dragon_spawner between 1 and 20 light, interval 300, 1 chance, 1 mese_dragon_spawner in area up to 31000 in height
mobs:spawn_specific("mobs:mese_dragon", {"mobs:mese_dragon_spawner"}, {"air"}, 1, 20, 300, 1, 100, -31000, 31000, true)
mobs:register_egg("mobs:mese_dragon", "Mese Dragon", "mobs_mese_dragon_inv.png", 1)
