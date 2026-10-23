local jd_def = JokerDisplay.Definitions
local counter_scale = 0.3
local active_message_scale = 0.3
local reminder_text_scale = 0.3

local function hand_has_enhancement(hand, enhancement)
  for _, card in pairs(hand) do
    if card.facing and card.facing ~= 'back' and SMODS.has_enhancement(card, enhancement) then
      return true
    end
  end
end

jd_def['j_RainyDays_abacus'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank3' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local xmult = card.ability.extra.x_mult
    if not RainyDays.evaluating_play and #JokerDisplay.current_hand > 0 then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in ipairs(scoring_hand) do
          local id = scoring_card:get_id()
          if RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_abacus[1]] == id or RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_abacus[2]] == id 
          or RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_abacus[3]] == id then
            xmult = xmult + card.ability.extra.plus_xmult * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.xmult = xmult
    card.joker_display_values.rank1 = localize(G.GAME.current_round.RD_abacus[1], 'ranks')
    card.joker_display_values.rank2 = localize(G.GAME.current_round.RD_abacus[2], 'ranks')
    card.joker_display_values.rank3 = localize(G.GAME.current_round.RD_abacus[3], 'ranks')
  end
}

jd_def['j_RainyDays_absent_heart'] = {
  text = {
    { text = "(" },
    { ref_table = 'card.ability.extra', ref_value = 'drawn_counter' },
    { text = "/" },
    { ref_table = 'card.ability.extra', ref_value = 'per_drawn' },
    { text = ")" }
  },
  text_config = { scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'drawn' },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.drawn = localize('rainydays_JD_drawn')
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[3] then
      reminder_text.children[3].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_accountant'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    card.joker_display_values.mult = card.ability.extra.mult * (G.GAME.facing_blind and G.GAME.rd_cards_drawn_this_round or 0)
  end
}

jd_def['j_RainyDays_algebra'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'ex', colour = G.C.CLEAR },
    { text = "+", colour = G.C.CHIPS },
    { ref_table = 'card.ability.extra', ref_value = 'current_chips', retrigger_type = 'mult', colour = G.C.CHIPS },
    { ref_table = 'card.joker_display_values', ref_value = 'ex' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'text', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local ex = ""
    
    if G.GAME.current_round.discards_left > 0 and not RainyDays.evaluating_play then
      local text = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        
        local function nummbers_only()
          for i = 1, #JokerDisplay.current_hand do
            if JokerDisplay.current_hand[i]:get_id() > 10 or JokerDisplay.current_hand[i]:get_id() < 2 then
              return false
            end
          end
          return true
        end
        
        ex = #JokerDisplay.current_hand > 0 and nummbers_only() and " !" or ""
      end
    end
    
    card.joker_display_values.ex = ex
    card.joker_display_values.text = localize('rainydays_JD_numbers')
  end
}

jd_def['j_RainyDays_atom'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 },
    { text = "+", colour = G.C.MULT },
    { ref_table = 'card.ability.extra', ref_value = 'mult_rewards', colour = G.C.MULT }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  extra = {{
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'odds' },
    { text = ")" },
  }},
  extra_config = { colour = G.C.GREEN, scale = 0.3 },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.count = count
    
    local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    card.joker_display_values.odds = localize{ type = 'variable', key = 'jdis_odds', vars = { numerator, denominator }}
    
    card.joker_display_values.localized_text = localize(card.ability.extra.rank, 'ranks')
  end
}

jd_def['j_RainyDays_avocado'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
}

jd_def['j_RainyDays_balance'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'x_mult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.blind and G.GAME.blind.in_blind then
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].played_this_round > 0 then
          count = count + 1
        end
      end
    
      local text = (JokerDisplay.evaluate_hand())
      if text and G.GAME.hands[text] and G.GAME.hands[text].played_this_round == 0 then
        count = count + 1
      end
    end
    
    if G.GAME.facing_blind and #JokerDisplay.current_hand >= 1 then
      math.max(count, 1)
    end
    
    card.joker_display_values.x_mult = count * card.ability.extra.xmult
  end
}

jd_def['j_RainyDays_bankaccount'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'plus_chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  reminder_text = {
    { text = "(" },
    { text = "$", colour = G.C.GOLD },
    { ref_table = 'card', ref_value = 'sell_cost', colour = G.C.GOLD },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
}

jd_def['j_RainyDays_bazaar'] = {
  text = {
    { text = "+", colour = G.C.FILTER },
    { ref_table = 'card.ability.extra', ref_value = 'hand_size', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'hand_size' },
  },
  
  calc_function = function(card)
    card.joker_display_values.hand_size = localize('rainydays_JD_hand_size')
  end
}

jd_def['j_RainyDays_beanstalk'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  reminder_text = {
    { text = "(", scale = counter_scale },
    { ref_table = 'card.ability.extra', ref_value = 'cards_used_this_round', scale = counter_scale },
    { text = "/", scale = counter_scale },
    { ref_table = 'card.ability.extra', ref_value = 'card_amount', scale = counter_scale },
    { text = ")", scale = counter_scale }
  },
  reminder_text_config = { scale = reminder_text_scale }
}

jd_def['j_RainyDays_bingo_balls'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  calc_function = function(card)
    card.joker_display_values.chips = G.GAME.rd_bingo_balls
  end
}

jd_def['j_RainyDays_blood_moon'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  }
}

jd_def['j_RainyDays_bonsai'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { ref_table = 'card.joker_display_values', ref_value = 'in_deck' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local amount = 0
    if G.deck and G.deck.cards then
      for i= 1, #G.deck.cards do
        if G.deck.cards[i]:is_suit(card.ability.extra.suit) then
          amount = amount + 1
        end
      end
    end
    
    card.joker_display_values.mult = card.ability.extra.mult * math.floor(amount / card.ability.extra.cards)
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
    card.joker_display_values.in_deck = localize('rainydays_JD_in_deck')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[2] then
      reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_breakdance'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local xmult = card.ability.extra.xmult
    if not RainyDays.breakdance_check_active() then
      xmult = 1
    elseif not RainyDays.evaluating_play then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if not RainyDays.Is_odd(scoring_card) then
            xmult = 1
            break
          end
        end
      end
    end
    
    card.joker_display_values.xmult = xmult
  end
}

jd_def['j_RainyDays_breakfast_cereal'] = {
  text = {
    { text = "+", colour = G.C.SECONDARY_SET['Tarot'] },
    { ref_table = 'card.joker_display_values', ref_value = 'amount', colour = G.C.SECONDARY_SET['Tarot'], retrigger_type = 'mult' },
    { text = " " },
    { ref_table = 'card.joker_display_values', ref_value = 'tag' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'countdown' },
    { text = ")" }
  },
  
  calc_function = function(card)
    local amount = card.ability.extra.cards_amount
    local cards_played = 0
    if G.GAME.facing_blind and not RainyDays.evaluating_play then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if not scoring_card.debuff and next(SMODS.get_enhancements(scoring_card)) then
            cards_played = cards_played + 1
          end
        end
      end
    end
    amount = amount - cards_played
    
    card.joker_display_values.countdown = math.max(0, amount) .. "/" .. card.ability.extra.cards_amount_start
    card.joker_display_values.amount = (amount <= 0) and card.ability.extra.amount or 0 
    card.joker_display_values.tag = localize{ type = 'name_text', set = 'Tag', key = card.ability.extra.tag }
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children and reminder_text.children[2] then
      local amount = card.ability.extra.cards_amount
      local cards_played = 0
      if G.GAME.facing_blind and  not RainyDays.evaluating_play then
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
          for _, scoring_card in pairs(scoring_hand) do
            if not scoring_card.debuff and next(SMODS.get_enhancements(scoring_card)) then
              cards_played = cards_played + 1
            end
          end
        end
      end
      amount = amount - cards_played
      reminder_text.children[2].config.colour = (amount <= 0) and G.C.RED or G.C.UI.TEXT_INACTIVE
    end
  end,
  
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if held_in_hand then 
      return 0 
    end
    
    local retrigger = false
    if JokerDisplay.in_scoring(playing_card, scoring_hand) and next(SMODS.get_enhancements(playing_card)) then
      local amount_before = 0
      for i = 1, #scoring_hand do
        if scoring_hand[i] == playing_card then
          if amount_before < joker_card.ability.extra.cards_amount then
            retrigger = true
            break
          end
        elseif next(SMODS.get_enhancements(playing_card)) then
          amount_before = amount_before + 1
        end
      end
    end
    
    return retrigger and joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end
}

jd_def['j_RainyDays_bud'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'chips' }
  },
  
  reminder_text = {
    { ref_table = 'card.joker_display_values', ref_value = 'reminder_start' },
    { ref_table = 'card.joker_display_values', ref_value = 'dollar_minus', colour = G.C.GOLD },
    { ref_table = 'card.joker_display_values', ref_value = 'reminder_end' }
  },
  --reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.chips = "+" .. (card.ability.extra.chip_reward * math.floor(card.ability.extra.dollars_spent / card.ability.extra.per_dollar) * JokerDisplay.calculate_joker_triggers(card))
    if card.ability.extra.bloomed then
      card.joker_display_values.reminder_start = ""
      card.joker_display_values.dollar_minus = ""
      card.joker_display_values.reminder_end = ""
    else
      card.joker_display_values.reminder_start = "("
      card.joker_display_values.dollar_minus = "-" .. localize('$') .. card.ability.extra.dollar_take
      card.joker_display_values.reminder_end = " " .. localize('k_round') .. ")"
    end
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if text and text.children and text.children[1] then
      text.children[1].config.colour = card.ability.extra.bloomed and not card.debuff and G.C.CHIPS or G.C.UI.TEXT_INACTIVE
    end
    if reminder_text and reminder_text.children then
      for i = 1, #reminder_text.children do
        reminder_text.children[i].config.scale = card.ability.extra.bloomed and 0 or reminder_text_scale
      end
    end
  end
}

