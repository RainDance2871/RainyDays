SMODS.Joker:take_ownership('j_midas_mask', {
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      local faces = {}
      for _, value in ipairs(context.scoring_hand) do
        if not value.debuff and value:is_face() then 
          faces[#faces + 1] = value
        end
      end
      
      if #faces > 0 then
        return RainyDays.set_ability_multiple(card, faces, 'm_gold', { message = localize('k_gold'), colour = G.C.MONEY })
      end
    end
  end
}, true)