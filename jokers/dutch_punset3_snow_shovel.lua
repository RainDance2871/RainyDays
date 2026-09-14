SMODS.Joker {
  key = 'snow_shovel',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('snow_shovel'),
  attributes = { 'chips', 'scaling', 'suit', 'spades' },
  
  config = {
    extra = {
      per_scored = 7,
      scored_counter = 0,
      chip_bonus = 25,
      chip_current = 0,
      suit = 'Spades'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          G.C.SUITS[card.ability.extra.suit]
        },
        card.ability.extra.chip_bonus,
        card.ability.extra.chip_current,
        card.ability.extra.per_scored,
        card.ability.extra.per_scored - card.ability.extra.scored_counter,
        localize(card.ability.extra.suit, 'suits_singular')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.chip_current > 0 then
      return {
        chips = card.ability.extra.chip_current
      }
    end
    
    --grant mult on playing of spades
    if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.suit) and not context.blueprint then
      card.ability.extra.scored_counter = card.ability.extra.scored_counter + 1
      
      local upgraded = 0
      while card.ability.extra.scored_counter >= card.ability.extra.per_scored do
        upgraded = upgraded + 1
        card.ability.extra.scored_counter = card.ability.extra.scored_counter - card.ability.extra.per_scored
      end
      
      if upgraded > 0 then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra, 
          ref_value = 'chip_current',
          scalar_value = 'chip_bonus',
          operation = function(ref_table, ref_value, initial, modifier)
            ref_table[ref_value] = initial + modifier * upgraded
          end,
          scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.CHIPS }
        })
      else
        return { 
          message_card = card,
          message = localize('rainydays_message_countdown_prefix') .. (card.ability.extra.per_scored - card.ability.extra.scored_counter) .. localize('rainydays_message_countdown_postfix'),
          colour = G.C.FILTER,
          delay = 0.2
        }
      end
    end
  end
}