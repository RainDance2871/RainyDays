SMODS.Joker {
  key = 'flipflop',
  name = 'Flip-flop',
  atlas = 'RainyDays',
  rarity = 2,
  cost = 6,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('flipflop_even'),
  config = {
    plus_xmult = 2,
    plus_chips = 100,
    state = 0
  },
  
  loc_vars = function(self, info_queue, card)
    local key = 'j_RainyDays_flipflop_odd'
    if card.ability.state == 0 then --do we really have two entirely different entries just to display one variable differently? yes.
      key = 'j_RainyDays_flipflop_even'
    end
    return {
      key = key,
      vars = {
        card.ability.plus_xmult,
        card.ability.plus_chips,
      }
    }
  end,
  
  set_sprites = function(self, card, front)
    if card.ability and card.ability.state == 1 then
      card.children.center:set_sprite_pos(GetRainyDaysAtlasTable('flipflop_odd'))
    end
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      if card.ability.state == 0 then
        if not context.blueprint then
           G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.5,
            blocking = false,
            func = function()
              card:flip()
              card.ability.state = 1
              card.children.center:set_sprite_pos(GetRainyDaysAtlasTable('flipflop_odd'))
              card:flip()
            return true
            end
          }))
        end
        return {
          Xmult_mod = card.ability.plus_xmult,
          message = localize {
            type = 'variable',
            key = 'a_xmult',
            vars = { card.ability.plus_xmult }
          },
          colour = G.C.RED
        }
      else
        if not context.blueprint then
          G.E_MANAGER:add_event(Event({ 
            trigger = "after",
            delay = 0.5,
            blocking = false,
            func = function()
              card:flip()
              card.ability.state = 0
              card.children.center:set_sprite_pos(GetRainyDaysAtlasTable('flipflop_even'))
              card:flip()
              return true
            end
          }))
        end
        return {
          chip_mod =  card.ability.plus_chips,
          message = localize {
            type = 'variable',
            key = 'a_chips',
            vars = { card.ability.plus_chips }
          },
          colour = G.C.CHIPS,
        }
      end
    end
  end
}