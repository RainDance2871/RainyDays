SMODS.Joker {
  key = 'feather_energetic',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('feather_energetic'),
  config = {
    extra = {
      repetitions = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.repetitions, 
        card.ability.extra.repetitions * GetFeatherCount() 
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      return {
        repetitions = card.ability.extra.repetitions * GetFeatherCount()
      }
    end
  end
}