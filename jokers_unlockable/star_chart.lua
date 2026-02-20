if RainyDays.config.constellations then SMODS.Joker {
  key = 'star_chart',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = GetJokersAtlasTable('star_chart'),
  soul_pos = GetJokersAtlasTable('star_chart_soul'),
  soul_draw_as_highlight = true,
  soul_draw_as_highlight_shader = 'RainyDays_metallic_highlight',
  
  config = {
    extra = {
      chip_amount = 12
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.chip_amount,
        card.ability.extra.chip_amount * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.constellation or 0)
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.chip_amount * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.constellation or 0)
      }
    end
    
    if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Constellation' then
      local amount = card.ability.extra.chip_amount * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.constellation or 0)
      return { 
        message = localize { type = 'variable', key = 'a_chips', vars = { amount }},
        colour = G.C.CHIPS
      }
    end
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'discover_amount' and #G.P_CENTER_POOLS.Constellation <= args.constellation_count
  end
} end