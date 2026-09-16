SMODS.Joker {
  key = 'heirloom',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --only appears if player has at least one bonus or mult card in deck.
    if G.playing_cards then
      for i = 1, #G.playing_cards do
        if SMODS.has_enhancement(G.playing_cards[i], 'm_bonus') or SMODS.has_enhancement(G.playing_cards[i], 'm_mult') then
          return true
        end
      end
    end
    return false
  end,
  pos = RainyDays.GetJokersAtlasTable('heirloom'),
  attributes = { 'enhancements', 'chance', 'modify_card' },
  
  config = {
    extra = {
      numerator_in = 1,
      denominator_in = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
    info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    local numerator_out, denominator_out = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    return {
      vars = {
        numerator_out,
        denominator_out
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff and SMODS.pseudorandom_probability(card, 'heirloom', card.ability.extra.numerator_in, card.ability.extra.denominator_in) then
      local options = {}
      if SMODS.has_enhancement(context.other_card, 'm_bonus') then
        options[#options + 1] = 'm_bonus'
      end
      if SMODS.has_enhancement(context.other_card, 'm_mult') then
        options[#options + 1] = 'm_mult'
      end
      
      if #options > 0 then
        local function find_position(card, hand)
          for i = 1, #hand do
            if hand[i] == card then
              return i
            end
          end
        end
        
        local card_pos = find_position(context.other_card, context.scoring_hand)
        if card_pos and context.scoring_hand[card_pos + 1] then
          local enhancement = SMODS.poll_enhancement({ type_key = 'heirloom', guaranteed = true, options = options })
          return RainyDays.set_ability_multiple(context.blueprint_card or card, context.scoring_hand[card_pos + 1], enhancement, { juice_card = context.other_card })
        end
      end
    end
  end
}