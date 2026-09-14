SMODS.Joker {
  key = 'orange',
  atlas = 'Jokers',
  pools = { Food = true },
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('orange'),
  attributes = { 'mult', 'food' },
  config = {
    extra = {
      mult = 18,
      malus_mult = 3,
      border = 5
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.mult,
        card.ability.extra.malus_mult,
        card.ability.extra.border
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        mult = card.ability.extra.mult
      }
    end
    
    if context.before and #context.scoring_hand < card.ability.extra.border and not context.blueprint then
      local before = card.ability.extra.mult
      SMODS.scale_card(card, {
        ref_table = card.ability.extra, 
        ref_value = 'mult',
        scalar_value = 'malus_mult',
        operation = '-',
        no_message = true
      })
      if card.ability.extra.mult <= 0 then
        SMODS.destroy_cards(card, { pinch_anim = true })
        return {
          message = localize('k_eaten_ex'),
          colour = G.C.RED
        }
      else 
        return {
          message = localize { type = 'variable', key = 'a_mult_minus', vars = { math.abs(before - card.ability.extra.mult) }},
          colour = G.C.MULT
        }
      end
    end
  end
}