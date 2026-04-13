SMODS.Joker {
  key = 'wishbone',
  atlas = 'Jokers',
  rarity = 1,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('wishbone'),
  config = {
    extra = {
      chips = 50
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS[G.GAME.current_round.RD_wishbone]
    
    local string_tarot1 = localize{ type = 'name_text', set = 'Tarot', key = G.GAME.current_round.RD_wishbone }
    local string_tarot2
    local split = string.find(string_tarot1, ' ', 6)
    if split then
      string_tarot2 = string.sub(string_tarot1, split + 1, -1)
      string_tarot1 = string.sub(string_tarot1, 1, split - 1)
    end
    
    return {
      key = split and 'j_RainyDays_wishbone_long' or 'j_RainyDays_wishbone_short',
      vars = {
        card.ability.extra.chips,
        string_tarot1,
        string_tarot2
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
    
    if context.selling_self and not context.blueprint then
      return RainyDays.create_consumable(context.other_joker, 'Tarot', nil, G.GAME.current_round.RD_wishbone)
    end
  end
}

function RainyDays.reset_game_globals_wishbone()
  G.GAME.current_round.RD_wishbone = pseudorandom_element(G.P_CENTER_POOLS['Tarot'], pseudoseed('wishbone' .. G.GAME.round_resets.ante)).key
end