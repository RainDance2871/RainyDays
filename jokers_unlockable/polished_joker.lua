SMODS.Joker {
  key = 'polished_joker',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  rd_polished = true,
  attributes = { 'scaling', 'xmult', 'enhancements' },
  config = {
    extra = {
      xmult = 1,
      xmult_gain = 0.3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult_gain,
        card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.rd_setting_ability_multiple and not context.blueprint then
      local count = 0
      for i = 1, #context.cards do
        if context.cards[i].old ~= 'c_base' and context.cards[i].new ~= 'c_base' and not context.cards[i].unchanged then
          count = count + 1
        end
      end
      
      if count > 0 then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'xmult',
          scalar_value = 'xmult_gain',
          operation = function(ref_table, ref_value, initial, modifier)
            ref_table[ref_value] = initial + modifier * count
          end,
          scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
        })
      end
    end
    
    if context.setting_ability and not RainyDays.setting_ability_multiple and context.other_card.ability.set == 'Enhanced' and not context.blueprint and context.old ~= context.new and context.old ~= 'c_base' then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'xmult',
        scalar_value = 'xmult_gain',
        scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
      })
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME.rd_enhancements_override_count or 0) or nil,
      vars = { 
        5
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'rd_enhancements_given' and G.GAME.rd_enhancements_override_count and G.GAME.rd_enhancements_override_count >= 5
  end
}