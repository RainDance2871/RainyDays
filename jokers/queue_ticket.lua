SMODS.Joker {
  key = 'queue_ticket',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('queue_ticket'),
  display_size = { w = 52, h = 95 },
  pixel_size = { w = 52, h = 95 },
  attributes = { 'retrigger', 'rank', 'queen', 'two' }, 
  
  config = {
    extra = {
      rank1 = 'Queen',
      rank2 = '2',
      repetitions = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks')
      }
    } 
  end,
  
  calculate = function (self, card, context)
    if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand) then
      if context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
        return {
          repetitions = card.ability.extra.repetitions
        }
      end
    end
  end
}