SMODS.Joker {
  key = 'mirror_lake',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true, 
  in_pool = function(self, args) --only appears if player has at least one glass card in deck.
    if G.playing_cards then
      for i = 1, #G.playing_cards do
        if SMODS.has_enhancement(G.playing_cards[i], 'm_glass') then
          return true
        end
      end
    end
    return false
  end,
  pos = RainyDays.GetJokersAtlasTable('mirror_lake'),
    
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
  end,
  
  calculate = function(self, card, context)
    if context.before then
      for i = 1, #context.full_hand do
        if SMODS.has_enhancement(context.full_hand[i], 'm_glass') then
          return RainyDays.create_consumable(context.blueprint_card or card, RainyDays.Constellations and 'CN_Constellation' or 'Tarot')
        end
      end
    end
  end
}