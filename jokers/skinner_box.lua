SMODS.Joker {
  key = 'skinner_box',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true, 
  discovered = true,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('skinner_box'),
  
  config = {
    extra = {
      money_low = 1,
      money_high = 7,
      border_increase = 4,
    }
  },
  
  loc_vars = function(self, info_queue, card)
    local main_end = this_joker_is_owned(card) and {
      { n = G.UIT.T, config = { text = '(' .. localize('rainydays_currently') .. ' ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }},
      { n = G.UIT.T, config = { text = localize('$') .. card.ability.extra.current_card_value, colour = G.C.MONEY, scale = 0.32 }},
      { n = G.UIT.T, config = { text = ')', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 }},
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
  
  set_ability = function(self, card, initial, delay_sprites)
    card.ability.extra.current_card_value = pseudorandom('skinner_box', card.ability.extra.money_low, card.ability.extra.money_high)
    card:set_cost()
  end,
  
  set_sprites = function(self, card, front)
    if card.ability then
      generate_sell_value_sprite(card, true)
    end
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
      card.ability.extra.money_high = card.ability.extra.money_high + card.ability.extra.border_increase
      card.ability.extra.current_card_value = pseudorandom('skinner_box', card.ability.extra.money_low, card.ability.extra.money_high)
      card:set_cost()
      card_eval_status_text(card, 'extra', nil, nil, nil, {
        message = localize('$') .. card.ability.extra.current_card_value,
        colour = G.C.MONEY
      })
    end
  end
}

local set_cost_ref = Card.set_cost
function Card:set_cost()
  local ret = set_cost_ref(self)
  if self.config.center.key == 'j_RainyDays_skinner_box' then
    self.sell_cost = math.floor((self.ability.extra.current_card_value or 0) + (self.ability.extra_value or 0) + 0.5 * (get_edition_cost(self) or 0))
    self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    generate_sell_value_sprite(self)
  end
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

function generate_sell_value_sprite(card, force)
  if not card.ability.canvas_sprite or force then
    card.ability.canvas_sprite = CanvasSprite(card.children.center.T.x, card.children.center.T.y, card.children.center.T.w, card.children.center.T.h)
  end
  
  love.graphics.push()
  love.graphics.origin()
  local old = love.graphics.getCanvas()
  love.graphics.setCanvas(card.ability.canvas_sprite.canvas)
  love.graphics.clear()
  love.graphics.setFont(RainyDays_skinner_box_font)
  love.graphics.setColor(0.309803921569, 0.388235294118, 0.403921568627, 1)
  local string = localize('$') .. (this_joker_is_owned(card) and card.sell_cost or card.cost)
  love.graphics.print(string, 65 - RainyDays_skinner_box_font:getWidth(string), 10, 0)
  love.graphics.setCanvas(old)
  love.graphics.pop()
end

function this_joker_is_owned(card)
  if G.jokers and G.jokers.cards then
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i] == card then
        return true
      end
    end
  end
  return false
end