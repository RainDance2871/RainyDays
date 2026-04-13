SMODS.Joker {
  key = 'hecate',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('hecate'),
  soul_pos = RainyDays.GetJokersAtlasTable('hecate_soul'),
  RD_soul_draw_as_highlight = true,
  RD_soul_draw_as_highlight_shader = 'RainyDays_metallic_highlight',
  
  config = {
    extra = {
      hand = 'Three of a Kind'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.hand, 'poker_hands')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played_this_round > 0 and card.ability.extra.hand ~= value then
          return 
        end
      end
      if G.GAME.hands[card.ability.extra.hand].played_this_round > 0 then
        return RainyDays.create_consumable(card, 'Spectral')
      end
    end
  end
}