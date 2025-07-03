SMODS.Joker {
  key = 'heirloom',
  name = 'Heirloom',
  atlas = 'RainyDays',
  rarity = 2,
  cost = 5,
  unlocked = true, 
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --only appears if player has at least one bonus or mult card in deck.
    for i = 1, #G.playing_cards do
      if SMODS.has_enhancement(G.playing_cards[i], 'm_bonus') or SMODS.has_enhancement(G.playing_cards[i], 'm_mult') then
        return true
      end
    end
    return false
  end,
  pos = GetRainyDaysAtlasTable('heirloom'),  
  config = {
    chip_bonus = 15,
    mult_bonus = 2
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    return {
      vars = { 
        card.ability.chip_bonus,
        card.ability.mult_bonus
      }
    }
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint and context.individual and context.cardarea == G.play then
      if SMODS.has_enhancement(context.other_card, 'm_bonus') or SMODS.has_enhancement(context.other_card, 'm_mult') then
        if not context.other_card.debuff and check_card_in_hand(context.other_card, context.scoring_hand) then
          --find position of this card 
          local card_position = nil
          for i = 1, #context.scoring_hand do
            if context.scoring_hand[i] == context.other_card then
              card_position = i
              break
            end
          end
          
          --if the next card exists, we increase its chip and mult amount.
          if card_position and context.scoring_hand[card_position + 1] then
            context.scoring_hand[card_position + 1].ability.perma_bonus = (context.scoring_hand[card_position + 1].ability.perma_bonus or 0) + card.ability.chip_bonus
            context.scoring_hand[card_position + 1].ability.perma_mult = (context.scoring_hand[card_position + 1].ability.perma_mult or 0) + card.ability.mult_bonus
            return {
              message_card = context.scoring_hand[card_position + 1],
              message = localize('k_upgrade_ex'),
              colour = G.C.MULT
            }
          end
        end
      end
    end
  end
}