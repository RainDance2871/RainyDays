SMODS.Joker {
  key = 'prehistory',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
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
        if G.jokers.cards[i] ~= card and RainyDays.list_contains(card.ability.extra.old_jokers, G.jokers.cards[i].ability.rd_joker_id) and not SMODS.is_eternal(G.jokers.cards[i]) then
          local name = localize{ type = 'name_text', set = 'Joker', key = G.jokers.cards[i].config.center_key }
          
          local function amount_of_copies(card)
            local amount = 0
            local nr
            for j = 1, #G.jokers.cards do
              if G.jokers.cards[j].config.center.key == card.config.center.key then
                amount = amount + 1
                if G.jokers.cards[j] == card then
                  nr = amount
                end
              end
            end
            return amount, nr
          end
          
          local amount, nr = amount_of_copies(G.jokers.cards[i])
          if amount > 1 and nr then
            name = name .. localize('rainydays_infobox_nr_sign_prefix') .. nr .. localize('rainydays_infobox_nr_sign_postfix')
          end
          
          contents[#contents + 1] = name
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
        15
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'modify_jokers' and G.jokers and G.GAME.rd_jokers_uniquelist_count >= 15
  end
}