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
            "witchcraft_smoke.png^[colorize:magenta:50" --texture
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
            "witchcraft_smoke.png^[colorize:magenta:50" --texture
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

function potion_change_node(from_node, to_node, above, spawner, place)
    return function(itemstack, user, pointed_thing)
        if itemstack:take_item() ~= nil then
            local player = user:get_player_name()
            local pos = nil
            if above then
                pos = pointed_thing.above
            else
                pos = pointed_thing.under
            end
            if place then
                func = minetest.place_node
            else
                func = minetest.set_node
            end
            if pointed_thing.type == "node" then
                for k, v in ipairs(from_node)do
                print("DEBUG"..minetest.get_node(pos).name)
                if minetest.get_node(pos).name == v then
                    if not minetest.is_protected(pos, player) then
                    func(pos, {name=to_node})
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

function potion_farming_grow(itemstack, user, pointed_thing)
    if itemstack:take_item() ~= nil then
        local player = user:get_player_name()
        local pos = nil
        --if above then
        --    pos = pointed_thing.above
        --else
        --    pos = pointed_thing.under
        --end
        pos = pointed_thing.under
        growing = {
            {"farming:wheat_", "farming:wheat_8",},
            {"farming:barley_", "farming:barley_7",},
            {"farming:tomato_", "farming:tomato_8",},
            {"farming:raspberry_", "farming:raspberry_4",},
            {"farming:pumpkin_", "farming:pumpkin",},
            {"farming:potato_", "farming:potato_4",},
            {"farming:melon_", "farming:melon_8",},
            {"farming:rhubar_", "farming:rhubarb_3",},
            {"farming:grapes_", "farming:grapes_8",},
            {"farming:cotton_", "farming:cotton_8",},
            {"farming:corn_", "farming:corn_8",},
            {"farming:coffee_", "farming:coffee_5",},
            {"farming:rice_", "farming:rice_4",},
            {"farming:tea_", "farming:tea_4",},
            {"farming:cocoa_", "farming:cocoa_3",},
            {"farming:carrot_", "farming:carrot_8",},
            {"farming:cucumber_", "farming:cucumber_4",},
            {"farming:blueberry_", "farming:blueberry_4",},
            {"farming:beanpole_", "farming:beanpole_5",},
            {"farming_plus:carrot_", "farming_plus:carrot",},
            {"farming_plus:orange_", "farming_plus:orange",},
            {"farming_plus:potato_", "farming_plus:potato",},
            {"farming_plus:rhubarb_", "farming_plus:rhubarb",},
            {"farming_plus:strawberry_", "farming_plus:strawberry",},
            {"farming_plus:tomato_", "farming_plus:tomato",},
        }
        if pointed_thing.type == "node" then
            for k, v in ipairs(growing)do
                local pfrom = v[1]
                local pto = v[2]
                if string.find(minetest.get_node(pos).name,pfrom) then
                    if not minetest.is_protected(pos, player) then
                        minetest.set_node(pos, {name=pto})
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

function grow_tree(pos)
    local mapgen = minetest.get_mapgen_params().mgname
    if mapgen == "v6" then
        default.grow_tree(pos, math.random(1, 4) == 1)
    else
        default.grow_new_apple_tree(pos)
    end
end

function grow_default_jungle(pos)
    local mapgen = minetest.get_mapgen_params().mgname
    if mapgen == "v6" then
        default.grow_jungle_tree(pos)
    else
        default.grow_new_jungle_tree(pos)
    end
end

local function is_snow_nearby(pos)
    local x, y, z = pos.x, pos.y, pos.z
    local c_snow = minetest.get_content_id("default:snow")
    local c_snowblock = minetest.get_content_id("default:snowblock")
    local c_dirtsnow = minetest.get_content_id("default:dirt_with_snow")

    local vm = minetest.get_voxel_manip()
    local minp, maxp = vm:read_from_map(
        {x = x - 1, y = y - 1, z = z - 1},
        {x = x + 1, y = y + 1, z = z + 1}
    )
    local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
    local data = vm:get_data()

    for yy = y - 1, y + 1 do
    for zz = z - 1, z + 1 do
        local vi  = a:index(x - 1, yy, zz)
        for xx = x - 1, x + 1 do
            local nodid = data[vi]
            if nodid == c_snow or nodid == c_snowblock or nodid == c_dirtsnow then
                return true
            end
            vi  = vi + 1
        end
    end
    end

    return false
end

function grow_pine(pos)
    local mapgen = minetest.get_mapgen_params().mgname
    local snow = is_snow_nearby(pos)
    if mapgen == "v6" then
        default.grow_pine_tree(pos, snow)
    elseif snow then
        default.grow_new_snowy_pine_tree(pos)
    else
        default.grow_new_pine_tree(pos)
    end
end

function grow_banana(pos)
    farming.generate_tree(pos, "default:tree", "farming_plus:banana_leaves", {"default:dirt", "default:dirt_with_grass"}, {["farming_plus:banana"]=20})
end

function grow_cocoa(pos)
    farming.generate_tree({x=pos.x, y=pos.y+1, z=pos.z}, "default:tree", "farming_plus:cocoa_leaves", {"default:sand", "default:desert_sand"}, {["farming_plus:cocoa"]=20})
end

function grow_model_tree(tree_model)
    return function (pos)
        minetest.remove_node(pos)
        biome_lib:grow_tree(pos, tree_model)
    end
end

