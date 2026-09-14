SMODS.Joker {
  key = 'lady_in_waiting',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('lady_in_waiting'),
  attributes = { 'rank', 'queen', 'modify_card', 'enhancements' },
  
  config = {
    extra = {
      rank = 'Queen'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks')
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.rd_draw_individual and G.GAME.facing_blind and context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
      local options = {}
      for _, value in pairs(G.P_CENTER_POOLS['Enhanced']) do
        if value.key ~= context.other_card.config.center.key and value.key ~= 'm_stone' and not value.overrides_base_rank then
          options[#options + 1] = value.key
        end
      end
      local enhancement = SMODS.poll_enhancement({ type_key = 'lady_in_waiting', guaranteed = true, options = options })
      return RainyDays.set_ability_multiple(card, context.other_card, enhancement, { delay = 0.3 })
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local count = 0
    if G.playing_cards then
      for i = 1, #G.playing_cards do
        if G.playing_cards[i]:get_id() == RainyDays.balatro_ranks_to_id['Queen'] then
          count = count + 1
        end
      end
    else
      count = 4
    end
    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(count) or nil,
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
        if G.playing_cards[i]:get_id() == RainyDays.balatro_ranks_to_id['Queen'] then
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