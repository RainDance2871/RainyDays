if RainyDays.config.feathers then SMODS.Joker {
  key = 'feather_vibrant',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --does not appear in packs normally if player already has a feather
    return not RainyDays.FeatherOwned()
  end,
  pos = RainyDays.GetJokersAtlasTable('feather_vibrant'),
  config = {
    extra = {
      plus_chips = 35
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_chips
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.other_joker and RainyDays.IsInPool(context.other_joker, 'Feather') then
      return {
        message_card = context.other_joker,
        chips = card.ability.extra.plus_chips
      }
    end
  end,
  
  calc_dollar_bonus = function(self, card)
    if G.GAME.rd_feather_payout and G.GAME.rd_feather_payout > 0 then
      return G.GAME.rd_feather_payout
    end
	end
} end