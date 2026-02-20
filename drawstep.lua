SMODS.DrawStep {
  key = 'draw_soul_as_hightlights',
  order = 5,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if self.config.center.soul_draw_as_highlight and (self.config.center.discovered or self.bypass_discovery_center) then
      self.children.floating_sprite:draw_shader(self.config.center.soul_draw_as_highlight_shader, nil, self.ARGS.send_to_shader, nil, self.children.center, 0, 0)
    end
  end
}

SMODS.DrawStep {
  key = "draw_canvas_sprite",
  order = 25,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if self.ability and self.ability.canvas_sprite and self.children.center and (self.config.center.discovered or self.bypass_discovery_center) then
      if self.ability.canvas_sprite.role then
        self.ability.canvas_sprite.role.draw_major = self
      end
      
      local edition = self.delay_edition or self.edition
      if edition then
        for k, v in pairs(G.P_CENTER_POOLS.Edition) do
          if edition[v.key:sub(3)] and v.shader then
            self.ability.canvas_sprite:draw_shader(v.shader, nil, nil, nil, self.children.center)
          end
        end
      else
        self.ability.canvas_sprite:draw_shader("dissolve", nil, nil, nil, self.children.center)
      end
    end
  end
}