SMODS.Joker {
  key = 'return_to_sender',
  atlas = 'Jokers',
  rarity = 3,
  cost = 9,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('return_to_sender'),
  attributes = { 'copying', 'joker' },
  
  config = {
    extra = {}
  },
  
  loc_vars = function(self, info_queue, card)
    local other_joker, second_best, other_joker_name
    if G.jokers and G.jokers.cards then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.key ~= card.config.center.key and G.jokers.cards[i].config.center.blueprint_compat and G.jokers.cards[i].ability.rd_joker_id and not G.jokers.cards[i].debuff then
          if not other_joker then
            other_joker = G.jokers.cards[i]
          elseif G.jokers.cards[i].ability.rd_joker_id > other_joker.ability.rd_joker_id then
            second_best = other_joker
            other_joker = G.jokers.cards[i]
          end
        end
      end
    end
    
    if other_joker then 
      other_joker_name = RainyDays.GetJokerName(other_joker)
    end
    
    if other_joker and not SMODS.is_eternal(other_joker, card) and second_best then
      local second_best_name = RainyDays.GetJokerName(second_best)
      local split = localize('rainydays_return_to_sender_split') and string.len(second_best_name) > 8 and string.find(second_best_name, ' ', 6) or nil
      local split1, split2
      if split then
        split2 = string.sub(second_best_name, split + 1, -1)
        split1 = string.sub(second_best_name, 1, split - 1)
      end
      
      local key = (split or string.len(second_best_name) > 12) and 'rainydays_return_to_sender_second_best' or 'rainydays_return_to_sender_second_best_short'
      info_queue[#info_queue + 1] = { set = 'Other', key = key, specific_vars = { second_best_name, split1, split2 }}
    end
    
    return {
      vars = {
        colours = { 
          other_joker and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        other_joker_name or string.lower(localize('k_none'))
      }
    }
  end,

  calculate = function(self, card, context)    
    local other_joker
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i].config.center.key ~= card.config.center.key and G.jokers.cards[i].config.center.blueprint_compat and G.jokers.cards[i].ability.rd_joker_id and not G.jokers.cards[i].debuff then
        if not other_joker or G.jokers.cards[i].ability.rd_joker_id > other_joker.ability.rd_joker_id then
          other_joker = G.jokers.cards[i]
        end
      end
    end
    
    if other_joker then
      if (not card.ability.extra.last_copied or card.ability.extra.last_copied ~= other_joker.ability.rd_joker_id) and not context.blueprint then
        card.ability.extra.last_copied = other_joker.ability.rd_joker_id
        card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('rainydays_new_target'), colour = G.C.FILTER })
      end
      
      return SMODS.blueprint_effect(card, other_joker, context)
    elseif card.ability.extra.last_copied and not context.blueprint then
      card.ability.extra.last_copied = nil
      return {
        message = localize('rainydays_target_lost'),
        colour = G.C.FILTER
      }    
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.rd_jokers_uniquelist_count or 0) or nil,
      vars = { 
        20
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'win_custom' and G.GAME and G.GAME.rd_jokers_uniquelist_count and G.GAME.rd_jokers_uniquelist_count >= 20
  end
}

local old_generate_UIBox_func_ref = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(vars_only)
  if (self.area == G.pack_cards or self.area == G.shop_jokers) and self.config.center.blueprint_compat and next(SMODS.find_card('j_RainyDays_return_to_sender', true)) then
    RainyDays.return_to_sender_compatible = true
  end
  local ret = old_generate_UIBox_func_ref(self, vars_only)
  RainyDays.return_to_sender_compatible = nil
  return ret
end