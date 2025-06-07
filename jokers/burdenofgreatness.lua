SMODS.Joker {
  key = 'burdenofgreatness',
  name = 'Burden of Greatness',
  atlas = 'RainyDays',
  rarity = 3,
  cost = 5,
  unlocked = true, 
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('burdenofgreatness'),
  config = {
    plus_money = 25,
    plus_score = 30
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.plus_money,
        card.ability.plus_score
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint then
      if (context.buying_card and context.card == self) or (context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss) then
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * (1 + 0.01 * card.ability.plus_score)
        ease_dollars(card.ability.plus_money)
        return {
          message = localize('$')..card.ability.plus_money,
          colour = G.C.MONEY,
          extra = {
            message = localize('rainydays_danger'),
            colour = G.C.PURPLE
          }
        }
      end
    end
  end
}