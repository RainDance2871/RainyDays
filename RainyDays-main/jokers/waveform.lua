SMODS.Joker {
  key = 'waveform',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = GetJokersAtlasTable('waveform'),
  soul_pos = GetJokersAtlasTable('waveform_soul'),
  soul_draw_as_highlight = true,
  soul_draw_as_highlight_shader = 'RainyDays_false_glow',
  
  config = {
    extra = {
      chip_amount = 0,
      chip_increase_base = 1,
      chip_trigger_bonus = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.chip_increase_base,
        card.ability.extra.chip_trigger_bonus,
        card.ability.extra.chip_amount
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.chip_amount > 0 then
      return {
        chips = card.ability.extra.chip_amount
      }
    end
    
    if context.individual and context.cardarea == G.play and not context.blueprint then
      local bonus = card.ability.extra.chip_increase_base + (context.is_repetition and card.ability.extra.chip_trigger_bonus or 0)
      card.ability.extra.chip_amount = card.ability.extra.chip_amount + bonus
      card_eval_status_text(card, 'jokers', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.CHIPS, delay = 0.1 })
    end
  end
}