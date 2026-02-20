SMODS.Joker {
  key = 'equity',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('equity'),
  pixel_size = { w = 71, h = 94 },
  
  config = {
    extra = {
      mult = 15
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint and context.initial_scoring_step then
      mult = mod_mult(card.ability.extra.mult)
      card_eval_status_text(card, 'jokers', nil, nil, nil, { 
        message = localize('rainydays_base_mult_set'), 
        colour = G.C.MULT 
      })
    end
  end
}