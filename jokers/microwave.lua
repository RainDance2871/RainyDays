SMODS.Joker {
  key = 'microwave',
  name = 'Microwave',
  atlas = 'RainyDays',
  rarity = 1,
  cost = 5,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('microwave'),
  config = {
    plus_mult = 4,
    plus_mult_add = 4,
    plus_mult_border = 20
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] =  G.P_CENTERS.j_popcorn
    return {
      vars = { 
        card.ability.plus_mult,
        card.ability.plus_mult_add,
        card.ability.plus_mult_border
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      return {
        mult_mod =  card.ability.plus_mult,
        message = localize {
          type = 'variable',
          key = 'a_mult',
          vars = { card.ability.plus_mult }
        },
        colour = G.C.MULT,
      }
    end
    
    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
      card.ability.plus_mult = card.ability.plus_mult + card.ability.plus_mult_add
      if card.ability.plus_mult >= card.ability.plus_mult_border then
        card:flip()
        return {
          func = function()
            play_sound('RainyDays_microwave_ding', 0.7, 0.4)
            card:set_ability('j_popcorn', true)
            card:set_cost()
            card:flip()
          end,
          message = localize('rainydays_beep'),
          colour = G.C.RED
        }
      else
        return {
          message = localize{type='variable', key='a_mult', vars= { card.ability.plus_mult }},
          card = card,
          colour = G.C.RED
        }
      end
    end
  end
}

SMODS.Sound {
  key = 'microwave_ding',
  path = 'microwave_ding.ogg'
}