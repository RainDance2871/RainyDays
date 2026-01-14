function level_up_hand(card, hand, instant, level_up, chip_upgrade, mult_upgrade, money_upgrade)
  level_up_table_tailends(card, { hand }, nil, instant, level_up, chip_upgrade, mult_upgrade, money_upgrade)
end



function level_up_table_tailends(card, hands_upgraded, description, instant, level_up, chip_upgrade, mult_upgrade, money_upgrade, juice_cards)
  --set init visual values
  local desc
  if #hands_upgraded == 1 then
    local hand = hands_upgraded[1]
    desc = { handname = localize(hand, 'poker_hands'), level = G.GAME.hands[hand].level, chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult }
  else
    desc = { handname = description, level = '', chips = '...', mult = '...' }
  end
  update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 }, desc)
  
  --upgrade
  level_up_table(card, hands_upgraded, description, instant, level_up, chip_upgrade, mult_upgrade, money_upgrade, juice_cards)
  
  --set visual values after
  local hand_info
  if G.play and G.play.cards and #G.play.cards > 0 then
    local hand = (G.FUNCS.get_poker_hand_info(G.play.cards))
    hand_info = { handname = localize(hand, 'poker_hands'), level = G.GAME.hands[hand].level, chips = hand_chips, mult = mult }
  elseif G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
    local hand = (G.FUNCS.get_poker_hand_info(G.hand.highlighted))
    hand_info = { handname = localize(hand, 'poker_hands'), level = G.GAME.hands[hand].level, chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult }
  else
    hand_info = { handname = "", level = "", chips = 0, mult = 0 }
  end
   update_hand_text({ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 }, hand_info)
end



