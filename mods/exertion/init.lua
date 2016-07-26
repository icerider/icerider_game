local MOD_NAME = minetest.get_current_modname() or "exertion";
local MOD_PATH = minetest.get_modpath(MOD_NAME);

local exertion = { MOD_NAME = MOD_NAME, MOD_PATH = MOD_PATH };
_G[MOD_NAME] = exertion;


local function callFile(fileName, ...)
   local chunk, err = loadfile(MOD_PATH .. "/" .. fileName);
   if not chunk then error(err); end;
   return chunk(...);
end;


local settings = callFile("loadSettings.lua", exertion);
exertion.settings = settings;

local PlayerState = callFile("PlayerState.lua", exertion);
exertion.PlayerState = PlayerState;


PlayerState.load();
local playerStates = {};

--- Retrieves the PlayerState object for a given player.  Returns nil if player
 -- is not logged in.
 --
 -- @param player
 --    A player object or player name.
 --
function exertion.getPlayerState(player)
   if type(player) == 'string' then
      player = minetest.get_player_by_name(player);
   end;
   if playerStates then
	return playerStates[player];
   else
   	return nil;
   end
end;

minetest.register_on_joinplayer(
   function(player)
      minetest.after(
         0, function() playerStates[player] = PlayerState(player); end);
   end);

minetest.register_on_leaveplayer(
   function(player)
      playerStates[player] = nil;
   end);

minetest.register_on_dieplayer(
   function(player)
      local ps = playerStates[player];
      if not ps then return; end;
      ps:setFed(0, true);
      ps:setHydrated(0, true);
      ps:setPoisoned(0, true);
      ps:clearExertionStats();
      ps:updateHud();
   end);

minetest.register_on_shutdown(PlayerState.save);

minetest.register_on_dignode(
   function(pos, oldNode, digger)
      local ps = playerStates[digger];
      if ps then ps:markBuildAction(oldNode); end;
   end);

minetest.register_on_placenode(
   function(pos, newNode, placer, oldNode, itemStack, pointedThing)
      local ps = playerStates[placer];
      if ps then ps:markBuildAction(newNode); end;
   end);

local controlPeriod = settings.controlTestPeriod_seconds;
local updatePeriod = settings.accountingPeriod_seconds;
local savePeriod = settings.savePeriod_seconds;
local controlTime = 0.0;
local updateTime = 0.0;
local saveTime = 0.0;
minetest.register_globalstep(
   function(dt)
      controlTime = controlTime + dt;
      if controlTime >= controlPeriod then
         for _, ps in pairs(playerStates) do
            ps:pollForActivity();
         end;
         controlTime = 0;
      end;

      updateTime = updateTime + dt;
      if updateTime >= updatePeriod then
         controlPeriod = settings.controlTestPeriod_seconds;
         updatePeriod = settings.accountingPeriod_seconds;
         local tw = os.time();
         for _, ps in pairs(playerStates) do
            ps:update(tw, updateTime);
         end;
         updateTime = 0;
      end;

      saveTime = saveTime + dt;
      if saveTime >= savePeriod then
         savePeriod = settings.savePeriod_seconds;
         PlayerState.save();
         saveTime = 0;
      end;
   end);

