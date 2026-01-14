SMODS.Consumable {
  key = 'cancer',
  set = 'Constellation',
  atlas = "Constellations",
  pos = GetConstellationAtlasTable('cancer'),
  unlocked = true,
  discovered = true,
  config = {
    card_amount = 3
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_RainyDays_junk
    local last_hand_text = G.GAME.last_hand_played and localize(G.GAME.last_hand_played, 'poker_hands') or localize('k_none')
    local colour = G.GAME.last_hand_played and G.C.GREEN or G.C.RED
    
    return {
      main_end = generate_main_end(last_hand_text, colour),
      vars = { 
        card.ability.card_amount
      }
    }
  end,
  
  use = function(self, card, area, copier)
    level_up_table_tailends(card, { G.GAME.last_hand_played }, nil, false, 1)
    
    local new_cards = {}
    for i = 1, card.ability.card_amount do
      new_cards[i] = SMODS.create_card { set = 'Base', enhancement = 'm_RainyDays_junk', area = G.discard }
      G.playing_card = (G.playing_card and G.playing_card + 1) or 1
      new_cards[i].playing_card = G.playing_card
      table.insert(G.playing_cards, new_cards[i])
      new_cards[i].states.visible = nil
    end
    
    if #new_cards > 0 then
      G.E_MANAGER:add_event(Event({
        blocking = false,
        func = function() 
          if #G.play.cards > 0 then
            return false
          end
          
          for i = 1, #new_cards do
            new_cards[i]:start_materialize()
            G.play:emplace(new_cards[i])
          end
          
          G.E_MANAGER:add_event(Event({
            trigger = "after", --delay the event by 1 unit. exact time depends on game speed.
            delay = 1,
            func = function()
              G.E_MANAGER:add_event(Event({
                func = function()
                  G.deck.config.card_limit = G.deck.config.card_limit + #new_cards
                  return true
                end
              }))
              for i = 1, #new_cards do
                draw_card(G.play, G.deck, 90, 'up', nil, new_cards[i]) --draw from play into the deck.
              end
              G.deck:shuffle('cancer'..G.GAME.round_resets.ante) --shuffle the deck
              SMODS.calculate_context({ playing_card_added = true, cards = new_cards }) --some jokers care about adding cards to the deck, so we let them know.
              delay(0.5)
              card_eval_status_text(G.deck, 'extra', nil, nil, nil, {
                message = '+' .. #new_cards .. ' ' .. localize('rainydays_junk_cards'),
                colour = G.C.FILTER,
                no_juice = true
              })
              return true
            end
          }))
          return true
        end
      }))
    end
  end,

  can_use = function(self, card)
    return G.GAME.last_hand_played
  end
}