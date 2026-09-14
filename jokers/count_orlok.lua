SMODS.Joker {
  key = 'count_orlok',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('count_orlok'),
  attributes = { 'chips', 'face', 'destroy_card', 'scaling' },
  
  config = {
    extra = {
      chips = 0,
      chips_gain = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.chips
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.chips > 0 then
      return {
        chips = card.ability.extra.chips
      }
    end
    
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() 
        return (G.GAME.current_round.discards_left > 0 and G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
      end
      juice_card_until(card, eval, true)
    end
    
    if context.destroy_card and not context.blueprint and G.GAME.current_round.hands_played == 0 then
      if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and context.full_hand[1]:is_face() then
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          delay = 0,
          func = function()
            SMODS.scale_card(card, {
              ref_table = card.ability.extra,
              ref_value = 'chips',
              scalar_value = 'chips_gain',
              operation = function(ref_table, ref_value, initial, modifier)
                ref_table[ref_value] = initial + modifier * context.full_hand[1]:get_chip_bonus()
              end,
              no_message = true
            })
            return true
          end
        }))
        
        return {
          remove = true,
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS
        }
      end
    end
  end
}