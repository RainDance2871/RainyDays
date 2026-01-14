SMODS.Joker {
  key = 'sediment',
  atlas = 'Jokers',
  rarity = 2,
  cost = 7,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('sediment'),
  config = {
    extra = {
      plus_xmult = 2.5,
      card_amount = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_RainyDays_junk
    return {
      vars = { 
        card.ability.extra.plus_xmult,
        card.ability.extra.card_amount
      }
    } 
  end,
    
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.plus_xmult
      }
    end
    
    if context.setting_blind then
      local new_cards = {}
      for i = 1, card.ability.extra.card_amount do
        new_cards[i] = SMODS.create_card { set = 'Base', enhancement = 'm_RainyDays_junk', area = G.discard }
        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
        new_cards[i].playing_card = G.playing_card
        table.insert(G.playing_cards, new_cards[i])
      end
      
      G.E_MANAGER:add_event(Event({
        func = function()
          for i = 1, #new_cards do
            new_cards[i]:start_materialize()
            G.play:emplace(new_cards[i])
          end
          return true
        end
      }))
      return {
        message = '+' .. #new_cards .. ' ' .. localize('rainydays_junk_cards'),
        colour = G.C.FILTER,
        func = function()
          for i = 1, #new_cards do
            draw_card(G.play, G.deck, 90, 'up', nil, new_cards[i])
          end
          SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
        end
      }
    end
  end
}