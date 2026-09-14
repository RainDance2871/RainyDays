SMODS.Joker {
  key = 'primality',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('primality'),
  attributes = { 'rank', 'modify_card', 'enhancements', 'seven', 'five', 'three', 'two' },
  pixel_size = { w = 70, h = 94 },
  config = {
    extra = {
      rank1 = '7',
      rank2 = '5',
      rank3 = '3',
      rank4 = '2'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    return {
      vars = {
        localize(card.ability.extra.rank1, 'ranks'),
        localize(card.ability.extra.rank2, 'ranks'),
        localize(card.ability.extra.rank3, 'ranks'),
        localize(card.ability.extra.rank4, 'ranks'),
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      local cards = {}
      for i = 1, #context.scoring_hand do
        if not context.scoring_hand[i].debuff then
          local id = context.scoring_hand[i]:get_id()
          if id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank1] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank2] 
          or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank3] or id == RainyDays.balatro_ranks_to_id[card.ability.extra.rank4] then
            cards[#cards + 1] = context.scoring_hand[i]
          end
        end
      end
      
      if #cards > 0 then
        return RainyDays.set_ability_multiple(card, cards, 'm_wild', { message = localize('rainydays_wild_ex') })
      end
    end
  end
}