SMODS.Joker:take_ownership('j_satellite', {
  soul_atlas = 'Indicators',
  soul_pos = RainyDays.GetIndicatorsAtlasTable('planets'),
  rd_indicator_shader = 'RainyDays_indicator',
  
  set_sprites = function(self, card, front)
    if RainyDays.config.satellite and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 2) and (card.config.center.discovered or card.bypass_discovery_center) then
      card.children.center.atlas = RainyDays.atlas_jokers
      card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('satellite'))
    end
  end,
  
  loc_vars = function(self, info_queue, card)
    local contents = {}
    local count = 0
    for key, consumable in pairs(G.GAME.consumeable_usage) do
      if consumable.set == 'Planet' and consumable.count > 0 then
        contents[key] = true
        count = count + 1
      end
    end
    
    if RainyDays.config.satellite and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 3) and card.area and not card.area.created_on_pause then
      if #contents > 0 then
        local box_contents = {}
        local planets = { 'c_eris', 'c_ceres', 'c_planet_x', 'c_neptune', 'c_mars', 'c_earth', 'c_jupiter', 'c_saturn', 'c_venus', 'c_uranus', 'c_mercury', 'c_pluto' }
        for i = 1, #planets do
          if contents[planets[i]] then
            contents[planets[i]] = nil
            box_contents[#box_contents + 1] = localize{ type = 'name_text', set = 'Planet', key = planets[i] }
          end
        end
        
        for key in pairs(contents) do
          box_contents[#box_contents + 1] = localize{ type = 'name_text', set = 'Planet', key = key }
        end
        
        local box = RainyDays.create_infobox_list(localize('rainydays_satellite_box_name'), box_contents)
        info_queue[#info_queue + 1] = { set = 'Other', key = box }
      end
    end
    
    return {
      card.ability.extra,
      card.ability.extra * count
    }
  end
}, true)