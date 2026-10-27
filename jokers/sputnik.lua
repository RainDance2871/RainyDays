SMODS.Joker {
  key = 'sputnik',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('sputnik'),
  soul_atlas = 'Indicators',
  soul_pos = RainyDays.GetIndicatorsAtlasTable('hands'),
  rd_indicator_shader = 'RainyDays_indicator',
  attributes = { 'tarot', 'generation', 'hand_type', 'space', 'boss_blind' },
  
  config = {
    extra = {
      dollar = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    if card.area and not card.area.created_on_pause and G.GAME.blind and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) then
      local contents = {}
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played_this_ante and G.GAME.hands[value].played_this_ante > 0 then
          contents[#contents + 1] = localize(value, 'poker_hands')
        end
      end
        
      if #contents > 0 then
        local box = RainyDays.create_infobox_list(localize('rainydays_sputnik_box_name'), contents)
        info_queue[#info_queue + 1] = { set = 'Other', key = box }
      end
    end
    
    return {
      vars = {
        card.ability.extra.dollar
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.before and G.GAME.hands[context.scoring_name].played_this_ante == 1 then
      local ret = RainyDays.create_consumable(context.blueprint_card or card, RainyDays.Constellations and 'CN_Constellation' or 'Tarot')
      if not RainyDays.Constellations and ret then
        ease_dollars(-card.ability.extra.dollar)
        card_eval_status_text(context.blueprint_card or card, 'dollars', -card.ability.extra.dollar)
      end
      return ret
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.blind.boss then
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
}