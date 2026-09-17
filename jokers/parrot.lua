SMODS.Joker {
  key = 'parrot',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('parrot'),
  attributes = { 'copying', 'joker' },
  
  config = {
    extra = {
      copied_before = {},
      round_limit = 5
    }
  },
  
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.round = card.ability.extra.round or G.GAME.round
  end,
  
  loc_vars = function(self, info_queue, card)
    local contents = {}
    local other_joker_name
    local main_end
    
    if card.area and card.area == G.jokers and G.GAME.blind then
      for i = 1, #G.jokers.cards do
        if RainyDays.parrot_copied_before(card, G.jokers.cards[i]) then
          local name = localize{ type = 'name_text', set = 'Joker', key = G.jokers.cards[i].config.center_key }
          
          local function amount_of_copies(card)
            local amount = 0
            local nr
            for j = 1, #G.jokers.cards do
              if G.jokers.cards[j].config.center.key == card.config.center.key then
                amount = amount + 1
                if G.jokers.cards[j] == card then
                  nr = amount
                end
              end
            end
            return amount, nr
          end
          
          local amount, nr = amount_of_copies(G.jokers.cards[i])
          if amount > 1 and nr then
            name = name .. localize('rainydays_infobox_nr_sign_prefix') .. nr .. localize('rainydays_infobox_nr_sign_postfix')
          end
          
          if card.ability.extra.other_joker_id == G.jokers.cards[i].ability.rd_joker_id then
            other_joker_name = name
          else
            contents[#contents + 1] = name
          end
        end
      end
      
      if #contents > 0 then
        local box = RainyDays.create_infobox_list(localize('rainydays_parrot_box_name'), contents)
        info_queue[#info_queue + 1] = { set = 'Other', key = box }
      end
      
      
      local other_joker
      if card.ability.extra.other_joker_id then
        for i = 1, #G.jokers.cards do
          if card.ability.extra.other_joker_id == G.jokers.cards[i].ability.rd_joker_id then
            other_joker = G.jokers.cards[i]
            break
          end
        end
      end
    
      if not other_joker then
        local next_joker
        for i = 1, #G.jokers.cards do
          if G.jokers.cards[i] == card then 
            next_joker = G.jokers.cards[i + 1]
          end
        end
        
        local compatible = next_joker and next_joker.config.center.blueprint_compat
        local string = localize('k_' .. (compatible and 'compatible' or 'incompatible'))
        if compatible and RainyDays.parrot_copied_before(card, next_joker) then
          compatible = false
          local rounds_remain = card.ability.extra.copied_before[next_joker.ability.rd_joker_id] + card.ability.extra.round_limit - card.ability.extra.round + 1
          if rounds_remain > 1 then
            string = string.lower(localize('rainydays_parrot_wait_prefix_plural') .. rounds_remain .. localize('rainydays_parrot_wait_postfix_plural'))
          else
            string = string.lower(localize('rainydays_parrot_wait_prefix_singular') .. rounds_remain .. localize('rainydays_parrot_wait_postfix_singular'))
          end
        end
        
        main_end = {{
          n = G.UIT.C,
          config = { align = 'bm', minh = 0.4 },
          nodes = {{
            n = G.UIT.C,
            config = { ref_table = card, align = 'm', colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
            nodes = {{ n = G.UIT.T, config = { text = ' ' .. string .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 }}}
          }}
        }}
      end
    end
    
    return {
      main_end = main_end,
      vars = {
        colours = { 
          other_joker_name and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        other_joker_name or string.lower(localize('k_none')),
        card.ability.extra.round_limit
      }
    }
  end,

  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card and G.jokers.cards[i + 1] and G.jokers.cards[i + 1].config.center.blueprint_compat then
          if not RainyDays.parrot_copied_before(card, G.jokers.cards[i + 1]) then
            card.ability.extra.other_joker_id = G.jokers.cards[i + 1].ability.rd_joker_id
            card.ability.extra.copied_before[card.ability.extra.other_joker_id] = card.ability.extra.round
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('rainydays_found_target'), colour = G.C.GREEN })
          end
        end
      end
    end
    
    if (context.joker_type_destroyed or context.selling_card) and context.card and context.card.ability and not card.ability.extra.target_destroyed then
      if context.card.ability.rd_joker_id and context.card.ability.rd_joker_id == card.ability.extra.other_joker_id then
        card.ability.extra.target_destroyed = true
        
        local reset = {
          message = localize('k_reset'),
          colour = G.C.GREEN,
          func = function()
            card.ability.extra.target_destroyed = nil
            card.ability.extra.other_joker_id = nil
          end
        }
        
        local ret = SMODS.blueprint_effect(card, context.card, context)
        if ret then
          ret.colour = G.C.GREEN
          if not ret.extra then
            ret.extra = reset
          else
            ret.extra.extra = reset
          end
          return ret
        end
        return reset
      end
    end
    
    if context.end_of_round then
      if not context.repetition and not context.individual then
        card.ability.extra.round = G.GAME.round + 1
        for key, round in pairs(card.ability.extra.copied_before) do
          if card.ability.extra.round - round >= card.ability.extra.round_limit + 1 then
            card.ability.extra.copied_before[key] = nil
          end
        end
        
        if card.ability.extra.other_joker_id then
          card.ability.extra.other_joker_id = nil
          return {
            message = localize('k_reset'),
            colour = G.C.GREEN
          }
        end
      end
      return
    end
    
    if card.ability.extra.other_joker_id then
      local other_joker
      for i = 1, #G.jokers.cards do
        if card.ability.extra.other_joker_id == G.jokers.cards[i].ability.rd_joker_id then
          other_joker = G.jokers.cards[i]
          break
        end
      end
      
      if other_joker then
        local ret = SMODS.blueprint_effect(card, other_joker, context)
        if ret then
          ret.colour = G.C.GREEN
          return ret
        end
      end
    end
  end
}

function RainyDays.parrot_copied_before(parrot, copied_card)
  for key in pairs(parrot.ability.extra.copied_before) do    
    if key == copied_card.ability.rd_joker_id then
      return true
    end
  end
  return false
end