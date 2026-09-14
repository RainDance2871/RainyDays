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
  rd_soul_indicator_shader = 'RainyDays_indicator_ranks',
  rd_skip_soul = true,
  attributes = { 'rank', 'xmult' },
  
  config = {
    extra = {
      xmult = 1.5
    }
  },
  
  loc_vars = function(self, info_queue, card)
    if card.area and not card.area.created_on_pause and G.GAME.blind and G.GAME.blind.in_blind and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) then
      info_queue[#info_queue + 1] = G.P_CENTERS['j_RainyDays_checklist_list']
    end
    
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

SMODS.Joker {
  key = 'checklist_list',
  unlocked = true,
  discovered = true,
  no_collection = true,
  in_pool = function(self, args)
    return false
  end,
  
  loc_vars = function(self, info_queue, card)
    local colours = {}
    for i = 1, 13 do
      local rank_id = RainyDays.balatro_ranks_to_id[RainyDays.balatro_ranks[i]]
      colours[i] = (G.GAME.rd_ranks_played_this_round[rank_id] and G.GAME.rd_ranks_played_this_round[rank_id] > 0) and G.C.FILTER or G.C.UI.TEXT_INACTIVE
    end
    
    return {
      vars = {
        colours = colours
      }
    }
  end
}