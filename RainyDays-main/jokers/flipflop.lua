SMODS.Joker {
  key = 'flipflop',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('flipflop_even'),
  config = {
    extra = {
      plus_xmult = 2,
      plus_chips = 100,
      state = 0
    }
  },
  
  set_ability = function(self, card, initial, delay_sprites)
    card.ability.extra.state = pseudorandom_element({ 0, 1 }, pseudoseed('flipflop' .. G.GAME.round_resets.ante))
    if card.ability and card.ability.extra.state == 1 then
      card.children.center:set_sprite_pos(GetJokersAtlasTable('flipflop_odd'))
    end
  end,
  
  loc_vars = function(self, info_queue, card)
    return {
      key = card.ability.extra.state == 0 and 'j_RainyDays_flipflop_even' or 'j_RainyDays_flipflop_odd',
      vars = {
        card.ability.extra.plus_xmult,
        card.ability.extra.plus_chips
      }
    }
  end,
  
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra.state == 1 then
      card.children.center:set_sprite_pos(GetJokersAtlasTable('flipflop_odd'))
    end
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      if card.ability.extra.state == 0 then
        if not context.blueprint then
           G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.5,
            blocking = false,
            func = function()
              card:flip()
              card.ability.extra.state = 1
              card.children.center:set_sprite_pos(GetJokersAtlasTable('flipflop_odd'))
              card:flip()
            return true
            end
          }))
        end
        return {
          xmult = card.ability.extra.plus_xmult
        }
      else
        if not context.blueprint then
          G.E_MANAGER:add_event(Event({ 
            trigger = "after",
            delay = 0.5,
            blocking = false,
            func = function()
              card:flip()
              card.ability.extra.state = 0
              card.children.center:set_sprite_pos(GetJokersAtlasTable('flipflop_even'))
              card:flip()
              return true
            end
          }))
        end
        return {
          chips = card.ability.extra.plus_chips
        }
      end
    end
  end
}