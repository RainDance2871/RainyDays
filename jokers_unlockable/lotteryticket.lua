SMODS.Joker {
  key = 'lotteryticket',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('lotteryticket'),
  config = {
    extra = {
      reward_money = 4
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local second_rank = localize(G.GAME.current_round.RD_lotteryticket[2], 'ranks')
    return {
      key = string.len(second_rank) >= 3 and 'j_RainyDays_lotteryticket_long' or 'j_RainyDays_lotteryticket_short',
      vars = {
        localize(G.GAME.current_round.RD_lotteryticket[1], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[2], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[3], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[4], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[5], 'ranks'),
        card.ability.extra.reward_money
      }
    }
  end,
  
  set_ability = function(self, card, initial, delay_sprites)
    RainyDays.generate_lottery_string(card)
    RainyDays.generate_lottery_string_sprite(card)
  end,
  
  set_sprites = function(self, card, front)
    if card.ability then
      RainyDays.generate_lottery_string(card)
      RainyDays.generate_lottery_string_sprite(card, true)
    end
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint and context.after then
      G.E_MANAGER:add_event(Event({
        func = function()
          RainyDays.generate_lottery_string(card)
          RainyDays.generate_lottery_string_sprite(card)
          return true
        end
      }))
    end
    
    local function is_lottery_rank(card)
      for i = 1, #G.GAME.current_round.RD_lotteryticket do 
        if RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_lotteryticket[i]] == card:get_id() then
          return true
        end
      end
      return false
    end
      
    --check if rank is special and has been played yet.
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      if not SMODS.has_no_rank(context.other_card) and is_lottery_rank(context.other_card) then        
        local rank_count = 0
        local position_first
        for i = 1, #context.scoring_hand do
          if context.scoring_hand[i]:get_id() == context.other_card:get_id() then
            rank_count = rank_count + 1
            if not position_first then
              position_first = i
            end
          end
        end
        
        if position_first and context.other_card == context.scoring_hand[position_first] then
          if G.GAME.rd_ranks_scored_this_round[context.other_card:get_id()] and G.GAME.rd_ranks_scored_this_round[context.other_card:get_id()] <= rank_count then
            return {
              func = function()
                ease_dollars(card.ability.extra.reward_money)
              end,
              message_card = context.blueprint_card or card,
              message = localize('$') .. card.ability.extra.reward_money,
              colour = G.C.MONEY
            }
          end
        end
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME.rd_lucky_trigger_count or 0) or nil,
      vars = { 10 }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'rd_lucky_trigger_count' and G.GAME.rd_lucky_trigger_count and G.GAME.rd_lucky_trigger_count >= 10
  end
}

--this function updates the listed ranks every round.
function RainyDays.reset_game_globals_lotteryticket()  
  --add ranks from cards in deck to pool for picking, ranks can be added multiple times, so more common ranks get chosen more often
  local ranks_in_deck = {}
  if G.playing_cards then
    for i = 1, #G.playing_cards do
      if not SMODS.has_no_rank(G.playing_cards[i]) then
        ranks_in_deck[#ranks_in_deck + 1] = G.playing_cards[i].base.id --numbers from 14 to 2, converting to proper ranks later.
      end
    end
	end
  
  --pick ranks five times, removing ranks already chosen.
  local picked_ranks = {}
  local unchosen_ranks = { 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 } --second list of all unchosen options, only used if first list is empty
  for i = 1, #G.GAME.current_round.RD_lotteryticket do
    if ranks_in_deck[1] then
      picked_ranks[i] = pseudorandom_element(ranks_in_deck, pseudoseed('Lottery' .. G.GAME.round_resets.ante))
      RainyDays.remove_by_value(ranks_in_deck, picked_ranks[i])
      RainyDays.remove_by_value(unchosen_ranks, picked_ranks[i])
    else --If no possible ranks left in deck, pick from all unchosen ranks.
      picked_ranks[i] = pseudorandom_element(unchosen_ranks, pseudoseed('Lottery' .. G.GAME.round_resets.ante))
      RainyDays.remove_by_value(unchosen_ranks, picked_ranks[i])
    end
  end
  ranks_in_deck = nil
  unchosen_ranks = nil
  
  --order the ranks chosen from ace to 2
  table.sort(picked_ranks, function(a,b) return a > b end)
  
  --now convert our ids to the ranks and set them as values.
  for i = 1, #G.GAME.current_round.RD_lotteryticket do
    if picked_ranks[i] <= 10 then
      G.GAME.current_round.RD_lotteryticket[i] = tostring(picked_ranks[i])
    elseif picked_ranks[i] == 11 then
      G.GAME.current_round.RD_lotteryticket[i] = 'Jack'
    elseif picked_ranks[i] == 12 then
      G.GAME.current_round.RD_lotteryticket[i] = 'Queen'
    elseif picked_ranks[i] == 13 then
      G.GAME.current_round.RD_lotteryticket[i] = 'King'
    elseif picked_ranks[i] == 14 then
      G.GAME.current_round.RD_lotteryticket[i] = 'Ace'
    end
  end
  picked_ranks = nil
  
  local table = SMODS.find_card('j_RainyDays_lotteryticket', true)
  for i = 1, #table do
    RainyDays.generate_lottery_string(table[i])
    RainyDays.generate_lottery_string_sprite(table[i])
  end
end

function RainyDays.generate_lottery_string(card)
  local string = ''
  for i = 1, #G.GAME.current_round.RD_lotteryticket do
    local rank = RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_lotteryticket[i]]
    if not G.GAME.rd_ranks_scored_this_round[rank] or G.GAME.rd_ranks_scored_this_round[rank] <= 0 then
      local sub = string.sub(G.GAME.current_round.RD_lotteryticket[i], 1, 1)
      string = string .. (sub ~= '1' and sub or '10') .. (i < #G.GAME.current_round.RD_lotteryticket and ' ' or '')
    end
  end
  
  if string == '' then
    string = localize('rainydays_full_clear')
  end
  
  card.ability.lottery_string = string
end

function RainyDays.generate_lottery_string_sprite(card, force)
  if not card.canvas_text then
    card.canvas_text = SMODS.CanvasSprite({
      text_colour = G.C.UI.TEXT_DARK,
      text_offset = { x = 36, y = 47 },
      text_width = 49,
      text_height = 11
    })
  end
  card.canvas_text.text = card.ability.lottery_string
end