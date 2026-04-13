SMODS.Joker {
  key = 'long_road',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('long_road'), 
  config = {
    extra = {
      discard_bonus = 2,
      hand1 = 'Flush',
      hand2 = 'Straight'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.discard_bonus,
        localize(card.ability.extra.hand1, 'poker_hands'),
        localize(card.ability.extra.hand2, 'poker_hands')
      }
    }
  end,

  calculate = function(self, card, context)
    if context.joker_main and (next(context.poker_hands[card.ability.extra.hand1]) or next(context.poker_hands[card.ability.extra.hand2])) then
      G.E_MANAGER:add_event(Event({
        func = function()
          ease_discard(card.ability.extra.discard_bonus)
          local string = localize('rainydays_plus') .. card.ability.extra.discard_bonus .. ' ' .. localize('k_hud_discards')
          card_eval_status_text(context.blueprint_card or card, 'jokers', nil, nil, nil, { message = string, colour = G.C.RED })
          return true
        end
      }))
    end
  end
}