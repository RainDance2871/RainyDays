loc_colour() --first time running creates G.ARGS.LOC_COLOURS
G.ARGS.LOC_COLOURS.ivory = HEX('e0d59d')

if RainyDays.config.constellations then SMODS.Seal {
  key = 'ivory',
  atlas = 'Seals',
  pos = { x = 0, y = 0 },
  badge_colour = G.ARGS.LOC_COLOURS.ivory,

  calculate = function(self, card, context)
    if context.before and G.GAME.current_round.hands_played == 0 then
      local played = false
      for i = 1, #context.full_hand do
        if context.full_hand[i] == card then
          return create_constellation(card)
        end
      end
    end
  end,
  
  draw = function(self, card, layer)
    if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
      G.shared_seals[card.seal].role.draw_major = card
      G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
      G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
  end
} end