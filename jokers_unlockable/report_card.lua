SMODS.Joker {
  key = 'report_card',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('report_card'),
  attributes = { 'rank', 'ace', 'xmult' }, 
  
  config = {
    extra = {
      rank = 'Ace',
      xmult_base = 1,
      xmult_extra = 0.1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult_extra,
        localize(card.ability.extra.rank, 'ranks'),
        card.ability.extra.xmult_base + card.ability.extra.xmult_extra * (G.GAME.rd_ranks_scored_this_ante[RainyDays.balatro_ranks_to_id[card.ability.extra.rank]] or 0)
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult_base + card.ability.extra.xmult_extra * (G.GAME.rd_ranks_scored_this_ante[RainyDays.balatro_ranks_to_id[card.ability.extra.rank]] or 0)
      }
    end
    
    if context.individual and context.cardarea == G.play and not context.other_card.debuff and context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
      return { 
        message_card = card,
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT
      }
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.blind.boss then
      if G.GAME.rd_ranks_scored_this_ante[RainyDays.balatro_ranks_to_id[card.ability.extra.rank]] and G.GAME.rd_ranks_scored_this_ante[RainyDays.balatro_ranks_to_id[card.ability.extra.rank]] > 0 then
        return {
          message = localize('k_reset'),
          colour = G.C.RED
        }
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.rd_ranks_scored and G.GAME.rd_ranks_scored[14] or 0) or nil,
      vars = {
        localize('Ace', 'ranks'),
        250
      }
    }
  end,  
  
  check_for_unlock = function(self, args)
    return args.type == 'hand' and G.GAME.rd_ranks_scored and G.GAME.rd_ranks_scored[14] and G.GAME.rd_ranks_scored[14] >= 250
  end
}