SMODS.Joker {
  key = 'blood_moon',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('blood_moon'),
  attributes = { 'xmult', 'destroy_card' },
  
  config = {
    extra = {
      xmult = 3,
      cards = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult,
        card.ability.extra.cards
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.destroy_card and context.cardarea == G.hand and not context.blueprint then
      if not card.ability.extra.destroyed then
        card.ability.extra.destroyed = {}
        
        local cards = {}
        for i = 1, #G.hand.cards do
          if not G.hand.cards[i].getting_sliced then
            cards[#cards + 1] = G.hand.cards[i]
          end
        end
        
        for i = 1, 2 do 
          if #cards > 0 then
            local picked = pseudorandom_element(cards, pseudoseed('blood_moon' .. G.GAME.round_resets.ante))
            card.ability.extra.destroyed[#card.ability.extra.destroyed + 1] = picked
            picked.getting_sliced = true
            RainyDays.remove_by_value(cards, picked)
          end
        end
        
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          delay = 0,
          func = function()
            card.ability.extra.destroyed = nil
            return true
          end
        }))
      end
      
      if RainyDays.list_contains(card.ability.extra.destroyed, context.destroy_card) then
        return {
          remove = true,
          message_card = card,
          message = (context.destroy_card == card.ability.extra.destroyed[#card.ability.extra.destroyed]) and localize('rainydays_destroyed') or nil,
          colour = G.C.FILTER
        }
      end
    end
  end
}