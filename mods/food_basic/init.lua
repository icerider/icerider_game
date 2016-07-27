-- Boilerplate to support localized strings if intllib mod is installed.
local S = 0
if rawget(_G, "intllib") then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
else
	S = function ( s ) return s end
end

minetest.register_craftitem(":food:bowl",{
    description = S("Bowl"),
    inventory_image = "food_bowl.png",
    groups = {food_bowl=1}
})
minetest.register_craft({
    output = "food:bowl",
    recipe = {
        {"default:clay_lump","","default:clay_lump"},
        {"default:clay_lump","default:clay_lump","default:clay_lump"}
    }
})

-- Register Soups
local soups = {
	{"tomato", "tomato", 10},
	{"meat", "meat", 12}
}
for i=1, #soups do
	local flav = soups[i]
	minetest.register_craftitem(":food:soup_"..flav[1],{
		description = S(flav[1].." Soup"),
		inventory_image = "food_soup_"..flav[1]..".png",
		on_use = minetest.item_eat(flav[3], "food:bowl"),
		groups = {food=3}
	})
	minetest.register_craftitem(":food:soup_"..flav[1].."_raw",{
		description = S("Uncooked ".. flav[1].." Soup"),
		inventory_image = "food_soup_"..flav[1].."_raw.png",

	})
	minetest.register_craft({
		type = "cooking",
		output = "food:soup_"..flav[1],
		recipe = "food:soup_"..flav[1].."_raw",
	})
	minetest.register_craft({
		output = "food:soup_"..flav[1].."_raw",
		recipe = {
			{"", "", ""},
			{"bucket:bucket_water", "group:food_"..flav[2], "bucket:bucket_water"},
			{"farming_plus:carrot_item", "group:food_bowl", "farming:potato"},
		},
		replacements = {{"bucket:bucket_water", "bucket:bucket_empty"},{"bucket:bucket_water", "bucket:bucket_empty"}}
	})
end

-- Juices
local juices = {"apple", "orange", "cactus"}
for i=1, #juices do
	local flav = juices[i]
	minetest.register_craftitem(":food:"..flav.."_juice", {
		description = S(flav.." Juice"),
		inventory_image = "food_"..flav.."_juice.png",
		on_use = minetest.item_eat(2, "vessels:drinking_glass"),
	})
	minetest.register_craft({
		output = "food:"..flav.."_juice",
		recipe = {
			{"","",""},
			{"","group:food_"..flav,""},
			{"","vessels:drinking_glass",""},
		}
	})
end
