SMODS.Joker {
  key = 'prehistory',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('prehistory'),
  config = {
    extra = {
      plus_chips = 2
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.plus_chips,
        card.ability.extra.plus_chips * (G.GAME and G.GAME.rd_jokers_uniquelist_count or 0)
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      return {
        chips = card.ability.extra.plus_chips * G.GAME.rd_jokers_uniquelist_count
      }
    end
    
    if context.rd_unique_joker_added and not context.blueprint then
      if #context.card_keys > 1 or context.card_keys[1] ~= card.config.center.key then
        return {
          message_card = card,
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS
        }
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)    
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.rd_jokers_uniquelist_count or 0) or nil,
      vars = { 
        20
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'modify_jokers' and G.jokers and G.GAME.rd_jokers_uniquelist_count >= 20
  end
}