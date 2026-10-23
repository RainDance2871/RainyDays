SMODS.Joker {
  key = 'goose',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('goose'),
  attributes = { 'scaling', 'xmult', 'tag' },
  config = {
    extra = {
      xmult = 1,
      xmult_gain = 0.4
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.xmult_gain,
        card.ability.extra.xmult
      }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.xmult
      }
    end
    
    if context.tag_added and not context.tag_added.getting_sliced and not context.blueprint then
      context.tag_added.getting_sliced = true
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1,
        func = function()
          if context.tag_added then
            context.tag_added:remove()
            SMODS.scale_card(card, {
              ref_table = card.ability.extra,
              ref_value = 'xmult',
              scalar_value = 'xmult_gain',
              scaling_message = { message = localize('k_upgrade_ex'), message_card = card, colour = G.C.MULT }
            })
          end
          return true
        end
      }))
    end
    
    if context.prevent_tag_trigger and context.prevent_tag_trigger.getting_sliced and not context.blueprint then
      return {
        prevent_trigger = true
      }
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.rainydays_tag_count or 0) or nil,
      vars = { 
        10
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    return args.type == 'rd_tag_count' and G.GAME.rd_tag_count and G.GAME.rd_tag_count >= 10
  end
}