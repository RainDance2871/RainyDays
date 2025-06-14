SMODS.Joker {
  key = 'lotteryticket',
  name = 'Lottery Ticket',
  atlas = 'RainyDays',
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('lotteryticket'),
  config = {
    reward_money = 10
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(G.GAME.current_round.RD_lotteryticket[1], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[2], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[3], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[4], 'ranks'),
        localize(G.GAME.current_round.RD_lotteryticket[5], 'ranks'),
        card.ability.reward_money
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.before and #context.scoring_hand >= 5 then
      if lottery_check(context.scoring_hand) then --for each rank in our lottery, check if there is a card to match it.
        ease_dollars(card.ability.reward_money)
        return {
          message = localize('$')..card.ability.reward_money,
          colour = G.C.MONEY
        }
      end
    end
  end
}

--overrides existing get straight function
local old_func_get_straight = get_straight
function get_straight(hand, min_length, skip, wrap) 
  --check results of old function first.
  local ret = old_func_get_straight(hand, min_length, skip, wrap)
  
  if #hand < 5 or not next(SMODS.find_card('j_RainyDays_lotteryticket')) then --lottery straight is impossible.
    return ret
  end
  
  for i = 1, #ret do
    if #ret[i] >= 5 then --if there is already a hand using all five cards, we can just return it now.
      return ret
    end
  end
  
  if not lottery_check(hand) then --check if we have all five lottery ranks in hand. we also call this function when checking our scoring hand.
    return ret
  end
  
  --we made it! We just need to let the game know which cards to score. We make a table containing all five cards and add it.
  local straight = {}
  for i = 1, #hand do
    straight[#straight + 1] = hand[i]
  end
  
  ret[#ret + 1] = straight
  table.sort(ret, function(a,b) return #a > #b end) --lets put our five card sequence at the top of the table.
  return ret
end

--for each rank in our lottery, check if there is a card to match it.
function lottery_check(hand)
  for i = 1, #G.GAME.current_round.RD_lotteryticket do 
    if not check_hand_for_match(hand, G.GAME.current_round.RD_lotteryticket[i]) then --see function.lua
      return false --a rank is missing. Abort.
    end
  end
  return true
end

--this function updates the listed ranks every round.
function reset_game_globals_lotteryticket(run_start)  
  --add ranks from cards in deck to pool for picking, ranks can be added multiple times, so more common ranks get chosen more often
  local ranks_in_deck = {}
  for i = 1, #G.playing_cards do
		if not SMODS.has_no_rank(G.playing_cards[i]) then
			ranks_in_deck[#ranks_in_deck + 1] = G.playing_cards[i].base.id --numbers from 14 to 2, converting to proper ranks later.
		end
	end
  
  --pick ranks five times, removing ranks already chosen.
  local picked_ranks = {}
  local unchosen_ranks = { 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2 } --second list of all unchosen options, only used if first list is empty
  for i = 1, #G.GAME.current_round.RD_lotteryticket do
    if ranks_in_deck[1] then
      picked_ranks[i] = pseudorandom_element(ranks_in_deck, pseudoseed('Lottery' .. G.GAME.round_resets.ante))
      remove_by_value(ranks_in_deck, picked_ranks[i])
      remove_by_value(unchosen_ranks, picked_ranks[i])
    else --If no possible ranks left in deck, pick from all unchosen ranks.
      picked_ranks[i] = pseudorandom_element(unchosen_ranks, pseudoseed('Lottery' .. G.GAME.round_resets.ante))
      remove_by_value(unchosen_ranks, picked_ranks[i])
    end
  end
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
    elseif picked_ranks[i] == 14 then --do you miss switch statements yet?
      G.GAME.current_round.RD_lotteryticket[i] = 'Ace'
    end
  end
  picked_ranks = nil
  
  G.GAME.current_round.RD_lotteryticket_string = ""
  for i = 1, #G.GAME.current_round.RD_lotteryticket do
    local sub = string.sub(G.GAME.current_round.RD_lotteryticket[i], 1, 1)
    if sub ~= "1" then
      G.GAME.current_round.RD_lotteryticket_string = G.GAME.current_round.RD_lotteryticket_string .. sub
    else
      G.GAME.current_round.RD_lotteryticket_string = G.GAME.current_round.RD_lotteryticket_string .. "10"
    end
    
    if i ~= #G.GAME.current_round.RD_lotteryticket then
      G.GAME.current_round.RD_lotteryticket_string = G.GAME.current_round.RD_lotteryticket_string  .. " "
    end
  end
end

--here we draw or lottery ticket ranks onto our card. It's far from perfect, but it's the best I can manage. 
--issues: text hovers over editions, text wobbles a bit, text moves as you move the joker around the screen (sometimes outside the box).
--if you have any how to solve one or more of these issues, your help is most welcome on either github or discord.
SMODS.DrawStep {
  key = 'lotteryticket_text',
  order = 21,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if self.ability.name == 'Lottery Ticket' and self.children.center then
      --drawing the string
      prep_draw(self.children.center, 0.015)
      if self.edition and self.edition.negative then
        love.graphics.setColor(1 - 0.047059, 1 - 0.039216, 1 - 0.258824, 1) --not the right color, but it looks cool
      else
        love.graphics.setColor(0.047059, 0.039216, 0.258824, 1)
      end
      love.graphics.print(G.GAME.current_round.RD_lotteryticket_string, -40, -10, 0)
      love.graphics.pop()
    end
  end
}