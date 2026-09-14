SMODS.Joker {
  key = 'star_chart',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('star_chart'),
  soul_pos = RainyDays.GetJokersAtlasTable('star_chart_soul'),
  rd_highlight_shader = 'RainyDays_metallic_highlight',
  rd_skip_soul = true,
  attributes = { 'chips', 'scaling', 'planet', 'space' },
  
  config = {
    extra = {
      chip_amount = RainyDays.Constellations and 10 or 5
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local amount = 0
    if G.GAME.consumeable_usage_total then
      amount = G.GAME.consumeable_usage_total and (RainyDays.Constellations and G.GAME.consumeable_usage_total.cn_constellation or G.GAME.consumeable_usage_total.planet) or 0
    end
    
    return {
      vars = {
        card.ability.extra.chip_amount,
        card.ability.extra.chip_amount * amount
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.consumeable_usage_total then
      local amount = G.GAME.consumeable_usage_total and (RainyDays.Constellations and G.GAME.consumeable_usage_total.cn_constellation or G.GAME.consumeable_usage_total.planet) or 0
      return {
        chips = card.ability.extra.chip_amount * amount
      }
    end
    
    if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == (RainyDays.Constellations and 'CN_Constellation' or 'Planet') then
      return { 
        message_card = card,
        message = localize('k_upgrade_ex'),
        colour = G.C.CHIPS
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local amount = 0
    if G.GAME and G.GAME.consumeable_usage_total then
      amount = RainyDays.Constellations and G.GAME.consumeable_usage_total.constellation or G.GAME.consumeable_usage_total.planet
    end
    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(amount) or nil,
      vars = { 
        25
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'rd_used_consumeable' and G.GAME and G.GAME.consumeable_usage_total then
      return ((RainyDays.Constellations and G.GAME.consumeable_usage_total.cn_constellation or 0) + G.GAME.consumeable_usage_total.planet) >= 25
    end
  end
}