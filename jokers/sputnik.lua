if RainyDays.config.constellations then SMODS.Joker {
  key = 'sputnik',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('sputnik'),
  
  config = {
    juicing = false,
    played_hands = {},
    active = false    
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
      main_end = #card.ability.played_hands > 0 and main_end_string(string_hands_played, 25) or nil
    }
  end,

  update = function(self, card, dt)
    if G.hand and G.hand.highlighted and #G.hand.highlighted > 0 and not card.ability.juicing then
      local current_hand = (G.FUNCS.get_poker_hand_info(G.hand.highlighted))
      if not list_contains(card.ability.played_hands, current_hand) then
        card.ability.juicing = true
        card:juice_up(0.1, 0.1)
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.3,
          blocking = false,
          blockable = false,
          timer = 'REAL',
          func = function()
            card.ability.juicing = false
            return true
          end
        }))
      end
    end
  end,

  calculate = function(self, card, context)   
    if context.before and not context.blueprint then
      card.ability.active = not list_contains(card.ability.played_hands, context.scoring_name)
      if card.ability.active then
        card.ability.played_hands[#card.ability.played_hands + 1] = context.scoring_name
      end
    end
    
    if card.ability.active and context.joker_main then
      return create_constellation(card)
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.blind.boss then
      card.ability.played_hands = {}
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end
} end