SMODS.Joker {
  key = 'five_and_dime',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('five_and_dime'),
  attributes = { 'mult', 'rank', 'ten', 'five', 'economy' },
  
  config = {
    extra = {
      rank1 = '10',
      rank2 = '5',
      mult = 5,
      numerator_in = 1,
      denominator_in = 5,
      money = 5
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = {
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks'),
        card.ability.extra.mult,
        numerator_out,
        denominator_out,
        card.ability.extra.money
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
        if SMODS.pseudorandom_probability(card, 'five_and_dime', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
          return {
            dollars = card.ability.extra.money
          }
        else
          return {
            mult = card.ability.extra.mult
          }
        end
      end
    end
  end
}