SMODS.Joker {
  key = 'spire',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('spire'),
  attributes = { 'economy', 'scaling', 'chance', 'booster' },
  
  config = {
    extra = {
      payout = 1,
      bonus = 2,
      numerator_in = 1,
      denominator_in = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = {
        card.ability.extra.payout,
        card.ability.extra.bonus,
        numerator_out,
        denominator_out
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.open_booster and not context.blueprint and SMODS.pseudorandom_probability(card, 'spire' .. G.GAME.round_resets.ante, card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'payout',
        scalar_value = 'bonus',
        scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MONEY }
      })
    end
  end,
  
  calc_dollar_bonus = function(self, card)
    return card.ability.extra.payout
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME.rd_boosters_opened or 0) or nil,
      vars = { 
        20
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'rd_booster_opened' and G.GAME and G.GAME.rd_boosters_opened and G.GAME.rd_boosters_opened >= 20
  end
}