SMODS.Joker {
  key = 'desolate',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('desolate'),
  soul_pos = RainyDays.GetJokersAtlasTable('indicator_hands'),
  rd_soul_indicator_shader = 'RainyDays_indicator',
  rd_skip_soul = true,
  attributes = { 'xmult', 'discard', 'hand_type' },
  
  config = { 
    extra = { 
      Xmult = 3,
      hands = 9
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local contents = {}
    for _, value in ipairs(G.handlist) do
      if G.GAME.hands[value].rd_discarded and G.GAME.hands[value].rd_discarded > 0 then
        contents[#contents + 1] = localize(value, 'poker_hands')
      end
    end
      
    if card.area and not card.area.created_on_pause and G.GAME.blind and #contents > 0 and #contents < card.ability.extra.hands and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) then
      local box = RainyDays.create_infobox_list(localize('rainydays_desolate_box_name'), contents)
      info_queue[#info_queue + 1] = { set = 'Other', key = box }
    end
    
    local active = #contents >= card.ability.extra.hands
    return {
      vars = {
        card.ability.extra.Xmult,
        card.ability.extra.hands,
        active and localize('rainydays_desolate_prefix_active') or localize('rainydays_desolate_prefix_inactive'),
        active and localize('rainydays_active') or (card.ability.extra.hands - #contents),
        active and localize('rainydays_desolate_postfix_active') or localize('rainydays_desolate_postfix_inactive')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].rd_discarded and G.GAME.hands[value].rd_discarded > 0 then
          count = count + 1
        end
      end
      
      if count >= card.ability.extra.hands then
        return {
          xmult = card.ability.extra.Xmult
        }
      end
    end
    
    if context.pre_discard and not context.blueprint then
      local text = (G.FUNCS.get_poker_hand_info(G.hand.highlighted))
      if G.GAME.hands[text].rd_discarded == 1 then
        local count = 0
        for _, value in ipairs(G.handlist) do
          if G.GAME.hands[value].rd_discarded and G.GAME.hands[value].rd_discarded > 0 then
            count = count + 1
          end
        end
        
        if count == 9 then
          return {
            message = localize('rainydays_activated'),
            colour = G.C.FILTER
          }
        elseif count < 9 then
          return {
            message = localize('rainydays_desolate_message_prefix') .. (card.ability.extra.hands - count) .. localize('rainydays_desolate_message_postfix'),
            colour = G.C.FILTER
          }
        end
      end
    end
  end
}