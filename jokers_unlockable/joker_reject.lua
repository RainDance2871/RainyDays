SMODS.Joker {
  key = 'joker_reject',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('joker_reject'),
  attributes = { 'passive', 'discard' }, 
  
  config = {
    extra = {
      discards = 3,
      money_pay = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.discards,
        card.ability.extra.money_pay
      }
    }
  end,
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
    ease_discard(card.ability.extra.discards)
    G.GAME.modifiers.discard_cost = (G.GAME.modifiers.discard_cost or 0) + card.ability.extra.money_pay
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
    ease_discard(-card.ability.extra.discards)
    G.GAME.modifiers.discard_cost = (G.GAME.modifiers.discard_cost or 0) - card.ability.extra.money_pay
  end,
  
  locked_loc_vars = function(self, info_queue, card)   
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.unused_discards or 0) or nil,
      vars = { 
        25
      }
    }
  end, 
  
  check_for_unlock = function(self, args)
    return args.type == 'round_win' and (G.GAME and G.GAME.unused_discards or 0) >= 25
  end
}