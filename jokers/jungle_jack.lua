SMODS.Joker {
  key = 'jungle_jack',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('jungle_jack'),
  attributes = { 'rank', 'jack', 'passive' },
  config = {
    extra = {
      rank = 'Jack'
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.jungle_jack = (G.GAME.jungle_jack or 0) + 1
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.jungle_jack = (G.GAME.jungle_jack or 0) - 1
  end,
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks')
      }
    } 
  end
}

--functions to change the card ids, then change them back
local function change_cards(hand)
  if hand and type(hand) == "table" and G.GAME.jungle_jack and G.GAME.jungle_jack > 0 then
    local table = {}
    for i = 2, #hand do
      if hand[i]:get_id() == 11 and not SMODS.has_no_rank(hand[i - 1]) and hand[i - 1]:get_id() ~= 11 then
        table[#table + 1] = { card = hand[i], old_id = hand[i].base.id, old_rank = hand[i].base.value, new_id = hand[i - 1]:get_id(), new_rank = hand[i - 1].base.value }
        hand[i].base.id = hand[i - 1]:get_id()
        hand[i].base.value = hand[i - 1].base.value
      end
    end
    return table
  end
end

local function reset_changed_cards(table)
  if table then
    for i = 1, #table do
      if table[i].card and table[i].card.base.id == table[i].new_id and table[i].card.base.value == table[i].new_rank then
        table[i].card.base.id = table[i].old_id
        table[i].card.base.value = table[i].old_rank
      end
    end
  end
end

--overrides 
local function_poker_hand_info_ref = G.FUNCS.get_poker_hand_info
function G.FUNCS.get_poker_hand_info(_cards)
  if not (RainyDays.evaluate_play or RainyDays.discard_cards_from_highlighted or RainyDays.joker_display_calculate) and _cards and _cards[1] and _cards[1].area == G.hand and _cards[1].highlighted then
    local list_changed = change_cards(_cards)
    local text, loc_disp_text, poker_hands, scoring_hand, disp_text = function_poker_hand_info_ref(_cards)
    reset_changed_cards(list_changed)
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
  else
    return function_poker_hand_info_ref(_cards)
  end
end

local function_discard_cards_from_highlighted_ref = G.FUNCS.discard_cards_from_highlighted
function G.FUNCS.discard_cards_from_highlighted(e, hook)
  RainyDays.discard_cards_from_highlighted = true
  local list_changed = change_cards(G.hand.highlighted)  
  function_discard_cards_from_highlighted_ref(e, hook)  
  reset_changed_cards(list_changed)  
  RainyDays.discard_cards_from_highlighted = nil
end

local function_evaluate_play_ref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
  RainyDays.evaluate_play = true
  local list_changed = change_cards(G.play.cards)
  function_evaluate_play_ref(e)
  reset_changed_cards(list_changed)  
  RainyDays.evaluate_play = nil
end

local function_calculate_joker_display_ref = Card.calculate_joker_display
function Card:calculate_joker_display(custom_parent)
  RainyDays.joker_display_calculate = true
  local list_changed
  if G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
    list_changed = change_cards(G.hand.highlighted)
  end
  local text, poker_hands, final_scoring_hand = function_calculate_joker_display_ref(self, custom_parent)
  reset_changed_cards(list_changed)  
  RainyDays.joker_display_calculate = nil
  return text, poker_hands, final_scoring_hand
end

--makes sure that highlighted cards are in the table from left to right and calls parse highlighted if necessary
local function_align_cards_ref = CardArea.align_cards
function CardArea:align_cards()
  function_align_cards_ref(self)
  if G.GAME.jungle_jack and G.GAME.jungle_jack > 0 and self == G.hand and G.hand.highlighted and #G.hand.highlighted > 1 then
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
      local old_order = {}
      for i = 1, #G.hand.highlighted do
        old_order[i] = G.hand.highlighted[i].ID
      end
      
      table.sort(G.hand.highlighted, function (a, b) return a.T.x + a.T.w / 2 < b.T.x + b.T.w / 2 end)
      
      for i = 1, #G.hand.highlighted do
        if G.hand.highlighted[i].ID ~= old_order[i] then
          G.hand:parse_highlighted()
          break
        end
      end
    end
  end
end