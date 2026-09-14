SMODS.Joker {
  key = 'trading_stamps',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('trading_stamps'), 
  attributes = { 'economy', 'sell_value' }, 
  config = {
    extra = {
      money_border = 15,
      plus_value = 4,
      money_spent = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)  
    return {
      vars = {
        card.ability.extra.money_border,
        card.ability.extra.plus_value,
        card.ability.extra.money_border - card.ability.extra.money_spent
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.money_altered and context.amount < 0 and not context.blueprint then
      card.ability.extra.money_spent = card.ability.extra.money_spent - context.amount
      if card.ability.extra.money_spent >= card.ability.extra.money_border then
        local increase_value = math.floor(card.ability.extra.money_spent / card.ability.extra.money_border)
        
        if increase_value > 0 then
          card.ability.extra.money_spent = card.ability.extra.money_spent - card.ability.extra.money_border * increase_value
          card.ability.extra_value = card.ability.extra_value + card.ability.extra.plus_value * increase_value
          card:set_cost()
          return {
            message = localize('k_val_up'),
            colour = G.C.MONEY,
            delay = 1
          }
        end
      else
        return {
          message = localize('rainydays_trading_stamps_message_prefix') .. (card.ability.extra.money_border - card.ability.extra.money_spent) .. localize('rainydays_trading_stamps_message_postfix'),
          colour = G.C.MONEY,
          delay = 0.5
        }
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(localize('$') .. (G.GAME.rd_money_spent or 0)) or nil,
      vars = { 
        200
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'money' and (G.GAME.rd_money_spent or 0) >= 200
  end
}