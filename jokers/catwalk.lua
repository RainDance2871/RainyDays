SMODS.Joker {
  key = 'catwalk',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('catwalk'),
  soul_pos = RainyDays.GetJokersAtlasTable('catwalk_soul'),
  rd_highlight_shader = 'RainyDays_metallic_highlight',
  rd_skip_soul = true,
  attributes = { 'xmult', 'enhancements' },
  
  config = { 
    extra = { 
      xmult = 1.5
    } 
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and RainyDays.has_enhancement_unique_to_hand(context.other_card, G.play.cards) then
      return {
        xmult = card.ability.extra.xmult
      }
    end
  end
}

function RainyDays.has_enhancement_unique_to_hand(check_card, hand)
  local enhancements = SMODS.get_enhancements(check_card)
  if next(enhancements) then
    for key in pairs(enhancements) do
      
      local function enhancement_is_unique(check_card, hand, enhancement)
        for i = 1, #hand do
          if hand[i] ~= check_card and SMODS.has_enhancement(hand[i], enhancement) then
            return false
          end
        end
        return true
      end
      
      if enhancement_is_unique(check_card, hand, key) then
        return true
      end
    end
  end
end