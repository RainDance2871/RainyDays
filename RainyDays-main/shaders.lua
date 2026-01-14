SMODS.Shader {
  key = 'metallic_highlight',
  path = 'metallic_highlight.fs',
  
  send_vars = function (sprite, card)
    return {
      brightness = 1.6,
      scaling = 0.03
    }
  end
}

SMODS.Shader {
  key = 'false_glow',
  path = 'false_glow.fs',
  
  send_vars = function (sprite, card)
    return {
      timer = 300 * love.timer.getTime()
    }
  end
}