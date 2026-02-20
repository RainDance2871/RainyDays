SMODS.Joker {
  key = 'fabergeegg',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('fabergeegg'),
  soul_pos = GetJokersAtlasTable('fabergeegg_soul'),
  soul_draw_as_highlight = true,
  soul_draw_as_highlight_shader = 'RainyDays_metallic_highlight',
  
  config = {
    extra = {
      plus_value = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.extra.plus_value }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:is_face() then
      local effect_card = context.blueprint_card or card
      effect_card.ability.extra_value = effect_card.ability.extra_value + card.ability.extra.plus_value
      effect_card:set_cost()
      return {
        message_card = card,
        message = localize('k_val_up'),
        colour = G.C.MONEY
      }
    end
  end
}