jd_def['j_RainyDays_burdenofgreatness'] = {
  text = {
    { text = "+", colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'plus_score', colour = G.C.FILTER },
    { text = "%", colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'danger' }
  },
  
  reminder_text = {
    { ref_table = 'card.joker_display_values', ref_value = 'round' }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  extra = {{
    { text = "+", colour = G.C.SECONDARY_SET['Tarot'] },
    { ref_table = 'card.ability.extra', ref_value = 'amount', colour = G.C.SECONDARY_SET['Tarot'], retrigger_type = 'mult' },
    { text = " " },
    { ref_table = 'card.joker_display_values', ref_value = 'tag' }
  }},
  
  calc_function = function(card)
    card.joker_display_values.plus_score = math.floor((((1 + card.ability.extra.plus_score / 100) * JokerDisplay.calculate_joker_triggers(card)) - 1) * 100 + 0.5)
    card.joker_display_values.danger = localize('rainydays_JD_required_scores')
    card.joker_display_values.round = "(" .. localize('k_round') .. ")"
    card.joker_display_values.tag = localize{ type = 'name_text', set = 'Tag', key = card.ability.extra.tag }
  end
}

jd_def['j_RainyDays_canine'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 },
    { text = "+", colour = G.C.CHIPS },
    { ref_table = 'card.ability.extra', ref_value = 'chips', colour = G.C.CHIPS },
    { text = "/" },
    { text = "+", colour = G.C.MULT },
    { ref_table = 'card.ability.extra', ref_value = 'mult', colour = G.C.MULT },
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.count = count
    
    card.joker_display_values.rank1 = localize(card.ability.extra.rank1, 'ranks') 
    card.joker_display_values.rank2 = localize(card.ability.extra.rank2, 'ranks')
  end
}

jd_def['j_RainyDays_catalogue'] = {
  extra = {{
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'odds' },
    { text = ")" },
  }},
  extra_config = { colour = G.C.GREEN, scale = 0.3 },
  
  calc_function = function(card)
    local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    card.joker_display_values.odds = localize{ type = 'variable', key = 'jdis_odds', vars = { numerator, denominator }}
  end
}

jd_def['j_RainyDays_catwalk'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if RainyDays.has_enhancement_unique_to_hand(scoring_card, JokerDisplay.current_hand) then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    card.joker_display_values.xmult = card.ability.extra.xmult ^ count
  end
}

