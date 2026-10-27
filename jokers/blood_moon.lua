SMODS.Joker {
  key = 'blood_moon',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('blood_moon'),
  attributes = { 'xmult', 'destroy_card' },
  config = {
    extra = {
      rank = '4',
      xmult = 3,
      hands = 4,
      activations = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local active = card.ability.extra.activations > 0
    return {
      key = active and 'j_RainyDays_blood_moon_active' or 'j_RainyDays_blood_moon',
      vars = {
        card.ability.extra.rank,
        card.ability.extra.xmult,
        card.ability.extra.hands,
        card.ability.extra.activations > 1 and card.ability.extra.activations or "",
        string.lower((card.ability.extra.activations == 1) and localize('rainydays_hand') or localize('rainydays_hands'))
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.activations > 0 then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.destroy_card and not context.blueprint and #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and RainyDays.balatro_ranks_to_id[card.ability.extra.rank] == context.full_hand[1]:get_id() then
      card.ability.extra.activated = true
      return {
        remove = true
      }
    end
    
    if context.after and not context.blueprint then
      if card.ability.extra.activated then
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          delay = 0,
          func = function()
            card.ability.extra.activated = nil
            card.ability.extra.activations = card.ability.extra.hands
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
          message = card.ability.extra.activations == 1 and localize('k_reset') or localize('rainydays_charges_message_prefix') .. (card.ability.extra.activations - 1) .. localize('rainydays_charges_message_postfix'),
          colour = G.C.RED
        }
      end
    end
  end
}