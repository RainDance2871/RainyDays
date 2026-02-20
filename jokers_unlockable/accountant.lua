SMODS.Joker {
  key = 'accountant',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = GetJokersAtlasTable('accountant'),
  
  config = {
    extra = {
      mult = 0.5,
      cards_drawn = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult,
        card.ability.extra.mult * card.ability.extra.cards_drawn
      }
    }
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint and context.hand_drawn then
      card.ability.extra.cards_drawn = card.ability.extra.cards_drawn + #context.hand_drawn
      return { 
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult * card.ability.extra.cards_drawn }},
        colour = G.C.MULT
      }
    end
    
    if context.cardarea == G.jokers and context.joker_main then
      local score = card.ability.extra.mult * card.ability.extra.cards_drawn
      if score > 0 then
        return {
          mult = score
        }
      end
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.cards_drawn > 0 then
      card.ability.extra.cards_drawn = 0
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'round_win' then
      return #G.deck.cards <= 0
    end
    return false
  end
}
