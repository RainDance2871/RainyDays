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
    return not RainyDays.FeatherOwned()
  end,
  pos = RainyDays.GetJokersAtlasTable('feather_precious'),
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
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.rd_feather_payout = (G.GAME.rd_feather_payout or 0) + card.ability.extra.plus_money
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.rd_feather_payout = (G.GAME.rd_feather_payout or 0) - card.ability.extra.plus_money
  end,
  
  calc_dollar_bonus = function(self, card)
    if G.GAME.rd_feather_payout and G.GAME.rd_feather_payout > 0 then
      return G.GAME.rd_feather_payout
    end
	end
} end