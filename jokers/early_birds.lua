SMODS.Joker {
  key = 'early_birds',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('early_birds'),
  attributes = { 'mult' },
  
  config = {
    extra = {
      mult = 7
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.other_card.ability.rd_early_bird and context.cardarea == G.play then
      return {
        mult = card.ability.extra.mult
      }
    end
  end
}