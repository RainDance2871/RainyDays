SMODS.Joker {
  key = 'fan_mail',
  atlas = 'Jokers',
  rarity = 1,
  cost = 5,
  unlocked = true, 
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('fan_mail'),
  config = {
    extra = {
      packs = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.packs
      }
    } 
  end,
  
  add_to_deck = function(self, card, from_debuff)
    SMODS.change_booster_limit(card.ability.extra.packs)
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_booster_limit(-card.ability.extra.packs)
  end
}