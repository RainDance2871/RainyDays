SMODS.Joker {
  key = 'cloverfield',
  name = 'Clover Field',
  atlas = 'RainyDays',
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = GetRainyDaysAtlasTable('cloverfield'),
  config = {
    current_mult = 0,
    plus_mult = 3,
    per_discarded = 5,
    discarded_counter = 0
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.plus_mult,
        card.ability.current_mult,
        card.ability.per_discarded,
        card.ability.per_discarded - card.ability.discarded_counter
      }
    }
  end,
  
  calculate = function(self, card, context)
    --grant mult on discard of clubs
    if context.discard and not context.blueprint and context.other_card:is_suit("Clubs") then
      card.ability.discarded_counter = card.ability.discarded_counter + 1
      
      --enough clubs discarded
      while card.ability.discarded_counter >= card.ability.per_discarded do
        card.ability.current_mult = card.ability.current_mult + card.ability.plus_mult
        card.ability.discarded_counter = card.ability.discarded_counter - card.ability.per_discarded
        return {
          message_card = card,
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT,
        }
      end
    end
    
    --apply mult
    if context.joker_main and card.ability.current_mult > 0 then
      return {
        mult_mod = card.ability.current_mult,
        message = localize {
          type = 'variable',
          key = 'a_mult',
          vars = { card.ability.current_mult }
        },
        colour = G.C.MULT,
      }
    end
  end
}