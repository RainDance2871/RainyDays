SMODS.Joker {
  key = 'feather_marvelous',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 2,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  in_pool = function(self, args) --only appears if player has at least one feather joker already
    return (GetFeatherCount() > 0)
  end,
  pos = GetJokersAtlasTable('feather_marvelous'),
  config = {
    extra = {
      plus_xmult = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_xmult, 
        card.ability.extra.plus_xmult * GetFeatherCount() 
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      local feather_count = GetFeatherCount()
      return {
        xmult = math.max(1, feather_count * card.ability.extra.plus_xmult)
      }
    end
  end
}