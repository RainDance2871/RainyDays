SMODS.Joker {
  key = 'whirlpool',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('whirlpool'),
  attributes = { 'hand_type', 'suit' },
  
  config = {
    extra = {
      hand = 'Flush',
      cards = 4
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.rd_whirlpool = (G.GAME.rd_whirlpool or 0) + 1
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.rd_whirlpool = (G.GAME.rd_whirlpool or 0) - 1
  end,
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.cards,
        card.ability.extra.hand
      }
    }
  end
}

local ref_get_flush_old = get_flush
function get_flush(hand)
  local ret = ref_get_flush_old(hand)
  if #hand >= 4 and G.GAME.rd_whirlpool and G.GAME.rd_whirlpool > 0 then
    ret = ret or {}
    local included = {}
    local non_wild = {}
    for i = 1, #hand do
      if not SMODS.has_no_suit(hand[i]) then
        if SMODS.has_any_suit(hand[i]) then
          included[#included + 1] = hand[i]
        else
          non_wild[#non_wild + 1] = hand[i]
        end
      end
    end
    
    local suits = {}
    for i = 1, #non_wild do 
      for key in pairs(SMODS.Suits) do
        if not suits[key] and non_wild[i]:is_suit(key, true) then
          suits[key] = true
          break
        end
      end
    end
    
    local count = #included
    for key in pairs(SMODS.Suits) do
      if suits[key] then
        count = count + 1
      end
    end
    
    if count >= 4 then
      for i = 1, #non_wild do
        included[#included + 1] = non_wild[i]
      end
      table.insert(ret, included)
    end
  end
  return ret
end