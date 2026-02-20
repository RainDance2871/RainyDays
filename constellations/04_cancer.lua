SMODS.Consumable {
  key = 'cancer',
  set = 'Constellation',
  atlas = 'Constellations',
  pos = GetConstellationAtlasTable('cancer'),
  unlocked = true,
  config = {
    extra_cost = 5
  },
  
  loc_vars = function(self, info_queue, card)
    local planet_key = nil
    if G.GAME.last_hand_played then
      for _, value in pairs(G.P_CENTER_POOLS.Planet) do
        if value.config.hand_type == G.GAME.last_hand_played then
          planet_key = value.key
          break
        end
      end
    end
    
    if planet_key then
      info_queue[#info_queue + 1] = G.P_CENTERS[planet_key]
    end
    
    local last_hand_text = planet_key and localize{ type = 'name_text', set = 'Planet', key = planet_key } or localize('k_none')
    local colour = planet_key and G.C.GREEN or G.C.RED
    
    return {
      main_end = generate_main_end(last_hand_text, colour),
      vars = { 
        card.ability.extra_cost
      }
    }
  end,
  
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if G.consumeables.config.card_limit > #G.consumeables.cards then
          play_sound('timpani')
          if G.GAME.last_hand_played then
            local planet_key = nil
            for key, value in pairs(G.P_CENTER_POOLS.Planet) do
              if value.config.hand_type == G.GAME.last_hand_played then
                planet_key = value.key
                break
              end
            end
            if planet_key then
              SMODS.add_card({ key = planet_key })
            end
          end
          card:juice_up(0.3, 0.5)
        end
        return true
      end
    }))

    ease_dollars(-card.ability.extra_cost)
    delay(0.6)
  end,

  can_use = function(self, card)
    if G.GAME.last_hand_played then
      for _, value in pairs(G.P_CENTER_POOLS.Planet) do
        if value.config.hand_type == G.GAME.last_hand_played then
          return true
        end
      end
    end
    return false
  end
}