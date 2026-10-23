SMODS.Joker {
  key = 'receipt',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('receipt'),
  attributes = { 'mult', 'scaling', 'shop' },
  
  config = {
    extra = {
      mult_gain = 6,
      current_mult = 0,
      money_border = 10,
      money_spent = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)    
    return {
      key = (card.area and not card.area == G.jokers and G.shop and not G.shop.REMOVED and not card.ability.extra.activated) and 'j_RainyDays_receipt_in_shop' or 'j_RainyDays_receipt',
      vars = {
        card.ability.extra.mult_gain,
        card.ability.extra.money_border,
        card.ability.extra.current_mult,
        card.ability.extra.money_border - card.ability.extra.money_spent
      }
    }
  end,
  
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff and G.shop and not G.shop.REMOVED then
      card.ability.extra.money_spent = card.ability.extra.money_spent + (G.GAME.rd_money_spent_this_shop or 0)
      if card.ability.extra.money_spent >= card.ability.extra.money_border and not card.ability.extra.activated then
        card.ability.extra.activated = true
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'current_mult',
          scalar_value = 'mult_gain',
          scaling_message = { 
            message = localize('k_upgrade_ex'), 
            colour = G.C.MULT
          }
        })
      end
    end
  end,
  
  calculate = function(self, card, context)    
    if context.joker_main then
      return {
        mult = card.ability.extra.current_mult
      }
    end
    
    if context.money_altered and G.shop and not G.shop.REMOVED and context.amount < 0 and not card.ability.extra.activated and not context.blueprint then
      card.ability.extra.money_spent = math.min(card.ability.extra.money_spent - context.amount, card.ability.extra.money_border)
      if card.ability.extra.money_spent >= card.ability.extra.money_border then
        card.ability.extra.activated = true
        SMODS.scale_card(card, {
          ref_table = card.ability.extra,
          ref_value = 'current_mult',
          scalar_value = 'mult_gain',
          scaling_message = { 
            message = localize('k_upgrade_ex'), 
            colour = G.C.MULT
          }
        })
      else
        return {
          message = localize('rainydays_money_message_prefix') .. (card.ability.extra.money_border - card.ability.extra.money_spent) .. localize('rainydays_money_message_postfix'),
          colour = G.C.MONEY,
          delay = 0.5
        }
      end
    end
    
    if context.ending_shop and not context.blueprint then
      card.ability.extra.money_spent = 0
      card.ability.extra.activated = nil
    end
  end
}