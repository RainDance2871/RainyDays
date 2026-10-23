SMODS.Joker {
  key = 'collection',
  atlas = 'Wide',
  rarity = 3,
  cost = 8,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = { x = 1, y = 0 },
  display_size = { w = 72, h = 70 },
  pixel_size = { w = 72, h = 70 },
  attributes = { 'xmult', 'joker' },
  
  config = { 
    extra = { 
      Xmult = 4,
      jokers = 20
    }
  },
  
  loc_vars = function(self, info_queue, card)    
    local active = G.GAME.rd_jokers_uniquelist_count >= card.ability.extra.jokers
    return {
      key = active and 'j_RainyDays_collection_active' or 'j_RainyDays_collection',
      vars = {
        card.ability.extra.Xmult,
        card.ability.extra.jokers,
        card.ability.extra.jokers - G.GAME.rd_jokers_uniquelist_count
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.rd_jokers_uniquelist_count >= card.ability.extra.jokers then
      return {
        xmult = card.ability.extra.Xmult
      }
    end
    
    if context.card_added and context.card.ability.set == 'Joker' and context.card ~= card then
      if not G.GAME.rd_jokers_uniquelist[context.card.config.center.key] and not context.blueprint then
        local difference = card.ability.extra.jokers - G.GAME.rd_jokers_uniquelist_count - 1
        return {
          message = difference <= 0 and localize('rainydays_activated') or (localize('rainydays_jokers_message_prefix') .. difference .. localize('rainydays_jokers_message_postfix')),
          colour = G.C.FILTER
        }
      end
    end
  end
}

local old_generate_UIBox_func_ref = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(vars_only)
  if self.area == G.pack_cards or self.area == G.shop_jokers then
    local collection = SMODS.find_card('j_RainyDays_collection', true)
    if collection and collection[1] and collection[1].ability and G.GAME.rd_jokers_uniquelist_count < collection[1].ability.extra.jokers then
      RainyDays.collection_message = true
    end
  end
  local ret = old_generate_UIBox_func_ref(self, vars_only)
  RainyDays.collection_message = nil
  return ret
end