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
      copied_before = {}
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local contents = {}
    local other_joker_name
    local main_end
    
    if card.area and card.area == G.jokers and G.GAME.blind then
      for i = 1, #G.jokers.cards do
        if RainyDays.list_contains(card.ability.extra.copied_before, G.jokers.cards[i].ability.rd_joker_id) then
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
    
      if not G.GAME.blind.in_blind then
        local next_joker
        for i = 1, #G.jokers.cards do
          if G.jokers.cards[i] == card then 
            next_joker = G.jokers.cards[i + 1]
          end
        end
        
        local compatible = next_joker and next_joker.config.center.blueprint_compat
        local string = localize('k_' .. (compatible and 'compatible' or 'incompatible'))
        if compatible and RainyDays.list_contains(card.ability.extra.copied_before, next_joker.ability.rd_joker_id) then
          compatible = false
          string = string.lower(localize('rainydays_parrot_copied_before'))
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
        other_joker_name or string.lower(localize('k_none'))
      }
    }
  end,

  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card and G.jokers.cards[i + 1] and G.jokers.cards[i + 1].config.center.blueprint_compat then
          if not RainyDays.list_contains(card.ability.extra.copied_before, G.jokers.cards[i + 1].ability.rd_joker_id) then
            card.ability.extra.other_joker_id = G.jokers.cards[i + 1].ability.rd_joker_id
            card.ability.extra.copied_before[#card.ability.extra.copied_before + 1] = card.ability.extra.other_joker_id
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('rainydays_found_target'), colour = G.C.GREEN })
          end
        end
      end
    end
    
    if context.end_of_round then
      if not context.repetition and not context.individual then
        if G.GAME.blind.boss and #card.ability.extra.copied_before > 0 then
          card.ability.extra.other_joker_id = nil
          card.ability.extra.copied_before = {}
          return {
            message = localize('rainydays_full_reset'),
            colour = G.C.GREEN
          }
        elseif card.ability.extra.other_joker_id then
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
        end
        return ret
      end
    end
  end
}