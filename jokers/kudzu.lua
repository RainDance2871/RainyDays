SMODS.Joker {
  key = 'kudzu',
  atlas = 'Jokers',
  rarity = 2,
  cost = 3,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = false,
  pos = GetJokersAtlasTable('kudzu'), 
  config = {
    extra = {
      mult_bonus = 1,
      mult_current = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local edition = card.delay_edition or card.edition
    local main_end = (edition and edition.negative) and {
      { n = G.UIT.T, config = { text = '(' .. localize('rainydays_removes') .. ' ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.9 * 0.32 }},
      { n = G.UIT.T, config = { text = localize('negative', 'labels'), colour = G.C.DARK_EDITION, scale = 0.9 * 0.32 }},
      { n = G.UIT.T, config = { text = ' ' .. localize('rainydays_from_copy') .. ')', colour = G.C.UI.TEXT_INACTIVE, scale = 0.9 * 0.32 }},
    } or nil
  
    return {
      main_end = main_end,
      vars = {
        card.ability.extra.mult_bonus,
        card.ability.extra.mult_current
      }
    }
  end,

  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main and card.ability.extra.mult_current > 0 then
      return {
        mult = card.ability.extra.mult_current
      }
    end
    
    if context.setting_blind and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          if #G.jokers.cards < G.jokers.config.card_limit then
            play_sound('timpani')
            local new = copy_card(card, nil, nil, nil, card.edition and card.edition.negative)
            new.ability.extra.mult_current = 0
            new:add_to_deck()
            G.jokers:emplace(new)
          end
          
          local count = #SMODS.find_card('j_RainyDays_kudzu')
          if count > 0 then 
            card.ability.extra.mult_current = card.ability.extra.mult_current + count
            card_eval_status_text(card, 'jokers', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.MULT })
          end
          return true
        end
      }))
    end
  end
}