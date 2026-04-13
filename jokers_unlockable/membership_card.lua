SMODS.Joker {
  key = 'membership_card',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('membership_card'),
  config = {
    extra = {
      cost_reduction = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.cost_reduction
      }
    } 
  end,
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.inflation = G.GAME.inflation - card.ability.extra.cost_reduction
    for _, value in pairs(G.I.CARD) do
      if value.set_cost and value ~= card then
        value:set_cost()
      end
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
        card:set_cost()
        return true
      end
    }))
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.inflation = G.GAME.inflation + card.ability.extra.cost_reduction
    for _, value in pairs(G.I.CARD) do
      if value.set_cost then
        value:set_cost()
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(localize('$') .. (G.GAME.rd_money_spent_shop or 0)) or nil,
      vars = { 
        50
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'money' and (G.GAME.rd_money_spent_shop or 0) >= 50
  end
}