local foods = {
    ["mobs:honey"] = {6, 0, 0.005},   --из дикого улья
    ["mobs:beehive"] = {4, 0, 0.005}, --улей
    ["mobs:chicken_egg_fried"] = {2, 0.005},
    ["mobs:chicken_raw"] = {2, 0, 0.3},
    ["mobs:chicken_cooked"] = {3, 0, 0.04},
    ["mobs:pork_raw"] = {4, 0, 0.3},
    ["mobs:pork_cooked"] = {7, 0, 0.04},
    ["mobs:bucket_milk"] = {6, 8, 0},
    ["mobs:cheese"] = {4, 0, 0.02},
    ["mobs:meat_raw"] = {3, 0, 0.3},
    ["mobs:meat"] = {7, 0, 0.04},
    ["witchcraft:potion_red"] = {20, 6, 0.01},
    ["witchcraft:potion_red_2"] = {60, 6, 0.01},
    ["witchcraft:potion_lightyellow"] = {5, 5, 0},
    ["witchcraft:potion_blue"] = {0, 2, 0}, --water
    ["flowers:mushroom_red"] = {-5, 0, 0},
    ["flowers:mushroom_brown"] = {1, 0, 0.05},
    ["default:apply"] = {2, 0, 0.01},
    ["farming:rhubarb"] = {1, 1},
    ["farming:rhubarb_pie"] = {6, 0},
    ["farming:cucumber"] = {4, 0},
    ["farming:bread"] = {5, 0, 0.1},
    ["farming:coffee_cup"] = {2, 4, 0},
    ["farming:coffee_cup_hot"] = {3, 5, 0},
    ["farming:blueberries"] = {1, 1},
    ["farming:muffing_blueberry"] = {2, 0},
    ["farming:cookie"] = {2, 0},
    ["farming:chocolate_dark"] = {3, 0},
    ["farming:beans"] = {1, 0},
    ["farming:carrot"] = {4, 0},
    ["farming:carrot_gold"] = {6, 1},
    ["farming:grapes"] = {2, 1},
    ["farming:corn"] = {3, 0},
    ["farming:corn_cob"] = {5, 0},
    ["farming:raspberries"] = {1, 1},
    ["farming:smoothie_raspberry"] = {2, 4},
    ["farming:donut"] = {4, 0},
    ["farming:donut_chocolate"] = {6, 0},
    ["farming:donut_apple"] = {6, 0},
    ["farming:tomate"] = {4, 1},
    ["farming:melon_slice"] = {2, 2},
    ["farming:pumpkin_slice"] = {2, 0},
    ["farming:pumpkin_bread"] = {8, 0},
    ["farming:popato"] = {1, 0},
    ["farming:baked_popato"] = {6, 0},
    ["cooked_rat"] = {6, 0, 0.05},
    ["farming_plus:tomato_item"] = {4, 1},
    ["farming_plus:banana"] = {6, 0},
    ["farming_plus:orange_item"] = {4, 1},
    ["farming_plus:carrot_item"] = {3, 0},
    ["farming_plus:strawberry_item"] = {2, 1},
    ["bushes:basket_strawberry"] = {18, 0},
    ["bushes:basket_blackberry"] = {18, 0},
    ["bushes:basket_blueberry"] = {18, 0},
    ["bushes:basket_raspberry"] = {18, 0},
    ["bushes:basket_gooseberry"] = {18, 0},
    ["bushes:basket_mixed_berry"] = {18, 0},
    ["bushes:sugar"] = {1, 0, 0},
    ["bushes:strawberry_pie_raw"] = {4, 0, 0.04},
    ["bushes:blackberry_pie_raw"] = {4, 0, 0.04},
    ["bushes:blueberry_pie_raw"] = {4, 0, 0.04},
    ["bushes:raspberry_pie_raw"] = {4, 0, 0.04},
    ["bushes:gooseberry_pie_raw"] = {4, 0, 0.04},
    ["bushes:mixed_berry_pie_raw"] = {4, 0, 0.04},
    ["framing_plus:strawberry_item"] = {2, 1},
    ["bushes:strawberry_pie_cooked"] = {6, 0},
    ["bushes:blackberry_pie_cooked"] = {6, 0},
    ["bushes:blueberry_pie_cooked"] = {6, 0},
    ["bushes:raspberry_pie_cooked"] = {6, 0},
    ["bushes:gooseberry_pie_cooked"] = {6, 0},
    ["bushes:mixed_berry_pie_cooked"] = {6, 0},
    ["bushes:strawberry_pie_slice"] = {1, 0},
    ["bushes:blueberry_pie_slice"] = {1, 0},
    ["bushes:raspberry_pie_slice"] = {1, 0},
    ["bushes:blackberry_pie_slice"] = {1, 0},
    ["bushes:gooseberry_pie_slice"] = {1, 0},
    ["bushes:mixed_berry_pie_slice"] = {1, 0},
    ["beer_mug"] = {2, 4},
    ["homedecor:soda_can"] = {2, 6},
    ["moretrees:coconut_milk"] = {2, 4},
    ["moretrees:raw_coconut"] = {4, 0},
    ["moretrees:acorn_muffin"] = {4, 0},
    ["moretrees:spruce_nuts"] = {1, 0},
    ["moretrees:cedar_nuts"] = {1, 0},
    ["moretrees:fir_nuts"] = {1, 0},
    ["glooptest:kalite_lump"] = {1, 0, 0.04},
    ["bees:bottle_honey"] = {3, 0},
    ["bees:honey_comb"] = {2, 0},
    ["fishing:fish_raw"] = {2, 0, 0.3},
    ["fishing:fish_cooked"] = {4, 0},
    ["fishing:sushi"] = {6, 0},
    ["fishing:clownfish_raw"] = {2, 0, 0.3},
    ["fishing:bluewhite_raw"] = {2, 0, 0.3},
    ["fishing:exoticfish_raw"] = {2, 0, 0.3},
    ["fishing:carp_raw"] = {2, 0, 0.3},
    ["fishing:perch_raw"] = {2, 0, 0.3},
    ["fishing:catfish_raw"] = {2, 0, 0.3},
    ["fishing:shark_raw"] = {2, 0, 0.3},
    ["fishing:shark_cooked"] = {6, 0},
    ["fishing:pike_raw"] = {6, 0, 0.3},
    ["fishing:pike_cooked"] = {6, 0},
    ["dwarves:beer"] = {4, 6},
    ["dwarves:apple_cider"] = {4, 6},
    ["dwarves:midus"] = {2, 6},
    ["dwarves:tequila"] = {3, 6},
    ["dwarves:tequila_with_lime"] = {5, 6},
    ["dwarves:sake"] = {4, 6},
    ["farming:onigiri"] = {3, 0},
    ["farming:tea_cup"] = {0, 8},
}

