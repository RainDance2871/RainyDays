SMODS.Joker {
  key = 'secret_agent',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('secret_agent'),
  attributes = { 'mult', 'rank', 'seven', 'jack' },
  
  config = {
    extra = {
      rank1 = 'Jack',
      rank2 = '7',
      mult = 5
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks'),
        card.ability.extra.mult
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      local id = context.other_card:get_id()
      if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
        return {
          mult = card.ability.extra.mult
        }
      end
    end
    
    if context.modify_scoring_hand and not context.blueprint then
      local id = context.other_card:get_id()
      if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then      
        return {
          add_to_hand = true
        }
      end
    end
  end
}