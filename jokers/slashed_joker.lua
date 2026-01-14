SMODS.Joker {
  key = 'slashed_joker',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('slashed_joker'),
  soul_pos = GetJokersAtlasTable('slashed_joker_soul'),
  soul_draw_edition = true,
  
  config = {
    extra = {
      cards_amount = 3,
      repetitions = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.cards_amount
      }
    } 
  end,
  
  calculate = function (self, card, context)
    if context.repetition and context.cardarea == G.play and #context.full_hand <= card.ability.extra.cards_amount then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end
}