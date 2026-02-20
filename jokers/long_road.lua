SMODS.Joker {
  key = 'long_road',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('long_road'), 
  config = {
    extra = {
      discard_bonus = 2,
      hand_border = 'Straight'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.discard_bonus,
        localize(card.ability.extra.hand_border, 'poker_hands')
      }
    }
  end,

  calculate = function(self, card, context)
    local function poker_hand_played()
      for _, poker_hand in ipairs(G.handlist) do
        if next(context.poker_hands[poker_hand]) then
          return true
        elseif poker_hand == card.ability.extra.hand_border then
          return false
        end
      end
    end
      
    if context.joker_main and poker_hand_played() then
      G.E_MANAGER:add_event(Event({
        func = function()
          ease_discard(card.ability.extra.discard_bonus)
          local string = '+' .. card.ability.extra.discard_bonus .. ' ' .. localize('k_hud_discards')
          card_eval_status_text(context.blueprint_card or card, 'jokers', nil, nil, nil, { message = string, colour = G.C.RED })
          return true
        end
      }))
    end
  end
}