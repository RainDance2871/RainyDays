SMODS.Joker {
  key = 'windowsill',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('windowsill'),
  
  config = {
    extra = {
      per_drawn = 7,
      drawn_counter = 0,
      planet_cards = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.per_drawn,
        card.ability.extra.per_drawn - card.ability.extra.drawn_counter,
        card.ability.extra.planet_cards
      }
    }
  end,
  
  calculate = function(self, card, context)
     if context.rd_draw_individual and G.GAME.facing_blind and context.other_card:is_suit('Diamonds') and not context.other_card.debuff then
       local create_card
       if not context.blueprint then
        card.ability.extra.drawn_counter = card.ability.extra.drawn_counter + 1
        if card.ability.extra.drawn_counter >= card.ability.extra.per_drawn then
          card.ability.extra.drawn_counter = card.ability.extra.drawn_counter - card.ability.extra.per_drawn
          card.ability.extra.create_card = true
          create_card = true
        else
          card.ability.extra.create_card = nil
        end
      else
        if RainyDays.GetJokerPosition(context.blueprint_card) < RainyDays.GetJokerPosition(card) then
          create_card = (card.ability.extra.drawn_counter + 1 >= card.ability.extra.per_drawn)
        else
          create_card = card.ability.extra.create_card
        end
      end
      
      if create_card then
        if RainyDays.Constellations then
          return RainyDays.create_consumable(context.blueprint_card or card, 'CN_Constellation')
        else
          return RainyDays.create_consumable(context.blueprint_card or card, 'Planet', card.ability.extra.planet_cards)
        end
      end
    end
  end
}