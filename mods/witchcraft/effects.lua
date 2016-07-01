--Stuff from vessels

-- -
-- Copyright (C) 2012 Vanessa Ezekowitz
-- Copyright (C) 2012 celeron55, Perttu Ahola <celeron55@gmail.com>
-- Copyright (C) 2016 icerider <icerider@mail.ru>

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

function add_drink_spawner(playerpos)
        minetest.add_particlespawner(
            5, --amount
            0.1, --time
            {x=playerpos.x-1, y=playerpos.y+1, z=playerpos.z-1}, --minpos
            {x=playerpos.x+1, y=playerpos.y+1, z=playerpos.z+1}, --maxpos
            {x=-0, y=-0, z=-0}, --minvel
            {x=0, y=0, z=0}, --maxvel
            {x=-0.5,y=4,z=-0.5}, --minacc
            {x=0.5,y=4,z=0.5}, --maxacc
            0.5, --minexptime
            1, --maxexptime
            1, --minsize
            2, --maxsize
            false, --collisiondetection
            "witchcraft_effect.png" --texture
        )
end

function add_smoke_spawner(playerpos)
        minetest.add_particlespawner(
            20, --amount
            0.5, --time
            {x=playerpos.x-1, y=playerpos.y+1, z=playerpos.z-1}, --minpos
            {x=playerpos.x+1, y=playerpos.y+1, z=playerpos.z+1}, --maxpos
            {x=-0, y=-0.5, z=0}, --minvel
            {x=0, y=0.6, z=0}, --maxvel
            {x=0,y=-0.5,z=0}, --minacc
            {x=0,y=0.6,z=0}, --maxacc
            1, --minexptime
            3, --maxexptime
            10, --minsize
            15, --maxsize
            false, --collisiondetection
            "witchcraft_smoke.png%[colorize:magenta:50" --texture
        )
end

function add_smoke_spawner_lv2(playerpos)
        minetest.add_particlespawner(
            20, --amount
            0.5, --time
            {x=playerpos.x-1, y=playerpos.y+1, z=playerpos.z-1}, --minpos
            {x=playerpos.x+1, y=playerpos.y+1, z=playerpos.z+1}, --maxpos
            {x=-0, y=0.2, z=0}, --minvel
            {x=0, y=0.2, z=0}, --maxvel
            {x=0,y=-0.1,z=0}, --minacc
            {x=0,y=0.1,z=0}, --maxacc
            5, --minexptime
            10, --maxexptime
            10, --minsize
            15, --maxsize
            false, --collisiondetection
            "witchcraft_smoke.png%[colorize:magenta:50" --texture
        )
end

function add_dark_spawner(playerpos)
        minetest.add_particlespawner(
            2000, --amount
            1, --time
            {x=playerpos.x-20, y=playerpos.y-3, z=playerpos.z-20}, --minpos
            {x=playerpos.x+20, y=playerpos.y+3, z=playerpos.z+20}, --maxpos
            {x=-0, y=0, z=0}, --minvel
            {x=0, y=0, z=0}, --maxvel
            {x=0.1,y=0,z=-0.1}, --minacc
            {x=0.1,y=0,z=0.1}, --maxacc
            5, --minexptime
            10, --maxexptime
            10, --minsize
            20, --maxsize
            false, --collisiondetection
            "witchcraft_pot_bottom.png^[colorize:black:200" --texture
        )
end

--invisibility potion by Tenplus1(DWTFYWT V2), see darkpurple potion for on_use effect

invisibility = {}

function witchcraft.is_player_invisibility(player)
    if player then
        local name = player:get_player_name()
        return invisibility[name]
    else
        return false
    end
end

-- reset player invisibility if they go offline

minetest.register_on_leaveplayer(function(player)

	local name = player:get_player_name()

	if invisibility[name] then
		invisibility[name] = nil
	end
end)

invisible = function(player, toggle)

	if not player then return false end

	local name = player:get_player_name()

	invisibility[name] = toggle

	local prop

	if toggle == true then
		-- hide player and name tag
		prop = {
			visual_size = {x = 0, y = 0},
			collisionbox = {0, 0, 0, 0, 0, 0}
		}

		player:set_nametag_attributes({
			color = {a = 0, r = 255, g = 255, b = 255}
		})
	else
		-- show player and tag
		prop = {
			visual_size = {x = 1, y = 1},
			collisionbox = {-0.35, -1, -0.35, 0.35, 1, 0.35}
		}

		player:set_nametag_attributes({
			color = {a = 255, r = 255, g = 255, b = 255}
		})
	end

	player:set_properties(prop)

end

playereffects.register_effect_type("invisibility", "Invisibility", "witchcraft_potion_darkpurple", {"invisibility"},
    function(player)

        -- make player invisible
        invisible(player, true)

        local pos = player:getpos()
        if pos then
            -- play sound
            minetest.sound_play("pop", {
                pos = pos,
                gain = 1.0,
                max_hear_distance = 5
            })
        end
    end,
    function(effect, player)
        -- show aready hidden player
        invisible(player, nil)

        local pos = player:getpos()
        if pos then
            -- play sound
            minetest.sound_play("pop", {
                pos = pos,
                gain = 1.0,
                max_hear_distance = 5
            })
        end
    end
)


