SMODS.Joker {
  key = 'absent_heart',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('absent_heart'),
  attributes = { 'tarot', 'generation', 'suit', 'hearts' },
  
  config = {
    extra = {
      per_drawn = 7,
      drawn_counter = 0,
      suit = 'Hearts',
      reward = 'Tarot'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          G.C.SUITS[card.ability.extra.suit]
        },
        card.ability.extra.per_drawn,
        card.ability.extra.per_drawn - card.ability.extra.drawn_counter,
        localize(card.ability.extra.suit, 'suits_singular')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.rd_draw_individual and G.GAME.facing_blind and context.other_card:is_suit(card.ability.extra.suit) and not context.other_card.debuff and not context.blueprint then
      card.ability.extra.drawn_counter = card.ability.extra.drawn_counter + 1
      if card.ability.extra.drawn_counter >= card.ability.extra.per_drawn then
        card.ability.extra.drawn_counter = card.ability.extra.drawn_counter - card.ability.extra.per_drawn
        return RainyDays.create_consumable(context.blueprint_card or card, card.ability.extra.reward)        
      else
        return { 
          message_card = card,
          message = localize('rainydays_message_countdown_prefix') .. (card.ability.extra.per_drawn - card.ability.extra.drawn_counter) .. localize('rainydays_message_countdown_postfix'),
          colour = G.C.FILTER,
          delay = 0.2
        }
      end
    end
  end
}