SMODS.Joker {
  key = 'wanted',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('wanted'),
  config = {
    extra = {
      reward_money = 12
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local string_joker1 = localize{ type = 'name_text', set = 'Joker', key = G.GAME.current_round.RD_headhunter }
    local string_joker2 = ''
    local split = string.find(string_joker1, ' ', 8)
    if split then
      string_joker2 = string.sub(string_joker1, split + 1, -1) .. ' '
      string_joker1 = string.sub(string_joker1, 1, split - 1)
    end
    
    return {
      vars = {
        string_joker1,
        string_joker2,
        card.ability.extra.reward_money
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.selling_self and card.config.center_key == G.GAME.current_round.RD_headhunter then
      return {
        dollars = card.ability.extra.reward_money
      }
    end
    
    if context.selling_card and context.card ~= card and context.card.ability.set == 'Joker' then
      if context.card.config.center_key == G.GAME.current_round.RD_headhunter then
        return {
          dollars = card.ability.extra.reward_money
        }
      end
    end
  end
}

function RainyDays.reset_game_globals_headhunter()
  local jokers = {}
  if G.jokers and G.jokers.cards then
    for i = 1, #G.jokers.cards do
      if not SMODS.is_eternal(G.jokers.cards[i]) then
        jokers[#jokers + 1] = G.jokers.cards[i].config.center_key
      end
    end
  end
  
  if #jokers > 0 then
    G.GAME.current_round.RD_headhunter = pseudorandom_element(jokers, pseudoseed('headhunter' .. G.GAME.round_resets.ante))
  else
    if #G.P_CENTER_POOLS['Joker'] > 0 then
      G.GAME.current_round.RD_headhunter = pseudorandom_element(G.P_CENTER_POOLS['Joker'], pseudoseed('headhunter' .. G.GAME.round_resets.ante)).key
    end
  end
end