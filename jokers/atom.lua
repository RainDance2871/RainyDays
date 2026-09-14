SMODS.Joker {
  key = 'atom',
  atlas = 'Jokers',
  rarity = 2,
  cost = 7,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('atom'),
  attributes = { 'mult', 'rank', 'ace', 'chance', 'hand_type' },
  config = {
    extra = {
      rank = 'Ace',
      numerator_in = 1,
      denominator_in = 4,
      mult_rewards = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks'),
        numerator_out,
        denominator_out,
        card.ability.extra.mult_rewards
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
      if not context.other_card.debuff and SMODS.pseudorandom_probability(card, 'atom', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
        local source = context.blueprint_card or card
        local hand = G.GAME.hands[context.scoring_name]
        local message_cards = { source, context.other_card }
        local ret = {
          no_message = true,
          colour = G.C.MULT
        }
        
        ret.func = function()
          hand.mult_bonus = (hand.mult_bonus or 0) + card.ability.extra.mult_rewards
          hand.mult = hand.s_mult + hand.mult_bonus + hand.l_mult * (hand.level - 1)
          
          card_eval_status_text(source, 'extra', nil, nil, nil, { message = localize('rainydays_hands_upgraded'), colour = ret.colour })
          
          update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 }, {})
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() return RainyDays.shakeit(message_cards, true) end }))
          update_hand_text({ delay = 0 }, { mult = SMODS.Scoring_Parameters.mult.current + card.ability.extra.mult_rewards, StatusText = true })
          mod_mult(SMODS.Scoring_Parameters.mult.current + card.ability.extra.mult_rewards)
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function() return RainyDays.shakeit(message_cards, true) end }))
          G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function() return RainyDays.shakeit(message_cards, false) end }))
          delay(1.3)
        end
        return ret
      end
    end
  end
}