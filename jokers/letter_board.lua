SMODS.Joker {
  key = 'letter_board',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true, 
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('letter_board'),
  attributes = { 'chips' },
  config = {
    extra = {
      plus_chips = 80
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.extra.plus_chips }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      for i = 1, #context.full_hand do
        if context.full_hand[i]:get_id() <= 10 and context.full_hand[i]:get_id() >= 2 then
          return
        end
      end
      return {
        chips = card.ability.extra.plus_chips
      }
    end
  end
}