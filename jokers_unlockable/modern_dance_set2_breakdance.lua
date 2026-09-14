SMODS.Joker {
  key = 'breakdance',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('breakdance'),
  attributes = { 'xmult', 'rank', 'ace', 'three', 'five', 'seven', 'nine' },
  config = {
    extra = {
      xmult = 3
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.message_sent = not RainyDays.breakdance_check_active() or nil
  end,
  
  loc_vars = function(self, info_queue, card)
    local active = RainyDays.breakdance_check_active()
    
    return {
      vars = {
        colours = {
          active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        card.ability.extra.xmult,
        active and localize('rainydays_active') or localize('rainydays_inactive')
      }
    }
  end,
  
  calculate = function (self, card, context)
    if context.before and not context.blueprint and not card.ability.extra.message_sent and not RainyDays.breakdance_check_active() then
      card.ability.extra.message_sent = true
      return {
        message = localize('rainydays_deactivated'),
        colour = G.C.UI.TEXT_INACTIVE
      }
    end
    
    if context.joker_main and RainyDays.breakdance_check_active() then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.message_sent then
      card.ability.extra.message_sent = nil
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local count = 0
    if G.playing_cards then
      for i = 1, #G.playing_cards do
        if RainyDays.Is_odd(G.playing_cards[i]) then
          count = count + 1
        end
      end
    else
      count = 20
    end
    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(count) or nil,
      vars = { 
        30
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_deck' and G.playing_cards then
      local count = 0
      for i = 1, #G.playing_cards do
        if RainyDays.Is_odd(G.playing_cards[i]) then
          count = count + 1 
          if count >= 30 then
            return true
          end
        end
      end
    return false
    end
  end
}

function RainyDays.breakdance_check_active()
  if G.GAME.blind and G.GAME.blind.in_blind then
    if G.GAME.rd_ranks_played_this_round then
      for key, value in pairs(G.GAME.rd_ranks_scored_this_round) do
        if value > 0 and not (key == 14 or key == 9 or key == 7 or key == 5 or key == 3) then
          return false
        end
      end
    end
  end
  return true
end