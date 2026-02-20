SMODS.Joker {
  key = 'balance',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('balance'),
  
  config = {
    played_hands = {},
    extra = {
      xmult = 0,
      plus_xmult = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local string_hands_played = '(' .. localize('rainydays_hands_played') .. ': '
    local count = 0
    for _, value in ipairs(G.handlist) do
      if list_contains(card.ability.played_hands, value) then
        count = count + 1
        string_hands_played = string_hands_played .. localize(value, 'poker_hands') .. (count < #card.ability.played_hands and ', ' or ')')
      end
    end

    return {
      main_end = #card.ability.played_hands > 0 and main_end_string(string_hands_played, 23) or nil,
      vars = {
        card.ability.extra.plus_xmult,
        card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)    
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.before and not context.blueprint then
      if not list_contains(card.ability.played_hands, context.scoring_name) then
        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.plus_xmult
        card.ability.played_hands[#card.ability.played_hands + 1] = context.scoring_name
      end
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      card.ability.extra.xmult = 0
      card.ability.played_hands = {}
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { vars = { 9 }}
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'hand' then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played > 0 then
          count = count + 1
          if count >= 9 then
            return true
          end
        end
      end
    return false
    end
  end
}