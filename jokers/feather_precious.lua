if RainyDays.config.feathers then SMODS.Joker {
  key = 'feather_precious',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 1,
  cost = 5,
  unlocked = true, 
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --does not appear in packs normally if player already has a feather
    return not FeatherOwned()
  end,
  pos = GetJokersAtlasTable('feather_precious'),
  config = {
    extra = {
      plus_money = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_money
      }
    } 
  end,
  
  calc_dollar_bonus = function(self, card)
    local bonus = card.ability.extra.plus_money * #SMODS.find_card('j_RainyDays_feather_precious')
    if bonus > 0 then
      return bonus
    end
	end
} end