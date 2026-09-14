SMODS.Joker {
  key = 'cloverfield',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('cloverfield'),
  attributes = { 'mult', 'discard', 'scaling', 'suits', 'clubs' },
  
  config = {
    extra = {
      current_mult = 0,
      plus_mult = 4,
      per_discarded = 7,
      discarded_counter = 0,
      suit = 'Clubs'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          G.C.SUITS[card.ability.extra.suit]
        },
        card.ability.extra.plus_mult,
        card.ability.extra.current_mult,
        card.ability.extra.per_discarded,
        card.ability.extra.per_discarded - card.ability.extra.discarded_counter,
        localize(card.ability.extra.suit, 'suits_singular')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.current_mult > 0 then
      return {
        mult = card.ability.extra.current_mult
      }
    end
    
    --grant mult on discard of clubs
    if context.discard and not context.blueprint and context.other_card:is_suit(card.ability.extra.suit) then
      card.ability.extra.discarded_counter = card.ability.extra.discarded_counter + 1
      
      --enough clubs discarded
      local upgraded = 0
      while card.ability.extra.discarded_counter >= card.ability.extra.per_discarded do
        upgraded = upgraded + 1
        card.ability.extra.discarded_counter = card.ability.extra.discarded_counter - card.ability.extra.per_discarded
      end
      
      if upgraded > 0 then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra, 
          ref_value = 'current_mult',
          scalar_value = 'plus_mult',
          operation = function(ref_table, ref_value, initial, modifier)
            ref_table[ref_value] = initial + modifier * upgraded
          end,
          scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
        })
      else
        return { 
          message_card = card,
          message = localize('rainydays_message_countdown_prefix') .. (card.ability.extra.per_discarded - card.ability.extra.discarded_counter) .. localize('rainydays_message_countdown_postfix'),
          colour = G.C.FILTER,
          delay = 0.2
        }
      end
    end
  end
}