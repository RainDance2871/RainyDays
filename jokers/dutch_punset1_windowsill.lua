SMODS.Joker {
  key = 'windowsill',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('windowsill'),
  attributes = { 'spectral', 'generation', 'suit', 'diamonds' },
  config = {
    extra = {
      per_held = 7,
      held_counter = 0,
      suit = 'Diamonds',
      reward = 'Spectral'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          G.C.SUITS[card.ability.extra.suit]
        },
        card.ability.extra.per_held,
        card.ability.extra.per_held - card.ability.extra.held_counter,
        localize(card.ability.extra.suit, 'suits_singular')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and context.individual and context.cardarea == G.hand then
      if context.other_card:is_suit(card.ability.extra.suit) and not context.other_card.debuff and not context.blueprint then
        card.ability.extra.held_counter = card.ability.extra.held_counter + 1
        if card.ability.extra.held_counter >= card.ability.extra.per_held then
          card.ability.extra.held_counter = card.ability.extra.held_counter - card.ability.extra.per_held
          return RainyDays.create_consumable(context.blueprint_card or card, card.ability.extra.reward)
        else
          return { 
            message_card = card,
            message = localize('rainydays_message_countdown_prefix') .. (card.ability.extra.per_held - card.ability.extra.held_counter) .. localize('rainydays_message_countdown_postfix'),
            colour = G.C.FILTER,
            delay = 0.2
          }
        end
      end
    end
  end
}