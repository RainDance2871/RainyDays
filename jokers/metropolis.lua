SMODS.Joker {
  key = 'metropolis',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true, 
  pos = RainyDays.GetJokersAtlasTable('metropolis'),
  attributes = { 'xmult', 'hand_type' },  
  config = {
    extra = {
      poker_hand = 'Full House',
      xmult = 3,
      amount_hands = 2,
      activations = 0
    }
  },
    
  loc_vars = function(self, info_queue, card)
    local active = card.ability.extra.activations > 0
    local prefix = active and localize('rainydays_metropolis_prefix_active') or localize('rainydays_metropolis_prefix_inactive')
    local active_text = active and localize('rainydays_active') or localize('rainydays_inactive')
    
    if string.len(prefix) <= 0 then
      active_text = string.upper(string.sub(active_text, 1, 1)) .. string.sub(active_text, 2)
    end
    
    return {      
      vars = {
        colours = {
          active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        localize(card.ability.extra.poker_hand, 'poker_hands'),
        card.ability.extra.xmult,
        card.ability.extra.amount_hands,
        prefix,
        active_text,
        active and localize('rainydays_metropolis_infix_active') or localize('rainydays_metropolis_infix_inactive'),
        card.ability.extra.activations > 1 and card.ability.extra.activations or '',
        active and (card.ability.extra.activations == 1 and localize('rainydays_metropolis_postfix_active') or localize('rainydays_metropolis_postfix_active_plural')) or localize('rainydays_metropolis_postfix_inactive')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      if next(context.poker_hands[card.ability.extra.poker_hand]) then
        card.ability.extra.hand_played = true
      end
      
      if card.ability.extra.activations > 0 then
        return {
          xmult = card.ability.extra.xmult
        }
      end
    end
    
    if context.after and not context.blueprint then
      if card.ability.extra.hand_played then
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          delay = 0,
          func = function()
            card.ability.extra.hand_played = nil
            card.ability.extra.activations = card.ability.extra.amount_hands
            return true
          end
        }))
        return {
          message = localize('rainydays_activated'),
          colour = G.C.FILTER
        }
      elseif card.ability.extra.activations > 0 then
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          delay = 0,
          func = function()
            card.ability.extra.activations = card.ability.extra.activations - 1
            return true
          end
        }))
        return {
          message = card.ability.extra.activations == 1 and localize('k_reset') or localize('rainydays_metropolis_message_prefix') .. (card.ability.extra.activations -1) .. localize('rainydays_metropolis_message_postfix'),
          colour = G.C.RED
        }
      end
    end
  end
}