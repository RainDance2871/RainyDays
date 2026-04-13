SMODS.Joker {
  key = 'delirium',
  atlas = 'Jokers',
  rarity = 1,
  cost = 4,
  unlocked = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('delirium_alt0'), 
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
        card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('delirium_alt' .. card.ability.extra.art_state))
        card.ability.extra.time = love.timer.getTime()
      end
    else
      card.ability.extra.time = love.timer.getTime()
    end
  end,
  
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra.art_state then
      card.children.center:set_sprite_pos(RainyDays.GetJokersAtlasTable('delirium_alt' .. card.ability.extra.art_state))
    end
  end,
  
  loc_vars = function(self, info_queue, card)
    local active = G.GAME.blind and G.GAME.blind.in_blind and G.GAME.rd_delirium_active > 0
    return {
      vars = {
        colours = {
          active and G.C.FILTER or G.C.UI.TEXT_INACTIVE
        },
        card.ability.extra.mult_bonus,
        card.ability.extra.card_amount,
        active and localize('rainydays_active') or localize('rainydays_inactive')
      }
    }
  end,

  calculate = function(self, card, context)
    if context.joker_main and G.GAME.rd_delirium_active > 0 then
      return {
        mult = card.ability.extra.mult_bonus
      }
    end
    
    if context.discard and G.GAME.rd_delirium_active == 1 then
      return {
        message = localize('rainydays_activated'),
        colour = G.C.RED
      }
    end
    
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.rd_delirium_active > 0 then
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end
}