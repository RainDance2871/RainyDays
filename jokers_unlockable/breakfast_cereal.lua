SMODS.Joker {
  key = 'breakfast_cereal',
  atlas = 'Jokers',
  pools = { Food = true },
  rarity = 2,
  cost = 5,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('breakfast_cereal'),
  config = {
    extra = {
      cards_amount = 12,
      repetitions = 1
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_TAGS.tag_charm
    return {
      vars = {
        math.max(0, card.ability.extra.cards_amount)
      }
    } 
  end,
  
  calculate = function (self, card, context)
    if context.repetition and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card)) and card.ability.extra.cards_amount > 0 then
      if not context.blueprint then
        card.ability.extra.cards_amount = card.ability.extra.cards_amount - 1
      end
      
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
    
    if context.after and not context.blueprint then
      if card.ability.extra.cards_amount <= 0 then
        SMODS.destroy_cards(card, nil, nil, true)
        card_eval_status_text(card, 'jokers', nil, nil, nil, { message = localize('k_eaten_ex'), colour = G.C.RED })
        G.E_MANAGER:add_event(Event({
          func = function()
            add_tag(Tag('tag_charm'))
            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
            return true
          end
        }))
        return {
          message = localize('rainydays_plus') .. '1 ' .. localize('rainydays_charm_tag'),
          colour = G.C.SECONDARY_SET.Tarot
        }
      end
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