SMODS.Joker {
  key = 'starting_line',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('starting_line'),
  soul_pos = RainyDays.GetJokersAtlasTable('indicator_hands'),
  rd_soul_indicator_shader = 'RainyDays_indicator',
  rd_skip_soul = true,
  attributes = { 'xmult' },
  
  config = { 
    extra = { 
      Xmult = 2,
      amount = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    if (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) and card.area and not card.area.created_on_pause and G.GAME.blind then
      local contents = {}
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played >= card.ability.extra.amount then
          contents[#contents + 1] = localize(value, 'poker_hands')
        end
      end
        
      if #contents > 0 then
        local box = RainyDays.create_infobox_list(localize('rainydays_starting_line_box_name'), contents)
        info_queue[#info_queue + 1] = { set = 'Other', key = box }
      end
    end
    
    return {
      vars = {
        card.ability.extra.Xmult,
        card.ability.extra.amount
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played <= card.ability.extra.amount then
      return {
        xmult = card.ability.extra.Xmult
      }
    end
  end
}