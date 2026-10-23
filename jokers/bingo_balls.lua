SMODS.Joker {
  key = 'bingo_balls',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true, 
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('bingo_balls'),
  attributes = { 'chips', 'consumable' },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        G.GAME.rd_bingo_balls,
        G.GAME.rd_bingo_balls_min,
        G.GAME.rd_bingo_balls_max
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = G.GAME.rd_bingo_balls
      }
    end
    
    if context.using_consumeable and not context.blueprint then
      return {
        message = localize{ type = 'variable', key = 'a_chips', vars = { G.GAME.rd_bingo_balls }},
        colour = G.C.CHIPS
      }
    end
  end
}