function potion_tree_grow(itemstack, user, pointed_thing)
    if itemstack:take_item() ~= nil then
        local player = user:get_player_name()
        local pos = nil
        pos = pointed_thing.under
        local growing = {
            {"default:acacia_sapling", grow_model_tree(moretrees.acacia_model)},
            {"default:aspen_sapling", default.grow_new_aspen_tree},
            {"default:junglesapling", grow_default_jungle},
            {"default:pine_sapling", grow_pine},
            {"default:sapling", grow_tree},
            {"farming_plus:banana_sapling", grow_banana},
            {"farming_plus:cocoa_sapling", grow_cocoa},
            {"moretrees:apple_tree_sapling", grow_model_tree(moretrees.apple_tree_model) },
            {"moretrees:beech_sapling", grow_model_tree(moretrees.beech_model)},
            {"moretrees:birch_sapling", moretrees.grow_birch},
            {"moretrees:cedar_sapling", grow_model_tree(moretrees.cedar_model)},
            {"moretrees:fir_sapling", moretrees.grow_fir},
            {"moretrees:oak_sapling", grow_model_tree(moretrees.oak_model)},
            {"moretrees:palm_sapling", grow_model_tree(moretrees.palm_model)},
            {"moretrees:rubber_tree_sapling", grow_model_tree(moretrees.rubber_tree_model)},
            {"moretrees:sequoia_sapling", grow_model_tree(moretrees.sequoia_model)},
            {"moretrees:spruce_sapling", moretrees.grow_spruce},
            {"moretrees:willow_sapling", grow_model_tree(moretrees.willow_model)},
        }
        if pointed_thing.type == "node" then
            for k, v in ipairs(growing) do
                local pfrom = v[1]
                local pto = v[2]
                if string.find(minetest.get_node(pos).name,pfrom) then
                    if not minetest.is_protected(pos, player) then
                        pto(pos)
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
                        self.object:remove()
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

register_magic("witchcraft:fire", {"witchcraft_flame.png"}, 12,
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

register_magic("witchcraft:fire_2", {"witchcraft_flame.png"}, 20,
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

register_magic("witchcraft:fire_splash", {"witchcraft_splash_orange.png"}, 15,
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

function drink_item(waterSize) 
    return function(itemstack, player, pointed_thing)
        if itemstack:take_item() ~= nil then
            exertion.drinkItem(player, waterSize)
            use_bottle(itemstack, player)
        end
        return itemstack
    end
end

local portal_def = {
    tiles = {
        "nether_transparent.png",
        "nether_transparent.png",
        "nether_transparent.png",
        "nether_transparent.png",
        {
            name = "nether_portal.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.5,
            },
        },
        {
            name = "nether_portal.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.5,
            },
        },
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    use_texture_alpha = true,
    walkable = false,
    pointable = true,
    drop = "",
    light_source = 10,
    post_effect_color = {a = 180, r = 128, g = 0, b = 128},
    alpha = 192,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.1,  0.5, 0.5, 0.1},
        },
    },
    groups = {not_in_creative_inventory = 1, snappy=1, oddly_breakable_by_hand=1},
    on_rightclick = function(pos, node, player, stack, pointed_thing)
        if node.name == "witchcraft:portal_top" then
            pos.y = pos.y - 1
        end
        local meta = minetest.get_meta(pos)
        local target = meta:get_string("target")
        if target == "home" then
            unified_inventory.go_home(player)
            minetest.remove_node(pos)
            local p = {x=pos.x, y=pos.y+1, z=pos.z}
            minetest.remove_node(p)
            p = player:getpos()
            minetest.remove_node(p)
            minetest.set_node(p, {name="witchcraft:portal"})
            minetest.get_meta(p):set_string("target",minetest.pos_to_string(pos))
            p.y = p.y + 1
            minetest.remove_node(p)
            minetest.set_node(p, {name="witchcraft:portal_top"})
        else
            local target = minetest.string_to_pos(meta:get_string("target"))
            minetest.remove_node(pos)
            local p = {x=pos.x, y=pos.y+1, z=pos.z}
            minetest.remove_node(p)
            if target then
                player:setpos(target)
            end
        end
    end,
    after_destruct = function(pos, oldnode)
        pos.y = pos.y - 1
        minetest.remove_node(pos)
    end
}

minetest.register_node("witchcraft:portal_top", table.copy(portal_def))

portal_def.description = "Home Portal"
groups = {snappy=1, oddly_breakable_by_hand=1}
portal_def.after_place_node  = function(pos, placer, itemstack)
       local node = minetest.get_node(pos)
       local p = {x=pos.x, y=pos.y+1, z=pos.z}
       local p2 = node.param2
       minetest.add_node(p, {name="witchcraft:portal_top", paramtype2="facedir", param2=p2})
       minetest.get_meta(pos):set_string("target","home")
    end

portal_def.after_destruct = function(pos, oldnode)
        pos.y = pos.y + 1
        minetest.remove_node(pos)
    end

minetest.register_node("witchcraft:portal", table.copy(portal_def))

minetest.register_abm({
    nodenames = {"witchcraft:portal", "witchcraft:portal_top"},
    interval = 1,
    chance = 2,
    action = function(pos, node)
        minetest.add_particlespawner(
            32, --amount
            4, --time
            {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25}, --minpos
            {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25}, --maxpos
            {x = -0.8, y = -0.8, z = -0.8}, --minvel
            {x = 0.8, y = 0.8, z = 0.8}, --maxvel
            {x = 0, y = 0, z = 0}, --minacc
            {x = 0, y = 0, z = 0}, --maxacc
            0.5, --minexptime
            1, --maxexptime
            1, --minsize
            2, --maxsize
            false, --collisiondetection
            "nether_particle.png" --texture
        )
    end
})

