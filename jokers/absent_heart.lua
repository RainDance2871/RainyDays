SMODS.Joker {
  key = 'absent_heart',
  atlas = 'Jokers',
  rarity = 1,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('absent_heart'),
  config = {
    extra = {
      per_not_scored = 7,
      not_scored_counter = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.per_not_scored,
        card.ability.extra.per_not_scored - card.ability.extra.not_scored_counter
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == 'unscored' and context.other_card:is_suit('Hearts') and not context.other_card.debuff then
      local create_card
      if not context.blueprint then
        card.ability.extra.not_scored_counter = card.ability.extra.not_scored_counter + 1
        if card.ability.extra.not_scored_counter >= card.ability.extra.per_not_scored then
          card.ability.extra.not_scored_counter = card.ability.extra.not_scored_counter - card.ability.extra.per_not_scored
          card.ability.extra.create_card = true
          create_card = true
        else
          card.ability.extra.create_card = nil
        end
      else
        if RainyDays.GetJokerPosition(context.blueprint_card) < RainyDays.GetJokerPosition(card) then
          create_card = (card.ability.extra.not_scored_counter + 1 >= card.ability.extra.per_not_scored)
        else
          create_card = card.ability.extra.create_card
        end
      end
      
      if create_card then
        return RainyDays.create_consumable(context.blueprint_card or card, 'Tarot')
      end
    end
  end
}