jd_def['j_RainyDays_ceremonial_bowl'] = {
  text = {
    { text = "+" .. localize('$') },
    { ref_table = 'card.joker_display_values', ref_value = 'dollars' }
  },
  text_config = { colour = G.C.GOLD },
  
  reminder_text = {
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local amount = 0
    local pos = RainyDays.GetJokerPosition(card)
    if pos then
      amount = #G.jokers.cards - pos
    end
    
    card.joker_display_values.dollars = amount * card.ability.extra.dollars
  end
}

jd_def['j_RainyDays_checklist'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if not SMODS.has_no_rank(scoring_card) then
            local rank_id = scoring_card:get_id()
            if not RainyDays.evaluating_play then
              if G.GAME.rd_ranks_played_this_round[rank_id] and G.GAME.rd_ranks_played_this_round[rank_id] >= 1 then
                count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
              end
            else
              if G.GAME.rd_ranks_played_this_round[rank_id] and G.GAME.rd_ranks_played_this_round[rank_id] >= 2 then
                local rank_amount = 0
                for i = 1, #JokerDisplay.current_hand do
                  if not SMODS.has_no_rank(JokerDisplay.current_hand[i]) and JokerDisplay.current_hand[i]:get_id() == rank_id then
                    rank_amount = rank_amount + 1
                  end
                end
                
                if G.GAME.rd_ranks_played_this_round[rank_id] - rank_amount >= 1 then
                  count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
              end
            end
          end
        end
      end
    end
    
    card.joker_display_values.xmult = card.ability.extra.xmult ^ count
  end
}

jd_def['j_RainyDays_cleanslate'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'plus_mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
}

jd_def['j_RainyDays_cloverfield'] = {
  text = {
    { text = "+", colour = G.C.MULT },
    { ref_table = 'card.ability.extra', ref_value = 'current_mult', colour = G.C.MULT, retrigger_type = 'mult' },
    { text = " (", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { ref_table = 'card.ability.extra', ref_value = 'discarded_counter', scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { text = "/", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { ref_table = 'card.ability.extra', ref_value = 'per_discarded', scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { text = ")", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'discarded' },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.discarded = localize('rainydays_JD_discarded')
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[3] then
      reminder_text.children[3].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_collection'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'jokers' },
    { text = "/" },
    { ref_table = 'card.ability.extra', ref_value = 'jokers' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.jokers = math.min(G.GAME.rd_jokers_uniquelist_count, card.ability.extra.jokers)
    card.joker_display_values.xmult = (G.GAME.rd_jokers_uniquelist_count >= card.ability.extra.jokers) and card.ability.extra.Xmult or 1
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text then
      for i = 2, 4 do
        if reminder_text.children[i] then
          reminder_text.children[i].config.colour = (G.GAME.rd_jokers_uniquelist_count >= card.ability.extra.jokers) and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
      end
    end
  end
}

jd_def['j_RainyDays_conga_line'] = {
  reminder_text = {
    { text = "(10, 8, 6, 4, 2)" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if held_in_hand then 
      return 0 
    end
    return JokerDisplay.in_scoring(playing_card, scoring_hand) and RainyDays.Is_even(playing_card) and joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end
}

jd_def['j_RainyDays_count_orlok'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'faces', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.faces = localize('k_face_cards')
  end
}

jd_def['j_RainyDays_dancing_moves'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'active', scale = active_message_scale }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'wild' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local active = hand_has_enhancement(JokerDisplay.current_hand, 'm_wild')
    card.joker_display_values.active = active and localize('rainydays_activated') or localize('rainydays_deactivated')
    card.joker_display_values.wild = localize('rainydays_wild')
  end,
  
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if not held_in_hand and JokerDisplay.in_scoring(playing_card, scoring_hand) then 
      if hand_has_enhancement(JokerDisplay.current_hand, 'm_wild') then
        return joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
      end
    end
    return 0
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if text and text.children[1] then
      local active = not card.debuff and hand_has_enhancement(JokerDisplay.current_hand, 'm_wild')
      text.children[1].config.colour = active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
    end
  end
}

jd_def['j_RainyDays_dealer'] = {}

jd_def['j_RainyDays_delirium'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'ex', colour = G.C.CLEAR },
    { text = "+", colour = G.C.MULT },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult', colour = G.C.MULT },
    { ref_table = 'card.joker_display_values', ref_value = 'ex' }
  },
  
  calc_function = function(card)
    local bool = (not G.GAME.rd_delirium_active and G.GAME.facing_blind and G.GAME.current_round.discards_left > 0)
    card.joker_display_values.ex = (bool and not RainyDays.evaluating_play and RainyDays.delirium_check(JokerDisplay.current_hand)) and " !" or ""
    card.joker_display_values.mult =  G.GAME.rd_delirium_active and card.ability.extra.mult_bonus or 0
  end
}

jd_def['j_RainyDays_desolate'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'ex', colour = G.C.CLEAR },
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }},
    { ref_table = 'card.joker_display_values', ref_value = 'ex' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'hands' },
    { text = "/" },
    { ref_table = 'card.ability.extra', ref_value = 'hands' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    for _, value in ipairs(G.handlist) do
      if G.GAME.hands[value].rd_discarded and G.GAME.hands[value].rd_discarded > 0 then
        count = count + 1
      end
    end
    
    local ex = ""
    if G.GAME.facing_blind and not RainyDays.evaluating_play and G.GAME.current_round.discards_left > 0 and count < card.ability.extra.hands then
      local text = (JokerDisplay.evaluate_hand())
      if text and G.GAME.hands[text] and G.GAME.hands[text].rd_discarded and G.GAME.hands[text].rd_discarded == 0 then
        ex = " !"
      end
    end
    card.joker_display_values.ex = ex
    
    card.joker_display_values.hands = math.min(count, card.ability.extra.hands)
    card.joker_display_values.xmult = (count >= card.ability.extra.hands) and card.ability.extra.Xmult or 1
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text then
      local count = 0
      for _, value in ipairs(G.handlist) do
        if G.GAME.hands[value].rd_discarded and G.GAME.hands[value].rd_discarded > 0 then
          count = count + 1
        end
      end
      
      for i = 2, 4 do
        if reminder_text.children[i] then
          reminder_text.children[i].config.colour = (count >= card.ability.extra.hands) and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
      end
    end
  end
}

jd_def['j_RainyDays_doubling_joker'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          local id = scoring_card:get_id() 
          if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    card.joker_display_values.mult = (card.ability.extra.mult_start * (card.ability.extra.mult_base ^ count)) - 1
    card.joker_display_values.rank1 = localize(card.ability.extra.rank1, 'ranks') 
    card.joker_display_values.rank2 = localize(card.ability.extra.rank2, 'ranks')
  end
}

jd_def['j_RainyDays_duality'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'chips', colour = G.C.CHIPS },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', colour = G.C.MULT }
  },
  
  calc_function = function(card)
    if card.ability.extra.night then
      card.joker_display_values.chips = "+" .. (card.ability.extra.chips * JokerDisplay.calculate_joker_triggers(card))
      card.joker_display_values.mult = ""
    else
      card.joker_display_values.mult = "+"  .. (card.ability.extra.mult * JokerDisplay.calculate_joker_triggers(card))
      card.joker_display_values.chips = ""
    end
  end
}

jd_def['j_RainyDays_early_birds'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card.ability.rd_early_bird then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    card.joker_display_values.mult = card.ability.extra.mult * count
  end
}

jd_def['j_RainyDays_equity'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.prefix = localize('rainydays_JD_hold_no_prefix')
    card.joker_display_values.hand = localize(card.ability.extra.poker_hand, 'poker_hands')
    card.joker_display_values.postfix = localize('rainydays_JD_hold_no_postfix')
    
    if G.GAME.facing_blind then
      local playing_hand = next(G.play.cards)
      local held_in_hand = {}
      for _, playing_card in ipairs(G.hand.cards) do
        if playing_hand or not playing_card.highlighted then
          if not playing_hand and playing_card.facing and playing_card.facing == 'back' then
            card.joker_display_values.mult = 0
            return
          end
          
          held_in_hand[#held_in_hand + 1] = playing_card
        end
      end
      
      local _, _, pokerhands = G.FUNCS.get_poker_hand_info(held_in_hand)
      card.joker_display_values.mult = not next(pokerhands[card.ability.extra.poker_hand]) and card.ability.extra.mult or 0
    else
      card.joker_display_values.mult = 0
    end
  end
}

jd_def['j_RainyDays_fabergeegg'] = {
  text = {
    { text = "+" .. localize('$'), colour = G.C.GOLD },
    { ref_table = 'card.joker_display_values', ref_value = 'plus_value', colour = G.C.GOLD }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { text = " " },
    { text = localize('$'), colour = G.C.GOLD },
    { ref_table = 'card', ref_value = 'sell_cost', colour = G.C.GOLD },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          local id = scoring_card:get_id()
          if (RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] == id or RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] == id) then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
  
    card.joker_display_values.plus_value = card.ability.extra.plus_value * count
    card.joker_display_values.localized_text = localize(card.ability.extra.rank1, 'ranks') .. ", " .. localize(card.ability.extra.rank2, 'ranks')
  end
}

jd_def['j_RainyDays_fan_mail'] = {
  reminder_text = {
    { text = "(" },
    { text = "+", colour = G.C.FILTER },
    { ref_table = 'card.ability.extra', ref_value = 'packs', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'booster_pack' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.booster_pack = localize('rainydays_JD_booster_pack')
  end,
}

jd_def['j_RainyDays_feather_marvelous'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'count', colour = G.C.ORANGE },
    { text = "x" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { ref_table = 'card.joker_display_values', ref_value = 'sell_value', colour = G.C.GOLD },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.jokers then
      for i = 1, #G.jokers.cards do
        if RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
          count = count + 1
        end
      end
    end
    
    card.joker_display_values.count = count
    card.joker_display_values.localized_text = localize('rainydays_feather')
    card.joker_display_values.sell_value = next(SMODS.find_card('j_RainyDays_feather_precious', true)) and (" $" .. card.sell_cost) or ""
  end,
  
  mod_function = function(card, mod_joker)
    return { x_mult = (RainyDays.IsInPool(card, 'Feather') and mod_joker.ability.extra.plus_xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
  end
}

jd_def['j_RainyDays_feather_precious'] = {
  text = {
    { text = "+" .. localize('$') },
    { ref_table = 'card.joker_display_values', ref_value = 'dollars' }
  },
  text_config = { colour = G.C.GOLD },
  
  reminder_text = {
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { text = " $", colour = G.C.GOLD },
    { ref_table = 'card', ref_value = 'sell_cost', colour = G.C.GOLD },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.jokers then
      for i = 1, #G.jokers.cards do
        if RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
          count = count + 1
        end
      end
    end
    
    card.joker_display_values.dollars = count * card.ability.extra.sell_value
    card.joker_display_values.localized_text = "(" .. localize('k_round') .. ")"
  end
}

jd_def['j_RainyDays_feather_silky'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'count', colour = G.C.ORANGE },
    { text = "x" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { ref_table = 'card.joker_display_values', ref_value = 'sell_value', colour = G.C.GOLD },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.jokers then
      for i = 1, #G.jokers.cards do
        if RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
          count = count + 1
        end
      end
    end
    
    card.joker_display_values.count = count
    card.joker_display_values.localized_text = localize('rainydays_feather')
    card.joker_display_values.sell_value = next(SMODS.find_card('j_RainyDays_feather_precious', true)) and (" $" .. card.sell_cost) or ""
  end,
  
  mod_function = function(card, mod_joker)
    return { mult = (RainyDays.IsInPool(card, 'Feather') and mod_joker.ability.extra.plus_mult * JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
  end
}

jd_def['j_RainyDays_feather_vibrant'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'count', colour = G.C.ORANGE },
    { text = "x" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { ref_table = 'card.joker_display_values', ref_value = 'sell_value', colour = G.C.GOLD },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.jokers then
      for i = 1, #G.jokers.cards do
        if RainyDays.IsInPool(G.jokers.cards[i], 'Feather') then
          count = count + 1
        end
      end
    end
    
    card.joker_display_values.count = count
    card.joker_display_values.localized_text = localize('rainydays_feather')
    card.joker_display_values.sell_value = next(SMODS.find_card('j_RainyDays_feather_precious', true)) and (" $" .. card.sell_cost) or ""
  end,
  
  mod_function = function(card, mod_joker)
    return { chips = (RainyDays.IsInPool(card, 'Feather') and mod_joker.ability.extra.plus_chips * JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
  end
}

jd_def['j_RainyDays_five_and_dime'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 },
    { text = "+", colour = G.C.MULT },
    { ref_table = 'card.ability.extra', ref_value = 'mult', colour = G.C.MULT },
    { text = "/" },
    { text = "+" .. localize('$'), colour = G.C.GOLD },
    { ref_table = 'card.ability.extra', ref_value = 'money', colour = G.C.GOLD }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  extra = {{
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'odds' },
    { text = ")" },
  }},
  extra_config = { colour = G.C.GREEN, scale = 0.3 },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.count = count
    
    local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    card.joker_display_values.odds = localize{ type = 'variable', key = 'jdis_odds', vars = { numerator, denominator }}
    
    card.joker_display_values.rank1 = localize(card.ability.extra.rank1, 'ranks') 
    card.joker_display_values.rank2 = localize(card.ability.extra.rank2, 'ranks')
  end
}

jd_def['j_RainyDays_flipflop'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'chips', colour = G.C.CHIPS },
    { border_nodes = {
      { ref_table = 'card.joker_display_values', ref_value = 'xmult' }
    },
    --border_colour = G.C.CLEAR
    }
  },
  
  calc_function = function(card)
    if card.ability.extra.state == 1 then
      card.joker_display_values.chips = "+" .. (card.ability.extra.plus_chips * JokerDisplay.calculate_joker_triggers(card))
      card.joker_display_values.xmult = ""
    else
      card.joker_display_values.xmult = "X"  .. (card.ability.extra.plus_xmult ^ JokerDisplay.calculate_joker_triggers(card))
      card.joker_display_values.chips = ""
    end
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if text and text.children[2] then
      text.children[2].config.colour = (card.ability.extra.state == 0) and G.C.XMULT or G.C.CLEAR
    end
  end
}

jd_def['j_RainyDays_folding_chair'] = {
  text = {
    { text = "+", colour = G.C.FILTER },
    { ref_table = 'card.ability.extra', ref_value = 'hand_size_bonus_current', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'hand_size' },
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'steel' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'max' },
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'hand_size_bonus_max' },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.hand_size = localize('rainydays_JD_hand_size')
    card.joker_display_values.max = localize('rainydays_JD_max')
    card.joker_display_values.steel = localize('rainydays_steel')
  end
}

jd_def['j_RainyDays_frowny_face'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'faces', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, playing_card in ipairs(JokerDisplay.current_hand) do
          if playing_card:is_face(true) and (playing_card.debuff or not RainyDays.list_contains(scoring_hand, playing_card)) then
            count = count + 1
          end
        end
      end
    end
    
    card.joker_display_values.mult = card.ability.extra.plus_mult * count
    card.joker_display_values.faces = localize('k_face_cards')
  end
}


jd_def['j_RainyDays_fruit_punch'] = {}

jd_def['j_RainyDays_golden_idol'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'x_mult', retrigger_type = 'exp' }
    }}
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'gold' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.gold = localize('rainydays_gold')
  end
}

jd_def['j_RainyDays_goldfish'] = {
  text = {
    { text = "+" .. localize('$'), colour = G.C.GOLD },
    { ref_table = 'card.joker_display_values', ref_value = 'dollars', colour = G.C.GOLD, retrigger_type = 'mult' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)    
    local dollars = 0
    if G.GAME.facing_blind and #JokerDisplay.current_hand > 0 then
      local _, poker_hands, _ = JokerDisplay.evaluate_hand()
      if not (poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand])) then
        dollars = card.ability.extra.money_bonus
      end
    end
    card.joker_display_values.dollars = dollars
    card.joker_display_values.prefix = localize('rainydays_JD_no_prefix')
    card.joker_display_values.hand =  string.len(card.joker_display_values.prefix) > 0 and string.lower(localize(card.ability.extra.poker_hand, 'poker_hands')) or localize(card.ability.extra.poker_hand, 'poker_hands')
    card.joker_display_values.postfix = localize('rainydays_JD_no_postfix')
  end
}

jd_def['j_RainyDays_goose'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  }
}

jd_def['j_RainyDays_grapes'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    local cards_played = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if not scoring_card.debuff and cards_played < card.ability.extra.card_amount then
            cards_played = cards_played + 1
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    local amount = card.ability.extra.card_amount - (not RainyDays.evaluating_play and cards_played or 0)
    
    card.joker_display_values.localized_text = math.max(0, amount) .. "/" .. card.ability.extra.card_amount_start
    card.joker_display_values.mult = card.ability.extra.mult * count
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children and reminder_text.children[2] then
      local cards_played = 0
      if G.GAME.facing_blind and not RainyDays.evaluating_play then
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
          for _, scoring_card in pairs(scoring_hand) do
            if not scoring_card.debuff then
              cards_played = cards_played + 1
            end
          end
        end
      end
      local amount = card.ability.extra.card_amount - cards_played
      reminder_text.children[2].config.colour = amount <= 0 and G.C.RED or G.C.UI.TEXT_INACTIVE
    end
  end
}

jd_def['j_RainyDays_grey_joker'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'ex', colour = G.C.CLEAR },
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }},
    { ref_table = 'card.joker_display_values', ref_value = 'ex' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local xmult = card.ability.extra.xmult
    local ex = ""
    
    if G.GAME.current_round.discards_left > 0 and not RainyDays.evaluating_play then
      local text, poker_hands = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' and poker_hands[card.ability.extra.hand] and next(poker_hands[card.ability.extra.hand]) then
        ex = " !"
      end
    end
    
    card.joker_display_values.ex = ex
    card.joker_display_values.xmult = xmult
    card.joker_display_values.hand = localize(card.ability.extra.hand, 'poker_hands')
  end
}

