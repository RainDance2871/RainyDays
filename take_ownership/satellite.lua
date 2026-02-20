if RainyDays.config.constellations then SMODS.Joker:take_ownership('j_satellite', {
  config = {
    extra = 0,
    money_start = 2,
    money_bonus = 1
  },
  
  loc_vars = function(self, info_queue, card)
    local planets_used = 0
    local string = ''
    for key, value in pairs(G.GAME.consumeable_usage) do
      if value.set == 'Planet' then 
        planets_used = planets_used + 1
        string = string .. localize{ type = 'name_text', set = 'Planet', key = key } .. ', '
      end
    end
    
    if planets_used > 0 then
      string = sort_words_in_string(string)
      string = '(' .. localize('rainydays_planets_used') .. ': ' .. string.sub(string, 1, -3) .. ')'
    end
    
    return {
      main_end = planets_used > 0 and main_end_string(string, 29) or nil,
      vars = { 
        card.ability.money_start, 
        card.ability.money_bonus,
        card.ability.money_start + card.ability.money_bonus * planets_used
      }
    }
  end,
  
  calc_dollar_bonus = function(self, card)
    local planets_used = 0
    for _, value in pairs(G.GAME.consumeable_usage) do
      if value.set == 'Planet' then 
        planets_used = planets_used + 1 
      end
    end
    
    return card.ability.money_start + card.ability.money_bonus * planets_used
  end
}, true)
end