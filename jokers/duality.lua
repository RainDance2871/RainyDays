SMODS.Joker {
  key = 'duality',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('duality'),
  attributes = { 'chips', 'mult', 'planet' },
  
  config = {
    extra = {
      chips = 40,
      mult = 5,
      night = false
    }
  },
  
  update = function(self, card, dt)
    if (card.ability and card.ability.extra and not card.ability.extra.in_deck and not card.ability.extra.night ~= not G.GAME.rd_night_active) then
      card.ability.extra.night = G.GAME.rd_night_active
      card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable(card.ability.extra.night and 'duality_night' or 'duality'))
    end
  end,
  
  set_ability = function(self, card, initial, delay_sprites)
    if card.ability and card.ability.extra then
      card.ability.extra.night = G.GAME.rd_night_active
      if card.ability.extra.night and (card.config.center.discovered or card.bypass_discovery_center) then
        card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('duality_night'))
      end
    end
  end,
  
  add_to_deck = function(self, card, from_debuff)
    RainyDays.duality_transform(card, true)
    card.ability.extra.in_deck = true
  end,
  
  loc_vars = function(self, info_queue, card)
    local vars =  {
      card.ability.extra.chips,
      card.ability.extra.mult
    }
    
    return {
      key = card.ability.extra.night and 'j_RainyDays_duality_night' or 'j_RainyDays_duality',
      vars = vars
    }
  end,
  
  set_sprites = function(self, card, front)
    if G.GAME and G.GAME.rd_night_active and (card.config.center.discovered or card.bypass_discovery_center) then
      card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('duality_night'))
    end
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.night and card.ability.extra.chips or nil,
        mult = not card.ability.extra.night and card.ability.extra.mult or nil
      }
    end
    
    if context.using_consumeable and not context.blueprint then
      RainyDays.duality_transform(card, true)
    end
  end
}

function RainyDays.duality_transform(card, message)
  if (not card.ability.extra.night ~= not G.GAME.rd_night_active) then
    G.E_MANAGER:add_event(Event({ 
      trigger = 'before',
      delay = 0.1,
      func = function()
        card:flip()
        return true
      end
    }))

    G.E_MANAGER:add_event(Event({ 
      trigger = 'before',
      delay = 1,
      func = function()
        card.ability.extra.night = G.GAME.rd_night_active
        card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable(card.ability.extra.night and 'duality_night' or 'duality'))
        card:juice_up(0.3, 0.3)
        play_sound('card1')
        return true
      end
    }))
    if message then
      card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize(G.GAME.rd_night_active and 'rainydays_duality_night_appear' or 'rainydays_duality_day_appear'), colour = G.C.FILTER })
    end
    
    G.E_MANAGER:add_event(Event({ 
      trigger = 'before',
      delay = 1,
      func = function()
        card:flip()
        return true
      end
    }))
  end
end