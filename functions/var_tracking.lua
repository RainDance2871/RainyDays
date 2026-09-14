--see also lua injects

local game_init_game_object_ref = Game.init_game_object
function Game:init_game_object()
  local ret = game_init_game_object_ref(self)
  
  --hand vars
  for _, value in ipairs(G.handlist) do
    ret.hands[value].rd_discarded = 0
    ret.hands[value].rd_discarded_this_round = 0
    ret.hands[value].rd_discarded_this_ante = 0
    ret.hands[value].rd_secret = (not ret.hands[value].visible or type(ret.hands[value].visible) == 'function')
  end
  
  --cards played
  ret.rd_ranks_played_this_round = {}
  ret.rd_ranks_scored_this_round = {}
  ret.rd_enhancements_played_this_ante = {}
  
  --consumeable use
  ret.rd_consumeable_usage_round = 0
  ret.rd_consumeable_usage_ante = 0
  
  --jokers acquired
  ret.rd_jokers_uniquelist = {}
  ret.rd_jokers_uniquelist_count = 0
  
  --misc
  ret.rd_cards_drawn_this_round = 0
  ret.rd_steel_cards_drawn_this_round = 0
  ret.rd_delirium_active = false
  ret.rd_suit_count = 0
  for key in pairs(SMODS.Suits) do
    ret.rd_suit_count = ret.rd_suit_count + 1
  end
  
  return ret
end


local func_evaluate_play_ref = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
  RainyDays.evaluating_play = true
  G.GAME.rd_ranks_played_this_round = G.GAME.rd_ranks_played_this_round or {}
  for i = 1, #G.play.cards do
    if not SMODS.has_no_rank(G.play.cards[i]) then
      local id = G.play.cards[i]:get_id()
      G.GAME.rd_ranks_played_this_round[id] = (G.GAME.rd_ranks_played_this_round[id] or 0) + 1
    end

    local enhancements = SMODS.get_enhancements(G.play.cards[i])
    for key in pairs(enhancements) do
      G.GAME.rd_enhancements_played_this_ante[key] = (G.GAME.rd_enhancements_played_this_ante[key] or 0) + 1
    end
  end

  local _, _, _, scoring_hand = G.FUNCS.get_poker_hand_info(G.play.cards)
  G.GAME.rd_ranks_scored_this_round = G.GAME.rd_ranks_scored_this_round or {}
  for i = 1, #scoring_hand do
    if not SMODS.has_no_rank(scoring_hand[i]) then
      local id = scoring_hand[i]:get_id()
      G.GAME.rd_ranks_scored_this_round[id] = (G.GAME.rd_ranks_scored_this_round[id] or 0) + 1
    end
  end
  
  func_evaluate_play_ref(e)
  
  G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    blocking = false,
    blockable = false,
    func = function()
      if G.STATE ~= G.STATES.HAND_PLAYED then
        RainyDays.evaluating_play = nil
        return true
      end
    end
  }))
end


local discard_cards_from_highlighted_ref = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
  local highlighted_count = math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards)
  if highlighted_count > 0 and not hook then 
    local text = (G.FUNCS.get_poker_hand_info(G.hand.highlighted))
    G.GAME.hands[text].rd_discarded = G.GAME.hands[text].rd_discarded + 1
    G.GAME.hands[text].rd_discarded_this_ante = G.GAME.hands[text].rd_discarded_this_ante + 1
    G.GAME.hands[text].rd_discarded_this_round = G.GAME.hands[text].rd_discarded_this_round + 1
    
    if not G.GAME.rd_delirium_active and RainyDays.delirium_check(G.hand.highlighted) then
      G.GAME.rd_delirium_active = true
    end
  end
  return discard_cards_from_highlighted_ref(e, hook)
end

local end_round_ref = end_round
function end_round()
  end_round_ref()
  G.E_MANAGER:add_event(Event({
    trigger = 'after',
    delay = 0.2,
    func = function()
      --round values reset
      G.GAME.rd_delirium_active = false
      G.GAME.rd_consumeable_usage_round = 0
      G.GAME.rd_cards_drawn_this_round = 0
      G.GAME.rd_steel_cards_drawn_this_round = 0
      
      for key in pairs(G.GAME.rd_ranks_played_this_round) do
        G.GAME.rd_ranks_played_this_round[key] = nil
      end
      
      for key in pairs(G.GAME.rd_ranks_scored_this_round) do
        G.GAME.rd_ranks_scored_this_round[key] = nil
      end
      
      for _, value in pairs(G.GAME.hands) do
        value.rd_discarded_this_round = 0
      end
      
      for _, value in ipairs(G.playing_cards) do
        value.ability.rd_early_bird = nil
      end
      
      --ante values reset
      if G.GAME.blind:get_type() == 'Boss' then
        G.GAME.rd_consumeable_usage_ante = 0
        for _, value in pairs(G.GAME.hands) do
          value.rd_discarded_this_ante = 0
        end
        for key in pairs(G.GAME.rd_enhancements_played_this_ante) do
          G.GAME.rd_enhancements_played_this_ante[key] = nil
        end
      end
      return true
    end
  }))
end

function RainyDays.delirium_check(hand)
  if #hand >= 4 then
    local count = 0
    local non_wild = {}
    local suits = {}
    
    for i = 1, #hand do
      if not SMODS.has_no_suit(hand[i]) then
        if SMODS.has_any_suit(hand[i]) then
          count = count + 1
        else
          non_wild[#non_wild + 1] = hand[i]
        end
      end
    end
    
    --check if cards of suit are discarded
    for i = 1, #non_wild do 
      for key in pairs(SMODS.Suits) do
        if not suits[key] and non_wild[i]:is_suit(key, true) then
          suits[key] = true
          break
        end
      end
    end
    
    --count amount of suits
    for key in pairs(SMODS.Suits) do
      if suits[key] then
        count = count + 1
      end
    end
    
    if count >= 4 then
      return true 
    end
  end
  return false
end

--maintain list of unique jokers
local add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
  if G.GAME and self.ability.set == 'Joker' then
    if not self.ability.rd_joker_id then
      G.GAME.rd_joker_ids_given = (G.GAME.rd_joker_ids_given or 0) + 1
      self.ability.rd_joker_id = G.GAME.rd_joker_ids_given
    end
    
    if not G.GAME.rd_jokers_uniquelist[self.config.center.key] then
      G.GAME.rd_jokers_uniquelist[self.config.center.key] = true
      G.GAME.rd_jokers_uniquelist_count = G.GAME.rd_jokers_uniquelist_count + 1
      G.GAME.rd_jokers_uniquelist_added = G.GAME.rd_jokers_uniquelist_added or {}
      G.GAME.rd_jokers_uniquelist_added[#G.GAME.rd_jokers_uniquelist_added + 1] = self.config.center.key
      G.E_MANAGER:add_event(Event({
        func = function()
          if G.GAME.rd_jokers_uniquelist_added and #G.GAME.rd_jokers_uniquelist_added > 0 then
            SMODS.calculate_context({ rd_unique_joker_added = true, card_keys = G.GAME.rd_jokers_uniquelist_added })
            G.GAME.rd_jokers_uniquelist_added = nil
          end
          return true
        end
      }))
    end
  end
  return add_to_deck_ref(self, from_debuff)
end

local ref_add_tag = add_tag
function add_tag(_tag)
  ref_add_tag(_tag)
  G.GAME.rd_tag_count = (G.GAME.rd_tag_count or 0) + 1
  check_for_unlock({ type = 'rd_tag_count' })
end