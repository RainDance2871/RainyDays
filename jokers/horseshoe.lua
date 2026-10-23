SMODS.Joker {
  key = 'horseshoe',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true, 
  pos = RainyDays.GetJokersAtlasTable('horseshoe'),
  attributes = { 'rank', 'seven', 'modify_card', 'enhancements' },
  
  config = {
    extra = {
      rank = '7'
    }
  },
  
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    return {
      vars = {
        localize(card.ability.extra.rank, 'ranks')
      }
    } 
  end,
  
  calculate = function(self, card, context)
    if context.before then
      local seven_found
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i]:get_id() == RainyDays.balatro_ranks_to_id[card.ability.extra.rank] then
          seven_found = true
          break
        end
      end
      
      if seven_found then
        local choices = {}
        for i = 1, #context.scoring_hand do 
          if not context.scoring_hand[i].getting_enhancement and not context.scoring_hand[i].debuff and context.scoring_hand[i].ability.set ~= 'Enhanced' then
            choices[#choices + 1] = context.scoring_hand[i]
          end
        end
        
        if #choices <= 0 then
          return
        end
        
        local upgrade_card = pseudorandom_element(choices, pseudoseed('horseshoe' .. G.GAME.round_resets.ante))
        if upgrade_card then
          upgrade_card.getting_enhancement = true       
          G.E_MANAGER:add_event(Event({
            func = function()
              upgrade_card.getting_enhancement = nil
              return true
            end
          }))
          return RainyDays.set_ability_multiple(context.blueprint_card or card, upgrade_card, 'm_lucky')
        end
      end
    end
  end
}