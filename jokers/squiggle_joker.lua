SMODS.Joker {
  key = 'squiggle_joker',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('squiggle_joker'),
  attributes = { 'economy' },
  
  config = {
    extra = {
      money_bonus = 4,
      suit_amount = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.money_bonus,
        card.ability.extra.suit_amount
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      local suits = {}
      for i = 1, #G.hand.cards do
        if SMODS.has_any_suit(G.hand.cards[i]) then
          return
        end
        
        if not SMODS.has_no_suit(G.hand.cards[i]) then
          for key in pairs(SMODS.Suits) do
            if G.hand.cards[i]:is_suit(key, true) then
              suits[key] = true
            end
          end
        end
      end
      
      local count = 0
      for key in pairs(SMODS.Suits) do
        if suits[key] then
          count = count + 1
        end
      end
      
      if count == card.ability.extra.suit_amount then
        return {
          dollars = card.ability.extra.money_bonus
        }
      end
    end
  end
}