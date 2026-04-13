SMODS.Joker {
  key = 'checklist',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('checklist'),
  soul_pos = RainyDays.GetJokersAtlasTable('indicator_ranks'),
  RD_soul_draw_as_highlight = true,
  RD_soul_draw_as_highlight_shader = 'RainyDays_indicator_ranks',
  RD_soul_draw_always = true,
  
  config = {
    extra = {
      xmult = 1.5
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card) then
      local rank_id = context.other_card:get_id()
      if G.GAME.rd_ranks_played_this_round[rank_id] and G.GAME.rd_ranks_played_this_round[rank_id] > 1 then
        
        local rank_count = 0
        for i = 1, #context.full_hand do
          if context.full_hand[i]:get_id() == rank_id then
            rank_count = rank_count + 1
          end
        end
        
        if G.GAME.rd_ranks_played_this_round[rank_id] > rank_count then
          return {
            xmult = card.ability.extra.xmult
          }
        end
      end
    end
  end
}