jd_def['j_RainyDays_grindstone'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 },
    { text = "+", colour = G.C.CHIPS },
    { ref_table = 'card.ability.extra', ref_value = 'bonus_chips', colour = G.C.CHIPS }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.count = count
    
    card.joker_display_values.localized_text = localize(card.ability.extra.rank, 'ranks')
  end
}

jd_def['j_RainyDays_hannysvoorwerp'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local first
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.key == 'j_RainyDays_hannysvoorwerp' then
          first = (G.jokers.cards[i] == card)
          break
        end
      end
      
      if first then
        local text = (JokerDisplay.evaluate_hand())
        if text and G.GAME.hands[text] then
          for _, planet in ipairs(G.consumeables.cards) do
            if planet.ability.set == 'Planet'and planet.ability.hand_type == text and not planet.getting_sliced then
              count = count + 1
            end
          end
        end
      end
    end
    
    card.joker_display_values.mult = card.ability.extra.current_mult + count * card.ability.extra.plus_mult
  end
}

jd_def['j_RainyDays_hecate'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'spectral', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.SECONDARY_SET['Spectral'] },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.prefix = localize('rainydays_JD_hold_prefix')
    card.joker_display_values.hand = localize(card.ability.extra.hand, 'poker_hands')
    card.joker_display_values.postfix = localize('rainydays_JD_hold_postfix')
    
    local spectral = 0
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
      local playing_hand = next(G.play.cards)
      local held_in_hand = {}
      for _, playing_card in ipairs(G.hand.cards) do
        if playing_hand or not playing_card.highlighted and playing_card.facing and playing_card.facing ~= 'back' then
          held_in_hand[#held_in_hand + 1] = playing_card
        end
      end
      
      local _, _, pokerhands = G.FUNCS.get_poker_hand_info(held_in_hand)
      spectral = next(pokerhands[card.ability.extra.hand]) and 1 or 0
    end
    card.joker_display_values.spectral = spectral
  end
}

jd_def['j_RainyDays_heirloom'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'bonus' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'mult' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  extra = {{
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'odds' },
    { text = ")" },
  }},
  extra_config = { colour = G.C.GREEN, scale = 0.3 },
  
  calc_function = function(card)
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    local count = 0
    if text ~= 'Unknown' then
      for _, scoring_card in pairs(scoring_hand) do
        if SMODS.has_enhancement(scoring_card, 'm_bonus') or SMODS.has_enhancement(scoring_card, 'm_mult') then
          
          local function find_position(card, hand)
            for i = 1, #hand do
              if hand[i] == card then
                return i
              end
            end
          end
          
          local pos = find_position(scoring_card, JokerDisplay.current_hand)
          if pos and JokerDisplay.current_hand[pos + 1] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.count = count
    
    local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    card.joker_display_values.odds = localize{ type = 'variable', key = 'jdis_odds', vars = { numerator, denominator }}
    
    card.joker_display_values.bonus = localize('rainydays_bonus')
    card.joker_display_values.mult = localize('rainydays_mult')
  end
}

jd_def['j_RainyDays_horseshoe'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'active', scale = active_message_scale }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local seven_found
    local unenhanced_found
    if G.GAME.facing_blind and not card.debuff then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
            seven_found = true
          end
          if scoring_card.ability.set ~= 'Enhanced' then
            unenhanced_found = true
          end
        end
      end
    end
    card.joker_display_values.active = (seven_found and unenhanced_found) and localize('rainydays_activated') or localize('rainydays_deactivated')
    card.joker_display_values.rank = localize(card.ability.extra.rank, 'ranks')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if text and text.children[1] then
      local seven_found
      local unenhanced_found
      if G.GAME.facing_blind and not card.debuff then
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
          for _, scoring_card in pairs(scoring_hand) do
            if scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
              seven_found = true
            end
            if scoring_card.ability.set ~= 'Enhanced' then
              unenhanced_found = true
            end
          end
        end
      end
      text.children[1].config.colour = (seven_found and unenhanced_found) and G.C.FILTER or G.C.UI.TEXT_INACTIVE
    end
  end
}

jd_def['j_RainyDays_instructional'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'count', colour = G.C.ORANGE },
    { text = "x" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.jokers then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card and not RainyDays.list_contains(card.ability.extra.old_jokers, G.jokers.cards[i].ability.rd_joker_id) then
          count = count + 1
        end
      end
    end
    
    card.joker_display_values.count = count
    card.joker_display_values.localized_text = localize('b_jokers')
  end,
  
  mod_function = function(card, mod_joker)
    return { chips = (mod_joker ~= card and not RainyDays.list_contains(mod_joker.ability.extra.old_jokers, card.ability.rd_joker_id)) and mod_joker.ability.extra.chips * JokerDisplay.calculate_joker_triggers(mod_joker) or nil }
  end
}

