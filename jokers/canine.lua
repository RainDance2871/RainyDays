SMODS.Joker {
  key = 'canine',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('canine'),
  attributes = { 'chips', 'mult', 'rank', 'king', 'nine' },
  
  config = {
    extra = {
      rank1 = 'King',
      rank2 = '9',
      chips = 9,
      mult = 9
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks'),
        card.ability.extra.chips,
        card.ability.extra.mult
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
        local option = pseudorandom_element({ 'chips', 'mult' }, 'canine')
        return {
          chips = option == 'chips' and card.ability.extra.chips or nil,
          mult = option == 'mult' and card.ability.extra.mult or nil
        }
      end
    end
  end
}