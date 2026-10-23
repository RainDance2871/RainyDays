SMODS.Joker {
  key = 'xylophone',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('xylophone'),
  attributes = { 'mult', 'scaling', 'hand_type' },
  
  config = {
    extra = {
      mult = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local contents = {}
    for _, value in ipairs(G.handlist) do
      if G.GAME.hands[value].played > 0 then
        contents[#contents + 1] = localize(value, 'poker_hands')
      end
    end
    
    if card.area and card.area == G.jokers and #contents > 0 and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) then
      local box = RainyDays.create_infobox_list(localize('rainydays_xylophone_box_name'), contents)
      info_queue[#info_queue + 1] = { set = 'Other', key = box }
    end    
    
    return {
      vars = {
        card.ability.extra.mult,
        card.ability.extra.mult * #contents
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.before and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played == 1 and not context.blueprint then
      return { 
        message_card = card,
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT
      }
    end
    
    if context.joker_main then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played > 0 then
          count = count + 1
        end
      end
      return {
        mult = card.ability.extra.mult * count
      }
    end
  end
}