SMODS.Joker {
  key = 'fabergeegg',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('fabergeegg'),
  soul_pos = RainyDays.GetJokersAtlasTable('fabergeegg_soul'),
  RD_soul_draw_as_highlight = true,
  RD_soul_draw_as_highlight_shader = 'RainyDays_metallic_highlight',
  
  config = {
    extra = {
      plus_value = 1,
      rank1 = 'King',
      rank2 = 'Queen'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_value,
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks')
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local id = context.other_card:get_id()
      if (RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] == id or RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] == id) then
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
  end
}