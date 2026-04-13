SMODS.Joker {
  key = 'overflow',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('overflow'),
  config = {
    extra = {
      hand_size_bonus = 1,
      rank1 = '10',
      rank2 = '9'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.hand_size_bonus,
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks')
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.discard and context.other_card == context.full_hand[#context.full_hand] then
      for _, discarded_card in ipairs(context.full_hand) do
        if not discarded_card.debuff then
          local id = discarded_card:get_id()
          if (RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] == id or RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] == id) then
            G.hand:change_size(card.ability.extra.hand_size_bonus)
            G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + card.ability.extra.hand_size_bonus
            return {
              message_card = card,
              message = localize('rainydays_plus') .. card.ability.extra.hand_size_bonus .. ' ' .. localize('rainydays_hand_size'),
              colour = G.C.FILTER
            }
          end
        end
      end
    end
  end
}