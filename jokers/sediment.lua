SMODS.Joker {
  key = 'sediment',
  name = 'Sediment',
  atlas = 'RainyDays',
  rarity = 2,
  cost = 5,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('sediment'),
  config = {
    plus_xmult = 3,
    card_threshold = 5
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.plus_xmult, G.GAME.starting_deck_size + card.ability.card_threshold }
    } 
  end,
    
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      if #G.playing_cards - G.GAME.starting_deck_size >= card.ability.card_threshold then
        return {
          Xmult_mod = card.ability.plus_xmult,
          message = localize {
            type = 'variable',
            key = 'a_xmult',
            vars = { card.ability.plus_xmult }
          },
          colour = G.C.RED
        }
      end
    end
  end
}