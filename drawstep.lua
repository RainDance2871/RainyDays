SMODS.DrawStep {
  key = 'rd_sprite_to_canvas',
  order = 25,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if self.config.center.rd_canvas_drawing and (self.config.center.discovered or self.bypass_discovery_center) then
      --setup canvas
      self.rd_canvas_sprite = self.rd_canvas_sprite or SMODS.CanvasSprite({ canvasScale = 10 })
      local canvas_sprite = self.rd_canvas_sprite
      canvas_sprite.canvas:renderTo(love.graphics.clear, 0, 0, 0, 0)
      
      local function draw_sprite_in_canvas(sprite)
        love.graphics.push()
        love.graphics.origin()
        love.graphics.scale(canvas_sprite.canvasScale)
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
      
      local function setup_shader(shader_key, sprite)
        local _draw_major = sprite.role.draw_major or sprite
        G.SHADERS[shader_key]:send('dissolve', math.abs(_draw_major.dissolve or 0))
        G.SHADERS[shader_key]:send('time', 123.33412 * (_draw_major.ID / 1.14212 or 12.5123152) % 3000)
        G.SHADERS[shader_key]:send('texture_details', sprite:get_pos_pixel())
        G.SHADERS[shader_key]:send('image_details', sprite:get_image_dims())
        G.SHADERS[shader_key]:send('burn_colour_1', _draw_major.dissolve_colours and _draw_major.dissolve_colours[1] or G.C.CLEAR)
        G.SHADERS[shader_key]:send('burn_colour_2', _draw_major.dissolve_colours and _draw_major.dissolve_colours[2] or G.C.CLEAR)
        
        local send = SMODS.Shader.obj_table[shader_key].send_vars()
        for key, value in pairs(send) do
          G.SHADERS[shader_key]:send(key, value)
        end
        love.graphics.setShader(G.SHADERS[shader_key])
      end
      
      --card
      if self.children.center then
        canvas_sprite.canvas:renderTo(draw_sprite_in_canvas, self.children.center)
      end
      
      --soul
      if self.children.floating_sprite then
        if self.config.center.rd_waveform then
          local sprite = self.children.floating_sprite
          setup_shader('RainyDays_waveform_soul', sprite)
          canvas_sprite.canvas:renderTo(draw_sprite_in_canvas, sprite)
          love.graphics.setShader()
        else
          canvas_sprite.canvas:renderTo(draw_sprite_in_canvas, self.children.floating_sprite)
        end
      end
      
      --canvas text
      if self.config.center.rd_canvas_text then
        local canvas_text = self.config.center.rd_canvas_text --font, colour, text, offset {x, y}, align {h, v}, width, height
        local text = love.graphics.newText(canvas_text.font or G.FONTS[1].FONT, { canvas_text.colour or G.C.UI.TEXT_DARK, canvas_text.text or '' })
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
    end
  end
}

SMODS.DrawStep {
  key = 'rd_soul_indicators',
  order = 25,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if self.config.center.rd_soul_indicator_shader and (RainyDays.config.clarifiers == 1 or RainyDays.config.clarifiers == 2) and (self.config.center.discovered or self.bypass_discovery_center) then
      if self.area and not self.area.created_on_pause and G.GAME.blind then
        RainyDays.card_drawn = self
        self.children.floating_sprite:draw_shader(self.config.center.rd_soul_indicator_shader, nil, nil, nil, self.children.center)
        RainyDays.card_drawn = nil
      end
    end
  end
}

SMODS.DrawStep {
  key = 'rd_highlights',
  order = 26,
  conditions = { vortex = false, facing = 'front' },
  func = function(self, layer)
    if RainyDays.config.metallic_hightlights and self.config.center.rd_highlight_shader and (self.config.center.discovered or self.bypass_discovery_center) then
      self.children.floating_sprite:draw_shader(self.config.center.rd_highlight_shader, nil, self.ARGS.send_to_shader, nil, self.children.center)
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
    if ((G.GAME.rd_early_bird and G.GAME.rd_early_bird > 0) or next(SMODS.find_card('j_RainyDays_early_birds', true))) and self.ability and self.ability.rd_early_bird and not self.debuff then
      RainyDays.sprite_early_bird_sticker = RainyDays.sprite_early_bird_sticker or SMODS.create_sprite(0, 0, 71, 95, 'RainyDays_Jokers', RainyDays.GetJokersAtlasTable('early_birds_border'))
      RainyDays.sprite_early_bird_sticker.role.draw_major = self
      RainyDays.sprite_early_bird_sticker:draw_shader('dissolve', nil, nil, nil, self.children.center)
      RainyDays.sprite_early_bird_sticker:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
    end
  end
}