jd_def['j_RainyDays_joker_reject'] = {
  text = {
    { text = "+", colour = G.C.RED },
    { ref_table = 'card.ability.extra', ref_value = 'discards', colour = G.C.RED },
    { ref_table = 'card.joker_display_values', ref_value = 'discards' },
  },
  
  reminder_text = {
    { text = "(" },
    { text = "-" .. localize('$'), colour = G.C.GOLD },
    { ref_table = 'card.ability.extra', ref_value = 'money_pay', colour = G.C.GOLD },
    { ref_table = 'card.joker_display_values', ref_value = 'per_discard' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.discards = localize('rainydays_JD_discards')
    card.joker_display_values.per_discard = localize('rainydays_JD_per_discard')
  end
}

jd_def['j_RainyDays_jungle_jack'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.rank = localize(card.ability.extra.rank, 'ranks')
  end
}

jd_def['j_RainyDays_kimono'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { ref_table = 'card.joker_display_values', ref_value = 'in_deck' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
    card.joker_display_values.in_deck = localize('rainydays_JD_in_deck')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[2] then
      reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_kudzu'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'mult_current', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
}

jd_def['j_RainyDays_lady_in_waiting'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'faces', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.faces = localize('k_face_cards')
  end
}

jd_def['j_RainyDays_lady_of_the_lake'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'active', scale = active_message_scale }
  },
  
  calc_function = function(card)
    local active
    if G.GAME.facing_blind and not card.debuff then
      local _, _, scoring_hand = JokerDisplay.evaluate_hand()
      active = (#scoring_hand >= card.ability.extra.cards)
    end
    card.joker_display_values.active = active and localize('rainydays_activated') or localize('rainydays_deactivated')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if text and text.children[1] then
      local active
      if G.GAME.facing_blind and not card.debuff then
        local _, _, scoring_hand = JokerDisplay.evaluate_hand()
        active = (#scoring_hand >= card.ability.extra.cards)
      end
      text.children[1].config.colour = active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
    end
  end
}

jd_def['j_RainyDays_legions'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', colour = G.C.MULT }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text', colour = G.C.FILTER },
    { text = ")" }
  },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() <= 10 and scoring_card:get_id() >= 2 then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    card.joker_display_values.count = count
    card.joker_display_values.mult = "+1~5"
    card.joker_display_values.localized_text = localize('rainydays_JD_numbers')
  end
}

jd_def['j_RainyDays_letter_board'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },  
    
  calc_function = function(card)
    local function check_board()
      for i = 1, #JokerDisplay.current_hand do
        if JokerDisplay.current_hand[i]:get_id() <= 10 and JokerDisplay.current_hand[i]:get_id() >= 2 then
          return false
        end
      end
      return true
    end
    
    local chips = 0
    if G.GAME.facing_blind and #JokerDisplay.current_hand > 0 then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        local number_found = false
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() <= 10 and scoring_card:get_id() >= 2 then
            number_found = true
            break
          end
        end
        
        if not number_found then
          chips = card.ability.extra.plus_chips
        end
      end
    end
    
    card.joker_display_values.chips = chips
    card.joker_display_values.prefix = localize('rainydays_JD_no_prefix')
    card.joker_display_values.localized_text = string.len(card.joker_display_values.prefix) > 0 and string.lower(localize('rainydays_JD_numbers')) or localize('rainydays_JD_numbers')
    card.joker_display_values.postfix = localize('rainydays_JD_no_postfix')
  end
}

jd_def['j_RainyDays_lightning'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if SMODS.has_enhancement(scoring_card, 'm_mult') then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    card.joker_display_values.mult = localize('rainydays_mult')
    card.joker_display_values.xmult = card.ability.extra.xmult ^ count
  end
}

jd_def['j_RainyDays_long_road'] = {
  text = {
    { text = "+", colour = G.C.RED },
    { ref_table = 'card.joker_display_values', ref_value = 'count', colour = G.C.RED, retrigger_type = 'mult' },
    { ref_table = 'card.joker_display_values', ref_value = 'discards' },
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.discards = localize('rainydays_JD_discards')
    card.joker_display_values.hand = localize(card.ability.extra.hand, 'poker_hands')
    
    local _, poker_hands, _ = JokerDisplay.evaluate_hand()
    card.joker_display_values.count = (poker_hands[card.ability.extra.hand] and next(poker_hands[card.ability.extra.hand])) and card.ability.extra.discard_bonus or 0
  end
}

jd_def['j_RainyDays_lotteryticket'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 },
    { text = "+" .. localize('$'), colour = G.C.GOLD },
    { ref_table = 'card.ability.extra', ref_value = 'reward_money', colour = G.C.GOLD }
  },
  
  reminder_text = {
    { ref_table = 'card.joker_display_values', ref_value = 'string' }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    local count = 0
    if text ~= 'Unknown' then      
      for _, scoring_card in pairs(scoring_hand) do
        if not SMODS.has_no_rank(scoring_card) then
          local id = scoring_card:get_id()
          if not G.GAME.rd_ranks_scored_this_round[id] or G.GAME.rd_ranks_scored_this_round[id] <= 0 or (RainyDays.evaluating_play and RainyDays.list_contains(card.ability.extra.valid_ranks, id)) then
            local rank_count = 0
            local position_first
            for i = 1, #scoring_hand do
              if scoring_hand[i]:get_id() == id then
                rank_count = rank_count + 1
                position_first = position_first or i
              end
            end
          
            if position_first and scoring_card == scoring_hand[position_first] then
              count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
          end
        end
      end
    end
    
    card.joker_display_values.count = count
    card.joker_display_values.string = (string.len(card.ability.extra.string) > 0) and "(" .. card.ability.extra.string .. ")" or ""
  end
}

jd_def['j_RainyDays_membership_card'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { text = "-" .. localize('$'), colour = G.C.GOLD },
    { ref_table = 'card.ability.extra', ref_value = 'cost_reduction', colour = G.C.GOLD },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.prefix = localize('rainydays_JD_membership_prefix')
    card.joker_display_values.postfix = localize('rainydays_JD_membership_postfix')
  end
}

jd_def['j_RainyDays_metropolis'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'ex', colour = G.C.CLEAR },
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }},
    { ref_table = 'card.joker_display_values', ref_value = 'ex' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { text = " " },
    { ref_table = 'card.ability.extra', ref_value = 'activations' },
    { text = "/" },
    { ref_table = 'card.ability.extra', ref_value = 'amount_hands' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local ex = ""
    if not RainyDays.evaluating_play and G.GAME.facing_blind then
      local text = (JokerDisplay.evaluate_hand())
      if text and card.ability.extra.poker_hand == text then
        ex = " !"
      end
    end
    
    card.joker_display_values.ex = ex
    card.joker_display_values.xmult = card.ability.extra.activations > 0 and card.ability.extra.xmult or 1 
    card.joker_display_values.hand = localize(card.ability.extra.poker_hand, 'poker_hands')
  end
}

jd_def['j_RainyDays_minimalist'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
    
  calc_function = function(card)
    card.joker_display_values.chips = (G.jokers and G.jokers.config.card_limit > #G.jokers.cards) and card.ability.extra.chips or 0
  end
}

jd_def['j_RainyDays_mirror_lake'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'tarot', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.SECONDARY_SET['Tarot'] },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'glass' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.glass = localize('rainydays_glass')
    
    local tarot = G.GAME.facing_blind and hand_has_enhancement(JokerDisplay.current_hand, 'm_glass')
    card.joker_display_values.tarot = tarot and 1 or 0
  end,
}

jd_def['j_RainyDays_musketeers'] = {}

jd_def['j_RainyDays_orange'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    local mult = card.ability.extra.mult
    if not RainyDays.evaluating_play and #JokerDisplay.current_hand > 0 then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      local count = 0
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          count = count + 1
        end
        
        if count < 5 then
          mult = mult - card.ability.extra.malus_mult
        end
      end
    end
    card.joker_display_values.mult = math.max(0, mult)
  end
}

jd_def['j_RainyDays_origami'] = {
  text = {
    { text = "+$" },
    { ref_table = 'card.joker_display_values', ref_value = 'money' }
  },
  text_config = { colour = G.C.MONEY },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { ref_table = 'card.joker_display_values', ref_value = 'in_deck' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local amount = 0
    if G.deck and G.deck.cards then
      for i= 1, #G.deck.cards do
        if G.deck.cards[i]:is_suit(card.ability.extra.suit) then
          amount = amount + 1
        end
      end
    end
    
    card.joker_display_values.money = card.ability.extra.payout or (card.ability.extra.dollars * math.floor(amount / card.ability.extra.cards))
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
    card.joker_display_values.in_deck = localize('rainydays_JD_in_deck')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[2] then
      reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_overflow'] = {
  text = {
    { text = "+", colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'discards', colour = G.C.FILTER,  retrigger_type = 'mult' },
    { ref_table = 'card.joker_display_values', ref_value = 'text' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'localized_text' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local function discard_right_rank(hand)
      for _, playing_card in pairs(hand) do
        if playing_card.facing and playing_card.facing ~= 'back' and not playing_card.debuff then
          local id = playing_card:get_id()
          if id and (RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] == id or RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] == id) then
            return true
          end
        end
      end
    end
    
    card.joker_display_values.discards = G.GAME.facing_blind and discard_right_rank(G.hand.highlighted) and card.ability.extra.hand_size_bonus or 0
    card.joker_display_values.text = localize('rainydays_JD_hand_size')
    card.joker_display_values.localized_text = localize(card.ability.extra.rank1, 'ranks') .. ", " .. localize(card.ability.extra.rank2, 'ranks')
    
  end
}

jd_def['j_RainyDays_parrot'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'text', scale = 0.35 }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'copying', colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8) },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local next_joker
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i] == card then 
        next_joker = G.jokers.cards[i + 1]
      end
    end
    
    local text
    if next_joker and next_joker.config.center.blueprint_compat then
      if not RainyDays.parrot_copied_before(card, next_joker) then
        text = localize('k_compatible')
      else
        local rounds_remain = card.ability.extra.copied_before[next_joker.ability.rd_joker_id] + card.ability.extra.round_limit - card.ability.extra.round + 1
        if rounds_remain > 1 then
          text = localize('rainydays_parrot_wait_prefix_plural') .. rounds_remain .. localize('rainydays_parrot_wait_postfix_plural')
        else
          text = localize('rainydays_parrot_wait_prefix_singular') .. rounds_remain .. localize('rainydays_parrot_wait_postfix_singular')
        end
      end
    else
      text = localize('k_incompatible')
    end
    
    card.joker_display_values.text = string.upper(string.sub(text, 1, 1)) .. string.sub(text, 2)
    local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
    card.joker_display_values.copying = localize('rainydays_JD_not_copying')
    JokerDisplay.copy_display(card, copied_joker, copied_debuff)
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if text and text.children[1] then
      if card.debuff then
        text.children[1].config.colour = G.C.UI.TEXT_INACTIVE
        return
      end
      
      local next_joker
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then 
          next_joker = G.jokers.cards[i + 1]
        end
      end
      local compatible = next_joker and next_joker.config.center.blueprint_compat and not RainyDays.parrot_copied_before(card, next_joker)
      text.children[1].config.colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
    end
  end,
  
  get_blueprint_joker = function(card)
    if card.ability.extra.other_joker_id then
      local other_joker
      for i = 1, #G.jokers.cards do
        if card.ability.extra.other_joker_id == G.jokers.cards[i].ability.rd_joker_id then
          return G.jokers.cards[i]
        end
      end
    end
  end
}

