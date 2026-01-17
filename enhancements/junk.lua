SMODS.Enhancement {
  key = 'junk',
  atlas = 'Enhancements',
  pos = GetEnhancementAtlasTable('junk3'),
  config = {
    extra = { 
      plays_needed = 3,
      plays_made = 0
    } 
  },
  replace_base_card = true,
  no_rank = true,
  no_suit = true,
  never_scores = true,
  weight = 0,
  
  set_ability = function(self, card, initial, delay_sprites)
    if not G.GAME.creating_junk then
      local enhancement = SMODS.poll_enhancement({ type_key = 'junk', guaranteed = false })
      card:set_ability(enhancement, nil, true)
    end
  end,
  
  loc_vars = function(self, info_queue, card)
    return { 
      vars = { 
        card.ability.extra.plays_needed,
        math.max(0, card.ability.extra.plays_needed - card.ability.extra.plays_made)
      }
    }
  end,
  
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra then
      local xx = math.min(math.max(0, card.ability.extra.plays_needed - card.ability.extra.plays_made), 3)
      card.children.center:set_sprite_pos(GetEnhancementAtlasTable('junk' .. xx))
    end
  end,
  
  calculate = function(self, card, context)
    if context.before then
      local function card_is_played()
        for i = 1, #context.full_hand do
          if context.full_hand[i] == card then
            return true
          end
        end
      end
      
      if card_is_played() then
        card.ability.extra.plays_made = card.ability.extra.plays_made + 1
        local xx = math.min(math.max(0, card.ability.extra.plays_needed - card.ability.extra.plays_made), 3)
        card.children.center:set_sprite_pos(GetEnhancementAtlasTable('junk' .. xx))
      end
    end
    
    if context.destroy_card == card and card.ability.extra.plays_made >= card.ability.extra.plays_needed then 
      return { remove = true }
    end
  end
}