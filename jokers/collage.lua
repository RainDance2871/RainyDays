SMODS.Joker {
  key = 'collage',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('collage'),
  soul_pos = RainyDays.GetJokersAtlasTable('indicator_enhancements'),
  rd_soul_indicator_shader = 'RainyDays_indicator_enhancements',
  rd_skip_soul = true,
  attributes = { 'xmult', 'scaling', 'boss_blind', 'enhancements', 'reset' },
  
  config = { 
    extra = { 
      xmult = 0.3,
      xmult_base = 1
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.xmult_message = card.ability.extra.xmult_base + card.ability.extra.xmult * RainyDays.collage_amount_of_enhancements()
  end,
  
  loc_vars = function(self, info_queue, card)
    local contents = {}
    if G.GAME and G.GAME.rd_enhancements_scored_this_ante then
      for key in pairs(G.GAME.rd_enhancements_scored_this_ante) do
        if G.GAME.rd_enhancements_scored_this_ante[key] > 0 then
          contents[#contents + 1] = key
        end
      end
    end
    
    local function sort_function(a, b)
      return G.P_CENTERS[a].order < G.P_CENTERS[b].order
    end
    table.sort(contents, sort_function)
    
    for i = 1, #contents do
      contents[i] = localize{ type = 'name_text', set = 'Enhanced', key = contents[i] }
    end
      
    if card.area and not card.area.created_on_pause and G.GAME.blind and #contents > 0 and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) then
      local box = RainyDays.create_infobox_list(localize('rainydays_collage_box_name'), contents)
      info_queue[#info_queue + 1] = { set = 'Other', key = box }
    end
    
    return {
      vars = {
        card.ability.extra.xmult,
        card.ability.extra.xmult_base + card.ability.extra.xmult * #contents
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      local new_mult = card.ability.extra.xmult_base + card.ability.extra.xmult * RainyDays.collage_amount_of_enhancements()
      if new_mult > card.ability.extra.xmult_base and not card.ability.extra.xmult_message or card.ability.extra.xmult_message < new_mult then
        card.ability.extra.xmult_message = new_mult
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT
        }
      end
    end
    
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult_base + card.ability.extra.xmult * RainyDays.collage_amount_of_enhancements()
      }
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.blind.boss and card.ability.extra.xmult_message > 1 then
      card.ability.extra.xmult_message = nil
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end
}

function RainyDays.collage_amount_of_enhancements()
  local amount = 0;
  if G.GAME and G.GAME.rd_enhancements_scored_this_ante then
    for key in pairs(G.GAME.rd_enhancements_scored_this_ante) do
      if G.GAME.rd_enhancements_scored_this_ante[key] > 0 then
        amount = amount + 1
      end
    end
  end
  
  return amount
end