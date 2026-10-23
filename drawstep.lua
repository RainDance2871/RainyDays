SMODS.DrawStep {
  key = 'rd_sprite_to_canvas',
  order = 25,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    local draw_when = self.config.center.rd_canvas_drawing
    or (RainyDays.config.metallic_hightlights and self.config.center.rd_highlight_shader)
    or ((RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 2) and self.config.center.rd_indicator_shader)
    if draw_when and self.config.center_key == 'j_satellite' and not RainyDays.config.satellite then
      draw_when = false
    end
    if draw_when and (self.config.center.discovered or self.bypass_discovery_center) then
      --setup canvas
      self.rd_canvas_sprite = self.rd_canvas_sprite or SMODS.CanvasSprite({ canvasScale = 10 })
      local canvas_sprite = self.rd_canvas_sprite
      canvas_sprite.canvas:renderTo(love.graphics.clear, 0, 0, 0, 0)
      
      local function draw_sprite_in_canvas(sprite, scale)
        love.graphics.push()
        love.graphics.origin()
        love.graphics.scale((scale or 1) * canvas_sprite.canvasScale)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setBlendMode('alpha')
        love.graphics.draw(
          sprite.atlas.image, 
          sprite.sprite,
          sprite.flipped_h and loc.atlas.px or 0, 
          sprite.flipped_v and loc.atlas.py or 0,
          0,
          sprite.VT.w / sprite.T.w * (sprite.flipped_h and -1 or 1),
          sprite.VT.h / sprite.T.h * (sprite.flipped_v and -1 or 1)
        )
        love.graphics.pop()  
      end
      
      local function setup_shader(shader_key, sprite, skip_sprite_data)
        if not skip_sprite_data then
          G.SHADERS[shader_key]:send('texture_details', sprite:get_pos_pixel())
          G.SHADERS[shader_key]:send('image_details', sprite:get_image_dims())
        end
        
        if SMODS.Shader.obj_table[shader_key].send_vars then
          local send = SMODS.Shader.obj_table[shader_key].send_vars(sprite, self)
          for key, value in pairs(send) do
            G.SHADERS[shader_key]:send(key, value)
          end
        end
        
        love.graphics.setShader(G.SHADERS[shader_key])
      end
      
      --card
      if self.children.center then
        setup_shader('RainyDays_base', self.children.center, true)
        canvas_sprite.canvas:renderTo(draw_sprite_in_canvas, self.children.center)
        love.graphics.setShader()
      end
      
      --soul
      if self.children.floating_sprite then
        if self.config.center.rd_indicator_shader then
          if self.area and not self.area.created_on_pause then
            local sprite = self.children.floating_sprite
            setup_shader(self.config.center.rd_indicator_shader, sprite)
            canvas_sprite.canvas:renderTo(draw_sprite_in_canvas, sprite, 0.5)
            love.graphics.setShader()
          end
        elseif self.config.center.rd_highlight_shader then
          local sprite = self.children.floating_sprite
          setup_shader(self.config.center.rd_highlight_shader, sprite)
          canvas_sprite.canvas:renderTo(draw_sprite_in_canvas, sprite)
          love.graphics.setShader()
        elseif self.config.center.rd_waveform then
          if not self.debuff then
            local sprite = self.children.floating_sprite
            setup_shader('RainyDays_waveform_soul', sprite)
            canvas_sprite.canvas:renderTo(draw_sprite_in_canvas, sprite)
            love.graphics.setShader()
          end
        end
      end
      
      --canvas text
      if self.config.center.rd_canvas_text then
        local canvas_text = self.config.center.rd_canvas_text --font, colour, text, offset {x, y}, align {h, v}, width, height
        local text = love.graphics.newText(canvas_text.font or G.FONTS[1].FONT, { canvas_text.colour or G.C.UI.TEXT_DARK, canvas_text.text or "" })
        love.graphics.push()
        love.graphics.origin()
        local scale_fac = math.min((canvas_text.width or canvas_sprite.canvasW) / text:getWidth(), (canvas_text.height or canvas_sprite.canvasH) / text:getHeight()) * canvas_sprite.canvasScale
        canvas_sprite.canvas:renderTo(love.graphics.draw, text,
          canvas_text.offset and canvas_text.offset.x * canvas_sprite.canvasScale or 0,
          canvas_text.offset and canvas_text.offset.y * canvas_sprite.canvasScale or 0,
          0,
          scale_fac,
          scale_fac,
          canvas_text.align.h == 'left' and 0 or (canvas_text.align.h == 'right' and text:getWidth() or text:getWidth() / 2),
          canvas_text.align.v == 'top' and 0 or (canvas_text.align.v == 'bottom' and text:getHeight() or text:getHeight() / 2)
        )
        love.graphics.pop()  
      end
      
      --draw card
      canvas_sprite.role.draw_major = self
      canvas_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center)
      
      --add edition
      local edition = self.delay_edition or self.edition
      if edition then
        for k, v in pairs(G.P_CENTER_POOLS.Edition) do
          if edition[v.key:sub(3)] and v.shader then
            if type(v.draw) == 'function' then
              v:draw(self, layer)
            else
              canvas_sprite:draw_shader(v.shader, nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
          end
        end
      end
      if (edition and edition.negative) then
        canvas_sprite:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center)
      end
      
      --debuffed
      if self.debuff and not self.delay_debuff then
        canvas_sprite:draw_shader('debuff', nil, self.ARGS.send_to_shader, nil, self.children.center)
      end
    end
  end
}

SMODS.DrawStep {
  key = 'rd_polished_joker',
  order = 26,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if self.config.center.rd_polished and (self.config.center.discovered or self.bypass_discovery_center) then
      self.children.center:draw_shader('negative_shine', nil, self.ARGS.send_to_shader)
      self.children.center:draw_shader('RainyDays_polish_sparkle')
    end
  end
}

SMODS.DrawStep {
  key = 'RD_early_bird_markings',
  order = 40,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if next(SMODS.find_card('j_RainyDays_early_birds', true)) and self.ability and self.ability.rd_early_bird and not self.debuff then
      RainyDays.sprite_early_bird_sticker = RainyDays.sprite_early_bird_sticker or SMODS.create_sprite(0, 0, 71, 95, 'RainyDays_Jokers', RainyDays.GetJokersAtlasTable('early_birds_border'))
      RainyDays.sprite_early_bird_sticker.role.draw_major = self
      RainyDays.sprite_early_bird_sticker:draw_shader('dissolve', nil, nil, nil, self.children.center)
      RainyDays.sprite_early_bird_sticker:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
    end
  end
}

SMODS.DrawStep {
  key = 'rd_floating_sprite_debuff',
  order = 61,
  func = function(self)
    if self.config.center.rd_soul_draw_edition and self.debuff and not self.delay_debuff then
      local scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL)
      local rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL)
      self.children.floating_sprite:draw_shader('debuff', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
    end
  end
}