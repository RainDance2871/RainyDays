SMODS.Joker {
  key = 'burdenofgreatness',
  atlas = 'Jokers',
  rarity = 3,
  cost = 5,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('burdenofgreatness'),
  
  config = {
    extra = {
      plus_money = 25,
      plus_score = 30
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.plus_money,
        card.ability.extra.plus_score
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint then
      if (context.buying_card and context.card == card) or (context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss) then
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * (1 + 0.01 * card.ability.extra.plus_score)
        ease_dollars(card.ability.extra.plus_money)
        return {
          message = localize('$') .. card.ability.extra.plus_money,
          colour = G.C.MONEY,
          extra = {
            message = localize('rainydays_danger'),
            colour = G.C.PURPLE
          }
        }
      end
    end
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'round_win' and G.GAME.blind.boss and G.GAME.chips / G.GAME.blind.chips >= to_big(3)
  end
}