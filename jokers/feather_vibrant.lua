SMODS.Joker {
  key = 'feather_vibrant',
  atlas = 'Jokers',
  pools = { Feather = true },
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('feather_vibrant'),
  config = {
    extra = {
      plus_chips = 40
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_chips, 
        card.ability.extra.plus_chips * GetFeatherCount() 
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
      local feather_count = GetFeatherCount()
      return {
        chips = feather_count * card.ability.extra.plus_chips
      }
    end
  end
}