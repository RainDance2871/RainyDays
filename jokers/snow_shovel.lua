SMODS.Joker {
  key = 'snow_shovel',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = GetJokersAtlasTable('snow_shovel'),
  
  config = {
    extra = {
      per_scored = 7,
      scored_counter = 0,
      chip_bonus = 25,
      chip_current = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.chip_bonus,
        card.ability.extra.chip_current,
        card.ability.extra.per_scored,
        card.ability.extra.per_scored - card.ability.extra.scored_counter
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.chip_current > 0 then
      return {
        chips = card.ability.extra.chip_current
      }
    end
    
    --grant mult on drawing of spades
    if context.individual and context.cardarea == G.play and context.other_card:is_suit('Spades') and not context.blueprint then
      card.ability.extra.scored_counter = card.ability.extra.scored_counter + 1
      
      local upgraded = false
      while card.ability.extra.scored_counter >= card.ability.extra.per_scored do
        card.ability.extra.chip_current = card.ability.extra.chip_current + card.ability.extra.chip_bonus
        card.ability.extra.scored_counter = card.ability.extra.scored_counter - card.ability.extra.per_scored
        upgraded = true
      end
      
      if upgraded then
        return {
          message_card = card,
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS
        }
      end
    end
  end
}