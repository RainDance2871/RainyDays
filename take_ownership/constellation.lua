if RainyDays.config.constellations then SMODS.Joker:take_ownership('j_constellation', {
  config = { 
    extra = { 
      Xmult = 1, 
      Xmult_mod = 0.1 
    } 
  },
  
  loc_vars = function(self, info_queue, card)
    return { 
      vars = { 
        card.ability.extra.Xmult_mod, 
        card.ability.extra.Xmult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    
    if context.using_consumeable and not context.blueprint and (context.consumeable.ability.set == 'Constellation' or context.consumeable.ability.set == 'Planet') then
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
      return {
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
      }
    end
  end
}, true)
end