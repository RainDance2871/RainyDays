SMODS.Joker {
  key = 'sputnik',
  atlas = 'Jokers',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('sputnik'),
  soul_pos = RainyDays.GetJokersAtlasTable('indicator_hands'),
  RD_soul_draw_as_highlight = true,
  RD_soul_draw_as_highlight_shader = 'RainyDays_indicator',
  RD_soul_draw_always = true,
  
  config = {
    juicing = false
  },

  calculate = function(self, card, context)
    if context.joker_main and G.GAME.hands[context.scoring_name].played_this_ante == 1 then
      if RainyDays.Constellations then
        return RainyDays.create_consumable(context.blueprint_card or card, 'CN_Constellation')
      else
        local planet_key = nil
        for _, value in pairs(G.P_CENTER_POOLS.Planet) do
          if value.config.hand_type == context.scoring_name then
            planet_key = value.key
            break
          end
        end
        
        if planet_key then
          return RainyDays.create_consumable(context.blueprint_card or card, 'Planet', 1, planet_key)
        end
      end
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.blind.boss then
      return {
        message = localize('k_reset'),
        colour = G.C.FILTER
      }
    end
  end,
}