minetest.register_on_item_eat(
   function(hpChange, replacementItem, itemStack, player, pointedThing)
      local itemname = itemStack:get_name();
      if itemStack:take_item() ~= nil then
         local values = foods[itemname];

         local eat, drink, poisoned;
         if not values then
            print("Unknown food:"..itemname);
            eat = hpChange;
            drink = hpChange / 2;
         else
            eat, drink, poisoned = values[1], values[2], values[3]
         end
         if not poisoned then
            poisoned = settings.foodPoisoningProb;
         end
         local ps = playerStates[player];
         if ps then
            local mult = ps:get_food_mult(itemname)
            if eat and mult > 0.4 then
                minetest.chat_send_player(player:get_player_name(), "Try eat any other")
            end
            eat = eat * (1-mult)
            drink = drink * (1-(mult/2))
            if eat >= 0 then
               local pp = math.max(0, poisoned);

               if math.random() <= 1.0 - pp then
                  local update = false;
                  update = ps:addFood(eat, true) or update;
                  update = ps:addWater(drink, true) or update;
                  if update then ps:updateHud(); end;
               else
                  minetest.chat_send_player(player:get_player_name(),
                                            settings.foodPoisoningMessage);
                  ps:addPoison(eat);
               end;
            elseif eat < 0 then
               minetest.chat_send_player(player:get_player_name(),
                                         settings.foodPoisoningMessage);
               ps:addPoison(-eat);
            end;
            ps:register_food(itemname)
         end;

         if itemStack:is_empty() then
             itemStack:add_item(replacementItem)
         else
             local inv = player:get_inventory()
             if inv:room_for_item("main", {name=replacementItem}) then
                 inv:add_item("main", replacementItem)
             else
                 local pos = player:getpos()
                 pos.y = math.floor(pos.y + 0.5)
                 core.add_item(pos, replacementItem)
             end
         end
      end;
      return itemStack;
   end);

function exertion.drinkItem(player, waterChange)
         local ps = playerStates[player];
         if ps then
            if waterChange > 0 then
               local pp = math.max(0, settings.foodPoisoningProb);

               if math.random() <= 1.0 - pp then
                  local update = false;
                  update = ps:addWater(waterChange, true) or update;
                  if update then ps:updateHud(); end;
               else
                  minetest.chat_send_player(player:get_player_name(),
                                            settings.foodPoisoningMessage);
                  ps:addPoison(waterChange);
               end;
            elseif waterChange < 0 then
               minetest.chat_send_player(player:get_player_name(),
                                         settings.foodPoisoningMessage);
               ps:addPoison(-waterChange);
            end;
         end;
end;