--new function that allows upgrading multiple hands at once
function level_up_table(card, hands_upgraded, description, instant, level_up, chip_upgrade, mult_upgrade, money_upgrade, juice_cards)
  --set vars
  local play_hand, play_chips, play_mult
  
  --special case: level up hands while and hand is being played
  if G.play and G.play.cards and #G.play.cards > 0 then
    play_hand = (G.FUNCS.get_poker_hand_info(G.play.cards))
    play_chips = G.GAME.hands[play_hand].chips
    play_mult = G.GAME.hands[play_hand].mult
  end
  level_up = level_up or 1
  chip_upgrade = chip_upgrade or 0
  mult_upgrade = mult_upgrade or 0
  money_upgrade = money_upgrade or 0
    
  --upgrade all hands
  local individual_hand_money_change = false
  for i = 1, #hands_upgraded do
    local hand = G.GAME.hands[hands_upgraded[i]]
    
    --apply bonus chips and mult
    hand.chips_bonus = (hand.chips_bonus or 0) + chip_upgrade
    hand.mult_bonus = (hand.mult_bonus or 0) + mult_upgrade
    
    --apply levelup and bonus
    hand.level = math.max(1, hand.level + level_up)
    hand.chips = hand.s_chips + hand.chips_bonus + hand.l_chips * (hand.level - 1)
    hand.mult = hand.s_mult + hand.mult_bonus + hand.l_mult * (hand.level - 1)
    hand.money = (hand.money or 0) + money_upgrade
    
    --alter game info page if needed
    if hand.money ~= 0 then 
      G.GAME.money_bonus_given = true
    end
    
    --prevent negative scores
    if to_big(hand.chips) < to_big(0) then
      hand.chips_bonus = hand.chips_bonus - hand.chips
      hand.chips = 0
    end
    if to_big(hand.mult) < to_big(1) then
      hand.mult_bonus = hand.mult_bonus - hand.mult + 1
      hand.mult = 1
    end
  end

  --animation
  if not instant then
    --description vars II: post upgrade
    local desc_level_up, desc_chips_up, desc_mult_up
    if #hands_upgraded ~= 1 then
      if level_up == 0 then
        desc_chips_up = chip_upgrade ~= 0 and (chip_upgrade > 0 and '+' .. chip_upgrade or '-' .. math.abs(chip_upgrade)) or nil
        desc_mult_up = mult_upgrade ~= 0 and (mult_upgrade > 0 and '+' .. mult_upgrade or '-' .. math.abs(mult_upgrade)) or nil
      else
        desc_level_up = level_up > 0 and '+' .. level_up or '-' .. math.abs(level_up)
        desc_chips_up = level_up > 0 and '+' or '-'
        desc_mult_up = level_up > 0 and '+' or '-'
      end
    else
      desc_level_up = G.GAME.hands[hands_upgraded[1]].level
      desc_chips_up = G.GAME.hands[hands_upgraded[1]].chips
      desc_mult_up = G.GAME.hands[hands_upgraded[1]].mult
    end
    
    --update values visual
    --mult
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
      return shakeit(card, juice_cards, true) end 
    }))
    update_hand_text({ delay = 0 }, { mult = desc_mult_up, StatusText = true })
    
    --chips
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function()
      return shakeit(card, juice_cards, true) end
    }))
    update_hand_text({ delay = 0 }, { chips = desc_chips_up, StatusText = true })
    
    --money
    if money_upgrade ~= 0 or individual_hand_money_change then
      local desc_money_up = money_upgrade ~= 0 and ((money_upgrade > 0 and '+' or '-') .. localize('$') .. math.abs(money_upgrade)) or localize('$')
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function()
        return shakeit_money(desc_money_up, card, juice_cards, true) end 
      }))
    end
    
    --level
    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.9, func = function()
      return shakeit(card, juice_cards, nil) end 
    }))
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = desc_level_up })
    
    delay(1.3)
  end
  
  --check if any jokers if rewards as result of a hand upgrade
  if G.jokers and G.jokers.cards then
    local context_sent = {
      hand_upgrade_response = true,
      card = card,
      hands_upgraded = hands_upgraded,
      level_up = level_up,
      chip_upgrade = chip_upgrade,
      mult_upgrade = mult_upgrade,
      money_upgrade = money_upgrade
    }
    for i = 1, #G.jokers.cards do
      eval_card(G.jokers.cards[i], context_sent)
    end
  end
  
  if not instant then
    --achievement check
    if level_up > 0 then
      for i = 1, #hands_upgraded do
      local hand = G.GAME.hands[hands_upgraded[i]]
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
            check_for_unlock{ type = 'upgrade_hand', hand = hands_upgraded[i], level = G.GAME.hands[hands_upgraded[i]].level } 
            return true 
          end
        }))
      end
    end
  end
  
  --special case: hand is being played
  if G.play and G.play.cards and #G.play.cards > 0 then
    hand_chips = mod_chips(hand_chips + G.GAME.hands[play_hand].chips - play_chips)
    mult = mod_mult(mult + G.GAME.hands[play_hand].mult - play_mult)
  end
end



--payout of the money bonus
local old_func_evaluate = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
  local ret = old_func_evaluate(e)
  local poker_hand = G.FUNCS.get_poker_hand_info(G.play.cards)
  if G.GAME.hands[poker_hand] and G.GAME.hands[poker_hand].money and G.GAME.hands[poker_hand].money ~= 0 then
    ease_dollars(G.GAME.hands[poker_hand].money)
    card_eval_status_text(G.play, 'extra', nil, nil, nil, {
      message = localize('rainydays_money_bonus') .. ': ' .. localize('$') .. G.GAME.hands[poker_hand].money,
      colour = G.C.MONEY,
      no_juice = true
    })
    delay(0.6)
  end
  return ret
end



function shakeit(card, juice_secondary, stat_type, tarot_pulse)
  play_sound('tarot1')
  if card then
    card:juice_up(0.8, 0.5)
  end
  if juice_secondary then
    juice_secondary:juice_up(0.8, 0.5)
  end
  G.TAROT_INTERRUPT_PULSE = tarot_pulse
  return true
end



function shakeit_money(money_text, card, juice_secondary, stat_type, tarot_pulse)
  attention_text({ 
    text = money_text, 
    scale = 0.8, 
    hold = 1, 
    cover = G.hand_text_area.handname.parent, 
    cover_colour = G.C.MONEY, 
    emboss = 0.05, 
    align = 'cm', 
    cover_align = 'cm'
  })
  return shakeit(card, juice_secondary, stat_type, tarot_pulse)
end