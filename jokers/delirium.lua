SMODS.Joker {
  key = 'delirium',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = GetJokersAtlasTable('delirium_alt0'), 
  config = {
    extra = {
      mult_bonus = 20,
      card_amount = 4,
      art_state = 0,
    }
  },
  
  update = function(self, card, dt)
    if card.ability and card.ability.extra.time then
      if love.timer.getTime() - card.ability.extra.time > 217 then
        card.ability.extra.art_state = math.floor(4 * love.math.random())
        card.children.center:set_sprite_pos(GetJokersAtlasTable('delirium_alt' .. card.ability.extra.art_state))
        card.ability.extra.time = love.timer.getTime()
      end
    else
      card.ability.extra.time = love.timer.getTime()
    end
  end,
  
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra.art_state then
      card.children.center:set_sprite_pos(GetJokersAtlasTable('delirium_alt' .. card.ability.extra.art_state))
    end
  end,
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        colours = {
          card.ability.extra.active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        card.ability.extra.mult_bonus,
        card.ability.extra.card_amount,
        card.ability.extra.active and  localize('rainydays_active') or localize('rainydays_inactive')
      }
    }
  end,

  calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.active then
      return {
        mult = card.ability.extra.mult_bonus
      }
    end
    
    if context.discard and not context.blueprint and not card.ability.extra.active then
      --find amount of wildcards
      local wild_card_count = 0
      local non_wild = {}
      local suits = {}
      for i = 1, #context.full_hand do
        if SMODS.has_any_suit(context.full_hand[i]) then
          wild_card_count = wild_card_count + 1
        elseif not SMODS.has_no_suit(context.full_hand[i]) then
          non_wild[#non_wild + 1] = context.full_hand[i]
        end
      end
      
      --check if cards of suit are discarded
      for i = 1, #non_wild do 
        for key, _ in pairs(SMODS.Suits) do
          if not suits[key] and non_wild[i]:is_suit(key, true) then
            suits[key] = true
            break
          end
        end
      end
      
      --count amount of suits
      local count = wild_card_count
      for key, _ in pairs(SMODS.Suits) do
        if suits[key] then
          count = count + 1
        end
      end
      
      if count >= card.ability.extra.card_amount then
        card.ability.extra.active = true
        return {
          message = localize('rainydays_activated'),
          colour = G.C.RED
        }
      end
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.active then
      card.ability.extra.active = nil
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end
}