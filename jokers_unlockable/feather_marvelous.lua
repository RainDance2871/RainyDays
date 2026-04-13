if RainyDays.config.feathers then SMODS.Joker {
  key = 'feather_marvelous',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 2,
  cost = 5,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --does not appear in packs normally if player already has a feather
    return not RainyDays.FeatherOwned()
  end,
  pos = RainyDays.GetJokersAtlasTable('feather_marvelous'),
  config = {
    extra = {
      plus_xmult = 1.3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_xmult
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.other_joker and RainyDays.IsInPool(context.other_joker, 'Feather') then
      return {
        message_card = context.other_joker,
        xmult = card.ability.extra.plus_xmult
      }
    end
  end,
  
  calc_dollar_bonus = function(self, card)
    if G.GAME.rd_feather_payout and G.GAME.rd_feather_payout > 0 then
      return G.GAME.rd_feather_payout
    end
	end,
  
  locked_loc_vars = function(self, info_queue, card)
    local count = 0
    if G.jokers and G.jokers.cards then
      for i = 1, #G.jokers.cards do
        if RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
          count = count + 1
        end
      end
    end
    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(count) or nil,
      vars = { 
        3
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_jokers' and G.jokers then
      local count = 0
      for i = 1, #G.jokers.cards do
        if RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
          count = count + 1
          if count >= 3 then
            return true
          end
        end
      end
      return false
    end
  end
} end