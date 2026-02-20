SMODS.Joker {
  key = 'lightning',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --only appears if player has at least one mult card in deck.
    for i = 1, #G.playing_cards do
      if SMODS.has_enhancement(G.playing_cards[i], 'm_mult') then
        return true
      end
    end
    return false
  end,
  pos = GetJokersAtlasTable('lightning'),
  
  config = {
    extra = {
      xmult = 1.5
    }
  },

  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    return {
      vars = {
        card.ability.extra.xmult,
        G.P_CENTERS.m_mult.config.mult
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.individual and context.cardarea == G.play then
      if SMODS.has_enhancement(context.other_card, 'm_mult') then
        return {
          xmult = card.ability.extra.xmult
        }
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { vars = { 5, localize { type = 'name_text', key = 'm_wild', set = 'Enhanced' } } }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_deck' and G.playing_cards then
      local count = 0
      for i = 1, #G.playing_cards do
        if SMODS.has_enhancement(G.playing_cards[i], 'm_mult') then
          count = count + 1 
          if count >= 5 then
            return true
          end
        end
      end
    return false
    end
  end
}

local get_chip_mult_ref = Card.get_chip_mult
function Card.get_chip_mult(self)
  local mult_amount = get_chip_mult_ref(self)
  if SMODS.has_enhancement(self, 'm_mult') and next(SMODS.find_card('j_RainyDays_lightning')) then
    mult_amount = mult_amount - G.P_CENTERS.m_mult.config.mult
  end
  return mult_amount
end