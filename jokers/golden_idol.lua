SMODS.Joker {
  key = 'golden_idol',
  atlas = 'Jokers',
  rarity = 3,
  cost = 7,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  in_pool = function(self, args) --only appears if player has at least one gold card in deck.
    for i = 1, #G.playing_cards do
      if SMODS.has_enhancement(G.playing_cards[i], 'm_gold') then
        return true
      end
    end
    return false
  end,
  pos = GetJokersAtlasTable('golden_idol'),
  
  config = {
    extra = {
      x_mult = 1,
      plus_xmult = 0.1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
    return {
      vars = {
        card.ability.extra.plus_xmult,
        card.ability.extra.x_mult
      }
    }
  end,
  
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main and card.ability.extra.x_mult > 1 then
      return {
        xmult = card.ability.extra.x_mult
      }
    end
    
     if not context.blueprint and context.hand_drawn then
      local count = 0
      for i = 1, #context.hand_drawn do
        if SMODS.has_enhancement(context.hand_drawn[i], 'm_gold') then
          count = count + 1
        end
      end
      
      if count > 0 then
        card.ability.extra.x_mult = card.ability.extra.x_mult + count * card.ability.extra.plus_xmult
        card_eval_status_text(card, 'jokers', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.MULT })
      end
    end
  end
}