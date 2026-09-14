SMODS.Joker {
  key = 'folding_chair',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --only appears if player has at least one steel card in deck.
    if G.playing_cards then
      for i = 1, #G.playing_cards do
        if SMODS.has_enhancement(G.playing_cards[i], 'm_steel') then
          return true
        end
      end
    end
    return false
  end,
  pos = RainyDays.GetJokersAtlasTable('folding_chair'),
  attributes = { 'hand_size', 'enhancements' },
  
  config = {
    extra = {
      hand_size_bonus = 1,
      hand_size_bonus_max = 3,
      hand_size_bonus_current = 0,
      hand_size_bonus_buffer = 0
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.hand_size_bonus_current = math.min(G.GAME.facing_blind and G.GAME.rd_steel_cards_drawn_this_round or 0, card.ability.extra.hand_size_bonus_max)
    card.ability.extra.hand_size_bonus_buffer = 0
    G.hand:change_size(card.ability.extra.hand_size_bonus_current)
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.hand_size_bonus_current)
    card.ability.extra.hand_size_bonus_buffer = 0
    card.ability.extra.hand_size_bonus_current = 0
  end,
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
    return {
      vars = {
        card.ability.extra.hand_size_bonus,
        card.ability.extra.hand_size_bonus_max,
        card.ability.extra.hand_size_bonus_current + card.ability.extra.hand_size_bonus_buffer
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.rd_draw_individual and G.GAME.facing_blind and not context.blueprint and SMODS.has_enhancement(context.other_card, 'm_steel') then
      if card.ability.extra.hand_size_bonus_current + card.ability.extra.hand_size_bonus_buffer < card.ability.extra.hand_size_bonus_max then
        card.ability.extra.hand_size_bonus_buffer = card.ability.extra.hand_size_bonus_buffer + 1
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.FILTER
        }
      end
    end
    
    if context.hand_drawn and not context.blueprint then
      local new_hand_size_bonus = math.min(G.GAME.rd_steel_cards_drawn_this_round, card.ability.extra.hand_size_bonus_max)
      if new_hand_size_bonus > card.ability.extra.hand_size_bonus_current then
        G.hand:change_size(new_hand_size_bonus - card.ability.extra.hand_size_bonus_current)
        card.ability.extra.hand_size_bonus_current = new_hand_size_bonus
        card.ability.extra.hand_size_bonus_buffer = 0
      end
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.hand_size_bonus_current > 0 then
      G.hand:change_size(-card.ability.extra.hand_size_bonus_current)
      card.ability.extra.hand_size_bonus_current = 0
      card.ability.extra.hand_size_bonus_buffer = 0
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end
}