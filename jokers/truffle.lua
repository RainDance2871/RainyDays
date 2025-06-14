SMODS.Joker {
  key = 'truffle',
  name = 'Truffle',
  atlas = 'RainyDays',
  pools = { Food = true },
  rarity = 3,
  cost = 6,
  unlocked = true, 
  discovered = true,
  blueprint_compat = false,
  eternal_compat = false,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('truffle'),
  config = {
    growth_money = 5,
    bonus_threshold = 10,
    jokers = 3,
    jokers_total = 3
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.growth_money,
        card.ability.bonus_threshold,
        card.ability.jokers
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint then
      if context.end_of_round and not context.repetition and not context.individual then
        --chose a random joker
        local jokers = {}
        for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].ability.set == 'Joker' and G.jokers.cards[i] ~= card then
            jokers[#jokers + 1] = G.jokers.cards[i]
          end
        end
        
        if #jokers > 0 then
          local joker = pseudorandom_element(jokers, pseudoseed('Truffle' .. G.GAME.round_resets.ante))
          
          --increase that jokers sell value
          card:juice_up(0.3, 0.4)
          joker.ability.extra_value = (joker.ability.extra_value or 0) + card.ability.growth_money
          joker:set_cost()
          card_eval_status_text(joker, 'extra', nil, nil, nil, {
            message = localize('k_val_up'),
            colour = G.C.MONEY
          })
        end
      end
      
      --when a joker is sold
      if context.selling_card and context.card.ability.set == 'Joker' and context.card.sell_cost >= card.ability.bonus_threshold then
        card.ability.jokers = card.ability.jokers - 1;
        local space_available = G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer) + 1
        if space_available >= 1 then
          play_sound('timpani')
          local new_joker = SMODS.create_card({ set = 'Joker', rarity = 'Rare', key_append = 'Truffle' })
          new_joker:add_to_deck()
          G.jokers:emplace(new_joker)
        else
          card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_no_room_ex') })
        end
        
        if card.ability.jokers <= 0 then
          G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.3,
              blockable = false,
              func = function()
                card:remove()
              end
            }))
            return true
            end
          }))
          return {
            message = localize('k_eaten_ex'),
            colour = G.C.RED
          }
        end
      end
    end
  end
}