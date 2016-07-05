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


function use_bottle(itemstack, user)
        local replace_with_item = "vessels:glass_bottle"
        if itemstack:is_empty() then
            itemstack:add_item(replace_with_item)
        else
            local inv = user:get_inventory()
            if inv:room_for_item("main", {name=replace_with_item}) then
                inv:add_item("main", replace_with_item)
            else
                local pos = user:getpos()
                pos.y = math.floor(pos.y + 0.5)
                core.add_item(pos, replace_with_item)
            end
        end
end

function fill_bottle(itemstack, user, replace_with_item)
    if itemstack:take_item() ~= nil then
        if itemstack:is_empty() then
            itemstack:add_item(replace_with_item)
        else
            local inv = user:get_inventory()
            if inv:room_for_item("main", {name=replace_with_item}) then
                inv:add_item("main", replace_with_item)
            else
                local pos = user:getpos()
                pos.y = math.floor(pos.y + 0.5)
                core.add_item(pos, replace_with_item)
            end
        end
    end
end


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
        player:set_breath(11)
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
            player_state:updateHud()
        end
    end,
    nil, nil, nil, 10
)

playereffects.register_effect_type("strong_antidot", "Strong Antidot", "witchcraft_potion_redbrown", {"poison"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.poisoned = math.max(0, player_state.state.poisoned - 1)
            player_state:updateHud()
        end
    end,
    nil, nil, nil, 1
)

playereffects.register_effect_type("toxin", "Toxin", "witchcraft_potion_brown", {"poison"},
    function(player)
        local player_state = exertion.getPlayerState(player)
        if player_state then
            player_state.state.poisoned = math.max(0, player_state.state.poisoned + 1)
            player_state:updateHud()
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
    return function(itemstack, user, pointed_thing)
        if itemstack:take_item() ~= nil then
            local player = user:get_player_name()
            local pos = nil
            if above then
                pos = pointed_thing.above
            else
                pos = pointed_thing.under
            end
            if pointed_thing.type == "node" then
                for k, v in ipairs(from_node)do
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
            use_bottle(itemstack, user)
        end
        return itemstack
    end
end

function go_home_effect(itemstack, user, pointed_thing)
    if itemstack:take_item() ~= nil then
        minetest.sound_play("teleport",
            {to_player=user:get_player_name(), gain = 1.0})
        unified_inventory.go_home(user)
        use_bottle(itemstack, user)
    end
    return itemstack
end

function register_magic(name, textures, damage, node_action, area_nodes_action, spawner)
    minetest.register_entity(name, {
        textures = textures,
        velocity = 0.1,
        damage = 2,
        collisionbox = {0, 0, 0, 0, 0, 0},
        on_step = function(self, obj, pos)
            local remove = minetest.after(2, function() 
                self.object:remove()
            end)
            local pos = self.object:getpos()
            local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
            for k, obj in pairs(objs) do
                if obj:get_luaentity() ~= nil then
                    if obj:get_luaentity().name ~= name and obj:get_luaentity().name ~= "__builtin:item" then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=damage},
                        }, nil)
                        --self.object:remove()
                    end
                end
            end
            for dx=0,1 do
                for dy=0,1 do
                    for dz=0,1 do
                        local p = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
                        local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                        local n = minetest.env:get_node(p).name
                        if node_action(self, p, t, n) then
                            self.object:remove()
                            return
                        end
                    end
                end
            end
            if spawner then
                local apos = self.object:getpos()
                spawner(apos)
            end
        end,
        hit_node = function(self, pos, node)
            local pos = self.object:getpos()
            for dx=-4,4 do
                for dy=-4,4 do
                    for dz=-4,4 do
                        local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                        local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                        local n = minetest.env:get_node(pos).name
                        area_nodes_action(self, p, t, n)
                    end
                end
            end
        end
    })
end

