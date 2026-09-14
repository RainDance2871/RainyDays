SMODS.Joker {
  key = 'train_ticket',
  atlas = 'Jokers',
  rarity = 1,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('train_ticket'),
  attributes = { 'mult', 'scaling' },
  
  config = {
    extra = {
      mult_gain = 1,
      card_count = 3,
      current_mult = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)    
    return {
      vars = {
        card.ability.extra.mult_gain,
        card.ability.extra.card_count,
        card.ability.extra.current_mult
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.joker_main then
      return {
        mult = card.ability.extra.current_mult
      }
    end
    
    if context.before and not context.blueprint and RainyDays.check_for_three_row(context.full_hand) then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'current_mult',
        scalar_value = 'mult_gain',
        scaling_message = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
      })
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.hands['Straight'].played or 0) or nil,
      vars = { 
        25,
        localize('Straight', 'poker_hands')
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'hand' and G.GAME.hands['Straight'].played >= 25
  end
}

function RainyDays.check_for_three_row(hand)
  local rank_ids = {}
  for i = 1, #hand do
    if not SMODS.has_no_rank(hand[i]) then
      local id = hand[i]:get_id()
      rank_ids[id] = true
      if id == 14 then
        rank_ids[1] = true
      end
    end
  end
    
  for i = 1, 12 do
    if rank_ids[i] and rank_ids[i + 1] and rank_ids[i + 2] then
      return true
    end
  end
end