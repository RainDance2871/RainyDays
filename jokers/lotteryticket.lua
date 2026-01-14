SMODS.Joker {
  key = 'lotteryticket',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('lotteryticket'),
  config = {
    extra = {
      reward_money = 3,
      ranks_played = {}
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          not list_contains(card.ability.extra.ranks_played, G.GAME.current_round.RD_lotteryticket[1]) and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
          not list_contains(card.ability.extra.ranks_played, G.GAME.current_round.RD_lotteryticket[2]) and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
          not list_contains(card.ability.extra.ranks_played, G.GAME.current_round.RD_lotteryticket[3]) and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
          not list_contains(card.ability.extra.ranks_played, G.GAME.current_round.RD_lotteryticket[4]) and G.C.FILTER or G.C.UI.TEXT_INACTIVE,
          not list_contains(card.ability.extra.ranks_played, G.GAME.current_round.RD_lotteryticket[5]) and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
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
    generate_lottery_string(card)
    generate_lottery_string_sprite(card)
  end,
  
  
  set_sprites = function(self, card, front)
    if card.ability then
      generate_lottery_string(card)
      generate_lottery_string_sprite(card, true)
    end
  end,
  
  calculate = function(self, card, context)
    if not context.blueprint then
      if context.first_hand_drawn then
        card.ability.extra.ranks_played = {}
      end
      
      if context.after then
        G.E_MANAGER:add_event(Event({
          func = function()
            generate_lottery_string(card)
            generate_lottery_string_sprite(card)
            return true
          end
        }))
        card.ability.card_to_reward = nil
      end
    end
      
    --check if rank is special and has been played yet.
    if context.individual and context.cardarea == G.play and not context.other_card.debuff and not SMODS.has_no_rank(context.other_card) then
      if not context.is_repetition and list_contains(G.GAME.current_round.RD_lotteryticket, context.other_card.base.value) then
        if not list_contains(card.ability.extra.ranks_played, context.other_card.base.value) then
          card.ability.card_to_reward = context.other_card
          card.ability.extra.ranks_played[#card.ability.extra.ranks_played + 1] = context.other_card.base.value
        end
        
        if card.ability.card_to_reward == context.other_card then
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
}

--this function updates the listed ranks every round.
function reset_game_globals_lotteryticket()  
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
    table[i].ability.extra.ranks_played = {}
    generate_lottery_string(table[i])
    generate_lottery_string_sprite(table[i])
  end
end

function generate_lottery_string(card)
  local string = ""
  for i = 1, #G.GAME.current_round.RD_lotteryticket do
    if not list_contains(card.ability.extra.ranks_played, G.GAME.current_round.RD_lotteryticket[i]) then
      local sub = string.sub(G.GAME.current_round.RD_lotteryticket[i], 1, 1)
      string = string .. (sub ~= "1" and sub or "10") .. (i < #G.GAME.current_round.RD_lotteryticket and " " or "")
    end
  end
  
  if string == "" then
    string = localize('rainydays_full_clear')
  end
  
  card.ability.lottery_string = string
end

function generate_lottery_string_sprite(card, force)
  if not card.ability.canvas_sprite or force then
    card.ability.canvas_sprite = CanvasSprite(card.children.center.T.x, card.children.center.T.y, card.children.center.T.w, card.children.center.T.h)
  end
  
  love.graphics.push()
  love.graphics.origin()
  local old = love.graphics.getCanvas()
  love.graphics.setCanvas(card.ability.canvas_sprite.canvas)
  love.graphics.clear()
  love.graphics.setFont(RainyDays_lottery_font)
  love.graphics.setColor(0.309803921569, 0.388235294118, 0.403921568627, 1)
  love.graphics.print(card.ability.lottery_string, 11, 41, 0)
  love.graphics.setCanvas(old)
  love.graphics.pop()
end