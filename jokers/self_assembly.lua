SMODS.Joker {
  key = 'self_assembly',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('self_assembly'),
  attributes = { 'scaling', 'mult', 'enhancements' },
  config = {
    extra = {
      mult = 0,
      mult_gain = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_gain,
        card.ability.extra.mult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
    
    if context.rd_setting_ability_multiple and not context.blueprint then
      local count = 0
      for i = 1, #context.cards do
        if context.cards[i].new ~= 'c_base' and not context.cards[i].unchanged then
          count = count + 1
        end
      end
      
      if count > 0 then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'mult',
          scalar_value = 'mult_gain',
          operation = function(ref_table, ref_value, initial, modifier)
            ref_table[ref_value] = initial + modifier * count
          end,
          scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
        })
      end
    end
    
    if context.setting_ability and not RainyDays.setting_ability_multiple and context.other_card.ability.set == 'Enhanced' and not context.blueprint and not context.unchanged then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'mult',
        scalar_value = 'mult_gain',
        scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
      })
    end
  end
}