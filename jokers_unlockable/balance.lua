SMODS.Joker {
  key = 'balance',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('balance'),
  soul_pos = RainyDays.GetJokersAtlasTable('indicator_hands'),
  RD_soul_draw_as_highlight = true,
  RD_soul_draw_as_highlight_shader = 'RainyDays_indicator',
  RD_soul_draw_always = true,
  
  config = {
    extra = {
      xmult = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local count = 0
    for _, value in ipairs(G.handlist) do
       if G.GAME.hands[value].played_this_round > 0 then
        count = count + 1
      end
    end
    
    return {
      vars = {
        card.ability.extra.xmult,
        count * card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.joker_main then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played_this_round > 0 then
          count = count + 1
        end
      end
      local xmult_given = count * card.ability.extra.xmult
      return {
        xmult = xmult_given ~= 1 and xmult_given or nil,
        message = xmult_given == 1 and localize {
          type = 'variable',
          key = 'a_xmult',
          vars = { xmult_given }
        } or nil,
        colour = G.C.MULT
      }
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
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
        if G.GAME.hands[value].played > 0 then
          count = count + 1
          if count >= 9 then
            return true
          end
        end
      end
    end
    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(count) or nil,
      vars = { 
        9
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'hand' then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played > 0 then
          count = count + 1
          if count >= 9 then
            return true
          end
        end
      end
    return false
    end
  end
}