register_magic("witchcraft:fire", {"witchcraft_flame.png"}, 10,
    function(self, p, t, n)
        if n ~= "witchcraft:fire" and n ~= "air" and n ~="default:dirt_with_grass" and n ~="default:dirt_with_dry_grass" and n ~="default:stone"  then
            minetest.env:set_node(t, {name="fire:basic_flame"})
        elseif n =="default:dirt_with_grass" or n =="default:dirt_with_dry_grass" then
            self.object:remove()
            return true
        end
    end,
    function(self, p, t, n)
        if math.random(1, 50) <= 35 then
            minetest.env:remove_node(p)
        end
        if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <=5 then
            minetest.env:set_node(t, {name="fire:basic_flame"})
        end
    end,
    function(apos)
        local part = minetest.add_particlespawner(
            10, --amount
            0.3, --time
            {x=apos.x-0.3, y=apos.y-0.3, z=apos.z-0.3}, --minpos
            {x=apos.x+0.3, y=apos.y+0.3, z=apos.z+0.3}, --maxpos
            {x=-0, y=-0, z=-0}, --minvel
            {x=0, y=0, z=0}, --maxvel
            {x=0,y=-0.5,z=0}, --minacc
            {x=0.5,y=0.5,z=0.5}, --maxacc
            1, --minexptime
            1, --maxexptime
            1, --minsize
            2, --maxsize
            false, --collisiondetection
            "witchcraft_flame.png" --texture
        )
    end
)

register_magic("witchcraft:tnt_splash", {"witchcraft_splash_yellgrn.png"}, 2,
    function(self, p, t, n)
        if n ~= "witchcraft:tnt_splash" and n ~="default:obsidian" and n ~= "air" then
            local pos = self.object:getpos()
            minetest.sound_play("default_break_glass.1.ogg", {
            pos = self.object:getpos(),
            gaint = 1.0,
            max_hear_distance = 20,
            })
            tnt.boom(pos, {damage_radius=5,radius=3,ignore_protection=false})
            return true
        end
    end,
    function(self, p, t, n)
        if math.random(1, 50) <= 35 then
            tnt.boom(n, {damage_radius=5,radius=3,ignore_protection=false})
        end
        if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <=5 then
            minetest.env:set_node(t, {name="fire:basic_flame"})
        end
    end,
    nil
)

register_magic("witchcraft:fire_splash", {"witchcraft_splash_orange.png"}, 10,
    function(self, p, t, n)
        if n ~= "witchcraft:fire_splash" and n ~= "air" then
            minetest.env:set_node(t, {name="fire:basic_flame"})
            minetest.sound_play("default_break_glass.1", {
                pos = self.object:getpos(),
                max_hear_distance = 20,
                gain = 10.0,
            })
            self.object:remove()
        elseif n =="default:dirt_with_grass" or n =="default:dirt_with_dry_grass" then
            return true
        end
    end,
    function(self, p, t, n)
        if math.random(1, 50) <= 1 then
            minetest.env:remove_node(p)
        end
        if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <=5 then
            minetest.env:set_node(t, {name="fire:basic_flame"})
        end
    end,
    nil
)

function spawn_magic(magic, texture, vec_func, accel) 
    return function(itemstack, placer, pointed_thing)
        if itemstack:take_item() ~= nil then
            local dir = placer:get_look_dir();
            local playerpos = placer:getpos();
            local vec = vec_func(dir)
            local obj = minetest.env:add_entity({x=playerpos.x+dir.x*1.5,y=playerpos.y+1.5+dir.y,z=playerpos.z+0+dir.z}, magic)
            obj:setvelocity(vec)
            if accel then
                obj:setacceleration(accel)
            end
            if texture then
                local part = minetest.add_particlespawner(
                        10, --amount
                        0.3, --time
                        {x=playerpos.x-0.3, y=playerpos.y+1.5, z=playerpos.z-0.3}, --minpos
                        {x=playerpos.x+0.3, y=playerpos.y+1.5, z=playerpos.z+0.3}, --maxpos
                        {x=dir.x*3,y=dir.y*3,z=dir.z*3}, --minvel
                        {x=dir.x*3,y=dir.y*3,z=dir.z*3}, --maxvel
                        {x=0,y=-0.5,z=0}, --minacc
                        {x=0.5,y=0.5,z=0.5}, --maxacc
                        1, --minexptime
                        2, --maxexptime
                        1, --minsize
                        2, --maxsize
                        false, --collisiondetection
                        texture
                    )
            end
            use_bottle(itemstack, placer)
        end
        return itemstack
    end
end
