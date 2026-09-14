SMODS.Joker {
  key = 'lady_of_the_lake',
  atlas = 'Jokers',
  rarity = 3,
  cost = 6,
  unlocked = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('lady_of_the_lake'),
  soul_pos = RainyDays.GetJokersAtlasTable('lady_of_the_lake_soul'),
  rd_highlight_shader = 'RainyDays_metallic_highlight',
  rd_skip_soul = true,
  attributes = { 'enhancements', 'modify_card' },  
  config = {
    extra = {
      cards = 5
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = { 
        card.ability.extra.cards
      }
    } 
  end,

  calculate = function (self, card, context)
    if context.before and context.main_eval and #context.scoring_hand >= card.ability.extra.cards then
      local choices = {}
      for i = 1, #context.scoring_hand do 
        if not context.scoring_hand[i].ladylaked and not context.scoring_hand[i].debuff then
          choices[#choices + 1] = context.scoring_hand[i]
        end
      end
      
      if #choices <= 0 then
        return
      end
      
      local upgrade_card = pseudorandom_element(choices, pseudoseed('ladylake' .. G.GAME.round_resets.ante))
      if upgrade_card then
        local options = {}
        for _, value in pairs(G.P_CENTER_POOLS['Enhanced']) do
          if value.key ~= upgrade_card.config.center.key then
            options[#options + 1] = value.key
          end
        end
        local enhancement = SMODS.poll_enhancement({ type_key = 'ladylake', guaranteed = true, options = options })
        upgrade_card.ladylaked = true       
        G.E_MANAGER:add_event(Event({
          func = function()
            upgrade_card.ladylaked = nil
            return true
          end
        }))
        return RainyDays.set_ability_multiple(context.blueprint_card or card, upgrade_card, enhancement)
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
          if not RainyDays.list_contains(list_enhance, key) then
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