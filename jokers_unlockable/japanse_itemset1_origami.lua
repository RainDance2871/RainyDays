SMODS.Joker {
  key = 'origami',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('origami'),
  attributes = { 'economy', 'suit', 'diamonds' }, 
  
  config = {
    extra = {
      dollars = 1,
      cards = 3,
      suit = 'Diamonds'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local amount = 0
    if G.deck and G.deck.cards then
      for i = 1, #G.deck.cards do
        if G.deck.cards[i]:is_suit(card.ability.extra.suit, true) then
          amount = amount + 1
        end
      end
    else
      amount = 13
    end
    
    return {
      vars = {
        colours = {
          G.C.SUITS[card.ability.extra.suit]
        },
        card.ability.extra.dollars,
        card.ability.extra.cards,
        localize(card.ability.extra.suit, 'suits_singular'),
        card.ability.extra.payout or card.ability.extra.dollars * math.floor(amount / card.ability.extra.cards)
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
      local amount = 0
      for i = 1, #G.deck.cards do
        if G.deck.cards[i]:is_suit(card.ability.extra.suit, true) then
          amount = amount + 1
        end
      end
      
      card.ability.extra.payout = math.floor(amount / card.ability.extra.cards)
    end
    
    if context.rd_after_payout and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        blocking = false,
        trigger = 'after',
        delay = 0.1,
        func = function()
          card.ability.extra.payout = nil
          return true
        end
      }))
    end
  end,
  
  calc_dollar_bonus = function(self, card)
    if card.ability.extra.payout and card.ability.extra.payout > 0 then
      return card.ability.extra.payout
    end
	end,
  
  locked_loc_vars = function(self, info_queue, card)
    local suit = 'Diamonds'
    local count = 0
    if G.playing_cards then
      for _, playing_card in ipairs(G.playing_cards) do
        if playing_card:is_suit(suit) then
          count = count + 1
        end
      end
    else
      count = 13
    end
    
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(count) or nil,
      vars = {
        colours = {
          G.C.SUITS[suit]
        },
        7,
        localize(suit, 'suits_singular')
      }
    }
  end,  
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_deck' and G.GAME and G.GAME.RD_init_complete then
      local count = 0      
      for _, playing_card in ipairs(G.playing_cards or {}) do
        if playing_card:is_suit('Diamonds', true) then
          count = count + 1
          if count > 7 then
            return false
          end
        else
        end
      end
      return true
    end
  end
}