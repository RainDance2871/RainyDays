SMODS.Joker {
  key = 'musketeers',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('musketeers'),
  attributes = { 'hand_type' },
  
  config = {
    extra = {
      hand = 'Three of a Kind',
      cards = 3
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.rd_musketeers = (G.GAME.rd_musketeers or 0) + 1
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.rd_musketeers = (G.GAME.rd_musketeers or 0) - 1
  end,
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.hand,
        card.ability.extra.cards
      }
    }
  end
}

function RainyDays.musketeers_check_full_house(parts3, parts2)
  if parts3[1].base_3oak then
		return parts3
	end
  
  local function no_shared_cards(groupA, groupB)
    for i = 1, #groupA do
      for j = 1, #groupB do
        if groupA[i] == groupB[j] then
          return false
        end
      end
    end
    return true
  end

	for i = 1, #parts2 do
		if no_shared_cards(parts3[1], parts2[i]) then
			return { SMODS.merge_lists(parts3, parts2[i]) }
		end
	end
end

local ref_get_x_same_old = get_X_same
function get_X_same(num, hand, or_more)
  local ret = ref_get_x_same_old(num, hand, or_more)
  if num == 3 and #hand >= 3 and G.GAME.rd_amigo and G.GAME.rd_amigo > 0 then
    local rank_ids = {}
    for i = 1, #hand do
      if not SMODS.has_no_rank(hand[i]) then
        local id = hand[i]:get_id()
        rank_ids[id] = rank_ids[id] or {}
        rank_ids[id][#rank_ids[id] + 1] = hand[i]
      end
    end
    
    rank_ids[1] = rank_ids[14]
    
    for i = 14, 3, -1 do
      if not rank_ids[i + 1] and rank_ids[i] and rank_ids[i - 1] and rank_ids[i -2] then
        local group = {}
        
        local j = i
        while rank_ids[j] do
          if #rank_ids[j] >= 3 then
            group['base_3oak'] = true
          end
          for k = 1, #rank_ids[j] do
            group[#group + 1] = rank_ids[j][k]
          end
          j = j - 1
        end
        
        if #ret > 0 then
          local group_id = group[1]:get_id()
          for j = 1, #ret do
            if group_id >= ret[j][1]:get_id() then
              table.insert(ret, j, group)
              break
            end
          end
        else
          table.insert(ret, group)
        end
      end
    end
  end
  return ret
end