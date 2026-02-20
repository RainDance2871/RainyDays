SMODS.Joker {
  key = 'cloverfield',
  atlas = 'Jokers',
  rarity = 1,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = GetJokersAtlasTable('cloverfield'),
  config = {
    extra = {
      current_mult = 0,
      plus_mult = 4,
      per_discarded = 7,
      discarded_counter = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.plus_mult,
        card.ability.extra.current_mult,
        card.ability.extra.per_discarded,
        card.ability.extra.per_discarded - card.ability.extra.discarded_counter
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.current_mult > 0 then
      return {
        mult = card.ability.extra.current_mult
      }
    end
    
    --grant mult on discard of clubs
    if context.discard and not context.blueprint and context.other_card:is_suit('Clubs') then
      card.ability.extra.discarded_counter = card.ability.extra.discarded_counter + 1
      
      --enough clubs discarded
      local upgraded = false
      while card.ability.extra.discarded_counter >= card.ability.extra.per_discarded do
        card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.plus_mult
        card.ability.extra.discarded_counter = card.ability.extra.discarded_counter - card.ability.extra.per_discarded
        upgraded = true
      end
      
      if upgraded then
        return {
          message_card = card,
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT
        }
      end
    end
  end
}