SMODS.Joker {
  key = 'sextant',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('sextant'),
  
  config = {
    extra = {
      mult_amount = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_amount,
        2 * card.ability.extra.mult_amount
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and #context.scoring_hand > 0 then
      local high = context.scoring_hand[1]:get_id() 
      local low = context.scoring_hand[1]:get_id()
      for i = 2, #context.scoring_hand do
        if context.scoring_hand[i]:get_id() > high then
          high = context.scoring_hand[i]:get_id()
        end
        if context.scoring_hand[i]:get_id() < low then
          low = context.scoring_hand[i]:get_id()
        end
      end
      
      local dif = math.max((high - low) - 1, 0)
      
      return {
        mult = card.ability.extra.mult_amount * dif
      }
    end
  end
}