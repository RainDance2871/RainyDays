SMODS.Joker {
  key = 'algebra',
  atlas = 'Jokers',
  rarity = 1,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('algebra'),
  attributes = { 'chips', 'scaling', 'discard' },
  
  config = {
    extra = {
      chips_gain = 7,
      current_chips = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)    
    return {
      vars = {
        card.ability.extra.chips_gain,
        card.ability.extra.current_chips
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.joker_main then
      return {
        chips = card.ability.extra.current_chips
      }
    end
    
    if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
      for i = 1, #context.full_hand do
        if context.full_hand[i]:get_id() > 10 or context.full_hand[i]:get_id() < 2 then
          return
        end
      end
      
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'current_chips',
        scalar_value = 'chips_gain',
        scaling_message = { message = localize('k_upgrade_ex'), colour = G.C.CHIPS }
      })
    end
  end
}