SMODS.Joker {
  key = 'spooky_joker',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('spooky_joker'),
  
  config = { 
    extra = { 
      Xmult = 2 / 3
    } 
  },
  
  loc_vars = function(self, info_queue, card)
    local amount = 0
    for _, value in ipairs(G.handlist) do
      if G.GAME.hands[value].rd_secret and G.GAME.hands[value].played > 0 then
        amount = amount + 1
      end
    end
    
    return {
      vars = {
        RainyDays.Round(card.ability.extra.Xmult, 2),
        RainyDays.Round(1 + amount * card.ability.extra.Xmult, 2)
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      local amount = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].rd_secret and G.GAME.hands[value].played > 0 then
          amount = amount + 1
        end
      end
      
      return {
        xmult = RainyDays.Round(1 + amount * card.ability.extra.Xmult, 2)
      }
    end
    
    if context.before and not context.blueprint and G.GAME.hands[context.scoring_name].rd_secret and G.GAME.hands[context.scoring_name].played == 1 then
      return {
        message_card = card,
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local amount = 0
    for _, value in ipairs(G.handlist) do
      if G.GAME.hands[value].rd_secret and G.GAME.hands[value].played > 0 then
        amount = amount + 1
      end
    end
    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(amount) or nil,
      vars = { 
        3
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'hand' then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].rd_secret and G.GAME.hands[value].played > 0 then
          count = count + 1
          if count >= 3 then
            return true
          end
        end
      end
    return false
    end
  end
}