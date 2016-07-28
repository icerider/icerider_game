-- Minetest 0.4.7 mod: technic
-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

local load_start = os.clock()

technic = rawget(_G, "technic") or {}
technic.creative_mode = minetest.setting_getbool("creative_mode")


local modpath = minetest.get_modpath("technic")
technic.modpath = modpath


technic.recharger = function(itemstack, user, pointed_thing)
    local meta = minetest.deserialize(itemstack:get_metadata())
    if not meta or not meta.charge then
        return
    end

    --If has enough charge to be used
    if meta.charge > 0 then
        --Get the stack to the left of the Tool Repairer
        local tool_to_charge = user:get_inventory():get_stack("main", user:get_wield_index()-1)

        --If the stack to the left is not empty and is not fully repaired
        if not tool_to_charge:is_empty() then
            local toolname=tool_to_charge:get_name()
            if technic.power_tools[toolname] == nil then
                return
            end
              local item_max_charge = technic.power_tools[toolname]
            local meta2 = minetest.deserialize(tool_to_charge:get_metadata())
            if not meta2 then
                meta2 = {charge = 0}
            end
            if not meta2 or not meta2.charge or meta2.charge >= item_max_charge then
                return
            end
            local charge_get = math.min(meta.charge, 5000, (item_max_charge - meta2.charge)/0.85)
            meta.charge = meta.charge - charge_get
            meta2.charge = meta2.charge + (charge_get * 0.85)
            technic.set_RE_wear(tool_to_charge, meta2.charge, item_max_charge)
            tool_to_charge:set_metadata(minetest.serialize(meta2))

            --Set the new wear value of the tool to the stack that the tool is in
            user:get_inventory():set_stack("main", user:get_wield_index()-1, tool_to_charge)
            --Decrease the charge of the Tool Repairer
            itemstack:set_metadata(minetest.serialize(meta))
              item_max_charge = technic.power_tools[itemstack:get_name()]
            technic.set_RE_wear(itemstack, meta.charge, item_max_charge)
        end

    end

    return itemstack
end

-- Boilerplate to support intllib
if rawget(_G, "intllib") then
	technic.getter = intllib.Getter()
else
	technic.getter = function(s,a,...)if a==nil then return s end a={a,...}return s:gsub("(@?)@(%(?)(%d+)(%)?)",function(e,o,n,c)if e==""then return a[tonumber(n)]..(o==""and c or"")else return"@"..o..n..c end end) end
end
local S = technic.getter

-- Read configuration file
dofile(modpath.."/config.lua")

-- Helper functions
dofile(modpath.."/helpers.lua")

-- Items 
dofile(modpath.."/items.lua")

-- Craft recipes for items 
dofile(modpath.."/crafts.lua")

-- Register functions
dofile(modpath.."/register.lua")

-- Machines
dofile(modpath.."/machines/init.lua")

-- Tools
dofile(modpath.."/tools/init.lua")

-- Aliases for legacy node/item names
dofile(modpath.."/legacy.lua")

if minetest.setting_getbool("log_mods") then
	print(S("[Technic] Loaded in %f seconds"):format(os.clock() - load_start))
end

