SMODS.Joker {
  key = 'hecate',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('hecate'),
  soul_pos = RainyDays.GetJokersAtlasTable('hecate_soul'),
  rd_highlight_shader = 'RainyDays_metallic_highlight',
  rd_skip_soul = true,
  attributes = { 'spectral', 'hand_type', 'generation', 'space' },
  
  config = {
    extra = {
      hand = 'Three of a Kind',
      reward = 'Spectral'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        localize(card.ability.extra.hand, 'poker_hands')
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
      local _, _, pokerhands = G.FUNCS.get_poker_hand_info(G.hand.cards)
      if next(pokerhands[card.ability.extra.hand]) then
        return RainyDays.create_consumable(card, card.ability.extra.reward)
      end
    end
  end
}