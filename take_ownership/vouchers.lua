--old shop rate = 4 .. 9.6 .. 32
--new shop rate = 2 .. 4.8 .. 16

local game_init_ref = Game.init_game_object
function Game:init_game_object()
  local ret = game_init_ref(self)
  if RainyDays.config.constellations then
    ret.planet_rate = ret.planet_rate / 2
    ret.constellation_rate = ret.planet_rate
  end
  return ret
end

if RainyDays.config.constellations then SMODS.Voucher:take_ownership('planet_merchant', {
  redeem = function(self, card)
    G.E_MANAGER:add_event(Event({
      func = function()
        local rate_change = 9.6 / 4 --starting rate 2 -> after 4.8
        G.GAME.planet_rate = G.GAME.planet_rate * rate_change
        G.GAME.constellation_rate = G.GAME.constellation_rate * rate_change
        return true
      end
    }))
  end,
}, true)

SMODS.Voucher:take_ownership('planet_tycoon', {
  redeem = function(self, card)
    G.E_MANAGER:add_event(Event({
      func = function()
        local rate_change = 32 / 9.6 --rate with merchant 4.8 -> after 16
        G.GAME.planet_rate = G.GAME.planet_rate * rate_change
        G.GAME.constellation_rate = G.GAME.constellation_rate * rate_change
        return true
      end
    }))
  end,
}, true)
end