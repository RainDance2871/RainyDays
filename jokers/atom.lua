SMODS.Joker {
  key = 'atom',
  atlas = 'Jokers',
  rarity = 2,
  cost = 7,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('atom'),
  config = {
    extra = {
      rank = 'Ace',
      numerator_in = 1,
      denominator_in = 4,
      mult_rewards = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks'),
        numerator_out, 
        denominator_out,
        card.ability.extra.mult_rewards
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.individual and context.cardarea == G.play and context.other_card.base.value == card.ability.extra.rank and not context.other_card.debuff then
      if SMODS.pseudorandom_probability(card, 'atom', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
        card_eval_status_text(context.other_card, 'jokers', nil, nil, nil, {
          message = localize('rainydays_hands_upgraded'),
          colour = G.C.FILTER
        })
      level_up_table_tailends(context.blueprint_card or card, { context.scoring_name }, nil, false, 0, nil, card.ability.extra.mult_rewards, nil, context.other_card)
      end
    end
  end
}