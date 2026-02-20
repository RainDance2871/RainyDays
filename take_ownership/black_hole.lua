SMODS.Consumable:take_ownership('c_black_hole',  {
  use = function(self, card, area, copier)
    local table = {}
    for key, value in ipairs(G.handlist) do
      table[#table + 1] = value
    end
    level_up_table_tailends(card, table, localize('k_all_hands'), false, 1)
  end
}, true)