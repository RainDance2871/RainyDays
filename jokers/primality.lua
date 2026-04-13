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
  pixel_size = { w = 70, h = 94 },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
  end,
  
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      local hit = false
      for _, scored_card in ipairs(context.scoring_hand) do
        if scored_card:get_id() == 2 or scored_card:get_id() == 3 or scored_card:get_id() == 5 or scored_card:get_id() == 7 then
          hit = true
          scored_card:set_ability('m_wild', nil, true)
          G.E_MANAGER:add_event(Event({
            func = function()
              scored_card:juice_up()
              return true
            end
          }))
        end
      end
      
      if hit then
        return {
          message = localize('rainydays_wild'),
          colour = G.C.FILTER
        }
      end
    end
  end
}