SMODS.Joker {
  key = 'doubling_joker',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('doubling_joker1'),
  attributes = { 'mult', 'rank', 'four', 'two' },
  
  config = {
    extra = {
      rank1 = '4',
      rank2 = '2',
      mult_start = 1,
      mult_base = 2,
      score_count = 0,
      score_count_visual = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks'),
        card.ability.extra.mult_start,
        card.ability.extra.mult_base
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.other_card.debuff then
      local id = context.other_card:get_id()
      if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] then
        local power
        if not context.blueprint then
          card.ability.extra.score_count = card.ability.extra.score_count + 1
          power = card.ability.extra.score_count - 1
        else
          local extra = (RainyDays.GetJokerPosition(context.blueprint_card) < RainyDays.GetJokerPosition(card)) and 1 or 0
          power = card.ability.extra.score_count - 1 + extra
        end
        
        return {
          mult = card.ability.extra.mult_start * (card.ability.extra.mult_base ^ power),
          func = not context.blueprint and (function()
            G.E_MANAGER:add_event(Event({
              blocking = false,
              trigger = 'after',
              delay = 0.1,
              func = function()
                card.ability.extra.score_count_visual = card.ability.extra.score_count_visual + 1
                card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('doubling_joker' .. math.min(9, card.ability.extra.score_count_visual + 1)))
                return true
              end
            }))
            return true
          end) or nil
        }
      end
    end
    
    if context.after and not context.blueprint then
      card.ability.extra.score_count = 0
      G.E_MANAGER:add_event(Event({ 
        trigger = 'after',
        delay = 0,
        func = function()
          card.ability.extra.score_count_visual = 0
          card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('doubling_joker1'))
          return true
        end
      }))
    end
  end
}