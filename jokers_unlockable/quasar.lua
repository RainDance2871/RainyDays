SMODS.Joker {
  key = 'quasar',
  atlas = 'Jokers',
  rarity = 2,
  cost = 7,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('quasar'),
  attributes = { 'xmult', 'scaling', 'space' }, 
  
  config = {
    extra = {
      xmult = 1,
      xmult_gain = 0.2,
      min_level = 2,
      level_loss = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.min_level,
        card.ability.extra.level_loss,
        card.ability.extra.xmult_gain,
        card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.before and not context.blueprint then
      if G.GAME.hands[context.scoring_name].level >= card.ability.extra.min_level then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'xmult',
          scalar_value = 'xmult_gain',
          no_message = true
        })        
        return {
          level_up = -card.ability.extra.level_loss,
          extra = {
            message = localize('k_upgrade_ex'),
            colour = G.C.MULT
          }
        }
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local planets_used = 0
    if G.GAME and G.GAME.consumeable_usage then
      for _, consumable in pairs(G.GAME.consumeable_usage) do
        if consumable.set == 'Planet' then
          planets_used = planets_used + 1
        end
      end
    end
    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(planets_used) or nil,
      vars = { 
        10
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'rd_used_consumeable' and G.GAME and G.GAME.consumeable_usage then
      local planets_used = 0
      for _, consumable in pairs(G.GAME.consumeable_usage) do
        if consumable.set == 'Planet' then
          planets_used = planets_used + 1
        end
      end
      
      return (planets_used >= 10)
    end
  end
}