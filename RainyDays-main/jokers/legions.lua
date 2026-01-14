SMODS.Joker {
  key = 'legions',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('legions'),
  
  calculate = function(self, card, context)    
    if context.individual and context.cardarea == G.play then
      if context.other_card:get_id() <= 10 and context.other_card:get_id() >= 2 then
        return {
          mult = context.other_card:get_id() / 2
        }
      end
    end
  end
}