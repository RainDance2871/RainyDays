SMODS.Joker {
  key = 'ceremonial_bowl',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('ceremonial_bowl'), 
  attributes = { 'economy', 'joker', 'position', 'destroy_card' }, 
  config = {
    extra = {
      dollars = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local amount = 0
    local pos = RainyDays.GetJokerPosition(card)
    if pos then
      amount = #G.jokers.cards - pos
    end
    
    return {
      vars = {
        card.ability.extra.dollars,
        amount * card.ability.extra.dollars
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.setting_blind then
      local self_card = context.blueprint_card or card
      local pos = RainyDays.GetJokerPosition(self_card)
      
      if pos then
        local amount = #G.jokers.cards - pos
        if amount > 0 then
          ease_dollars(amount * card.ability.extra.dollars)
          card_eval_status_text(self_card, 'dollars', amount * card.ability.extra.dollars)
          
          local destructable_jokers = {}
          for i = pos + 1, #G.jokers.cards do
            if not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then
              destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
            end
          end
          
          local joker_to_destroy = pseudorandom_element(destructable_jokers, 'altar')
          if joker_to_destroy then
            joker_to_destroy.getting_sliced = true
            G.E_MANAGER:add_event(Event({
              func = function()
                self_card:juice_up(0.8, 0.8)
                joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                return true
              end
            }))
          end
        end
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME.rd_jokers_destroyed or 0) or nil,
      vars = { 
        10
      }
    }
  end,  
  
  check_for_unlock = function(self, args)
    return args.type == 'rd_joker_destroyed' and G.GAME.rd_jokers_destroyed and G.GAME.rd_jokers_destroyed >= 10
  end
}