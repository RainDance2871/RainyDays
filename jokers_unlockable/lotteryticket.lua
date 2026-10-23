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
  rd_canvas_drawing = true,
  rd_canvas_text = {
    offset = { x = 36, y = 47 },
    align = { h = 'center', v = 'middle' },
    width = 49,
    height = 11
  },
  attributes = { 'economy' },
  
  config = {
    extra = {
      reward_money = 4,
      string = ""
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local colours = {}
    for i = 1, 5 do
      local id = RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_lotteryticket[i]]
      colours[i] = (G.GAME.rd_ranks_scored_this_round[id] and G.GAME.rd_ranks_scored_this_round[id] > 0) and G.C.UI.TEXT_INACTIVE or G.C.FILTER
    end
    
    local second_rank = localize(G.GAME.current_round.RD_lotteryticket[2], 'ranks')
    return {
      key = string.len(second_rank) >= 3 and 'j_RainyDays_lotteryticket' or 'j_RainyDays_lotteryticket_short',
      vars = {
        colours = colours,
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
  end,
  
  set_sprites = function(self, card, front)
    if card.ability then
      RainyDays.generate_lottery_string(card)
    end
  end,
  
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      card.ability.extra.valid_ranks = {}
      for i = 1, #G.GAME.current_round.RD_lotteryticket do 
        local id = RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_lotteryticket[i]]
        if not G.GAME.rd_ranks_scored_this_round[id] or G.GAME.rd_ranks_scored_this_round[id] <= 0 then
          card.ability.extra.valid_ranks[#card.ability.extra.valid_ranks + 1] = id
        end
      end
    end
    
    if context.individual and context.cardarea == G.play and not context.other_card.debuff and not SMODS.has_no_rank(context.other_card) then
      local id = context.other_card:get_id()
      if RainyDays.list_contains(card.ability.extra.valid_ranks, id) then
        local rank_count = 0
        local position_first
        for i = 1, #context.scoring_hand do
          if context.scoring_hand[i]:get_id() == id and not context.scoring_hand[i].debuff then
            rank_count = rank_count + 1
            position_first = position_first or i
          end
        end
        
        if position_first and context.other_card == context.scoring_hand[position_first] then
          return {
            dollars = card.ability.extra.reward_money
          }
        end
      end
    end
    
    if context.after and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          card.ability.extra.valid_ranks = nil
          RainyDays.generate_lottery_string(card)
          return true
        end
      }))
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME.rd_lucky_trigger_count or 0) or nil,
      vars = {
        7 
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'rd_lucky_trigger_count' and G.GAME.rd_lucky_trigger_count and G.GAME.rd_lucky_trigger_count >= 7
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
  end
end

function RainyDays.generate_lottery_string(card)
  local string = ''
  for i = 1, #G.GAME.current_round.RD_lotteryticket do
    local rank = RainyDays.balatro_ranks_to_id[G.GAME.current_round.RD_lotteryticket[i]]
    if not G.GAME.rd_ranks_scored_this_round[rank] or G.GAME.rd_ranks_scored_this_round[rank] <= 0 then
      local sub = string.sub(G.GAME.current_round.RD_lotteryticket[i], 1, 1)
      string = string .. (sub ~= '1' and sub or '10') .. " "
    end
  end
  string = string.sub(string, 1, -2)
  
  card.ability.extra.string = string.gsub(string, " ", ", ")
  
  if string.len(string) <= 0 then
    string = localize('rainydays_lotteryticket_full_clear')
  end
  
  card.config.center.rd_canvas_text.text = string
end