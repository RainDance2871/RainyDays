SMODS.Joker {
  key = 'shooting_star',
  atlas = 'Jokers',
  rarity = 2,
  cost = 7,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('shooting_star'),
  attributes = { 'chips', 'hand_type', 'space' },
  
  config = { 
    extra = { 
      chips_rewards = 7,
      hand = 'Flush'
    }
  },
  
  loc_vars = function(self, info_queue, card) 
    return {
      vars = {
        card.ability.extra.chips_rewards,
        localize(card.ability.extra.hand, 'poker_hands')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.before and next(context.poker_hands[card.ability.extra.hand]) then
      local source = context.blueprint_card or card
      local hand = G.GAME.hands[context.scoring_name]
      local message_cards = { source }
      local ret = {
        no_message = true,
        colour = G.C.CHIPS
      }
      
      ret.func = function()
        hand.chips_bonus = (hand.chips_bonus or 0) + card.ability.extra.chips_rewards
        hand.chips = hand.s_chips + hand.chips_bonus + hand.l_chips * (hand.level - 1)
        
        card_eval_status_text(source, 'extra', nil, nil, nil, { message = localize('rainydays_hands_upgraded'), colour = ret.colour })
        
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 }, {})
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() return RainyDays.shakeit(message_cards, true) end }))
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function() return RainyDays.shakeit(message_cards, true) end }))
        update_hand_text({ delay = 0 }, { chips = SMODS.Scoring_Parameters.chips.current + card.ability.extra.chips_rewards, StatusText = true })
        mod_chips(SMODS.Scoring_Parameters.chips.current + card.ability.extra.chips_rewards)
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function() return RainyDays.shakeit(message_cards, false) end }))
        delay(1.3)
      end
      return ret
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.hands['Flush'].played or 0) or nil,
      vars = { 
        25,
        localize('Flush', 'poker_hands')
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'hand' and G.GAME.hands['Flush'].played >= 25
  end
}