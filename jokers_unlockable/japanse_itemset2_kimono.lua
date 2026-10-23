SMODS.Joker {
  key = 'kimono',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('kimono'),
  attributes = { 'mult', 'suit', 'hearts', 'scaling' }, 
  
  config = {
    extra = {
      mult = 0,
      mult_gain = 1,
      cards = 3,
      suit = 'Hearts'
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
        card.ability.extra.mult_gain,
        card.ability.extra.cards,
        localize(card.ability.extra.suit, 'suits_singular'),
        card.ability.extra.mult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
    
    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
      local amount = 0
      for i = 1, #G.deck.cards do
        if G.deck.cards[i]:is_suit(card.ability.extra.suit, true) then
          amount = amount + 1
        end
      end
      
      local mod = math.floor(amount / card.ability.extra.cards)
      if mod > 0 then
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'mult',
          scalar_value = 'mult_gain',
          operation = function(ref_table, ref_value, initial, modifier)
            ref_table[ref_value] = initial + modifier * mod
          end,
          scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
        })
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local suit = 'Hearts'
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
        if playing_card:is_suit('Hearts', true) then
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