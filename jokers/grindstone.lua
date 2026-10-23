SMODS.Joker {
  key = 'grindstone',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('grindstone'),
  attributes = { 'rank', 'chips', 'modify_card', 'perma_bonus', 'six' },
  config = {
    extra = {
      rank = '6',
      bonus_chips = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks'),
        card.ability.extra.bonus_chips
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
      for _, playing_card in ipairs(G.playing_cards) do
        if playing_card:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
          playing_card.ability.perma_bonus = (playing_card.ability.perma_bonus or 0) + card.ability.extra.bonus_chips
        end
      end
      
      return {
        message_card = context.blueprint_card or card,
        message = localize('k_upgrade_ex'),
        colour = G.C.CHIPS
      }
    end
  end
}