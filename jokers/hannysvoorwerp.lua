if RainyDays.config.constellations then SMODS.Joker {
  key = 'hannysvoorwerp',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('hannysvoorwerp'),
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.interest_blockers = (G.GAME.interest_blockers or 0) + 1
    if not G.GAME.base_interest_state then
      G.GAME.base_interest_state = G.GAME.modifiers.no_interest
    end
    G.GAME.modifiers.no_interest = true
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.interest_blockers = (G.GAME.interest_blockers or 0) - 1
    if G.GAME.interest_blockers <= 0 then
      G.GAME.modifiers.no_interest = G.GAME.base_interest_state
    end
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
      return create_constellation(card)
    end
  end
} end