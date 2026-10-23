SMODS.Joker {
  key = 'bud',
  atlas = 'Jokers',
  rarity = 3,
  cost = 5,
  unlocked = true,
  blueprint_compat = false,
  eternal_compat = false,
  perishable_compat = false,
  pos = RainyDays.GetJokersAtlasTable('bud'),
  attributes = { 'chips', 'on_sell', 'lose_economy' },
  
  config = {
    extra = {
      dollar_take = 2,
      per_dollar = 1,
      chip_reward = 15,
      dollars_spent = 0
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local vars = {
      card.ability.extra.dollar_take,
      card.ability.extra.chip_reward,
      card.ability.extra.per_dollar,
      card.ability.extra.chip_reward * math.floor(card.ability.extra.dollars_spent / card.ability.extra.per_dollar),
      localize{ type = 'name_text', set = 'Joker', key = 'j_RainyDays_bud' },
      localize{ type = 'name_text', set = 'Joker', key = 'j_RainyDays_bud_bloomed' }
    }
    
    if not card.ability.extra.bloomed then
      local other_center = SMODS.shallow_copy(G.P_CENTERS['j_RainyDays_bud'])
      other_center.loc_vars = function(self)
        return {
          key = 'j_RainyDays_bud_bloomed',
          vars = vars 
        }
      end
      info_queue[#info_queue + 1] = other_center
      
      if next(SMODS.find_card('j_RainyDays_return_to_sender', true)) then
        info_queue[#info_queue + 1] = { set = 'Other', key = 'rainydays_return_to_sender_compatible_bloom', specific_vars = { 
          localize{ type = 'name_text', set = 'Joker', key = 'j_RainyDays_bud_bloomed' }, 
          localize{ type = 'name_text', set = 'Joker', key = 'j_RainyDays_return_to_sender' } 
        }}
      end
    end
    
    return {
      key = card.ability.extra.bloomed and 'j_RainyDays_bud_bloomed' or 'j_RainyDays_bud',
      vars = vars
    }
  end,
  
  load = function(self, card, card_table, other_card)
    if card.ability and card.ability.extra and card.ability.extra.bloomed then
      card.config.center.blueprint_compat = true
    end
  end,
  
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.bloomed and (card.config.center.discovered or card.bypass_discovery_center) then
      card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('bud_bloomed'))
    end
  end,
  
  calculate = function(self, card, context)
    if card.ability.extra.bloomed then
      if context.joker_main then
        return {
          chips = card.ability.extra.chip_reward * math.floor(card.ability.extra.dollars_spent / card.ability.extra.per_dollar)
        }
      end
    else
      if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
        ease_dollars(-card.ability.extra.dollar_take)
        card.ability.extra.dollars_spent = card.ability.extra.dollars_spent + card.ability.extra.dollar_take
        card_eval_status_text(card, 'dollars', -card.ability.extra.dollar_take)
      end
      
      if context.selling_self and not context.blueprint then
        local copy = SMODS.copy_card(card)
        copy.ability.extra.bloomed = true
        copy.config.center.blueprint_compat = true
        copy.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('bud_bloomed'))
        return {
          message_card = copy,
          message = localize('rainydays_bud_bloomed'),
          colour = G.C.FILTER
        }
      end
    end
  end
}