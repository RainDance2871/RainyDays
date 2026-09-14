SMODS.Joker {
  key = 'truffle',
  atlas = 'Jokers',
  pools = { Food = true },
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('truffle'),
  attributes = { 'xmult', 'food' },
  config = {
    extra = {
      xmult_amount = 3,
      xmult_decrease = 0.01
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.xmult_amount,
        card.ability.extra.xmult_decrease
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult_amount
      }
    end
    
    if context.end_of_round and context.game_over == false and not context.repetition and not context.individual and not context.blueprint then
      if #G.deck.cards > 0 then
        local before = card.ability.extra.xmult_amount
        SMODS.scale_card(card, {
          ref_table = card.ability.extra, 
          ref_value = 'xmult_amount',
          scalar_value = 'xmult_decrease',
          operation = function(ref_table, ref_value, initial, modifier)
            ref_table[ref_value] = initial - modifier * #G.deck.cards
          end,
          no_message = true
        })
        if card.ability.extra.xmult_amount <= 1 then
          SMODS.destroy_cards(card, { pinch_anim = true })
          return {
            message = localize('k_eaten_ex'),
            colour = G.C.RED
          }
        else 
          return {
            message = localize { type = 'variable', key = 'a_xmult_minus', vars = { math.abs(before - card.ability.extra.xmult_amount) }},
            colour = G.C.MULT
          }
        end
      end
    end
  end
}