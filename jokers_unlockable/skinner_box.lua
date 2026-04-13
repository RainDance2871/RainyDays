SMODS.Joker {
  key = 'skinner_box',
  atlas = 'Jokers',
  rarity = 2,
  cost = 5,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('skinner_box'),
  
  config = {
    extra = {
      money_low = 3,
      money_high = 9,
      border_increase = 4
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local main_end = card.ability.extra.current_card_value and {
      { n = G.UIT.T, config = { text = '(' .. localize('rainydays_currently') .. ' ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }},
      { n = G.UIT.T, config = { text = localize('$') .. card.ability.extra.current_card_value, colour = G.C.MONEY, scale = 0.32 }},
      { n = G.UIT.T, config = { text = ')', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }}
    } or nil
    
    return {
      main_end = main_end,
      vars = {
        card.ability.extra.money_low,
        card.ability.extra.money_high,
        card.ability.extra.border_increase
      }
    }
  end,
  
  set_sprites = function(self, card, front)
    if card.ability then
      generate_sell_value_sprite(card, card.sell_cost, true)
      card.ability.extra.value_displayed = card.sell_cost
    end
  end,
  
  update = function(self, card, dt)
    if card.ability then
      if not card.ability.extra.value_displayed or card.ability.extra ~= card.sell_cost then
        generate_sell_value_sprite(card, card.sell_cost)
        card.ability.extra.value_displayed = card.sell_cost
      end
    end
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false and not context.repetition and not context.individual and not context.blueprint then
      card.ability.extra.current_card_value = pseudorandom('skinner_box', card.ability.extra.money_low, card.ability.extra.money_high)
      card:set_cost()
      card.ability.extra.money_high = card.ability.extra.money_high + card.ability.extra.border_increase
      card_eval_status_text(card, 'extra', nil, nil, nil, {
        message = localize('$') .. card.ability.extra.current_card_value,
        colour = G.C.MONEY
      })
    end
  end,
  
  locked_loc_vars = function(self, info_queue, card)
    local total = 0
    if G.jokers and G.jokers.cards then
      for i = 1, #G.jokers.cards do
        total = total + math.max(0, G.jokers.cards[i].sell_cost)
      end
    end
      
    return { 
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(localize('$') .. total) or nil,
      vars = { 
        50
      }
    }
  end,
  
  check_for_unlock = function(self, args)
    if args.type == 'modify_jokers_cost' and G.jokers then
      local total = 0
      for i = 1, #G.jokers.cards do
        total = total + math.max(0, G.jokers.cards[i].sell_cost)
        if total >= 50 then
          return true
        end
      end
    return false
    end
  end
}

local set_cost_ref = Card.set_cost
function Card:set_cost()
  local ret = set_cost_ref(self)
  if self.config.center.key == 'j_RainyDays_skinner_box' and self.ability.extra.current_card_value then
    self.sell_cost = math.floor(self.ability.extra.current_card_value + (self.ability.extra_value or 0) + 0.5 * (get_edition_cost(self) or 0))
    self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
  end
  check_for_unlock({ type = 'modify_jokers_cost' }) 
  return ret
end

function get_edition_cost(card)
  if card.edition then
    for _, value in pairs(G.P_CENTER_POOLS.Edition) do
      if card.edition[value.key:sub(3)] and value.extra_cost then
        return value.extra_cost
      end
    end
  end
end

function generate_sell_value_sprite(card, value, force)
  if not card.canvas_text then
    card.canvas_text = SMODS.CanvasSprite({
      text_colour = G.C.UI.TEXT_DARK,
      text_offset = { x = 65, y = 21 },
      text_h_align = 'right',
      text_width = 59, 
      text_height = 20
    })
  end
  card.canvas_text.text = localize('$') .. value
end