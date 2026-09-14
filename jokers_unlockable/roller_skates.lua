SMODS.Joker {
  key = 'roller_skates',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('roller_skates'),
  attributes = { 'xmult', 'discard', 'hand_type' },   
  
  config = {
    extra = {
      xmult = 3,
      hand = 'Two Pair'
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.message_sent = RainyDays.skates_check_active(card) or nil
  end,
  
  loc_vars = function(self, info_queue, card)
    local active = RainyDays.skates_check_active(card)
    return {
      vars = {
        colours = {
          active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        card.ability.extra.xmult,
        localize(card.ability.extra.hand, 'poker_hands'),
        active and localize('rainydays_active') or localize('rainydays_inactive')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and RainyDays.skates_check_active(card) then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.pre_discard and not context.blueprint and RainyDays.skates_check_active(card) and not card.ability.extra.message_sent then
      card.ability.extra.message_sent = true
      return {
        message = localize('rainydays_activated'),
        colour = G.C.FILTER
      }
    end
    
    if context.end_of_round and context.game_over == false and card.ability.extra.message_sent and context.main_eval and not context.blueprint then
      card.ability.extra.message_sent = nil
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local count = 0
    if G.GAME then
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].rd_discarded > 0 then
          count = count + 1
        end
      end
    end
    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(count) or nil,
      vars = { 
        6
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'discard_custom' then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].rd_discarded > 0 then
          count = count + 1
          if count >= 6 then
            return true
          end
        end
      end
    return false
    end
  end
}

function RainyDays.skates_check_active(card)
  return G.GAME.blind and G.GAME.blind.in_blind and G.GAME.hands[card.ability.extra.hand].rd_discarded_this_round and G.GAME.hands[card.ability.extra.hand].rd_discarded_this_round > 0
end