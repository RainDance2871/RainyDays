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
    return not FeatherOwned()
  end,
  pos = GetJokersAtlasTable('feather_marvelous'),
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
    if context.other_joker and IsFeather(context.other_joker) then
      return {
        message_card = context.other_joker,
        xmult = card.ability.extra.plus_xmult
      }
    end
  end,
  
  calc_dollar_bonus = function(self, card)
    local bonus = G.P_CENTERS.j_RainyDays_feather_precious.config.extra.plus_money * #SMODS.find_card('j_RainyDays_feather_precious')
    if bonus > 0 then
      return bonus
    end
	end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      vars = { 
        3 
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_jokers' and G.jokers then
      local count = 0
      for i = 1, #G.jokers.cards do
        if IsFeather(G.jokers.cards[i]) then
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