SMODS.Joker {
  key = 'frowny_face',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true, 
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('frowny_face'),
  attributes = { 'mult', 'face' },
  
  config = {
    extra = {
      plus_mult = 10
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.extra.plus_mult }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      local count = 0
      for i = 1, #context.full_hand do
        if context.full_hand[i]:is_face(true) and (context.full_hand[i].debuff or not RainyDays.list_contains(context.scoring_hand, context.full_hand[i])) then
          count = count + 1
        end
      end
      
      return {
        mult = card.ability.extra.plus_mult * count
      }
    end
  end
}