SMODS.Joker {
  key = 'truffle',
  atlas = 'Jokers',
  pools = { Food = true },
  rarity = 2,
  cost = 6,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = GetJokersAtlasTable('truffle'),
  config = {
    extra = {
      chip_amount = 200,
      chip_decrease = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.chip_amount,
        card.ability.extra.chip_decrease
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.chip_amount
      }
    end
    
    if context.end_of_round and context.game_over == false and not context.repetition and not context.individual and not context.blueprint then
      card.ability.extra.chip_amount = card.ability.extra.chip_amount - (card.ability.extra.chip_decrease * #G.deck.cards)
      if card.ability.extra.chip_amount <= 0 then
        SMODS.destroy_cards(card, nil, nil, true)
        return {
          message = localize('k_eaten_ex'),
          colour = G.C.RED
        }
      else 
        return {
          message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_decrease * #G.deck.cards } },
          colour = G.C.CHIPS
        }
      end
    end
  end
}