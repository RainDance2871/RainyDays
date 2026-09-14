SMODS.Joker {
  key = 'prairie',
  atlas = 'Jokers',
  rarity = 1,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('prairie'),
  attributes = { 'mult', 'scaling', 'hand_type' },
  
  config = {
    extra = {
      mult_gain = 1,
      current_mult = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)    
    return {
      vars = {
        card.ability.extra.mult_gain,
        localize(G.GAME.current_round.RD_prairie_poker_hand, 'poker_hands'),
        card.ability.extra.current_mult
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.joker_main then
      return {
        mult = card.ability.extra.current_mult
      }
    end
    
    if context.before and context.scoring_name ~= G.GAME.current_round.RD_prairie_poker_hand and not context.blueprint then
      SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = 'current_mult',
        scalar_value = 'mult_gain',
        scaling_message = { 
          message = localize('k_upgrade_ex'), 
          colour = G.C.MULT
        }
      })
    end
  end
}

function RainyDays.reset_game_globals_prairie()
  local hand_most_played = nil
  for _, value in ipairs(G.handlist) do
    if SMODS.is_poker_hand_visible(value) and (not hand_most_played or G.GAME.hands[value].played >= G.GAME.hands[hand_most_played].played) then
      hand_most_played = value
    end
  end
  G.GAME.current_round.RD_prairie_poker_hand = hand_most_played
end