--allows us to create a feather pool.
SMODS.ObjectType {
	key = 'Feather'
}

--override of the create card. if the odds are right, we transform it into a feather. This keep feathers consistently appearing regardless of how many jokers were added by mods. not that this is only applied if the player has at least one feather already.
local old_func_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  local ret = old_func_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  if FeatherOwned() then
    local absent_feathers = GetAbsentFeathers(ret.config.center.rarity)
    if absent_feathers and #absent_feathers > 0 and pseudorandom('feathers') <= #absent_feathers / 65 then
      local feather_key = pseudorandom_element(absent_feathers, pseudoseed('Feathers' .. G.GAME.round_resets.ante))
      ret:set_ability(feather_key, true)
      ret:set_cost()
    end
  end
  return ret
end

function IsFeather(card)
  local center = (type(card) == "string" and G.P_CENTERS[card]) or (card.config and card.config.center)
  return (center and center.pools and center.pools.Feather)
end

function FeatherOwned()
  if G.jokers and G.jokers.cards then
    for i = 1, #G.jokers.cards do
      if IsFeather(G.jokers.cards[i]) then
        return true
      end
    end
  end
  return false
end

function GetAbsentFeathers(rarity)
  local feathers_available
  if (rarity == 1 or rarity == 'Common') then
    feathers_available = {
      'j_RainyDays_feather_mystic',
      'j_RainyDays_feather_precious',
      'j_RainyDays_feather_silky',
      'j_RainyDays_feather_vibrant'
    }
  elseif (rarity == 2 or rarity == 'Uncommon') then
    feathers_available = {
     'j_RainyDays_feather_marvelous'
    }
  end
  
  if feathers_available and not next(SMODS.find_card('j_ring_master')) then --if the player has showman, doubles will appear.
    for i = #feathers_available, 1, -1 do
      if G.GAME.used_jokers[feathers_available[i]] then --remove feathers already present in the game
        table.remove(feathers_available, i)
      end
    end
  end
  return feathers_available
end