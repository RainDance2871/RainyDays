SMODS.Joker {
  key = 'prehistory',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('prehistory'),
  config = {
    extra = {
      plus_chips = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_chips,
        card.ability.extra.plus_chips * (G.GAME and G.GAME.jokers_uniquelist_count or 0)
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      return {
        chips = card.ability.extra.plus_chips * (G.GAME and G.GAME.jokers_uniquelist_count or 0)
      }
    end
    
    if context.unique_joker_added and context.card_key ~= card.config.center.key and not context.blueprint then
      return { 
        message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.plus_chips * (G.GAME and G.GAME.jokers_uniquelist_count or 0) }},
        colour = G.C.CHIPS
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { vars = { 20 }}
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_jokers' and G.jokers then
      return (G.GAME and G.GAME.jokers_uniquelist_count or 0) >= 20
    end
  end
}

--maintain list of unique jokers
local add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
  if G.GAME and self.ability.set == "Joker" then
    if not G.GAME.jokers_uniquelist then
      G.GAME.jokers_uniquelist = {}
      G.GAME.jokers_uniquelist_count = 0
    end
    if not G.GAME.jokers_uniquelist[self.config.center.key] then
      G.GAME.jokers_uniquelist[self.config.center.key] = true
      G.GAME.jokers_uniquelist_count = G.GAME.jokers_uniquelist_count + 1
      SMODS.calculate_context({ unique_joker_added = true, card_key = self.config.center.key })
    end
  end
  return add_to_deck_ref(self, from_debuff)
end