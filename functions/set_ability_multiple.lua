function RainyDays.set_ability_multiple(source, cards, key, args) --args = { no_delay_sprites, colour, delay, juice_card, no_juice, message_card, no_message, instant }
  args = args or {}
  cards = not cards.ID and cards or { cards }
  
  RainyDays.setting_ability_multiple = true
  local cards_set = {}
  for i = 1, #cards do
    local old = cards[i].config.center.key
    cards[i]:set_ability(G.P_CENTERS[key], nil, not (args.no_delay_sprites or args.instant))
    cards_set[#cards_set + 1] = { old = old, new = cards[i].config.center_key, unchanged = (old == cards[i].config.center_key) }
  end
  RainyDays.setting_ability_multiple = nil
  
  local function cards_clean_up(cards)
    for i = 1, #cards do
      SMODS.clean_up_children(cards[i].children)
      if cards[i].canvas_text then
        SMODS.clean_up_canvas_text(cards[i])
      end
      if cards[i].ability and (cards[i].set == 'Enhanced' or cards[i].set == 'Default') and not cards[i]:should_hide_front() then
        cards[i]:set_sprites(nil, cards[i].config.card)
      end
      cards[i]:set_sprites(G.P_CENTERS[key])
      cards[i].delay_center = nil
      cards[i].front_hidden = cards[i]:should_hide_front()
    end
  end
  
  if not args.instant then
    local ret = {
      colour = args.colour or G.C.FILTER,
      no_message = true
    }
    
    ret.func = function()
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        delay = 0,
        blockable = true,
        blocking = true
      }))
      G.E_MANAGER:add_event(Event({ 
        trigger = 'after',
        delay = args.delay or 0,
        blockable = true,
        func = function()
          if args.juice_card then
            args.juice_card:juice_up()
          end
          
          cards_clean_up(cards)
          
          if not args.no_juice then
            for i = 1, #cards do
              cards[i]:juice_up()
            end
          end
          
          return true
        end
      }))
      
      if not args.no_message and (args.message_card or source) then
        card_eval_status_text(args.message_card or source, 'extra', nil, nil, nil, { message = args.message or localize('rainydays_enhanced'), colour = ret.colour, no_juice = args.no_juice })
      end
      SMODS.calculate_context({ rd_setting_ability_multiple = true, cards = cards_set })
      return true
    end
    
    return ret
  else
    cards_clean_up(cards)
    if not args.no_message and (args.message_card or source) then
      card_eval_status_text(args.message_card or source, 'extra', nil, nil, nil, { message = args.message or localize('rainydays_enhanced'), colour = args.colour or G.C.FILTER, no_juice = args.no_juice })
    end
    SMODS.calculate_context({ rd_setting_ability_multiple = true, cards = cards_set })
  end
end