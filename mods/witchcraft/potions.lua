--Stuff from vessels

-- -
-- Copyright (C) 2012 Vanessa Ezekowitz
-- Copyright (C) 2012 celeron55, Perttu Ahola <celeron55@gmail.com>

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

--changes so that bottles can't stack
--

function witchcraft.register_potion(potiondef)
    local itemtype = "potion"
    if potiondef.itemtype then
        itemtype = potiondef.itemtype
    end
    local image = "witchcraft_"..itemtype.."_"..potiondef.basename..".png"
    if potiondef.image then
        image = potiondef.image
    end
    local groups = {vessel=1,dig_immediate=3,attached_node=1}
    if potiondef.upgradable then
        groups.potion = 1
    else
        groups.potion2 = 1
    end
    local on_use;
    if potiondef.on_use then
        on_use = potiondef.on_use
    elseif potiondef.effect_type then
        on_use = function(itemstack, user, thing)
            if itemstack:take_item() ~= nil  then
                playereffects.apply_effect_type(potiondef.effect_type, potiondef.duration, user)
                if potiondef.spawner then
                    potiondef.spawner(user:getpos())
                else
                    add_drink_spawner(user:getpos())
                end
                use_bottle(itemstack, user)
            end
            return itemstack
        end
    else
        on_use = function(itemstack, user, thing)
            if itemstack:take_item() ~= nil  then
                if potiondef.spawner then
                    potiondef.spawner(user:getpos())
                else
                    add_drink_spawner(user:getpos())
                end
                use_bottle(itemstack, user)
            end
            return itemstack
        end
    end
    minetest.register_craftitem("witchcraft:"..itemtype.."_"..potiondef.basename, {
        description = potiondef.description,
        wield_image = image,
        inventory_image = image,
        stack_max = 50,
        groups = groups,
        on_use = on_use
    })
end

