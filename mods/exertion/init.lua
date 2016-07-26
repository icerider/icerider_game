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
    ["mobs:honey"] = 6,
    ["mobs:beehive"] = 4,
    ["mobs:chicken_egg_fried"] = 2,
    ["mobs:chicken_raw"] = 2,
    ["mobs:chicken_cooked"] = 2,
    ["mobs:pork_raw"] = 4,
    ["mobs:pork_cooked"] = 8,
    ["mobs:bucket_milk"] = 6,
    ["mobs:cheese"] = 4,
    ["mobs:meat_raw"] = 3,
    ["mobs:meat"] = 8,
    ["witchcraft:potion_red"] = 20,
    ["witchcraft:potion_red_2"] = 60,
    ["witchcraft:potion_lightyellow"] = 5,
    ["witchcraft:potion_blue"] = 1, --water
    ["flowers:mushroom_red"] = -5,
    ["flowers:mushroom_brown"] = 1,
    ["default:applet"] = 2,
    ["farming:rhubarb"] = 1,
    ["farming:rhubarb_pie"] = 6,
    ["farming:cucumber"] = 4,
    ["farming:bread"] = 5,
    ["farming:coffee_cup"] = 2,
    ["farming:coffee_cup_hot"] = 3,
    ["farming:blueberries"] = 1,
    ["farming:muffing_blueberry"] = 2,
    ["farming:cookie"] = 2,
    ["farming:chocolate_dark"] = 3,
    ["farming:beans"] = 1,
    ["farming:carrot"] = 4,
    ["farming:carrot_gold"] = 6,
    ["farming:grapes"] = 2,
    ["farming:corn"] = 3,
    ["farming:corn_cob"] = 5,
    ["farming:raspberries"] = 1,
    ["farming:smoothie_raspberry"] = 2,
    ["farming:donut"] = 4,
    ["farming:donut_chocolate"] = 6,
    ["farming:donut_apple"] = 6,
    ["farming:tomate"] = 4,
    ["farming:melon_slice"] = 2,
    ["farming:pumpkin_slice"] = 2,
    ["farming:pumpkin_bread"] = 8,
    ["farming:popato"] = 1,
    ["farming:baked_popato"] = 6,
    ["cooked_rat"] = 6,
    ["farming_plus:tomato_item"] = 4,
    ["farming_plus:banana"] = 6,
    ["farming_plus:banana"] = 6,
    ["farming_plus:orange_item"] = 4,
    ["farming_plus:carrot_item"] = 3,
    ["farming_plus:strawberry_item"] = 2,
    ["bushes:basket_strawberry"] = 18,
    ["bushes:basket_blackberry"] = 18,
    ["bushes:basket_blueberry"] = 18,
    ["bushes:basket_raspberry"] = 18,
    ["bushes:basket_gooseberry"] = 18,
    ["bushes:basket_mixed_berry"] = 18,
    ["bushes:sugar"] = 1,
    ["bushes:strawberry_pie_raw"] = 4,
    ["bushes:blackberry_pie_raw"] = 4,
    ["bushes:blueberry_pie_raw"] = 4,
    ["bushes:raspberry_pie_raw"] = 4,
    ["bushes:gooseberry_pie_raw"] = 4,
    ["bushes:mixed_berry_pie_raw"] = 4,
    ["framing_plus:strawberry_item"] = 2, --1
    ["bushes:strawberry_pie_cooked"] = 6,
    ["bushes:blackberry_pie_cooked"] = 6,
    ["bushes:blueberry_pie_cooked"] = 6,
    ["bushes:raspberry_pie_cooked"] = 6,
    ["bushes:gooseberry_pie_cooked"] = 6,
    ["bushes:mixed_berry_pie_cooked"] = 6,
    ["bushes:strawberry_pie_slice"] = 1,
    ["bushes:blueberry_pie_slice"] = 1,
    ["bushes:raspberry_pie_slice"] = 1,
    ["bushes:blackberry_pie_slice"] = 1,
    ["bushes:gooseberry_pie_slice"] = 1,
    ["bushes:mixed_berry_pie_slice"] = 1,
    ["beer_mug"] = 2,
    ["homedecor:soda_can"] = 2,
    ["moretrees:coconut_milk"] = 2,
    ["moretrees:raw_coconut"] = 4,
    ["moretrees:acorn_muffin"] = 4,
    ["moretrees:spruce_nuts"] = 1,
    ["moretrees:cedar_nuts"] = 1,
    ["moretrees:fir_nuts"] = 1,
    ["glooptest:kalite_lump"] = 1,
    ["bees:bottle_honey"] = 3,
    ["bees:honey_comb"] = 2,
    ["fishing:fish_raw"] = 2,
    ["fishing:fish_cooked"] = 4,
    ["fishing:sushi"] = 6,
    ["fishing:clownfish_raw"] = 2,
    ["fishing:bluewhite_raw"] = 2,
    ["fishing:exoticfish_raw"] = 2,
    ["fishing:carp_raw"] = 2,
    ["fishing:perch_raw"] = 2,
    ["fishing:catfish_raw"] = 2,
    ["fishing:shark_raw"] = 2,
    ["fishing:shark_cooked"] = 6,
    ["fishing:pike_raw"] = 2,
    ["fishing:pike_cooked"] = 6,
}

minetest.register_on_item_eat(
   function(hpChange, replacementItem, itemStack, player, pointedThing)
      if itemStack:take_item() ~= nil then
         local ps = playerStates[player];
         if ps then
            if hpChange > 0 then
               local pp = math.max(0, settings.foodPoisoningProb);

               if math.random() <= 1.0 - pp then
                  local update = false;
                  update = ps:addFood(hpChange, true) or update;
                  update = ps:addWater(hpChange / 2, true) or update;
                  if update then ps:updateHud(); end;
               else
                  minetest.chat_send_player(player:get_player_name(),
                                            settings.foodPoisoningMessage);
                  ps:addPoison(hpChange);
               end;
            elseif hpChange < 0 then
               minetest.chat_send_player(player:get_player_name(),
                                         settings.foodPoisoningMessage);
               ps:addPoison(-hpChange);
            end;
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
