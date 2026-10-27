SMODS.Joker {
  key = 'prehistory',
  atlas = 'Jokers',
  rarity = 3,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  in_pool = function(self, args) --does not appear in packs normally if player does not have a sellable joker
    if G.jokers and G.jokers.cards then
      for i = 1, #G.jokers.cards do
        if not SMODS.is_eternal(G.jokers.cards[i]) then
          return true
        end
      end
    end
    return false
  end,
  pos = RainyDays.GetJokersAtlasTable('prehistory'),
  attributes = { 'xmult', 'scaling', 'joker', 'on_sell' },  
  config = {
    extra = {
      xmult = 1,
      xmult_gain = 0.5,
      old_jokers = {}
    }
  },
  
  loc_vars = function(self, info_queue, card)
    if card.area and card.area == G.jokers then
      local contents = {}
      
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card and RainyDays.list_contains(card.ability.extra.old_jokers, G.jokers.cards[i].ability.rd_joker_id) and not SMODS.is_eternal(G.jokers.cards[i], card) then
          contents[#contents + 1] = RainyDays.GetJokerName(G.jokers.cards[i])
        end
      end      
      
      local box = RainyDays.create_infobox_list(localize('rainydays_prehistory_box_name'), contents)
      info_queue[#info_queue + 1] = { set = 'Other', key = box }
    end
    
    return {
      vars = { 
        card.ability.extra.xmult_gain,
        card.ability.extra.xmult
      }
    }
  end,
  
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      for i = 1, #G.jokers.cards do
        card.ability.extra.old_jokers[#card.ability.extra.old_jokers + 1] = G.jokers.cards[i].ability.rd_joker_id
      end
    end
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.xmult > 1 then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.selling_card and context.card ~= card and context.card.ability.set == 'Joker' and not context.blueprint then
      if RainyDays.list_contains(card.ability.extra.old_jokers, context.card.ability.rd_joker_id) then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'xmult',
          scalar_value = 'xmult_gain',
          scaling_message = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
        })
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.rd_jokers_uniquelist_count or 0) or nil,
      vars = { 
        30
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'modify_jokers' and G.jokers and G.GAME.rd_jokers_uniquelist_count >= 15
  end
}