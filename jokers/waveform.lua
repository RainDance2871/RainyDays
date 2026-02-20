SMODS.Joker {
  key = 'waveform',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('waveform'),
  soul_pos = GetJokersAtlasTable('waveform_soul'),
  soul_draw_as_highlight = true,
  soul_draw_as_highlight_shader = 'RainyDays_false_glow',
  
  config = {
    extra = {
      mult_amount = 5,
      card_gap = 3,
      card_count = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local string, colour
    if card.ability.extra.card_count > 0 then
      string = (card.ability.extra.card_count - 1) .. ' ' .. localize('rainydays_remaining')
      colour = G.C.UI.TEXT_INACTIVE
    else
      string = localize('rainydays_activated')
      colour = G.C.FILTER
    end
    
    local main_end = {
      { n = G.UIT.T, config = { text = '(', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }},
      { n = G.UIT.T, config = { text = string, colour = colour, scale = 0.32 }},
      { n = G.UIT.T, config = { text = ')', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }},
    }
    
    return {
      main_end = main_end,
      vars = {
        card.ability.extra.mult_amount
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.is_repetition then
      return {
        mult = card.ability.extra.mult_amount
      }
    end
    
    if context.repetition and context.cardarea == G.play then
      card.ability.extra.card_count = card.ability.extra.card_count - 1
      if card.ability.extra.card_count <= 0 then
        card.ability.extra.card_count = card.ability.extra.card_gap
        return {
          repetitions = 1
        }
      end
    end
  end
}