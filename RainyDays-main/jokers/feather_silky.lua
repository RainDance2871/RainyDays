SMODS.Joker {
  key = 'feather_silky',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('feather_silky'),
  config = {
    extra = {
      plus_mult = 7
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_mult, 
        card.ability.extra.plus_mult * GetFeatherCount() 
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      local feather_count = GetFeatherCount()
      return {
        mult = feather_count * card.ability.extra.plus_mult
      }
    end
  end
}