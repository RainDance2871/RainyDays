SMODS.Joker {
  key = 'instructional',
  atlas = 'Jokers',
  rarity = 3,
  cost = 7,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('instructional'),
  attributes = { 'chips' },
  
  config = {
    extra = {
      chips = 50,
      old_jokers = {}
    }
  },
  
  loc_vars = function(self, info_queue, card)
    if card.area and card.area == G.jokers then
      local contents = {}
      
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card and not RainyDays.list_contains(card.ability.extra.old_jokers, G.jokers.cards[i].ability.rd_joker_id) then
          contents[#contents + 1] = RainyDays.GetJokerName(G.jokers.cards[i])
        end
      end      
      
      local box = RainyDays.create_infobox_list(localize('rainydays_instructional_box_name'), contents)
      info_queue[#info_queue + 1] = { set = 'Other', key = box }
    end
    
    return {
      vars = { 
        card.ability.extra.chips
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
    if context.other_joker and context.other_joker ~= card and not RainyDays.list_contains(card.ability.extra.old_jokers, context.other_joker.ability.rd_joker_id) then
      return {
        message_card = context.other_joker,
        chips = card.ability.extra.chips
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      vars = { 
        5
      }
    }
  end,  
  
  check_for_unlock = function(self, args)
    return args.type == 'ante_up' and args.ante >= 5 and ((not G.GAME.rd_jokers_sold) or G.GAME.rd_jokers_sold <= 0)
  end
}