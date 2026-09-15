if RainyDays.config.satellite and RainyDays.config.clarifiers ~= 4 then 
  SMODS.Joker:take_ownership('j_satellite', {
    atlas = 'Jokers',
    pos = RainyDays.GetJokersAtlasTable('satellite'),
    soul_pos = RainyDays.GetJokersAtlasTable('indicator_planets'),
    rd_soul_indicator_shader = 'RainyDays_indicator',
    rd_skip_soul = true,
    
    loc_vars = function(self, info_queue, card)
      if (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) and card.area and not card.area.created_on_pause and G.GAME.consumeable_usage then
        local planets = { 'c_pluto', 'c_mercury', 'c_uranus', 'c_venus', 'c_saturn', 'c_jupiter', 'c_earth', 'c_mars', 'c_neptune', 'c_planet_x', 'c_ceres', 'c_eris' }
        
        local contents = {}
        for i = 1, #planets do
          if G.GAME.consumeable_usage[planets[i]] and G.GAME.consumeable_usage[planets[i]].count > 0 then
            contents[#contents + 1] = localize{ type = 'name_text', set = 'Planet', key = planets[i] }
          end
        end
          
        if #contents > 0 then
          local box = RainyDays.create_infobox_list(localize('rainydays_satellite_box_name'), contents)
          info_queue[#info_queue + 1] = { set = 'Other', key = box }
        end
      end
    end
  }, true)
end