if RainyDays.config.feathers then SMODS.Joker {
  key = 'feather_mystic',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 1,
  cost = 5,
  unlocked = true, 
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --does not appear in packs normally if player already has a feather
    return not FeatherOwned()
  end,
  pos = GetJokersAtlasTable('feather_mystic'),
  config = {
    extra = {
      numerator_in = 1,
      denominator_in = 6
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = { 
        numerator_out,
        denominator_out
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.other_joker and IsFeather(context.other_joker) then
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        if SMODS.pseudorandom_probability(card, 'feather_mystic', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          return {
            message = localize('k_plus_tarot'),
            message_card = context.other_joker,
            func = function()
              G.E_MANAGER:add_event(Event({
                func = (function()
                  SMODS.add_card { set = 'Tarot' }
                  G.GAME.consumeable_buffer = 0
                  return true
                end)
              }))
            end
          }
        end
      end
    end
  end,
  
  calc_dollar_bonus = function(self, card)
    local bonus = G.P_CENTERS.j_RainyDays_feather_precious.config.extra.plus_money * #SMODS.find_card('j_RainyDays_feather_precious')
    if bonus > 0 then
      return bonus
    end
	end
} end