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

dofile(minetest.get_modpath("witchcraft").."/effects.lua")
dofile(minetest.get_modpath("witchcraft").."/pot.lua")
dofile(minetest.get_modpath("witchcraft").."/potions.lua")
dofile(minetest.get_modpath("witchcraft").."/scrolls.lua")
dofile(minetest.get_modpath("witchcraft").."/brewing_stand.lua")
