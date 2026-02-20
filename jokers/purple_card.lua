if RainyDays.config.constellations then SMODS.Joker {
  key = 'purple_card',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('purple_card'),
  
  calculate = function(self, card, context)      
    if context.skipping_booster then
      return create_constellation(card)
    end
  end
} end