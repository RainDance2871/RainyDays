SMODS.Joker {
  key = 'recycle',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('recycle'),
  config = {
    extra = {
      bonus_mult = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.extra.bonus_mult }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.discard and context.other_card:get_id() >= 2 and context.other_card:get_id() <= 5 then
      context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.bonus_mult
      context.other_card.discard_into_deck = true
      return {
        card = context.other_card,
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT
      }
    end
  end
}