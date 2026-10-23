if RainyDays.config.feathers then SMODS.Joker {
  key = 'feather_precious',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 1,
  cost = 5,
  unlocked = true, 
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --does not appear in packs normally if player already has a feather
    return not RainyDays.FeatherOwned()
  end,
  pos = RainyDays.GetJokersAtlasTable('feather_precious'),
  attributes = { 'economy', 'sell_value' },
  
  config = {
    extra = {
      sell_value = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.sell_value
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      for _, other_card in ipairs(G.jokers.cards) do
        if RainyDays.IsInPool(other_card, 'Feather') then
          other_card.ability.extra_value = (other_card.ability.extra_value or 0) + card.ability.extra.sell_value
          other_card:set_cost()
        end
      end
      
      return {
        func = function()
          for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card and RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
              G.jokers.cards[i]:juice_up()
            end
          end
        end,
        message_card = card,
        message = localize('k_val_up'),
        colour = G.C.MONEY
      }
    end
  end
} end