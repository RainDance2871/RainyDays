SMODS.Joker {
  key = 'abacus',
  atlas = 'Jokers',
  rarity = 3,
  cost = 7,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('abacus'),
  pixel_size = { w = 71, h = 94 },
  attributes = { 'xmult', 'scaling' },
  
  config = {
    extra = {
      x_mult = 1,
      plus_xmult = 0.02
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(G.GAME.current_round.RD_abacus[1], 'ranks'),
        localize(G.GAME.current_round.RD_abacus[2], 'ranks'),
        localize(G.GAME.current_round.RD_abacus[3], 'ranks'),
        card.ability.extra.plus_xmult,
        card.ability.extra.x_mult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.x_mult
      }
    end
    
    if context.individual and context.cardarea == G.play and not context.blueprint then
      local id = context.other_card:get_id()
      if RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_abacus[1]] == id or RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_abacus[2]] == id
      or RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_abacus[3]] == id then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'x_mult',
          scalar_value = 'plus_xmult',
          scaling_message = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
          no_message = true
        })
        return {
          message_card = card,
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT
        }
      end
    end
  end
}

function RainyDays.reset_game_globals_abacus()
  local rank_count = {}
  if G.playing_cards then
    for i = 1, #G.playing_cards do
      if not SMODS.has_no_rank(G.playing_cards[i]) and G.playing_cards[i].base.id >= 2 and G.playing_cards[i].base.id <= 10 then
        rank_count[G.playing_cards[i].base.id] = (rank_count[G.playing_cards[i].base.id] or 0) + 1
      end
    end
	end
  
  local group_count = {}
  local total_weight = 0
  for i = 3, 9 do
    local weight = (rank_count[i - 1] or 0) + (rank_count[i] or 0) + (rank_count[i + 1] or 0)
    group_count[i] = weight
    total_weight = total_weight + weight
  end
  
  local rank
  if total_weight <= 0 then
    rank = pseudorandom('abacus', 3, 9)
  else
    local poll_weight = pseudorandom('abacus', 1, total_weight)
    local weight_i = 0
    for i = 3, 9 do
      weight_i = weight_i + group_count[i]
      if weight_i >= poll_weight then
        rank = i
        break
      end
    end
    
    G.GAME.current_round.RD_abacus = { tostring(rank + 1), tostring(rank), tostring(rank - 1) }
  end
end