SMODS.Shader {
  key = 'false_glow',
  path = 'false_glow.fs',
  
  send_vars = function(sprite, card)
    return {
      timer = 300 * love.timer.getTime()
    }
  end
}

SMODS.Shader {
  key = 'metallic_highlight',
  path = 'metallic_highlight.fs',
  
  send_vars = function(sprite, card)
    return {
      brightness = 1.6,
      scaling = 0.03
    }
  end
}

SMODS.Shader {
  key = 'indicator',
  path = 'indicator.fs',
  
  send_vars = function(sprite, card)
    local sphere
    if RainyDays.card_drawn.label == 'j_RainyDays_balance' then
      sphere = function(i)
        return (G.GAME.blind and G.GAME.blind.in_blind and G.GAME.hands[RainyDays.balatro_hands[i]].played_this_round > 0) and 1 or 0
      end
    elseif RainyDays.card_drawn.label == 'j_RainyDays_desolate' then
      sphere = function(i)
        return (G.GAME.blind and G.GAME.hands[RainyDays.balatro_hands[i]].rd_discarded > 0) and 1 or 0
      end
    elseif RainyDays.card_drawn.label == 'j_RainyDays_sputnik' then
      sphere = function(i)
        return (G.GAME.blind and G.GAME.hands[RainyDays.balatro_hands[i]].played_this_ante > 0) and 1 or 0
      end
    end
  
    return {
      sphere_visible1 = { sphere(1), sphere(2), sphere(3), sphere(4) },
      sphere_visible2 = { sphere(5), sphere(6), sphere(7), sphere(8) },
      sphere_visible3 = { sphere(9), sphere(10), sphere(11), sphere(12) },
      grid_origin = { 6, 71 },
      grid_dims = { 6, 2 },
      sphere_size = { 10, 10 }
    }
  end
}

SMODS.Shader {
  key = 'indicator_ranks',
  path = 'indicator_ranks.fs',
  
  send_vars = function(sprite, card)
    local sphere
    if RainyDays.card_drawn.label == 'j_RainyDays_checklist' then
      sphere = function(i)
        if G.GAME.blind and G.GAME.blind.in_blind then
          local rank_id = RainyDays.balatro_ranks_to_id[RainyDays.balatro_ranks[i]]
          if G.GAME.rd_ranks_played_this_round[rank_id] and G.GAME.rd_ranks_played_this_round[rank_id] > 0 then
            return 1
          end
        end
        return 0
      end
    end
  
    return {
      sphere_visible1 = { sphere(1), sphere(2), sphere(3), sphere(4) },
      sphere_visible2 = { sphere(5), sphere(6), sphere(7), sphere(8) },
      sphere_visible2_extra = sphere(9),
      sphere_visible3 = { sphere(10), sphere(11), sphere(12), sphere(13) },
      
      row_x = { 16, 11, 16 },
      row_y = { 63, 72, 81 },
      row_start = { 0, 4, 9 },      
      sphere_size = { 10, 9 }
    }
  end
}