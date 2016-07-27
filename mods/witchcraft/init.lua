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


-- reset player invisibility if they go offline
--
---invisibility potion by Tenplus1(DWTFYWT V2), see darkpurple potion for on_use effect
---

witchcraft = { MOD_NAME = MOD_NAME, MOD_PATH = MOD_PATH}
_G[MOD_NAME] = witchcraft;

local invisibility = {}

function witchcraft.is_player_invisibility(player)
    if player then
        local name = player:get_player_name()
        return invisibility[name]
    else
        return false
    end
end


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

dofile(MOD_PATH.."/effects.lua")
dofile(MOD_PATH.."/pot.lua")
dofile(MOD_PATH.."/potions.lua")
dofile(MOD_PATH.."/scrolls.lua")
dofile(MOD_PATH.."/brewing_stand.lua")


enchanting:register_tools("technic_armor", {
	materials = "tin, lead, carbon, stainless",
	armor = 1,
	tools = {
		boots      = {enchants = "strong, speed"},
		chestplate = {enchants = "strong"},
		helmet     = {enchants = "strong"},
		leggings   = {enchants = "strong"}
	}
})

enchanting:register_tools("moreores", {
	materials = "silver",
	armor = 1,
	tools = {
		boots      = {enchants = "strong, speed"},
		chestplate = {enchants = "strong"},
		helmet     = {enchants = "strong"},
		leggings   = {enchants = "strong"}
	}
})

enchanting:register_tools("moreores", {
	materials = "silver, mithril",
	tools = {
		axe    = {enchants = "durable, fast"},
		pick   = {enchants = "durable, fast"}, 
		shovel = {enchants = "durable, fast"},
		sword  = {enchants = "sharp"}
	}
})

enchanting:register_tools("gloopblocks", {
	materials = "evil, cement",
	tools = {
		axe    = {enchants = "durable, fast"},
		pick   = {enchants = "durable, fast"}, 
		shovel = {enchants = "durable, fast"},
		sword  = {enchants = "sharp"}
	}
})

enchanting:register_tools("3d_armor", {
	materials = "mithril",
	armor = 1,
	tools = {
		boots      = {enchants = "strong, speed"},
		chestplate = {enchants = "strong"},
		helmet     = {enchants = "strong"},
		leggings   = {enchants = "strong"}
	}
})

enchanting:register_tools("technic_aluminum", {
	materials = "aluminum, ruby, sapphire",
	armor = 1,
	tools = {
		boots      = {enchants = "strong, speed"},
		chestplate = {enchants = "strong"},
		helmet     = {enchants = "strong"},
		leggings   = {enchants = "strong"}
	}
})

enchanting:register_tools("technic_aluminum", {
	materials = "aluminum",
	tools = {
		axe    = {enchants = "durable, fast"},
		pick   = {enchants = "durable, fast"}, 
		shovel = {enchants = "durable, fast"},
		sword  = {enchants = "sharp"}
	}
})

enchanting:register_tools("glooptest", {
	materials = "alatro, arol",
	tools = {
		axe    = {enchants = "durable, fast"},
		pick   = {enchants = "durable, fast"}, 
		shovel = {enchants = "durable, fast"},
		sword  = {enchants = "sharp"}
	}
})
