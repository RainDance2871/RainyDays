SMODS.Joker {
  key = 'feather_silky',
  name = 'Silky Feather',
  atlas = 'RainyDays',
  pools = { Feather = true },
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('feather_silky'),
  config = {
    plus_mult = 8
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.plus_mult, card.ability.plus_mult * GetFeatherCount() }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      local feather_count = GetFeatherCount()
      return {
        mult_mod = feather_count * card.ability.plus_mult,
        message = localize {
          type = 'variable',
          key = 'a_mult',
          vars = { feather_count * card.ability.plus_mult }
        },
        colour = G.C.MULT,
      }
    end
  end
}