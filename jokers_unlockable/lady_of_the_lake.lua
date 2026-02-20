SMODS.Joker {
  key = 'lady_of_the_lake',
  atlas = 'Jokers',
  rarity = 3,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('lady_of_the_lake'),
  soul_pos = GetJokersAtlasTable('lady_of_the_lake_soul'),
  soul_draw_as_highlight = true,
  soul_draw_as_highlight_shader = 'RainyDays_metallic_highlight',

  calculate = function (self, card, context)
    if context.before and context.main_eval then
      for i = 1, #context.full_hand do
        if not context.full_hand[i].ladylaked and next(SMODS.get_enhancements(context.full_hand[i])) then
          return
        end
      end
      
      local choices = {}
      for i = 1, #context.scoring_hand do 
        if not context.scoring_hand[i].ladylaked then
          choices[#choices + 1] = context.scoring_hand[i]
        end
      end
      
      if #choices <= 0 then
        return
      end
      
      local upgrade_card = pseudorandom_element(choices, pseudoseed('ladylake' .. G.GAME.round_resets.ante))
      if upgrade_card then
        local enhancement = SMODS.poll_enhancement({ type_key = 'ladylake', guaranteed = true })
        upgrade_card:set_ability(enhancement, nil, true)
        upgrade_card.ladylaked = true
        G.E_MANAGER:add_event(Event({
          func = function()
            upgrade_card:juice_up()
            upgrade_card.ladylaked = nil
            return true
          end
        }))
        return {
          message = localize('rainydays_enhanced')
        }
      end
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    return { vars = { 5 }}
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'hand_contents' then
      local list_enhance = {}
      for i = 1, #args.cards do
        local enhancements = SMODS.get_enhancements(args.cards[i])
        for key, _ in pairs(enhancements) do
          if not list_contains(list_enhance, key) then
            list_enhance[#list_enhance + 1] = key
            if #list_enhance >= 5 then
              return true
            end
          end
        end
      end
    end
    return false
  end
}