witchcraft.register_potion({
    basename = "red",
    description = "Tasty Potion",
    effect_group = "food",
    upgradable = true,
    on_use = minetest.item_eat(20, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "red_2",
    description = "Tasty Potion (lv2)",
    image = "witchcraft_potion_red.png^[colorize:black:50",
    effect_group = "food",
    on_use = minetest.item_eat(60, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "red_blue",
    description = "Shady Potion",
    effect_type = "invisibility",
    duration = 30,
    upgradable = true
})

witchcraft.register_potion({
    basename = "darkpurple",
    description = "Shady Potion (lv_2)",
    effect_type = "invisibility",
    duration = 60,
})

witchcraft.register_potion({
    basename = "orange",
    description = "Dodgy Potion",
    upgradable = true,
    on_use = function(itemstack, placer)
        if itemstack:take_item() ~= nil then
            use_bottle(itemstack, placer)
            minetest.after(0, function()
                local pos = placer:getpos();
                tnt.boom(pos, {damage_radius=5,radius=3,ignore_protection=false})
            end)
        end
        return itemstack
    end,
})

witchcraft.register_potion({
    basename = "orange_2",
    description = "Dodgy Potion (lv_2)",
    image = "witchcraft_potion_orange.png^[colorize:black:50",
    on_use = function(itemstack, placer)
        if itemstack:take_item() ~= nil then
            use_bottle(itemstack, placer)
            minetest.after(0, function()
                local pos = placer:getpos();
                tnt.boom(pos, {damage_radius=10,radius=4,ignore_protection=false})
            end)
        end
        return itemstack
    end,
})

witchcraft.register_potion({
    basename = "brown",
    description = "Smokey Potion",
    spawner = add_smoke_spawner,
    upgradable = true
})

witchcraft.register_potion({
    basename = "lightyellow",
    description = "Filling Potion",
    on_use = minetest.item_eat(5, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "grey",
    description = "Catalisator Potion",
    upgradable = true,
    duration = 20,
    effect_type = "slowpoison",
})

witchcraft.register_potion({
    basename = "so2",
    description = "Sulfur Oxide",
    upgradable = true,
    duration = 60,
    effect_type = "slowpoison",
})

witchcraft.register_potion({
    basename = "grey_2",
    image = "witchcraft_potion_grey.png^[colorize:black:50",
    description = "Catalisator Potion (lv_2)",
    effect_type = "poison",
    duration = 30,
})

witchcraft.register_potion({
    basename = "blue",
    description = "Bottle of Water",
    on_use = minetest.item_eat(2, "vessels:glass_bottle"),
    --potion_change_node({"air", "default:water_flowing", "default:river_water_flowing"}, "default:water_source", true)
})

witchcraft.register_potion({
    basename = "lava",
    description = "Bottle of Lava",
    effect_type = "poison",
    duration = 10,
})

witchcraft.register_potion({
    basename = "green",
    description = "Green Filling Potion",
    on_use = minetest.item_eat(2, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "green_2",
    image = "witchcraft_potion_green.png^[colorize:black:50",
    description = "Grow Plant Potion",
    on_use = potion_farming_grow
})

witchcraft.register_potion({
    basename = "green2",
    description = "Grow Tree Potion",
    on_use = potion_tree_grow
})

witchcraft.register_potion({
    basename = "red_yellow",
    description = "Alchemy Potion",
    upgradable = true,
    on_use = potion_change_node({"technic:lead_block"}, "default:goldblock", false, add_drink_spawner)
})

witchcraft.register_potion({
    basename = "white",
    description = "Alchemy Potion (lv2)",
    on_use = potion_change_node({
        "glooptest:sapphireblock",
        "glooptest:rubyblock",
        "glooptest:emeraldblock",
        "glooptest:topazblock",
        "glooptest:amethystblock",
    }, "default:diamondblock", false, add_drink_spawner)
})

witchcraft.register_potion({
    basename = "red_green",
    description = "Fast Potion",
    upgradable = true,
    effect_type = "high_speed",
    duration = 20
})

witchcraft.register_potion({
    basename = "red_green_2",
    image = "witchcraft_potion_red_green.png^[colorize:black:50",
    description = "Fast Potion (lv_2)",
    effect_type = "high_speed",
    duration = 60
})

witchcraft.register_potion({
    basename = "gpurple",
    description = "Light Potion",
    effect_type = "low_gravity",
    duration = 10
})

witchcraft.register_potion({
    basename = "blue2",
    description = "Air Potion",
    effect_type = "breath",
    duration = 20
})

witchcraft.register_potion({
    basename = "blue2_2",
    image = "witchcraft_potion_blue2.png^[colorize:black:50",
    description = "Air Potion (lv_2)",
    effect_type = "breath",
    duration = 50
})

witchcraft.register_potion({
    basename = "cyan",
    description = "Teleport Potion",
    on_use = go_home_effect
})

witchcraft.register_potion({
    basename = "aqua",
    description = "Home Portal Potion",
    on_use = potion_change_node({"air", "default:air"}, "witchcraft:portal", true, add_drink_spawner, true)
})

witchcraft.register_potion({
    basename = "yellow",
    description = "Low Jump Potion",
    effect_type = "low_jump",
    duration = 20
})

witchcraft.register_potion({
    basename = "yellow_2",
    image = "witchcraft_potion_yellow.png^[colorize:black:50",
    description = "Volatile Potion",
    effect_type = "high_jump",
    upgradable = true,
    duration = 10
})

witchcraft.register_potion({
    basename = "ggreen",
    description = "Volatile Potion (lv_2)",
    effect_type = "high_jump",
    duration = 20
})


witchcraft.register_potion({
    basename = "purple",
    description = "Antidot Potion",
    effect_type = "antidot",
    upgradable = true,
    duration = 4
})

witchcraft.register_potion({
    basename = "purple_2",
    image = "witchcraft_potion_purple.png^[colorize:black:50",
    description = "Antidot Potion (lv_2)",
    effect_type = "strong_antidot",
    duration = 20
})

witchcraft.register_potion({
    basename = "magenta",
    description = "Waterly Potion",
    effect_type = "swimming",
    upgradable = true,
    duration = 30
})

witchcraft.register_potion({
    basename = "magenta_2",
    image = "witchcraft_potion_magenta.png^[colorize:black:50",
    description = "Waterly Potion (lv_2)",
    effect_type = "diving",
    duration = 60
})

witchcraft.register_potion({
    basename = "yellgrn",
    description = "Dragon Potion",
    on_use = spawn_magic("witchcraft:fire", "witchcraft_flame.png", 
        function(dir)
            return {x=dir.x*2, y=dir.y*2.5, z=dir.z*2}
        end
    )
})

witchcraft.register_potion({
    basename = "yellgrn_2",
    image = "witchcraft_potion_yellgrn.png^[colorize:black:50",
    description = "Dragon Potion (lv_2)",
    on_use = spawn_magic("witchcraft:fire_2", "witchcraft_flame.png^[colorize:blue:200", 
        function(dir)
            return {x=dir.x*3, y=dir.y*3.5, z=dir.z*3}
        end
    )
})

witchcraft.register_potion({
    basename = "yellgrn",
    itemtype = "splash",
    description = "Dragon Splash Potion",
    on_use = spawn_magic("witchcraft:fire_splash", nil, 
        function(dir)
            return {x=dir.x*6, y=dir.y*3.5, z=dir.z*6}
        end, {x=0,y=-9.8,z=0}
    )
})

witchcraft.register_potion({
    basename = "orange",
    itemtype = "splash",
    description = "Dodgy Splash Potion",
    on_use = spawn_magic("witchcraft:tnt_splash", nil, 
        function(dir)
            return {x=dir.x*7, y=dir.y*3.5, z=dir.z*7}
        end, {x=0,y=-9.8,z=0}
    )
})

witchcraft.register_potion({
    basename = "gcyan",
    description = "Strong Regeneration Potion",
    effect_type = "regen",
    upgradable = true,
    duration = 20
})

witchcraft.register_potion({
    basename = "gred",
    description = "Regeneration Potion",
    effect_type = "slowregen",
    upgradable = true,
    duration = 10
})

