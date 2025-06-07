SMODS.Joker {
  key = 'feather_precious',
  name = 'Precious Feather',
  atlas = 'RainyDays',
  pools = { Feather = true },
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('feather_precious'),
  config = {
    plus_money = 3
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.plus_money, card.ability.plus_money * GetFeatherCount() }
    } 
  end,
  
  calc_dollar_bonus = function(self, card)
		local bonus = card.ability.plus_money * GetFeatherCount()
		if bonus > 0 then 
      return bonus 
    end
	end
}