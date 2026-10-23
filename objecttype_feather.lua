--sea also transform_encountered_card
RainyDays.feather_rate = 75

function RainyDays.FeatherOwned()
  if G.jokers and G.jokers.cards then
    for i = 1, #G.jokers.cards do
      if RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
        return true
      end
    end
  end
  return false
end

function RainyDays.GetAbsentFeathers(rarity)
  local feathers_available
  if (rarity == 1 or rarity == 'Common') then
    feathers_available = {
      'j_RainyDays_feather_precious',
      'j_RainyDays_feather_silky',
      'j_RainyDays_feather_vibrant'
    }
  elseif (rarity == 2 or rarity == 'Uncommon') then
    feathers_available = {
     'j_RainyDays_feather_marvelous'
    }
  end
  
  if feathers_available and not SMODS.showman() then
    for i = #feathers_available, 1, -1 do
      if G.GAME.used_jokers[feathers_available[i]] then
        table.remove(feathers_available, i)
      end
    end
  end
  return feathers_available
end