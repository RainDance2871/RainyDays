SMODS.Joker {
  key = 'wanted',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('wanted'),
  attributes = { 'economy', 'on_sell', 'joker' },  
  config = {
    extra = {
      reward_money = 12
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local target_name = localize{ type = 'name_text', set = 'Joker', key = G.GAME.current_round.RD_wanted_name_key }
    return {
      key = string.len(target_name) > 9 and 'j_RainyDays_wanted_long' or 'j_RainyDays_wanted',
      vars = {
        target_name,
        card.ability.extra.reward_money
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.selling_self and card.config.center_key == G.GAME.current_round.RD_wanted_name_key then
      return {
        dollars = card.ability.extra.reward_money
      }
    end
    
    if context.selling_card and context.card ~= card and context.card.ability.set == 'Joker' then
      if localize{ type = 'name_text', set = 'Joker', key = context.card.config.center_key } == localize{ type = 'name_text', set = 'Joker', key = G.GAME.current_round.RD_wanted_name_key } then
        return {
          dollars = card.ability.extra.reward_money
        }
      end
    end
  end
}

function RainyDays.reset_game_globals_wanted()
  local jokers = {}
  if G.jokers and G.jokers.cards then
    for i = 1, #G.jokers.cards do
      if not SMODS.is_eternal(G.jokers.cards[i]) then
        jokers[#jokers + 1] = G.jokers.cards[i]
      end
    end
  end
  
  if #jokers > 0 then
    local joker_picked = pseudorandom_element(jokers, pseudoseed('wanted' .. G.GAME.round_resets.ante))
    G.GAME.current_round.RD_wanted_name_key = RainyDays.GetJokerNameKey(joker_picked)
  elseif #G.P_CENTER_POOLS['Joker'] > 0 then
    G.GAME.current_round.RD_wanted_name_key = pseudorandom_element(G.P_CENTER_POOLS['Joker'], pseudoseed('wanted' .. G.GAME.round_resets.ante)).key
  end
end