jd_def['j_RainyDays_pigeon'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  }
}

jd_def['j_RainyDays_plump_joker'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    card.joker_display_values.mult = (G.GAME.rd_consumeable_usage_ante or 0) * card.ability.extra.per_mult
  end
}

jd_def['j_RainyDays_polished_joker'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  }
}

jd_def['j_RainyDays_prairie'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local mult = card.ability.extra.current_mult
    if not RainyDays.evaluating_play and #JokerDisplay.current_hand > 0 then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' and G.GAME.current_round.RD_prairie_poker_hand ~= text then
        mult = mult + card.ability.extra.mult_gain
      end
    end
    
    card.joker_display_values.mult = math.max(0, mult)
    card.joker_display_values.prefix = localize('rainydays_JD_no_prefix')
    card.joker_display_values.hand = localize(G.GAME.current_round.RD_prairie_poker_hand, 'poker_hands')
    card.joker_display_values.postfix = localize('rainydays_JD_no_postfix')
  end
}

jd_def['j_RainyDays_prehistory'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  }
}

jd_def['j_RainyDays_primality'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank3' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank4' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.rank1 = localize(card.ability.extra.rank1, 'ranks') 
    card.joker_display_values.rank2 = localize(card.ability.extra.rank2, 'ranks')
    card.joker_display_values.rank3 = localize(card.ability.extra.rank3, 'ranks')
    card.joker_display_values.rank4 = localize(card.ability.extra.rank4, 'ranks')
  end
}

jd_def['j_RainyDays_purple_card'] = {}

jd_def['j_RainyDays_quasar'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local xmult = card.ability.extra.xmult
    if  G.GAME.blind and G.GAME.blind.in_blind and not RainyDays.evaluating_play and #JokerDisplay.current_hand > 0 then
      local text = (JokerDisplay.evaluate_hand())
      if text and G.GAME.hands[text] and G.GAME.hands[text].level >= card.ability.extra.min_level then
        xmult = xmult + card.ability.extra.xmult_gain
      end
    end
    card.joker_display_values.xmult = xmult
  end
}

jd_def['j_RainyDays_queue'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.rank1 = localize(card.ability.extra.rank1, 'ranks') 
    card.joker_display_values.rank2 = localize(card.ability.extra.rank2, 'ranks')
  end,
  
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if playing_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or playing_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
      if held_in_hand then 
        return joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
      else
        return JokerDisplay.in_scoring(playing_card, scoring_hand) and joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
      end
    end
  end
}

jd_def['j_RainyDays_receipt'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'current_mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'money_spent' },
    { text = "/" },
    { ref_table = 'card.ability.extra', ref_value = 'money_border' },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.money_spent = math.min(card.ability.extra.money_spent, card.ability.extra.money_border)
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text then
      for i = 2, 4 do
        if reminder_text.children[i] then
          reminder_text.children[i].config.colour = (card.ability.extra.money_spent >= card.ability.extra.money_border) and G.C.GREEN or G.C.UI.TEXT_INACTIVE
        end
      end
      for i = 1, #reminder_text.children do
        reminder_text.children[i].config.scale = G.shop and not G.shop.REMOVED and reminder_text_scale or 0
      end
    end
  end
}

jd_def['j_RainyDays_recycle'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count' },
    { text = "x", scale = 0.35 },
    { text = "+", colour = G.C.MULT },
    { ref_table = 'card.ability.extra', ref_value = 'bonus_mult', colour = G.C.MULT, retrigger_type = 'mult' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank3' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank4' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    local hand = G.hand.highlighted
    for _, playing_card in pairs(hand) do
      if playing_card.facing and not (playing_card.facing == 'back') and RainyDays.is_valid_recycle(playing_card, card) then
        count = count + 1
      end
    end
    card.joker_display_values.count = G.GAME.current_round.discards_left > 0 and (card.ability.extra.cards_recycled and #card.ability.extra.cards_recycled or count) or 0
    
    card.joker_display_values.rank1 = localize(card.ability.extra.rank1, 'ranks') 
    card.joker_display_values.rank2 = localize(card.ability.extra.rank2, 'ranks')
    card.joker_display_values.rank3 = localize(card.ability.extra.rank3, 'ranks')
    card.joker_display_values.rank4 = localize(card.ability.extra.rank4, 'ranks')
  end
}

jd_def['j_RainyDays_report_card'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local xmult = card.ability.extra.xmult_base + card.ability.extra.xmult_extra * (G.GAME.rd_ranks_scored_this_ante[RainyDays.balatro_ranks_to_id[card.ability.extra.rank]] or 0)
    if not RainyDays.evaluating_play and #JokerDisplay.current_hand > 0 then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in ipairs(scoring_hand) do
          local id = scoring_card:get_id()
          if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
            xmult = xmult + card.ability.extra.xmult_extra * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.xmult = xmult
    card.joker_display_values.rank = localize(card.ability.extra.rank, 'ranks')
  end
}

jd_def['j_RainyDays_return_to_sender'] = {  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'copying', colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8) },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
    card.joker_display_values.copying = localize('rainydays_JD_not_copying')
    JokerDisplay.copy_display(card, copied_joker, copied_debuff)
  end,
  
  get_blueprint_joker = function(card)
    local other_joker
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i].config.center.key ~= card.config.center.key and G.jokers.cards[i].config.center.blueprint_compat and G.jokers.cards[i].ability.rd_joker_id and not G.jokers.cards[i].debuff then
        if not other_joker or G.jokers.cards[i].ability.rd_joker_id > other_joker.ability.rd_joker_id then
          other_joker = G.jokers.cards[i]
        end
      end
    end
    return other_joker
  end
}

jd_def['j_RainyDays_roller_skates'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'ex', colour = G.C.CLEAR },
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }},
    { ref_table = 'card.joker_display_values', ref_value = 'ex' }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },    
  
  calc_function = function(card)
    card.joker_display_values.hand = localize(card.ability.extra.hand, 'poker_hands')
    local active = RainyDays.skates_check_active(card)
    local ex = ""
    if not active and G.GAME.current_round.discards_left > 0 and not RainyDays.evaluating_play and G.GAME.facing_blind then
      local text = (JokerDisplay.evaluate_hand())
      if text and card.ability.extra.hand == text then
        ex = " !"
      end
    end
    
    card.joker_display_values.ex = ex
    card.joker_display_values.xmult = active and card.ability.extra.xmult or 1
  end
}

jd_def['j_RainyDays_secret_agent'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank1' },
    { text = ", " },
    { ref_table = 'card.joker_display_values', ref_value = 'rank2' },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      local cards_played = 0
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          local id = scoring_card:get_id()
          if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    card.joker_display_values.mult = count * card.ability.extra.mult
    card.joker_display_values.rank1 = localize(card.ability.extra.rank1, 'ranks')
    card.joker_display_values.rank2 = localize(card.ability.extra.rank2, 'ranks')
  end
}

jd_def['j_RainyDays_self_assembly'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT }
}

