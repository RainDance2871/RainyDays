SMODS.Joker {
  key = 'simple_joker',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('simple_joker'),
  attributes = { 'mult', 'enhancements' },
  
  config = {
    extra = {
      mult = 7
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      for i = 1, #context.scoring_hand do
        if next(SMODS.get_enhancements(context.scoring_hand[i])) then
          return
        end
      end
      
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local count = 0
    if G.playing_cards then
      for _, playing_card in ipairs(G.playing_cards) do
        if next(SMODS.get_enhancements(playing_card)) then
          count = count + 1
        end
      end
    else
      count = 0
    end
    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(count) or nil,
      vars = { 
        5
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'win_custom' then
      local count = 0      
      for _, playing_card in ipairs(G.playing_cards or {}) do
        if next(SMODS.get_enhancements(playing_card)) then
          count = count + 1
          if count > 5 then
            return false
          end
        else
        end
      end
      return true
    end
  end
}