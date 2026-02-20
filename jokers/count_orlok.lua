SMODS.Joker {
  key = 'count_orlok',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = GetJokersAtlasTable('count_orlok'),
  
  config = {
    extra = {
      xmult = 1,
      xmult_gain = 0.1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult_gain,
        card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.xmult > 1 then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.before and context.main_eval and not context.blueprint then
      card.ability.extra.face_card = nil
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i]:is_face() then
          if not card.ability.extra.face_card then
            card.ability.extra.face_card = context.scoring_hand[i]
          else
            card.ability.extra.face_card = nil
            return
          end
        end
      end
      
      if card.ability.extra.face_card then
        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT
        }
      end
    end
    
    
    if card.ability.extra.face_card and context.destroy_card == card.ability.extra.face_card and context.cardarea == G.play and not context.blueprint then
      card.ability.extra.face_card = nil
      return {
        message_card = context.destroy_card,
        message = localize('rainydays_destroyed'),
        colour = G.C.FILTER,
        remove = true
      }
    end
  end
}