jd_def['j_RainyDays_serial'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        local suit_count = 0
        local suits_used = {}
        for _, scoring_card in pairs(scoring_hand) do
          if not SMODS.has_no_suit(scoring_card) and not scoring_card.debuff then
            if SMODS.has_any_suit(scoring_card) then
              suit_count = suit_count + 1
              count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            else
              for key in pairs(SMODS.Suits) do
                if scoring_card:is_suit(key) and not suits_used[key] then
                  suits_used[key] = true
                  suit_count = suit_count + 1
                  count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                  break
                end
              end
            end
          end
          
          if #suits_used >= G.GAME.rd_suit_count then
            break
          end
        end
      end
    end
    
    card.joker_display_values.chips = card.ability.extra.chips * count
  end
}

jd_def['j_RainyDays_sextant'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    local dif = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' and #scoring_hand >= 2 then
        local first_card
        for i = 1, #scoring_hand do
          if not SMODS.has_no_rank(scoring_hand[i]) then
            first_card = i
            break
          end
        end
      
        if first_card then
          local high = scoring_hand[first_card]:get_id() 
          local low = scoring_hand[first_card]:get_id()
          for i = first_card + 1, #scoring_hand do
            if not SMODS.has_no_rank(scoring_hand[i]) then
              local id = scoring_hand[i]:get_id()
              high = (id > high) and id or high
              low = (id < low) and id or low
            end
          end
          dif = math.max((high - low) - 1, 0)
        end
      end
    end
    
    card.joker_display_values.mult = card.ability.extra.mult_amount * dif
  end
}

jd_def['j_RainyDays_shooting_star'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'hand', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local chips = 0
    if G.GAME.facing_blind then
      local _, poker_hands, _ = JokerDisplay.evaluate_hand()
      if poker_hands[card.ability.extra.hand] and next(poker_hands[card.ability.extra.hand]) then
        chips = card.ability.extra.chips_rewards
      end
    end
    card.joker_display_values.chips = chips
    card.joker_display_values.hand = localize(card.ability.extra.hand, 'poker_hands')
  end
}

jd_def['j_RainyDays_simple_joker'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.joker_display_values', ref_value = 'enhancements', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.prefix = localize('rainydays_JD_no_prefix')
    card.joker_display_values.enhancements = string.len(card.joker_display_values.prefix) > 0 and string.lower(localize('rainydays_JD_enhancements')) or localize('rainydays_JD_enhancements')
    card.joker_display_values.postfix = localize('rainydays_JD_no_postfix')
    
    local mult = 0
    if G.GAME.facing_blind and #JokerDisplay.current_hand > 0 then
      local enhancement_found = false
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if next(SMODS.get_enhancements(scoring_card)) then
            enhancement_found = true
            break
          end
        end
        if not enhancement_found then
          mult = card.ability.extra.mult
        end
      end
    end
    card.joker_display_values.mult = mult
  end
}

jd_def['j_RainyDays_sketch_pad'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local table = {}
    for key in pairs(G.GAME.rd_enhancements_scored_this_ante) do
      table[key] = true
    end
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          local enhancements = SMODS.get_enhancements(scoring_card)
          for key in pairs(enhancements) do
            table[key] = true
          end
        end
      end
    end
    
    local count = 0
    for key in pairs(table) do
      count = count + 1
    end
    
    card.joker_display_values.xmult = card.ability.extra.xmult_base + card.ability.extra.xmult * count
  end
}

