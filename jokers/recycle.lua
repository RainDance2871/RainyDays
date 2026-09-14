SMODS.Joker {
  key = 'recycle',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('recycle'),
  attributes = { 'rank', 'mult', 'modify_card', 'perma_bonus', 'five', 'four', 'three', 'two' },
  config = {
    extra = {
      bonus_mult = 2,
      rank1 = '5',
      rank2 = '4',
      rank3 = '3',
      rank4 = '2'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.bonus_mult,
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks'),
        localize(card.ability.extra.rank3, 'ranks'),
        localize(card.ability.extra.rank4, 'ranks'),
      }
    } 
  end,
  
  calculate = function(self, card, context)    
    if context.discard then
      if not card.ability.extra.cards_recycled then
        card.ability.extra.cards_recycled = {}
        for i = 1, #context.full_hand do
          if RainyDays.is_valid_recycle(context.full_hand[i], card) then
            card.ability.extra.cards_recycled[#card.ability.extra.cards_recycled + 1] = context.full_hand[i]
          end
        end
      end
      
      local function clear_list()
        G.E_MANAGER:add_event(Event({
          trigger = 'before',
          delay = 0.1,
          func = function()
            card.ability.extra.cards_recycled = nil
            return true
          end
        }))
      end
      
      if RainyDays.is_valid_recycle(context.other_card, card) then
        context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.bonus_mult
        return {
          card = context.other_card,
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT,
          func = (context.other_card == context.full_hand[#context.full_hand] and not context.blueprint) and clear_list or nil
        }
      else
        return {
          func = (context.other_card == context.full_hand[#context.full_hand] and not context.blueprint) and clear_list or nil
        }
      end
    end
    
    if context.stay_flipped and context.from_area == G.hand and context.to_area == G.discard and not context.blueprint and RainyDays.is_valid_recycle(context.other_card, card) then
      if not G.GAME.rd_shuffle_deck then
        G.GAME.rd_shuffle_deck = true
        G.E_MANAGER:add_event(Event({
          func = function()
            G.deck:shuffle('recycle'..G.GAME.round_resets.ante)
            G.GAME.rd_shuffle_deck = nil
            return true
          end
        }))
      end
      
      return {
        modify = { to_area = G.deck }
      }
    end
  end
}

function RainyDays.is_valid_recycle(playing_card, card)
  if not SMODS.has_no_rank(playing_card) and not playing_card.debuff then
    local id = playing_card:get_id()
    if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2]
    or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank3] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank4] then
      return true
    end
  end
end