SMODS.Joker {
  key = 'catalogue',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('catalogue'),
  config = {
    extra = {
      numerator_in = 1,
      denominator_in = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = {
        numerator_out, 
        denominator_out
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.discard and context.other_card == context.full_hand[1] then
      if SMODS.pseudorandom_probability(card, 'catalogue', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
        local transformed = 0
        for i = 1, #context.full_hand do
          if not SMODS.has_no_rank(context.full_hand[i]) then
            local ranks = { 'Ace', 'King', 'Queen', 'Jack', '10', '9', '8', '7', '6', '5', '4', '3', '2' }
            remove_by_value(ranks, context.full_hand[i].base.value)
            local new_rank = pseudorandom_element(ranks, pseudoseed('catalogue'))
            G.GAME.blind:debuff_card(context.full_hand[i])
            SMODS.change_base(context.full_hand[i], context.full_hand[i].base.suit, new_rank)
            context.full_hand[i]:juice_up()
            transformed = transformed + 1
          end
        end
        
        if transformed > 0 then
          return {
            message_card = card,
            message = transformed > 1 and localize('rainydays_new_ranks') or localize('rainydays_new_rank'),
            colour = G.C.FILTER
          }
        end
      end
    end
  end
}