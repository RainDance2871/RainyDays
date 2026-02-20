if RainyDays.config.constellations then SMODS.Joker {
  key = 'windowsill',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('windowsill'),
  
  config = {
    extra = {
      per_drawn = 7,
      drawn_counter = 0,
      create_card = false
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.per_drawn,
        card.ability.extra.per_drawn - card.ability.extra.drawn_counter
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.hand_drawn then
      local count = 0
      for i = 1, #context.hand_drawn do
        if context.hand_drawn[i]:is_suit('Diamonds') then
          count = count + 1
        end
      end
      
      if count <= 0 then 
        return
      end
      
      if context.blueprint then
        if GetJokerPosition(context.blueprint_card) < GetJokerPosition(card) then
          card.ability.extra.create_card = math.floor((card.ability.extra.drawn_counter + count) / card.ability.extra.per_drawn)
        end
      else
        card.ability.extra.drawn_counter = card.ability.extra.drawn_counter + count
        card.ability.extra.create_card = math.floor(card.ability.extra.drawn_counter / card.ability.extra.per_drawn)
        for i = 1, card.ability.extra.create_card do
          card.ability.extra.drawn_counter = card.ability.extra.drawn_counter - card.ability.extra.per_drawn
        end
      end
      
      if card.ability.extra.create_card > 0 then
        return create_constellation(card, card.ability.extra.create_card)
      end
    end
  end
} end