playereffects.register_effect_type("high_speed", "High Speed", "witchcraft_potion_magenta", {"speed"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.speed_mod = 2.0
            player_state:updatePhysics()
        end
    end,
    function(effect, player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.speed_mod = 1.0
            player_state:updatePhysics()
        else
            player:set_physics_override({speed = 1.0})
        end
    end
)

playereffects.register_effect_type("low_speed", "Low Speed", "witchcraft_potion_magenta", {"speed"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.speed_mod = 0.5
            player_state:updatePhysics()
            player:set_physics_override({gravity = 1.2})
        end
    end,
    function(effect, player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.speed_mod = 1.0
            player_state:updatePhysics()
        else
            player:set_physics_override({speed = 1.0})
        end
        player:set_physics_override({gravity = 1.0})
    end
)

playereffects.register_effect_type("high_jump", "High Jump", "witchcraft_potion_green2", {"jump"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.jump_mod = 1.5
            player_state:updatePhysics()
            player:set_physics_override({gravity = 0.8})
        end
    end,
    function(effect, player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.jump_mod = 1.0
            player_state:updatePhysics()
        else
            player:set_physics_override({jump = 1.0})
        end
        player:set_physics_override({gravity = 1.0})
    end
)

playereffects.register_effect_type("low_jump", "Low Jump", "witchcraft_potion_green2", {"jump"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.jump_mod = 0.5
            player_state:updatePhysics()
        end
    end,
    function(effect, player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.jump_mod = 1.0
            player_state:updatePhysics()
        else
            player:set_physics_override({jump = 1.0})
        end
    end
)

playereffects.register_effect_type("low_gravity", "Antigravity", "witchcraft_potion_cyan", {"gravity"},
    function(player)
        player:set_physics_override({gravity = 0.1})
    end,
    function(effect, player)
        player:set_physics_override({gravity = 1.0})
    end
)

playereffects.register_effect_type("regen", "Strong Regeneration", "heart.png", {"health"},
    function(player)
        player:set_hp(player:get_hp()+1)
    end,
    nil, nil, nil, 1
)

playereffects.register_effect_type("breath", "Water Breath", "bubble.png", {"health"},
    function(player)
        player:set_breath(12)
    end,
    nil, nil, nil, 1
)

-- Repeating effect type: Adds 1 HP per 3 seconds
playereffects.register_effect_type("slowregen", "Regeneration", "heart.png", {"health"},
    function(player)
        player:set_hp(player:get_hp()+1)
    end,
    nil, nil, nil, 10
)

playereffects.register_effect_type("swimming", "Swimming", "witchcraft_potion_blue2", {"swimming"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            local pos = player:getpos()
            pos.y = pos.y + 1
            if minetest.get_node(pos).name == "default:water_source" then
                player_state.state.speed_mod = 3
                player_state:updatePhysics()
            else
                player_state.state.speed_mod = 1
                player_state:updatePhysics()
            end
        end
    end,
    function(effect, player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.speed_mod = 1.0
            player_state:updatePhysics()
        else
            player:set_physics_override({speed = 1.0})
        end
        player:set_physics_override({gravity = 1.0})
    end,
    nil, nil, 1
)

playereffects.register_effect_type("diving", "Diving", "witchcraft_potion_blue2", {"swimming"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            local pos = player:getpos()
            pos.y = pos.y + 1
            if minetest.get_node(pos).name == "default:water_source" then
                player_state.state.speed_mod = 3
                player_state:updatePhysics()
                player:set_physics_override({gravity = 4.0})
            else
                player_state.state.speed_mod = 1
                player_state:updatePhysics()
                player:set_physics_override({gravity = 1.0})
            end
        end
    end,
    function(effect, player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.speed_mod = 1.0
            player_state:updatePhysics()
        else
            player:set_physics_override({speed = 1.0})
        end
        player:set_physics_override({gravity = 1.0})
    end,
    nil, nil, 1
)

playereffects.register_effect_type("antidot", "Antidot", "witchcraft_potion_redbrown", {"poison"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.poisoned = math.max(0, player_state.state.poisoned - 1)
            player_staet:updateHud()
        end
    end,
    nil, nil, nil, 10
)

playereffects.register_effect_type("strong_antidot", "Strong Antidot", "witchcraft_potion_redbrown", {"poison"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.poisoned = math.max(0, player_state.state.poisoned - 1)
            player_staet:updateHud()
        end
    end,
    nil, nil, nil, 1
)

playereffects.register_effect_type("toxin", "Toxin", "witchcraft_potion_brown", {"poison"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.poisoned = math.max(0, player_state.state.poisoned + 1)
            player_staet:updateHud()
        end
    end,
    nil, nil, nil, 10
)

playereffects.register_effect_type("poison", "Strong Poison", "heart.png", {"health"},
    function(player)
        player:set_hp(player:get_hp()-1)
    end,
    nil, nil, nil, 1
)

playereffects.register_effect_type("slowpoison", "Poison", "heart.png", {"health"},
    function(player)
        player:set_hp(player:get_hp()-1)
    end,
    nil, nil, nil, 10
)

function potion_change_node(from_node, to_node, above, spawner)
    return function(item, user, pointed_thing)
        local player = user:get_player_name()
        local pos = nil
        if above then
            pos = pointed_thing.above
        else
            pos = pointed_thing.under
        end
        if pointed_thing.type == "node" then
            for k, v in ipair(from_node)do
                if minetest.get_node(pos).name == v then
                    if not minetest.is_protected(pos, player) then
                        minetest.set_node(pos, {name=to_node})
                        if spawner then
                            spawner(pos)
                        end
                    else
                        minetest.chat_send_player(player, "This area is protected.")
                    end
                    break
                end
            end
        end

        item:replace("vessels:glass_bottle")
        return item
    end
end

function go_home_effect(item, user, pointed_thing)
    minetest.sound_play("teleport",
        {to_player=user:get_player_name(), gain = 1.0})
    unified_inventory.go_home(user)
    item:replace("vessels:glass_bottle")
    return item
end
