SMODS.Joker {
  key = 'feather_vibrant',
  name = 'Vibrant Feather',
  atlas = 'RainyDays',
  pools = { Feather = true },
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetRainyDaysAtlasTable('feather_vibrant'),
  config = {
    plus_chips = 60
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.plus_chips, card.ability.plus_chips * GetFeatherCount() }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      local feather_count = GetFeatherCount()
      return {
        chip_mod = feather_count * card.ability.plus_chips,
        message = localize {
          type = 'variable',
          key = 'a_chips',
          vars = { feather_count * card.ability.plus_chips }
        },
        colour = G.C.CHIPS,
      }
    end
  end
}