jd_def['j_RainyDays_skinner_box'] = {  
  reminder_text = {
    { text = "(" },
    { text = '$', colour = G.C.GOLD },
    { ref_table = 'card', ref_value = 'sell_cost', colour = G.C.GOLD },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  extra = {{
    { ref_table = 'card.joker_display_values', ref_value = 'set_to' },
    { ref_table = 'card.joker_display_values', ref_value = 'text', colour = G.C.GOLD }
  }},
  extra_config = { scale = 0.3 },
  
  calc_function = function(card)
    card.joker_display_values.set_to = localize('rainydays_JD_set_to')
    card.joker_display_values.text = localize('$') .. card.ability.extra.money_low .. "~" .. card.ability.extra.money_high
  end,
}

jd_def['j_RainyDays_slashed_joker'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'active', scale = active_message_scale }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.ability.extra', ref_value = 'cards_amount', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if held_in_hand or #JokerDisplay.current_hand > joker_card.ability.extra.cards_amount then 
      return 0 
    end
    return JokerDisplay.in_scoring(playing_card, scoring_hand) and joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end,
  
  calc_function = function(card)
    card.joker_display_values.prefix = localize('rainydays_JD_slashed_joker_prefix')
    local active = (G.GAME.facing_blind and #JokerDisplay.current_hand > 0 and #JokerDisplay.current_hand <= card.ability.extra.cards_amount)
    card.joker_display_values.active = active and localize('rainydays_activated') or localize('rainydays_deactivated')
    card.joker_display_values.postfix = localize('rainydays_JD_slashed_joker_postfix')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if text and text.children[1] then
      local active = (G.GAME.facing_blind and not card.debuff and #JokerDisplay.current_hand > 0 and #JokerDisplay.current_hand <= card.ability.extra.cards_amount)
      text.children[1].config.colour = active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
    end
  end
}

jd_def['j_RainyDays_snow_shovel'] = {
  text = {
    { text = "+", colour = G.C.CHIPS },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', colour = G.C.CHIPS },
    { text = " (", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { ref_table = 'card.ability.extra', ref_value = 'scored_counter', scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { text = "/", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { ref_table = 'card.ability.extra', ref_value = 'per_scored', scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { text = ")", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'scored' },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.scored = localize('rainydays_JD_scored')
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
    
    local chips = card.ability.extra.chip_current
    local count = card.ability.extra.scored_counter
    if G.GAME.facing_blind and not RainyDays.evaluating_play then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:is_suit(card.ability.extra.suit) then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    
    card.joker_display_values.chips = chips + card.ability.extra.chip_bonus * math.floor(count / card.ability.extra.per_scored)
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[3] then
      reminder_text.children[3].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_spire'] = {
  text = {
    { text = "+" .. localize('$') },
    { ref_table = 'card.ability.extra', ref_value = 'payout' }
  },
  text_config = { colour = G.C.GOLD },
  
  reminder_text = {
    { ref_table = 'card.joker_display_values', ref_value = 'round' }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  extra = {{
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'odds' },
    { text = ")" },
  }},
  extra_config = { colour = G.C.GREEN, scale = 0.3 },
  
  calc_function = function(card)
    local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    card.joker_display_values.odds = localize{ type = 'variable', key = 'jdis_odds', vars = { numerator, denominator }}
    card.joker_display_values.round = "(" .. localize('k_round') .. ")"
  end
}

jd_def['j_RainyDays_spooky_joker'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local amount = 0
    for _, value in ipairs(G.handlist) do
      if G.GAME.hands[value].rd_secret and G.GAME.hands[value].played > 0 then
        amount = amount + 1
      end
    end
    
    if not RainyDays.evaluating_play and G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if G.GAME.hands[text] and G.GAME.hands[text].rd_secret and G.GAME.hands[text].played <= 0 then
        amount = amount + 1
      end
    end
    
    card.joker_display_values.xmult = RainyDays.Round(1 + amount * card.ability.extra.Xmult, 2)
  end
}

jd_def['j_RainyDays_sputnik'] = {
  text = {
    { text = "+", colour = G.C.SECONDARY_SET['Tarot'] },
    { ref_table = 'card.joker_display_values', ref_value = 'tarot', colour = G.C.SECONDARY_SET['Tarot'], retrigger_type = 'mult' },
    { text = " -$", colour = G.C.MONEY },
    { ref_table = 'card.joker_display_values', ref_value = 'money', colour = G.C.MONEY, retrigger_type = 'mult' }
  },
  
  calc_function = function(card)
    local tarot = 0
    if G.GAME.facing_blind then
      local text = JokerDisplay.evaluate_hand()
      if G.GAME.hands[text] and (G.GAME.hands[text].played_this_ante == 0 or (RainyDays.evaluating_play and G.GAME.hands[text].played_this_ante == 1)) then
        tarot = 1
      end
    end
    
    card.joker_display_values.tarot = tarot
    card.joker_display_values.money = tarot * card.ability.extra.dollar
  end
}

jd_def['j_RainyDays_squiggle_joker'] = {
  text = {
    { text = "+" .. localize('$') },
    { ref_table = 'card.joker_display_values', ref_value = 'money', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.GOLD },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'prefix' },
    { ref_table = 'card.ability.extra', ref_value = 'suit_amount', colour = G.C.FILTER },
    { ref_table = 'card.joker_display_values', ref_value = 'postfix' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.prefix = localize('rainydays_JD_squiggle_joker_prefix')
    card.joker_display_values.postfix = localize('rainydays_JD_squiggle_joker_postfix')
    
    local count = 0
    if G.GAME.facing_blind and #JokerDisplay.current_hand > 0 then
      local playing_hand = next(G.play.cards)
      local held_in_hand = {}
      for _, playing_card in ipairs(G.hand.cards) do
        if playing_hand or not playing_card.highlighted then
          if (playing_card.facing and playing_card.facing == 'back') or SMODS.has_any_suit(playing_card) then
            card.joker_display_values.money = 0
            return
          end
          
          held_in_hand[#held_in_hand + 1] = playing_card
        end
      end
      
      local suits = {}
      for i = 1, #held_in_hand do
        if not SMODS.has_no_suit(held_in_hand[i]) then
          for key in pairs(SMODS.Suits) do
            if held_in_hand[i]:is_suit(key, true) then
              suits[key] = true
            end
          end
        end
      end
      
      for key in pairs(SMODS.Suits) do
        if suits[key] then
          count = count + 1
        end
      end
    end
      
    card.joker_display_values.money = (count == card.ability.extra.suit_amount) and card.ability.extra.money_bonus or 0
  end
}

jd_def['j_RainyDays_star_chart'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  calc_function = function(card)
    local amount = G.GAME.consumeable_usage_total and (RainyDays.Constellations and G.GAME.consumeable_usage_total.cn_constellation or G.GAME.consumeable_usage_total.planet) or 0
    card.joker_display_values.chips  = card.ability.extra.chip_amount * amount
  end
}

jd_def['j_RainyDays_starting_line'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  calc_function = function(card)
    local xmult = 1
    if G.GAME.facing_blind then
      local text = (JokerDisplay.evaluate_hand())
      if G.GAME.hands[text] and G.GAME.hands[text].played < card.ability.extra.amount then
        xmult = card.ability.extra.Xmult
      elseif G.GAME.hands[text] and G.GAME.hands[text].played == card.ability.extra.amount and RainyDays.evaluating_play then
        xmult = card.ability.extra.Xmult
      end
    end
    
    card.joker_display_values.xmult = xmult
  end
}

jd_def['j_RainyDays_tessen'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { ref_table = 'card.joker_display_values', ref_value = 'in_deck' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local amount = 0
    if G.deck and G.deck.cards then
      for i= 1, #G.deck.cards do
        if G.deck.cards[i]:is_suit(card.ability.extra.suit) then
          amount = amount + 1
        end
      end
    end
    
    card.joker_display_values.chips = card.ability.extra.chips * math.floor(amount / card.ability.extra.cards)
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
    card.joker_display_values.in_deck = localize('rainydays_JD_in_deck')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[2] then
      reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_theater'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'faces', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local playing_hand = next(G.play.cards)
      for _, playing_card in ipairs(G.hand.cards) do
        if playing_hand or not playing_card.highlighted then
          if playing_card.facing ~= 'back' and not playing_card.debuff and playing_card:is_face() then
            count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
          end
        end
      end
    end
    card.joker_display_values.mult = card.ability.extra.mult * count
    card.joker_display_values.faces = localize('k_face_cards')
  end
}

jd_def['j_RainyDays_throne'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.joker_display_values', ref_value = 'xmult', retrigger_type = 'exp' }
    }}
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'faces', colour = G.C.FILTER },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.xmult = card.ability.extra.active and card.ability.extra.xmult or 1
    card.joker_display_values.faces = localize('k_face_cards')
  end
}

jd_def['j_RainyDays_trading_stamps'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.ability.extra', ref_value = 'money_spent' },
    { text = "/" },
    { ref_table = 'card.ability.extra', ref_value = 'money_border' },
    { text = " " },
    { text = "$", colour = G.C.GOLD },
    { ref_table = 'card', ref_value = 'sell_cost', colour = G.C.GOLD },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
}

jd_def['j_RainyDays_train_ticket'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    local mult = card.ability.extra.current_mult
    
    if not RainyDays.evaluating_play then
      local hand = {}
      for i = 1, #JokerDisplay.current_hand do
        if JokerDisplay.current_hand[i].facing and JokerDisplay.current_hand[i].facing ~= 'back' then
          hand[#hand + 1] = JokerDisplay.current_hand[i]
        end
      end
      
      if RainyDays.check_for_three_row(hand) then
        mult = mult + card.ability.extra.mult_gain
      end
    end
    card.joker_display_values.mult = math.max(0, mult)
  end
}

jd_def['j_RainyDays_truffle'] = {
  text = {
    { border_nodes = {
      { text = "X" },
      { ref_table = 'card.ability.extra', ref_value = 'xmult_amount', retrigger_type = 'exp' }
    }}
  }
}

jd_def['j_RainyDays_wanted'] = {
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'tarot', colour = G.C.FILTER },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.tarot = localize{ type = 'name_text', set = 'Joker', key = G.GAME.current_round.RD_wanted_name_key }
  end  
}

jd_def['j_RainyDays_waveform'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  extra = {{
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'odds' },
    { text = ")" },
  }},
  extra_config = { colour = G.C.GREEN, scale = 0.3 },
  
  calc_function = function(card)
    local count = 0
    
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand) - 1
        end
      end
    end
    
    card.joker_display_values.mult = card.ability.extra.mult_amount * count
    
    local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    card.joker_display_values.odds = localize{ type = 'variable', key = 'jdis_odds', vars = { numerator, denominator }}
  end
}

jd_def['j_RainyDays_whirlpool'] = {}

jd_def['j_RainyDays_windowsill'] = {
  text = {
    { text = "+", colour = G.C.SECONDARY_SET['Spectral'] },
    { ref_table = 'card.joker_display_values', ref_value = 'spectral', colour = G.C.SECONDARY_SET['Spectral'], retrigger_type = 'mult' },
    { text = " (", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { ref_table = 'card.ability.extra', ref_value = 'held_counter', scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { text = "/", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { ref_table = 'card.ability.extra', ref_value = 'per_held', scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE },
    { text = ")", scale = counter_scale, colour = G.C.UI.TEXT_INACTIVE }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'held' },
    { ref_table = 'card.joker_display_values', ref_value = 'suit' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    local spectral = 0
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
      local playing_hand = next(G.play.cards)
      local count = 0
      for _, playing_card in ipairs(G.hand.cards) do
        if playing_hand or not playing_card.highlighted and playing_card.facing and playing_card.facing ~= 'back' and playing_card:is_suit(card.ability.extra.suit) and not playing_card.debuff then
          count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
        end
      end
      
      spectral = math.floor((card.ability.extra.held_counter + count) / card.ability.extra.per_held)
    end
    
    card.joker_display_values.spectral = spectral
    card.joker_display_values.held = localize('rainydays_JD_held')
    card.joker_display_values.suit = localize(card.ability.extra.suit, 'suits_plural')
  end,
  
  style_function = function(card, text, reminder_text, extra)
    if reminder_text and reminder_text.children[3] then
      reminder_text.children[3].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
    end
  end
}

jd_def['j_RainyDays_wishbone'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.ability.extra', ref_value = 'chips', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.CHIPS },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'tarot', colour = G.C.SECONDARY_SET['Tarot'] },
    { text = ")" },
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  calc_function = function(card)
    card.joker_display_values.tarot = localize{ type = 'name_text', set = 'Tarot', key = G.GAME.current_round.RD_wishbone }
  end
}

jd_def['j_RainyDays_wuxing'] = {
  text = {
    { ref_table = 'card.joker_display_values', ref_value = 'count', retrigger_type = 'mult' },
    { text = "x", scale = 0.35 },
    { ref_table = 'card.joker_display_values', ref_value = 'tag', colour = G.C.FILTER }
  },
  
  reminder_text = {
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'rank' },
    { text = ")" }
  },
  reminder_text_config = { scale = reminder_text_scale },
  
  extra = {{
    { text = "(" },
    { ref_table = 'card.joker_display_values', ref_value = 'odds' },
    { text = ")" },
  }},
  extra_config = { colour = G.C.GREEN, scale = 0.3 },
  
  calc_function = function(card)
    local count = 0
    if G.GAME.facing_blind then
      local text, _, scoring_hand = JokerDisplay.evaluate_hand()
      if text ~= 'Unknown' then
        for _, scoring_card in pairs(scoring_hand) do
          if scoring_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
            count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
          end
        end
      end
    end
    card.joker_display_values.count = count
    card.joker_display_values.tag = localize('rainydays_JD_tag')
    
    local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator_in, card.ability.extra.denominator_in)
    card.joker_display_values.odds = localize{ type = 'variable', key = 'jdis_odds', vars = { numerator, denominator }}
    
    card.joker_display_values.rank = localize(card.ability.extra.rank, 'ranks')
  end
}

jd_def['j_RainyDays_xylophone'] = {
  text = {
    { text = "+" },
    { ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult' }
  },
  text_config = { colour = G.C.MULT },
  
  calc_function = function(card)
    local count = 0
    
    for _, value in ipairs(G.handlist) do
      if G.GAME.hands[value].played > 0 then
        count = count + 1
      end
    end
    
    if G.GAME.blind and G.GAME.blind.in_blind then
      local text = (JokerDisplay.evaluate_hand())
      if text and G.GAME.hands[text] and G.GAME.hands[text].played == 0 then
        count = count + 1
      else
        math.max(count, 1)
      end
    end
    
    card.joker_display_values.mult = count * card.ability.extra.mult
  end
}