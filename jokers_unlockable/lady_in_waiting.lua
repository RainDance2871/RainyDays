SMODS.Joker {
  key = 'lady_in_waiting',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('lady_in_waiting'),
  
  config = {
    extra = {
      rank = 'Queen',
      chip_bonus = 7
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks'),
        card.ability.extra.chip_bonus
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.hand_drawn then
      local queen_count = 0
      for i = 1, #context.hand_drawn do
        if context.hand_drawn[i].base.value == card.ability.extra.rank and not context.hand_drawn[i].debuff then
          queen_count = queen_count + 1
        end
      end
      
      if queen_count > 0 then
        for i = 1, #context.hand_drawn do
          context.hand_drawn[i].ability.perma_bonus = (context.hand_drawn[i].ability.perma_bonus or 0) + queen_count * card.ability.extra.chip_bonus
        end
        G.E_MANAGER:add_event(Event({
          func = function()
            for i = 1, #context.hand_drawn do
              context.hand_drawn[i]:juice_up()
            end
            card_eval_status_text(context.blueprint_card or card, 'jokers', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.CHIPS })
            return true
          end
        }))
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      vars = { 
        12,
        localize('Queen', 'ranks')
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_deck' and G.playing_cards then
      local count = 0
      for i = 1, #G.playing_cards do
        if G.playing_cards[i].base.value == 'Queen' then
          count = count + 1 
          if count >= 12 then
            return true
          end
        end
      end
    return false
    end
  end
}