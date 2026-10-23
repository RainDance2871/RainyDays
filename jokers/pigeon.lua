SMODS.Joker {
  key = 'pigeon',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('pigeon'), 
  attributes = { 'xmult', 'joker', 'destroy_card' }, 
  config = {
    extra = {
      xmult = 1,
      xmult_extra = 0.3,
      numerator_in = 1,
      denominator_in = 7
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = {
        numerator_out,
        denominator_out,
        card.ability.extra.xmult_extra,
        card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.card_added and context.card.config.center.key == card.config.center.key and not context.card.getting_sliced and not context.blueprint then
      context.card.getting_sliced = true
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 1,
        func = function()
          card:juice_up(0.8, 0.8)
          context.card:start_dissolve({ HEX('57ecab') }, nil, 1.6)
          play_sound('slice1', 0.96 + math.random() * 0.08)
          return true
        end
      }))
      
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'xmult',
        scalar_value = 'xmult_extra',
        scaling_message = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
      })
    end
    
    if context.rd_transform_encountered_card and context.created_card.ability.set == 'Joker' and not context.blueprint and not context.created_card.rd_transformed then
      if SMODS.pseudorandom_probability(card, 'pigeon', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
        context.created_card:set_ability(card.config.center.key, true)
        context.created_card:set_cost()
        context.created_card.rd_transformed = true
        context.created_card:remove_sticker('eternal')
        context.created_card:remove_sticker('perishable')
        return {
          message_card = card,
          message = localize('rainydays_pigeon_appear'),
          colour = G.C.FILTER
        }
      end
    end
  end
}