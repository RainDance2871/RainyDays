SMODS.Joker {
  key = 'grapes',
  atlas = 'Jokers',
  pools = { Food = true },
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('grapes'),
  attributes = { 'mult', 'food' },
  
  config = {
    extra = {
      display_card_amount = 30,
      display_card_amount_start = 30,
      card_amount = 30,
      mult = 4
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.card_amount,
        card.ability.extra.mult
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if not context.blueprint and not context.rd_is_repetition then
        card.ability.extra.card_amount = card.ability.extra.card_amount - 1
         G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          delay = 0,
          func = function()
            card.ability.extra.display_card_amount = card.ability.extra.display_card_amount - 1
            return true
          end
        }))
      end
      
      if card.ability.extra.card_amount > 0 or (card.ability.extra.card_amount == 0 and context.rd_is_repetition) then
        return {
          mult = card.ability.extra.mult
        }
      end
    end
    
    if context.after and card.ability.extra.card_amount <= 0 and not context.blueprint then
      SMODS.destroy_cards(card, { pinch_anim = true })
      G.E_MANAGER:add_event(Event({
        func = function()
          card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_eaten_ex'), colour = G.C.RED })
          return true
        end
      }))
    end
  end
}