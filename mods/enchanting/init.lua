local MOD_NAME = minetest.get_current_modname() or "enchanting";
local MOD_PATH = minetest.get_modpath(MOD_NAME);


-- reset player invisibility if they go offline
--
---invisibility potion by Tenplus1(DWTFYWT V2), see darkpurple potion for on_use effect
---

enchanting = { MOD_NAME = MOD_NAME, MOD_PATH = MOD_PATH}
_G[MOD_NAME] = enchanting;

screwdriver = screwdriver or {}

-- Cost in Mese crystal(s) for enchanting.
local mese_cost = 5

-- Force of the enchantments.
enchanting.uses     = 1.2  -- Durability
enchanting.times    = 0.1  -- Efficiency
enchanting.damages  = 1    -- Sharpness
enchanting.strength = 1.2  -- Armor strength (3d_armor only)
enchanting.speed    = 0.4  -- Player speed (3d_armor only)
enchanting.jump     = 0.4  -- Player jumping (3d_armor only)

function enchanting.formspec(pos, num)
	local meta = minetest.get_meta(pos)
	local formspec = [[ size[9,9;]
			bgcolor[#080808BB;true]
			background[0,0;9,9;ench_ui.png]
			list[context;tool;0.9,2.9;1,1;]
			list[context;mese;2,2.9;1,1;]
			list[current_player;main;0.5,4.5;8,4;]
			image[2,2.9;1,1;mese_layout.png]
			tooltip[sharp;Your weapon inflicts more damages]
			tooltip[durable;Your tool last longer]
			tooltip[fast;Your tool digs faster]
			tooltip[strong;Your armor is more resistant]
			tooltip[speed;Your speed is increased] ]]
			..default.gui_slots..default.get_hotbar_bg(0.5,4.5)

	local enchant_buttons = {
		[[ image_button[3.9,0.85;4,0.92;bg_btn.png;fast;Efficiency (Emerald)]
		image_button[3.9,1.77;4,1.12;bg_btn.png;durable;Durability (Amethist)] ]],
		"image_button[3.9,0.85;4,0.92;bg_btn.png;strong;Strength (Sapphire)]",
		"image_button[3.9,2.9;4,0.92;bg_btn.png;sharp;Sharpness (Ruby)]",
		[[ image_button[3.9,0.85;4,0.92;bg_btn.png;strong;Strength (Sapphire)]
		image_button[3.9,1.77;4,1.12;bg_btn.png;speed;Speed (Topaz)] ]]
	}

	formspec = formspec..(enchant_buttons[num] or "")
	meta:set_string("formspec", formspec)
end

function enchanting.on_put(pos, listname, _, stack)
	if listname == "tool" then
		local stackname = stack:get_name()
		local tool_groups = {
			"axe, pick, shovel",
			"chestplate, leggings, helmet",
			"sword", "boots"
		}

		for idx, tools in pairs(tool_groups) do
			if tools:find(stackname:match(":(%w+)")) then
				enchanting.formspec(pos, idx)
			end
		end
	end
end

function enchanting.fields(pos, _, fields, sender)
	if fields.quit then return end
	local inv = minetest.get_meta(pos):get_inventory()
	local tool = inv:get_stack("tool", 1)
	local mese = inv:get_stack("mese", 1)
	local orig_wear = tool:get_wear()
	local mod, name = tool:get_name():match("(.*):(.*)")
	local field = next(fields)
	local enchanted_tool = (mod or "")..":enchanted_"..(name or "").."_"..field
	local p1 = {x=pos.x-2, y=pos.y, z=pos.z-2}
	local p2 = {x=pos.x+2, y=pos.y+1, z=pos.z+2}
	local l_mese_cost = mese_cost
	local bookshelf = minetest.find_nodes_in_area(p1,p2, {"default:bookshelf"})
	if bookshelf then
		l_mese_cost = l_mese_cost - math.min(4, #bookshelf)
	end
	local gem_name = mese:get_name()
        if field == "sharp" and gem_name == "glooptest:ruby_gem" or field == "durable" and gem_name == "glooptest:amethyst_gem" or field == "fast" and gem_name == "glooptest:emerald_gem" or field == "strong" and gem_name == "glooptest:sapphire_gem" or field == "speed" and gem_name == "glooptest:topaz_gem" then
		if mese:get_count() >= l_mese_cost and minetest.registered_tools[enchanted_tool] then
			minetest.sound_play("xdecor_enchanting", {to_player=sender:get_player_name(), gain=0.8})
			tool:replace(enchanted_tool)
			tool:add_wear(orig_wear)
			mese:take_item(l_mese_cost)
			inv:set_stack("mese", 1, mese)
			inv:set_stack("tool", 1, tool)
		end
	end
end

function enchanting.dig(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("tool") and inv:is_empty("mese")
end

local function allowed(tool)
	for item in pairs(minetest.registered_tools) do
		if item:find("enchanted_"..tool) then return true end
	end
	return false
end

function enchanting.put(_, listname, _, stack)
	local item = stack:get_name():match("[^:]+$")
	if listname == "mese" and (item == "ruby_gem" or item == "topaz_gem" or item == "sapphire_gem" or item == "emerald_gem" or item == "amethyst_gem") then
		return stack:get_count()
	elseif listname == "tool" and allowed(item) then
		return 1 
	end
	return 0
end

function enchanting.on_take(pos, listname)
	if listname == "tool" then enchanting.formspec(pos, nil) end
end

function enchanting.construct(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext", "Enchantment Table")
	enchanting.formspec(pos, nil)

	local inv = meta:get_inventory()
	inv:set_size("tool", 1)
	inv:set_size("mese", 1)

	minetest.add_entity({x=pos.x, y=pos.y+0.85, z=pos.z}, "xdecor:book_open")
	local timer = minetest.get_node_timer(pos)
	timer:start(5.0)
end

function enchanting.destruct(pos)
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.9)) do
		if obj and obj:get_luaentity() and
				obj:get_luaentity().name == "xdecor:book_open" then
			obj:remove() break
		end
	end
end

function enchanting.timer(pos)
	local node = minetest.get_node(pos)
	local num = #minetest.get_objects_inside_radius(pos, 0.9)

	if num == 0 then
		minetest.add_entity({x=pos.x, y=pos.y+0.85, z=pos.z}, "xdecor:book_open")
	end

	local minp = {x=pos.x-2, y=pos.y, z=pos.z-2}
	local maxp = {x=pos.x+2, y=pos.y+1, z=pos.z+2}
	local bookshelves = minetest.find_nodes_in_area(minp, maxp, "default:bookshelf")
	if #bookshelves == 0 then return true end

	local bookshelf_pos = bookshelves[math.random(1, #bookshelves)]
	local x = pos.x - bookshelf_pos.x
	local y = bookshelf_pos.y - pos.y
	local z = pos.z - bookshelf_pos.z

	if tostring(x..z):find(2) then
		minetest.add_particle({
			pos = bookshelf_pos,
			velocity = {x=x, y=2-y, z=z},
			acceleration = {x=0, y=-2.2, z=0},
			expirationtime = 1,
			size = 2,
			texture = "xdecor_glyph"..math.random(1,18)..".png"
		})
	end
	return true
end

minetest.register_node(":xdecor:enchantment_table", {
	description = "Enchantment Table",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"enchtable_top.png",  "enchtable_bottom.png",
		 "enchtable_side.png", "enchtable_side.png",
		 "enchtable_side.png", "enchtable_side.png"},
	groups = {cracky=1, level=1},
	sounds = default.node_sound_stone_defaults(),
	on_rotate = screwdriver.rotate_simple,
	can_dig = enchanting.dig,
	on_timer = enchanting.timer,
	on_construct = enchanting.construct,
	on_destruct = enchanting.destruct,
	on_receive_fields = enchanting.fields,
	on_metadata_inventory_put = enchanting.on_put,
	on_metadata_inventory_take = enchanting.on_take,
	allow_metadata_inventory_put = enchanting.put,
	allow_metadata_inventory_move = function() return 0 end
})

minetest.register_entity(":xdecor:book_open", {
	visual = "sprite",
	visual_size = {x=0.75, y=0.75},
	collisionbox = {0},
	physical = false,
	textures = {"book_open.png"},
	on_activate = function(self)
		local pos = self.object:getpos()
		local pos_under = {x=pos.x, y=pos.y-1, z=pos.z}

		if minetest.get_node(pos_under).name ~= "xdecor:enchantment_table" then
			self.object:remove()
		end
	end
})

minetest.register_craft({
	output = "xdecor:enchantment_table",
	recipe = {
		{"", "default:book", ""},
		{"default:diamond", "default:obsidian", "default:diamond"},
		{"default:obsidian", "default:obsidian", "default:obsidian"}
	}
})

local function cap(S) return S:gsub("^%l", string.upper) end

function enchanting:register_tools(mod, def)
	for tool in pairs(def.tools) do
	for material in def.materials:gmatch("[%w_]+") do
	for enchant in def.tools[tool].enchants:gmatch("[%w_]+") do
		local original_tool = minetest.registered_tools[mod..":"..tool.."_"..material]
		if not original_tool then break end

		if original_tool.tool_capabilities then
			local original_damage_groups = original_tool.tool_capabilities.damage_groups
			local original_groupcaps = original_tool.tool_capabilities.groupcaps
			local groupcaps = table.copy(original_groupcaps)
			local fleshy = original_damage_groups.fleshy
			local full_punch_interval = original_tool.tool_capabilities.full_punch_interval
			local max_drop_level = original_tool.tool_capabilities.max_drop_level
			local group = next(original_groupcaps)

			if enchant == "durable" then
				groupcaps[group].uses = math.ceil(original_groupcaps[group].uses * enchanting.uses)
			elseif enchant == "fast" then
				for i, time in pairs(original_groupcaps[group].times) do
					groupcaps[group].times[i] = time - enchanting.times
				end
			elseif enchant == "sharp" then
				fleshy = fleshy + enchanting.damages
			end

			minetest.register_tool(":"..mod..":enchanted_"..tool.."_"..material.."_"..enchant, {
				description = "Enchanted "..cap(material).." "..cap(tool).." ("..cap(enchant)..")",
				inventory_image = original_tool.inventory_image.."^[colorize:violet:50",
				wield_image = original_tool.wield_image,
				groups = {not_in_creative_inventory=1},
				tool_capabilities = {
					groupcaps = groupcaps, damage_groups = {fleshy = fleshy},
					full_punch_interval = full_punch_interval, max_drop_level = max_drop_level
				}
			})
		end

		if def.armor then
			local original_armor_groups = original_tool.groups
			local armorcaps = {}
			armorcaps.not_in_creative_inventory = 1

			for armor_group, value in pairs(original_armor_groups) do
				if enchant == "strong" then
					armorcaps[armor_group] = math.ceil(value * enchanting.strength)
				elseif enchant == "speed" then
					armorcaps[armor_group] = value
					armorcaps.physics_speed = enchanting.speed
					armorcaps.physics_jump = enchanting.jump
				end
			end

			minetest.register_tool(":"..mod..":enchanted_"..tool.."_"..material.."_"..enchant, {
				description = "Enchanted "..cap(material).." "..cap(tool).." ("..cap(enchant)..")",
				inventory_image = original_tool.inventory_image,
				texture = mod .. "_" .. tool.."_"..material,
				wield_image = original_tool.wield_image,
				groups = armorcaps,
				wear = 0
			})
		end
	end
	end
	end
end

enchanting:register_tools("default", {
	materials = "steel, bronze, mese, diamond",
	tools = {
		axe    = {enchants = "durable, fast"},
		pick   = {enchants = "durable, fast"}, 
		shovel = {enchants = "durable, fast"},
		sword  = {enchants = "sharp"}
	}
})

enchanting:register_tools("3d_armor", {
	materials = "steel, bronze, gold, diamond",
	armor = 1,
	tools = {
		boots      = {enchants = "strong, speed"},
		chestplate = {enchants = "strong"},
		helmet     = {enchants = "strong"},
		leggings   = {enchants = "strong"}
	}
})
