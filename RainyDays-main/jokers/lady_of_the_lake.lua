SMODS.Joker {
  key = 'lady_of_the_lake',
  atlas = 'Jokers',
  rarity = 3,
  cost = 6,
  unlocked = true, 
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('lady_of_the_lake'),
  soul_pos = GetJokersAtlasTable('lady_of_the_lake_soul'),
  soul_draw_as_highlight = true,
  soul_draw_as_highlight_shader = 'RainyDays_metallic_highlight',

  calculate = function (self, card, context)
    if context.before and context.main_eval and #context.full_hand >= 5 then
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
  end
}