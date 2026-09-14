SMODS.Joker {
  key = 'sextant',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('sextant'),
  attributes = { 'mult', 'rank' },  
  
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
    if context.joker_main and #context.scoring_hand >= 2 then
      local dif = 0
      local first_card
      for i = 1, #context.scoring_hand do
        if not SMODS.has_no_rank(context.scoring_hand[i]) then
          first_card = i
          break
        end
      end
      
      if first_card then
        local high = context.scoring_hand[first_card]:get_id() 
        local low = context.scoring_hand[first_card]:get_id()
        for i = first_card + 1, #context.scoring_hand do
          if not SMODS.has_no_rank(context.scoring_hand[i]) then
            local id = context.scoring_hand[i]:get_id()
            high = (id > high) and id or high
            low = (id < low) and id or low
          end
        end
        
        dif = math.max((high - low) - 1, 0)
      end
      
      return {
        mult = card.ability.extra.mult_amount * dif
      }
    end
  end
}