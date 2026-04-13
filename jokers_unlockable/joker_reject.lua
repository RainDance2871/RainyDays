SMODS.Joker {
  key = 'joker_reject',
  atlas = 'Jokers',
  rarity = 2,
  cost = 6,
  unlocked = false,
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  pos = RainyDays.GetJokersAtlasTable('joker_reject'),
  
  config = {
    extra = {
      money_pay = 3
    }
  },
  
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.money_pay
      }
    }
  end,
  
  add_to_deck = function(self, card, from_debuff)
    G.GAME.rd_discard_for_money = (G.GAME.rd_discard_for_money or 0) + 1
    G.GAME.rd_discard_for_money_amount = card.ability.extra.money_pay
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.rd_discard_for_money = (G.GAME.rd_discard_for_money or 0) - 1
    G.GAME.rd_discard_for_money_amount = card.ability.extra.money_pay
  end,
  
  locked_loc_vars = function(self, info_queue, card)   
    return {
      main_end = not self.unlocked and RainyDays.generate_main_end_counter(G.GAME and G.GAME.unused_discards or 0) or nil,
      vars = { 
        50
      }
    }
  end, 
  
  check_for_unlock = function(self, args)
    return args.type == 'round_win' and (G.GAME and G.GAME.unused_discards or 0) >= 50
  end
}

local old_func_can_discard = G.FUNCS.can_discard
function G.FUNCS.can_discard(e)
  local ret = old_func_can_discard(e)
  if not e.config.button and G.GAME.rd_discard_for_money and G.GAME.rd_discard_for_money > 0 and G.GAME.dollars >= to_big(G.GAME.rd_discard_for_money_amount) then
    e.config.colour = G.C.RED
    e.config.button = 'discard_cards_from_highlighted'
  end
  return ret
end

local old_func_discard = G.FUNCS.discard_cards_from_highlighted
function G.FUNCS.discard_cards_from_highlighted(e, hook)
  local active = G.GAME.current_round.discards_left == 0
  local ret = old_func_discard(e, hook)
  if not hook and active and G.GAME.rd_discard_for_money and G.GAME.rd_discard_for_money > 0 then
    ease_dollars(-G.GAME.rd_discard_for_money_amount or 0)
  end
  return ret
end