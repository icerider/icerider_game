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
local MOD_NAME = minetest.get_current_modname() or "witchcraft";
local MOD_PATH = minetest.get_modpath(MOD_NAME);

local witchcraft = { MOD_NAME = MOD_NAME, MOD_PATH = MOD_PATH };
_G[MOD_NAME] = witchcraft;
--

function witchcraft.register_potion(potiondef)
    local image = "witchcraft_potion_"..potiondef.basename..".png"
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
            playereffects.apply_effect_type(potiondef.effect_type, potiondef.duration, user)
            itemstack:take_item()
            if potiondef.spawner then
                potiondef.spawner(user:getpos())
            else
                add_drink_spawner(user:getpos())
            end
            return {name = "vessels:glass_bottle"}
        end
    else
        on_use = function(itemstack, user, thing)
            if potiondef.spawner then
                potiondef.spawner(user:getpos())
            else
                add_drink_spawner(user:getpos())
            end
            itemstack:take_item()
            return {name = "vessels:glass_bottle"}
        end
    end
    minetest.register_craftitem("witchcraft:potion_"..potiondef.basename, {
        description = potiondef.description,
        wield_image = image,
        inventory_image = image,
        stack_max = 5,
        groups = groups,
        on_use = on_use
    })
end

witchcraft.register_potion({
    basename = "red",
    description = "Tasty Potion",
    effect_group = "food",
    upgradable = true,
    on_use = minetest.item_eat(30, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "red_2",
    description = "Tasty Potion (lv2)",
    image = "witchcraft_potion_red.png^[colorize:black:50",
    effect_group = "food",
    on_use = minetest.item_eat(100, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "darkpurple",
    description = "Shady Potion",
    effect_type = "invisibility",
    duration = 20,
    upgradable = true
})

witchcraft.register_potion({
    basename = "darkpurple_2",
    image = "witchcraft_potion_darkpurple.png^[colorize:black:50",
    description = "Shady Potion (lv_2)",
    effect_type = "invisibility",
    duration = 35,
})

witchcraft.register_potion({
    basename = "brown",
    description = "Murky Potion",
    effect_type = "toxin",
    duration = 30,
    upgradable = true
})

witchcraft.register_potion({
    basename = "brown_2",
    image = "witchcraft_potion_brown.png^[colorize:black:50",
    description = "Murky Potion (lv_2)",
    effect_type = "toxin",
    duration = 50
})

witchcraft.register_potion({
    basename = "yellgrn",
    description = "Dodgy Potion",
    upgradable = true
    on_use = function(pos, placer)
        local pos = placer:getpos();
        tnt.boom(pos, {damage_radius=5,radius=3,ignore_protection=false})
    end,
})

witchcraft.register_potion({
    basename = "yellgrn_2",
    description = "Dodgy Potion (lv_2)",
    image = "witchcraft_potion_yellgrn.png^[colorize:black:50",
    on_use = function(pos, placer)
        local pos = placer:getpos();
        tnt.boom(pos, {damage_radius=10,radius=4,ignore_protection=false})
    end,
})

witchcraft.register_potion({
    basename = "purple",
    description = "Smokey Potion",
    spawner = add_smoke_spawner,
    upgradable = true
})

witchcraft.register_potion({
    basename = "purple_2",
    image = "witchcraft_potion_purple.png^[colorize:black:50",
    description = "Smokey Potion (lv_2)",
    spawner = add_smoke_spawner_lv2,
})

witchcraft.register_potion({
    basename = "gpurple",
    description = "Filling Potion",
    on_use = minetest.item_eat(10, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "gred",
    description = "Hunger Potion",
    on_use = minetest.item_eat(-4, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "grey",
    description = "Evil Potion",
    upgradable = true,
    duration = 200,
    effect_type = "slowpoison",
})

witchcraft.register_potion({
    basename = "grey_2",
    image = "witchcraft_potion_grey.png^[colorize:black:50",
    description = "Evil Potion (lv_2)",
    effect_type = "poison",
    duration = 30,
})

witchcraft.register_potion({
    basename = "blue",
    description = "Bottle of Water",
    on_use = potion_change_node({"air"}, "default:water_source", true)
})

witchcraft.register_potion({
    basename = "green",
    description = "Melon Potion",
    on_use = potion_change_node({"air"}, "farmin:melon_8", true, add_drink_spawner)
})

witchcraft.register_potion({
    basename = "yellow",
    description = "Alchemy Potion",
    upgradable = true,
    on_use = potion_change_node({"technic:lead_block"}, "default:goldblock", false, add_drink_spawner)
})

witchcraft.register_potion({
    basename = "yellow_2",
    image = "witchcraft_potion_yellow.png^[colorize:black:50",
    description = "Alchemy Potion (lv2)",
    on_use = potion_change_node({
        "glooptest:sapphireblock",
        "glooptest:rubyblock",
        "glooptest:emeraldblock",
        "glooptest:topazblock",
        "glooptest:amethystblock",
    }, "default:goldblock", false, add_drink_spawner)
})

witchcraft.register_potion({
    basename = "aqua",
    description = "Complex Potion",
    on_use = minetest.item_eat(0, "vessels:glass_bottle"),
})

witchcraft.register_potion({
    basename = "magenta",
    description = "Fast Potion",
    upgradable = true,
    effect_type = "high_speed",
    duration = 20
})

witchcraft.register_potion({
    basename = "magenta_2",
    image = "witchcraft_potion_magenta.png^[colorize:black:50",
    description = "Fast Potion (lv_2)",
    effect_type = "high_speed",
    duration = 30
})

witchcraft.register_potion({
    basename = "cyan",
    description = "Light Potion",
    effect_type = "low_gravity",
    duration = 10
})

witchcraft.register_potion({
    basename = "gcyan",
    description = "Air Potion",
    effect_type = "breath",
    duration = 30
})

witchcraft.register_potion({
    basename = "cyan_2",
    image = "witchcraft_potion_cyan.png^[colorize:black:50",
    description = "Teleport Potion",
    on_use = go_home_effect
})

witchcraft.register_potion({
    basename = "green2",
    description = "Volatile Potion",
    effect_type = "high_jump",
    upgradable = true,
    duration = 10
})

witchcraft.register_potion({
    basename = "green2_2",
    image = "witchcraft_potion_green2.png^[colorize:black:50",
    description = "Volatile Potion (lv_2)",
    effect_type = "high_jump",
    duration = 20
})

witchcraft.register_potion({
    basename = "ggreen",
    description = "Darkness Potion",
    spawner = add_dark_spawner
})

witchcraft.register_potion({
    basename = "redbrown",
    description = "Antidot Potion",
    effect_type = "antidot",
    upgradable = true,
    duration = 40
})

witchcraft.register_potion({
    basename = "redbrown_2",
    image = "witchcraft_potion_redbrown.png^[colorize:black:50",
    description = "Antidot Potion (lv_2)",
    effect_type = "strong_antidot",
    duration = 20
})

witchcraft.register_potion({
    basename = "blue2",
    description = "Waterly Potion",
    effect_type = "swimming",
    upgradable = true,
    duration = 30
})

witchcraft.register_potion({
    basename = "blue2_2",
    image = "witchcraft_potion_blue2.png^[colorize:black:50",
    description = "Waterly Potion (lv_2)",
    effect_type = "diving",
    duration = 60
})
